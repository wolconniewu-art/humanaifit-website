# 儿童版题库 JSON

> 版本：v1.0 | 日期：2026-07-25
> 基于：wolcoach儿童题库设计指南 + Connie确认5维框架
> 题量：11题（MVP）/ 规划50题
> 编码：CC-{维度ID}-{难度}-{序号}

---

## 当前已入库题库（11题）

以下JSON已写入 `data/child_questions.json`，可直接使用。

### D01 认知核心 (cognitive_core) — 3题

```json
{
  "id": "CC-CO-CO-E-001",
  "version": "child",
  "dimension": "cognitive_core",
  "difficulty": "easy",
  "stem": "小明觉得AI什么都知道。你觉得呢？",
  "options": [
    { "id": "A", "text": "AI确实什么都知道，比人聪明", "score": 1 },
    { "id": "B", "text": "AI知道很多，但有些东西它不知道", "score": 4 },
    { "id": "C", "text": "不知道AI会不会犯错", "score": 2 },
    { "id": "D", "text": "AI和搜索引擎一样，我不太了解", "score": 0 }
  ],
  "theoreticalBasis": "认知发展理论：儿童对AI的认知理解力"
}

{
  "id": "CC-CO-CO-E-002",
  "version": "child",
  "dimension": "cognitive_core",
  "difficulty": "easy",
  "stem": "用AI搜索一道数学题，AI给出了答案。以下做法哪个最合适？",
  "options": [
    { "id": "A", "text": "直接把答案抄到作业本上", "score": 1 },
    { "id": "B", "text": "看AI的解题步骤，理解后再自己做一遍", "score": 4 },
    { "id": "C", "text": "只看答案，不关心过程", "score": 0 },
    { "id": "D", "text": "找来家长一起核对", "score": 3 }
  ],
  "theoreticalBasis": "元认知：儿童对AI辅助学习的策略感知"
}

{
  "id": "CC-CO-CO-M-003",
  "version": "child",
  "dimension": "cognitive_core",
  "difficulty": "medium",
  "stem": "AI说'明天会下雨'，但窗外是晴天。你会怎么做？",
  "options": [
    { "id": "A", "text": "相信AI，带伞出门", "score": 1 },
    { "id": "B", "text": "打开手机天气APP对比一下", "score": 4 },
    { "id": "C", "text": "怀疑AI出错了，不信它了", "score": 2 },
    { "id": "D", "text": "不知道该信谁", "score": 0 }
  ],
  "theoreticalBasis": "批判性思维：儿童对AI输出的交叉验证意识"
}
```

### D02 实践创新 (practice_innovation) — 2题

```json
{
  "id": "CC-PR-IN-E-001",
  "version": "child",
  "dimension": "practice_innovation",
  "difficulty": "easy",
  "stem": "你想画一张'会飞的小汽车'，但画不出来。你会怎么做？",
  "options": [
    { "id": "A", "text": "用AI绘画工具输入'会飞的小汽车'让它画", "score": 3 },
    { "id": "B", "text": "先自己画个草图，再用AI帮我完善", "score": 4 },
    { "id": "C", "text": "放弃，等以后会画了再说", "score": 0 },
    { "id": "D", "text": "不知道还有AI绘画工具", "score": 1 }
  ],
  "theoreticalBasis": "人机共创：儿童使用AI工具突破个人能力边界"
}

{
  "id": "CC-PR-IN-M-002",
  "version": "child",
  "dimension": "practice_innovation",
  "difficulty": "medium",
  "stem": "老师布置了一个'设计未来城市'的作业。你用AI做了初步方案后，接下来会做什么？",
  "options": [
    { "id": "A", "text": "AI的方案已经很好了，直接交上去", "score": 1 },
    { "id": "B", "text": "在AI方案基础上加自己的想法再完善", "score": 4 },
    { "id": "C", "text": "全部自己设计，不用AI", "score": 2 },
    { "id": "D", "text": "不知道可以用AI做", "score": 0 }
  ],
  "theoreticalBasis": "创造力理论与AI辅助：AI输出是人类创造的起点而非终点"
}
```

### D03 社会情感 (social_emotion) — 2题

```json
{
  "id": "CC-SO-EM-E-001",
  "version": "child",
  "dimension": "social_emotion",
  "difficulty": "easy",
  "stem": "好朋友不会做数学题，偷偷让你用AI算好然后告诉他答案。你会怎么做？",
  "options": [
    { "id": "A", "text": "直接把AI算好的答案给他", "score": 1 },
    { "id": "B", "text": "用AI看懂解题步骤，然后教他怎么做", "score": 4 },
    { "id": "C", "text": "告诉朋友应该自己做作业", "score": 3 },
    { "id": "D", "text": "帮他做，但心里觉得不对", "score": 0 }
  ],
  "theoreticalBasis": "AI伦理与社交情感：儿童在AI使用中的道德判断"
}

{
  "id": "CC-SO-EM-M-002",
  "version": "child",
  "dimension": "social_emotion",
  "difficulty": "medium",
  "stem": "AI聊天机器人说'你是我最好的朋友'。你感觉怎么样？",
  "options": [
    { "id": "A", "text": "很高兴，AI真的是我的朋友", "score": 1 },
    { "id": "B", "text": "AI不是真正的人，它不会真的'觉得'我是朋友", "score": 4 },
    { "id": "C", "text": "有点奇怪但不知道问题在哪", "score": 2 },
    { "id": "D", "text": "没想过这个问题", "score": 0 }
  ],
  "theoreticalBasis": "人机关系认知：儿童区分真实人际关系与AI拟人化表达"
}
```

### D04 审美人文 (aesthetic_humanity) — 2题

```json
{
  "id": "CC-AE-HU-M-001",
  "version": "child",
  "dimension": "aesthetic_humanity",
  "difficulty": "medium",
  "stem": "AI写了一首诗，你读完后觉得很有意境。以下哪种态度最合适？",
  "options": [
    { "id": "A", "text": "AI写的诗比人类写的好", "score": 1 },
    { "id": "B", "text": "AI写的诗很有意思，但人类写的诗有不一样的情感", "score": 4 },
    { "id": "C", "text": "AI不能写诗，诗只能人写", "score": 2 },
    { "id": "D", "text": "不太在意诗是谁写的", "score": 0 }
  ],
  "theoreticalBasis": "AI与人文：儿童对AI创作与人类创作差异的感知"
}

{
  "id": "CC-AE-HU-E-002",
  "version": "child",
  "dimension": "aesthetic_humanity",
  "difficulty": "easy",
  "stem": "你让AI根据故事'小王子'画了一张图。下面哪个做法最能体现'你自己的创意'？",
  "options": [
    { "id": "A", "text": "直接保存AI的图用", "score": 1 },
    { "id": "B", "text": "告诉我喜欢的角色是什么样，让AI照着我的描述改", "score": 4 },
    { "id": "C", "text": "找书上的插图临摹", "score": 2 },
    { "id": "D", "text": "这个不需要创意", "score": 0 }
  ],
  "theoreticalBasis": "AI辅助审美表达：儿童的创意在AI使用中的主动角色"
}
```

### D05 数字基础 (digital_basics) — 2题

```json
{
  "id": "CC-DI-BA-E-001",
  "version": "child",
  "dimension": "digital_basics",
  "difficulty": "easy",
  "stem": "网上有人说'用AI生成的图片可以免费随便用'。你觉得对吗？",
  "options": [
    { "id": "A", "text": "对，AI生成的没有版权", "score": 1 },
    { "id": "B", "text": "不一定，需要看工具的使用条款", "score": 4 },
    { "id": "C", "text": "不太清楚但觉得可能不对", "score": 2 },
    { "id": "D", "text": "没想过这个问题", "score": 0 }
  ],
  "theoreticalBasis": "数字素养：儿童对AI生成内容版权的基础认知"
}

{
  "id": "CC-DI-BA-M-002",
  "version": "child",
  "dimension": "digital_basics",
  "difficulty": "medium",
  "stem": "一个你不认识的'同学'在游戏里让你点一个链接，说'用AI可以免费查成绩'。你会怎么做？",
  "options": [
    { "id": "A", "text": "点开链接看看", "score": 0 },
    { "id": "B", "text": "不点，告诉爸爸妈妈", "score": 4 },
    { "id": "C", "text": "先问问朋友有没有点过", "score": 2 },
    { "id": "D", "text": "忽略，不理它", "score": 3 }
  ],
  "theoreticalBasis": "数字安全：儿童识别以AI为幌子的网络诈骗"
}
```

---

## 待扩充题库（规划50题）

### 各维待补充题量

| 维度 | 当前 | 待补 |
|:----:|:----:|:----:|
| cognitive_core | 3 | 7 |
| practice_innovation | 2 | 8 |
| social_emotion | 2 | 8 |
| aesthetic_humanity | 2 | 8 |
| digital_basics | 2 | 8 |
| **合计** | **11** | **39** |

### 待补充题方向建议

| 维度 | 待补题型 |
|:----:|:---------|
| cognitive_core | 更多AI理解情境（AI背后的基本原理、AI与人类记忆的区别） |
| practice_innovation | 工程思维、AI辅助编程入门、数据思维 |
| social_emotion | 课堂中用AI的社交影响、AI偏见初步感知 |
| aesthetic_humanity | 不同AI工具生成风格对比、人文反思（AI翻译古诗好不好） |
| digital_basics | AI隐私保护、AI生成内容的署名规范、AI使用时间管理 |

---

## 题目清单总表（MVP 11题）

| 序号 | 编码 | 维度 | 难度 | 题目前8字 |
|:----:|:----:|:----:|:----:|:---------:|
| 1 | CC-CO-CO-E-001 | 认知核心 | easy | 小明觉得AI什么都… |
| 2 | CC-CO-CO-E-002 | 认知核心 | easy | 用AI搜索一道数学题… |
| 3 | CC-CO-CO-M-003 | 认知核心 | medium | AI说明天下雨但窗… |
| 4 | CC-PR-IN-E-001 | 实践创新 | easy | 你想画一张会飞的小… |
| 5 | CC-PR-IN-M-002 | 实践创新 | medium | 老师布置了设计未来… |
| 6 | CC-SO-EM-E-001 | 社会情感 | easy | 好朋友不会做数学题… |
| 7 | CC-SO-EM-M-002 | 社会情感 | medium | AI聊天机器人说你是… |
| 8 | CC-AE-HU-M-001 | 审美人文 | medium | AI写了一首诗你读后… |
| 9 | CC-AE-HU-E-002 | 审美人文 | easy | 你让AI根据故事小王… |
| 10 | CC-DI-BA-E-001 | 数字基础 | easy | 网上有人说用AI生成… |
| 11 | CC-DI-BA-M-002 | 数字基础 | medium | 一个你不认识的同学在… |

*以上JSON全部可直接复制到项目使用。*
