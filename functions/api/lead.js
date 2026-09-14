// Cloudflare Pages Function: 接收留资（通用线索 + AI素养诊断），推送到飞书群
// 部署位置：/functions/api/lead.js → https://www.humanaifit.com/api/lead
// 兼容两类提交：
//   1. AI素养诊断格式：{ nickname, name, contact, result:{type,typeLabel,pct} }
//   2. 通用访客线索：  { name, email, contact, intent, source, note }
// 用飞书开放平台自建应用 API（OAuth2 鉴权）
//
// 【密钥安全 2026-08-28】
// 优先从 Cloudflare Pages 环境变量读取 FEISHU_APP_SECRET（最安全，dashboard 配）。
// 未配置时回退到内置兜底值（仅本函数内使用）。凭证不再硬编码泄露的旧值。

const FEISHU_APP_ID_DEFAULT = 'cli_aaaa6529aebadcff';
const CHAT_ID_DEFAULT = 'oc_c9e23bedfec97d8491c4787f0c2dca42';

// 兜底 secret：已移除明文硬编码（2026-08-29 安全加固，密钥轮换后）。
// 必须从 Cloudflare Pages 环境变量读取 FEISHU_APP_SECRET（dashboard/wrangler 配置）。
const FEISHU_APP_SECRET_FALLBACK = ''; // 无明文兜底，强制走环境变量

async function getTenantToken(appId, appSecret) {
  const resp = await fetch('https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ app_id: appId, app_secret: appSecret }),
  });
  const data = await resp.json();
  if (data.code !== 0) throw new Error(`获取token失败: ${data.code} ${data.msg}`);
  return data.tenant_access_token;
}

async function sendMessage(token, content, chatId) {
  const resp = await fetch('https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=chat_id', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` },
    body: JSON.stringify({ receive_id: chatId, msg_type: 'interactive', content: JSON.stringify(content) }),
  });
  return resp.json();
}

// 页面来源中文标签
const SOURCE_LABELS = {
  'home': '🏠 首页', 'about': '👤 About/关于', 'adult': '🧑 💼 成人诊断',
  'child': '👶 儿童诊断', 'senior': '🧓 银发诊断', 'cbam': '🏭 CBAM助手',
  'contact': '📮 联系我们', 'blog': '📰 文章页', 'subscribe': '✉️ 页脚订阅', 'default': '🌐 其他'
};

export async function onRequest(context) {
  if (context.request.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405, headers: { 'Content-Type': 'application/json' },
    });
  }

  // 凭证：env 优先，回退内置
  const appId = context.env.FEISHU_APP_ID || FEISHU_APP_ID_DEFAULT;
  const appSecret = context.env.FEISHU_APP_SECRET || FEISHU_APP_SECRET_FALLBACK;
  const chatId = context.env.FEISHU_LEAD_CHAT_ID || CHAT_ID_DEFAULT;

  // 安全门禁：无明文兜底，若未配置 env secret 则为配置错误
  if (!appSecret) {
    return new Response(JSON.stringify({ ok: false, error: 'FEISHU_APP_SECRET 未配置' }), {
      status: 500, headers: { 'Content-Type': 'application/json' },
    });
  }

  try {
    const body = await context.request.json();
    const { nickname, name, email, contact, intent, source, note, result } = body;
    const now = new Date().toLocaleString('zh-CN', { timeZone: 'Asia/Shanghai' });

    // ---- 判断是"AI素养诊断"还是"通用线索" ----
    const isDiagnosis = !!(result && (result.type || result.typeLabel));
    const srcLabel = SOURCE_LABELS[source] || SOURCE_LABELS.default;

    // 必填校验：诊断需contact，通用需email或contact
    if (isDiagnosis && !contact) {
      return new Response(JSON.stringify({ error: '联系方式不能为空' }), {
        status: 400, headers: { 'Content-Type': 'application/json' },
      });
    }
    if (!isDiagnosis && !email && !contact) {
      return new Response(JSON.stringify({ error: '联系方式不能为空' }), {
        status: 400, headers: { 'Content-Type': 'application/json' },
      });
    }

    let card;
    if (isDiagnosis) {
      // ===== AI素养诊断留资卡片 =====
      const resultLabel = result?.typeLabel ? `${result.typeLabel}（${result.type}）` : '未完成诊断';
      card = {
        header: { title: { tag: 'plain_text', content: '📋 AI素养诊断 - 新留资' }, template: 'blue' },
        elements: [
          { tag: 'div', text: { tag: 'lark_md', content: `**⏰ 时间：**${now}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**📱 来源：**${srcLabel}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**👶 孩子昵称：**${nickname || '未填写'}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**🙋 家长称呼：**${name || '未填写'}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**📞 联系方式：**${contact || '未填写'}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**🏷️ 诊断类型：**${resultLabel}` } },
          ...(result?.pct ? [{
            tag: 'div', text: { tag: 'lark_md',
              content: `**📊 得分：**探索 ${result.pct.explore||0}% / 应用 ${result.pct.apply||0}% / 创作 ${result.pct.create||0}%` },
          }] : []),
        ],
      };
    } else {
      // ===== 通用访客线索卡片 =====
      const intentLabel = Array.isArray(intent) ? intent.join('、') : (intent || '未选择');
      card = {
        header: { title: { tag: 'plain_text', content: '💡 新访客线索' }, template: 'blue' },
        elements: [
          { tag: 'div', text: { tag: 'lark_md', content: `**⏰ 时间：**${now}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**🌐 来源：**${srcLabel}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**📇 称呼/姓名：**${name || '未填写'}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**✉️ 邮箱：**${email || '未填写'}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**📞 联系方式：**${contact || '未填写'}` } },
          { tag: 'div', text: { tag: 'lark_md', content: `**🎯 意向：**${intentLabel}` } },
          ...(note ? [{ tag: 'div', text: { tag: 'lark_md', content: `**📝 需求：**${note}` } }] : []),
        ],
      };
    }

    card.elements.push({ tag: 'hr' });
    card.elements.push({ tag: 'note', elements: [{ tag: 'plain_text', content: '来自 humanaifit.com · 请24小时内跟进' }] });

    // 发送
    const token = await getTenantToken(appId, appSecret);
    const resultData = await sendMessage(token, card, chatId);

    return new Response(JSON.stringify({
      success: resultData.code === 0, code: resultData.code, msg: resultData.msg,
    }), { status: 200, headers: { 'Content-Type': 'application/json' } });
  } catch (err) {
    return new Response(JSON.stringify({ error: 'Internal error', detail: err.message }), {
      status: 200, headers: { 'Content-Type': 'application/json' },
    });
  }
}
