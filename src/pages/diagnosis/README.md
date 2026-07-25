# AI素养诊断引擎 — 架构底座

版本: v1.0 | 2026-07-25

三版本：🧒 儿童版 "AI未来星" / 👨‍💼 成人版 "AI职场力" / 👴 老年人版 "AI生活伴侣"

## 目录结构

```
diagnosis/
├── data/                     # 题库数据（JSON）
│   ├── adult_questions.json  # 成人版MVP 19题（8维）
│   ├── child_questions.json  # 儿童版 11题（5维）
│   └── senior_scenarios.json # 老年人版 4场景（需求选择）
├── engine/                   # 评分器（TS逻辑）
│   ├── types.ts              # 共享接口定义
│   ├── scorer.ts             # Scorer抽象基类
│   ├── adult-scorer.ts       # 成人8维评分器
│   ├── child-scorer.ts       # 儿童5维评分器
│   ├── senior-matcher.ts     # 老年人场景匹配器
│   └── question-selector.ts  # 自适应选题逻辑
├── api/                      # API路由（三版本路由共用）
│   ├── start.ts              # POST /start → 分发表
│   ├── submit.ts             # POST /submit → 评分
│   └── [id]/result.ts        # GET 结果（预留）
└── README.md                 # 本文件
```

## 各版本规格

| 版本 | 编码前缀 | 题数 | 评估方式 | 结果展示 |
|:----:|:--------:|:----:|:--------:|:--------:|
| 🧒 儿童 | CC-* | 11题(MVP) / 50题(完整) | 5维加权 → 雷达图 | 30天行动卡 |
| 👨‍💼 成人 | AC-* | 19题(MVP) / 40题(完整) | 8维三层加权 → 雷达图 | 三段式第一次行动+12周 |
| 👴 老年 | SC-* | 4场景 | 场景匹配 → 推荐 | 60秒视频+子女推送 |

## 开发指引

```bash
# 本地运行
npm install
npm run dev

# API测试（三版本）
curl -X POST http://localhost:3000/api/v1/diagnosis/start \
  -H "Content-Type: application/json" \
  -d '{"userId":"test","type":"adult"}'
```

## 编码方案

成人版: `AC-{维度ID}-{难度}-{序号}`  
儿童版: `CC-{维度ID}-{难度}-{序号}`  
场景版: `SC-{场景ID}-{序号}`

### 维度简称ID

**成人版（8维）：**
- `ai_tool_competency` — AI工具力
- `data_decision` — 数据决策力
- `workflow_design` — 工作流设计力
- `ai_creativity` — AI创造力
- `ai_judgment` — AI判断力
- `human_ai_collab` — 人机协作力
- `ai_strategy` — AI策略力
- `ai_self_awareness` — AI元认知 ⭐

**儿童版（5维）：**
- `cognitive_core` — 认知核心
- `practice_innovation` — 实践创新
- `social_emotion` — 社会情感
- `aesthetic_humanity` — 审美人文
- `digital_basics` — 数字基础

**场景版（4场景）：**
- `photo_restore` — 修照片
- `fraud_defense` — 防骗
- `health_inquiry` — 健康查询
- `voice_chat` — 语音聊天

## 数据库

表结构见 dev_docs/01_架构底座_技术规格.md

需部署到 Cloudflare Pages 时，配置 server adapter：
```bash
npm install @astrojs/cloudflare
```

## 版本记录

- v1.0 — 2026-07-25: 三版本题库+评分器+API路由 首次集成
