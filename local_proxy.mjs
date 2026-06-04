import http from 'http';
import crypto from 'crypto';

const FEISHU_URL = 'https://open.feishu.cn/open-apis/bot/v2/hook/693d9e71-826e-4509-ad9b-31942cb45ba7';
const SECRET = 'kiRprx…kz3u';

function sign(timestamp, secret) {
  const stringToSign = timestamp + '\n' + secret;
  const hmac = crypto.createHmac('sha256', stringToSign);
  hmac.update(Buffer.alloc(0));
  return hmac.digest('base64');
}

const server = http.createServer((req, res) => {
  if (req.method !== 'POST' || req.url !== '/api/lead') {
    res.writeHead(405);
    res.end(JSON.stringify({ error: 'Method not allowed' }));
    return;
  }
  let body = '';
  req.on('data', chunk => body += chunk);
  req.on('end', async () => {
    try {
      const data = JSON.parse(body);
      const { nickname, name, contact, result } = data;
      if (!contact) { res.writeHead(400); res.end(JSON.stringify({ error: '联系方式不能为空' })); return; }

      const now = new Date().toLocaleString('zh-CN', { timeZone: 'Asia/Shanghai' });
      const resultLabel = result ? `${result.typeLabel || '未知类型'}（${result.type}）` : '未完成诊断';
      const timestamp = Math.floor(Date.now() / 1000).toString();
      const signStr = sign(timestamp, SECRET);

      const card = {
        header: { title: { tag: 'plain_text', content: '📋 AI素养诊断 - 新留资通知' }, template: 'blue' },
        elements: [
          { tag: 'div', text: { tag: 'lark_md', content: `**⏰ 时间：**${now}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**👶 孩子昵称：**${nickname || '未填写'}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**🙋 家长称呼：**${name || '未填写'}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**📞 联系方式：**${contact}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**🏷️ 诊断类型：**${resultLabel}` } },
          ...(result ? [{ tag: 'div', text: { tag: 'lark_md', content: `**📊 得分：**探索 ${result.pct.explore || 0}% / 应用 ${result.pct.apply || 0}% / 创作 ${result.pct.create || 0}%` } }] : []),
          { tag: 'hr' },
          { tag: 'note', elements: [{ tag: 'plain_text', content: '来自 humanaifit.com AI素养诊断' }] }
        ]
      };

      const feishuRes = await fetch(FEISHU_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ timestamp, sign: signStr, msg_type: 'interactive', card })
      });
      const feishuResp = await feishuRes.text();
      const parsed = JSON.parse(feishuResp);

      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ success: parsed.code === 0, feishuResponse: feishuResp }));
    } catch (err) {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: err.message }));
    }
  });
});

server.listen(3456, '0.0.0.0', () => {
  console.log(`飞书代理服务运行端口3456`);
});
