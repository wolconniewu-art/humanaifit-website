// Cloudflare Pages Function: 接收诊断留资，推送到飞书群
// 使用飞书开放平台自建应用 API（OAuth2 鉴权，无需 IP 白名单）
// 部署位置：/functions/api/lead.js → https://www.humanaifit.com/api/lead

// 飞书自建应用凭证
const FEISHU_APP_ID = 'cli_aaaa6529aebadcff';
const FEISHU_APP_SECRET = 'OMRgRumzZvtoLMOXqz07Seruh5iLzm4F';

// 目标群 chat_id（AI素养诊断留资群）
const CHAT_ID = 'oc_c9e23bedfec97d8491c4787f0c2dca42';

// 获取 tenant_access_token（自动缓存到 context.waitUntil 中）
// 飞书开放平台 OAuth2: POST https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal
async function getTenantToken() {
  const resp = await fetch('https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      app_id: FEISHU_APP_ID,
      app_secret: FEISHU_APP_SECRET,
    }),
  });
  const data = await resp.json();
  if (data.code !== 0) {
    throw new Error(`获取 token 失败: ${data.code} ${data.msg}`);
  }
  return data.tenant_access_token;
}

// 发送消息到群
async function sendMessage(token, card) {
  const resp = await fetch('https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=chat_id', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
    body: JSON.stringify({
      receive_id: CHAT_ID,
      msg_type: 'interactive',
      content: JSON.stringify(card),
    }),
  });
  const data = await resp.json();
  return data;
}

export async function onRequest(context) {
  // 仅接受 POST
  if (context.request.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  try {
    const body = await context.request.json();
    const { nickname, name, contact, result } = body;

    // 验证必填字段
    if (!contact) {
      return new Response(JSON.stringify({ error: '联系方式不能为空' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // 构造飞书消息卡片
    const now = new Date().toLocaleString('zh-CN', { timeZone: 'Asia/Shanghai' });
    const resultLabel = result
      ? `${result.typeLabel || '未知类型'}（${result.type}）`
      : '未完成诊断';

    const card = {
      header: {
        title: { tag: 'plain_text', content: '📋 AI素养诊断 - 新留资通知' },
        template: 'blue',
      },
      elements: [
        {
          tag: 'div',
          text: { tag: 'lark_md', content: `**⏰ 时间：**${now}` },
        },
        {
          tag: 'div',
          text: { tag: 'lark_md', content: `**👶 孩子昵称：**${nickname || '未填写'}` },
        },
        {
          tag: 'div',
          text: { tag: 'lark_md', content: `**🙋 家长称呼：**${name || '未填写'}` },
        },
        {
          tag: 'div',
          text: { tag: 'lark_md', content: `**📞 联系方式：**${contact}` },
        },
        {
          tag: 'div',
          text: { tag: 'lark_md', content: `**🏷️ 诊断类型：**${resultLabel}` },
        },
        ...(result
          ? [
              {
                tag: 'div',
                text: {
                  tag: 'lark_md',
                  content: `**📊 得分：**探索 ${result.pct.explore || 0}% / 应用 ${result.pct.apply || 0}% / 创作 ${result.pct.create || 0}%`,
                },
              },
            ]
          : []),
        { tag: 'hr' },
        {
          tag: 'note',
          elements: [
            { tag: 'plain_text', content: '来自 humansifit.com AI素养诊断' },
          ],
        },
      ],
    };

    // Step 1: 获取 tenant_access_token
    const token = await getTenantToken();

    // Step 2: 发送消息到群
    const resultData = await sendMessage(token, card);

    return new Response(
      JSON.stringify({
        success: resultData.code === 0,
        code: resultData.code,
        msg: resultData.msg,
        data: resultData.data,
      }),
      {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ error: 'Internal error', detail: err.message }),
      {
        status: 200,  // 前端无感知，避免用户看到错误
        headers: { 'Content-Type': 'application/json' },
      }
    );
  }
}
