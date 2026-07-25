# 老年人版场景题库 JSON

> 版本：v1.0 | 日期：2026-07-25
> 基于：Connie确认4场景（修照片/防骗/健康查询/语音聊天）
> 编码：SC-{场景ID}-{序号}

---

## 当前已入库题库（4场景）

以下JSON已写入 `data/senior_scenarios.json`，可直接使用。

```json
[
  {
    "id": "SC-PH-RE-001",
    "version": "senior",
    "dimension": "photo_restore",
    "difficulty": "easy",
    "stem": "修照片",
    "options": [
      { "id": "A", "text": "我有老照片想修复，想学", "score": 4 },
      { "id": "B", "text": "好像用不上，但我可以试试", "score": 2 },
      { "id": "C", "text": "照片都是电子版，不需要修", "score": 0 }
    ],
    "theoreticalBasis": "老年人AI使用动机：可见产出+社交分享驱动"
  },
  {
    "id": "SC-FR-DE-001",
    "version": "senior",
    "dimension": "fraud_defense",
    "difficulty": "easy",
    "stem": "防骗",
    "options": [
      { "id": "A", "text": "我经常接到可疑电话，想学怎么防", "score": 4 },
      { "id": "B", "text": "子女总担心我上当，学一下让他们放心", "score": 3 },
      { "id": "C", "text": "我不会上当，不需要学", "score": 0 }
    ],
    "theoreticalBasis": "老年人科技焦虑：防骗是子女最关心的刚需场景"
  },
  {
    "id": "SC-HE-IN-001",
    "version": "senior",
    "dimension": "health_inquiry",
    "difficulty": "easy",
    "stem": "健康查询",
    "options": [
      { "id": "A", "text": "我经常查药品/挂号信息，想学用AI查", "score": 4 },
      { "id": "B", "text": "有点兴趣，但怕查错了", "score": 2 },
      { "id": "C", "text": "身体还行，暂时不需要", "score": 0 }
    ],
    "theoreticalBasis": "老年人AI使用动机：健康焦虑驱动，使用频率高"
  },
  {
    "id": "SC-VO-CH-001",
    "version": "senior",
    "dimension": "voice_chat",
    "difficulty": "easy",
    "stem": "语音聊天",
    "options": [
      { "id": "A", "text": "打字不太方便，想学用语音和AI聊天", "score": 4 },
      { "id": "B", "text": "会打字，但想试试跟AI说话是什么感觉", "score": 2 },
      { "id": "C", "text": "不需要跟AI聊天", "score": 0 }
    ],
    "theoreticalBasis": "老年人AI交互偏好：语音交互门槛最低"
  }
]
```

---

## 场景→视频映射

| 场景 | 视频文件名 | 时长 | 核心操作 |
|:----:|:----------:|:----:|:--------:|
| photo_restore | senior_photo_restore_60s.mp4 | 60s | 上传→输入→保存→分享 |
| fraud_defense | senior_fraud_defense_60s.mp4 | 60s | 打开AI→输入短信文本→阅读判断 |
| health_inquiry | senior_health_inquiry_60s.mp4 | 60s | 打开AI→输入药名→阅读回答 |
| voice_chat | senior_voice_chat_60s.mp4 | 60s | 打开AI→点话筒→说话 |

---

## 场景推荐配置

```typescript
// 配置信息（需要在项目中硬编码或配置化）
interface SeniorScenarioConfig {
  id: string;
  title: string;
  icon: string;            // Emoji 或 图标URL
  description: string;     // 一句话描述
  videoUrl: string;        // 视频URL（相对或绝对）
  pushIntervalDays: number;// 完成此场景后几天推下一个
  completionActions: {
    shareToFamily: boolean; // 完成后是否触发子女推送
  };
}

const SENIOR_SCENARIO_CONFIGS: SeniorScenarioConfig[] = [
  {
    id: 'photo_restore',
    title: '修照片',
    icon: '📸',
    description: '让旧照片变清晰',
    videoUrl: '/diagnosis/videos/senior/photo_restore_60s.mp4',
    pushIntervalDays: 3,
    completionActions: { shareToFamily: true },
  },
  {
    id: 'fraud_defense',
    title: '防骗',
    icon: '🚫',
    description: '识别诈骗电话和短信',
    videoUrl: '/diagnosis/videos/senior/fraud_defense_60s.mp4',
    pushIntervalDays: 3,
    completionActions: { shareToFamily: true },
  },
  {
    id: 'health_inquiry',
    title: '健康查询',
    icon: '🏥',
    description: '查药品、查挂号',
    videoUrl: '/diagnosis/videos/senior/health_inquiry_60s.mp4',
    pushIntervalDays: 3,
    completionActions: { shareToFamily: true },
  },
  {
    id: 'voice_chat',
    title: '语音聊天',
    icon: '💬',
    description: '说话就能问AI',
    videoUrl: '/diagnosis/videos/senior/voice_chat_60s.mp4',
    pushIntervalDays: 3,
    completionActions: { shareToFamily: true },
  },
];
```

---

## 场景选择页：结果映射

用户完成选择后，`SeniorMatcher` 输出：

```typescript
// 以用户选择修照片(photo_restore)为例
{
  "dimensions": [
    {
      "dimensionId": "photo_restore",
      "name": "修照片",
      "score": null,           // 老年人不评分
      "matchLevel": 1.0,       // 用户主动选的，最高匹配
      "label": "recommended",  // 推荐
    },
    {
      "dimensionId": "fraud_defense",
      "name": "防骗",
      "score": null,
      "matchLevel": 0.3,       // 中等推荐
      "label": "optional",
    },
    ...
  ],
  "scenarioRecommendations": [
    {
      "scenarioId": "photo_restore",
      "title": "修照片",
      "matchLevel": 1.0,
      "recommended": true,
    },
    {
      "scenarioId": "fraud_defense",
      "title": "防骗",
      "matchLevel": 0.3,
      "recommended": false,
    },
    ...
  ]
}
```

前端收到后置顶展示推荐场景（matchLevel最高的），附带60秒视频播放器。

---

*老年人版题库 JSON。可直接使用。*
