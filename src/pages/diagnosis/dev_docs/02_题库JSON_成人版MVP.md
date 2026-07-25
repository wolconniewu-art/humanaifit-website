# 成人版MVP题库 JSON

> 版本：v1.0 | 日期：2026-07-25
> 基于：wolcoach v2题库框架 + humanaifit v3a第8维5题 + PM三段式设计
> 题量：20题（8维×每维2-3题）
> 编码：AC-{维度简称}-{难度}-{序号}

---

## 基础层：D01-D03（7题）

### D01 AI工具力 (ai_tool_competency)

```json
{
  "id": "AC-AI-TC-E-001",
  "version": "adult",
  "dimension": "ai_tool_competency",
  "difficulty": "easy",
  "stem": "刚接触AI，想让它帮你写一封工作邮件。你会怎么输入指令？",
  "options": [
    { "id": "A", "text": "帮我写封邮件", "score": 1 },
    { "id": "B", "text": "写一封给客户的邮件，主题是项目延期，语气诚恳但保持专业", "score": 4 },
    { "id": "C", "text": "帮写邮件", "score": 2 },
    { "id": "D", "text": "不会用AI写邮件", "score": 0 }
  ],
  "theoreticalBasis": "TTF框架（Goodhue & Thompson, 1995）：任务与技术特征的匹配取决于用户能否用精准指令描述任务需求"
}

{
  "id": "AC-AI-TC-M-002",
  "version": "adult",
  "dimension": "ai_tool_competency",
  "difficulty": "medium",
  "stem": "你需要(1)整理一份会议纪要、(2)画一张数据分析图、(3)做PPT配图。你分别用什么工具最合适？",
  "options": [
    { "id": "A", "text": "全部用同一个AI工具搞定", "score": 1 },
    { "id": "B", "text": "会议纪要用Notion AI、图表用Claude+Excel、插图用Midjourney", "score": 4 },
    { "id": "C", "text": "只用常用软件自己硬做", "score": 2 },
    { "id": "D", "text": "不知道有哪些工具可选", "score": 0 }
  ],
  "theoreticalBasis": "AI工具生态认知：不同工具有不同的任务适配度"
}
```

### D02 数据决策力 (data_decision)

```json
{
  "id": "AC-DD-DM-E-001",
  "version": "adult",
  "dimension": "data_decision",
  "difficulty": "easy",
  "stem": "AI说：'根据数据分析，90%的客户满意度来自价格优势。'你怎么看？",
  "options": [
    { "id": "A", "text": "有数据支撑，可信", "score": 1 },
    { "id": "B", "text": "想知道数据来源、样本量、客户选取方式", "score": 4 },
    { "id": "C", "text": "不太确定但懒得深究", "score": 2 },
    { "id": "D", "text": "觉得AI在瞎说", "score": 0 }
  ],
  "theoreticalBasis": "批判性思维（Facione, 1990）：面对分析结论时，核心能力是质疑前提"
}

{
  "id": "AC-DD-DM-M-002",
  "version": "adult",
  "dimension": "data_decision",
  "difficulty": "medium",
  "stem": "AI根据去年的月销量数据做了一个预测模型。使用前最应该检查什么？",
  "options": [
    { "id": "A", "text": "数据范围是否包含节假日等特殊日期", "score": 4 },
    { "id": "B", "text": "预测值的小数点后几位是否准确", "score": 1 },
    { "id": "C", "text": "图表颜色是否好看", "score": 0 },
    { "id": "D", "text": "AI用的什么编程语言写的代码", "score": 2 }
  ],
  "theoreticalBasis": "数据素养（Mandinach & Gummer, 2016）：理解数据生成条件和局限性"
}
```

### D03 工作流设计力 (workflow_design)

```json
{
  "id": "AC-WF-DS-E-001",
  "version": "adult",
  "dimension": "workflow_design",
  "difficulty": "easy",
  "stem": "每周要写周报，以下分工哪个最合理？",
  "options": [
    { "id": "A", "text": "全部让AI写", "score": 1 },
    { "id": "B", "text": "自己列数据框架→AI填充细节→自己核对", "score": 4 },
    { "id": "C", "text": "自己写→让AI改一下语句", "score": 3 },
    { "id": "D", "text": "不考虑用AI", "score": 0 }
  ],
  "theoreticalBasis": "Task-Technology Fit：工作任务拆解为人适合的与AI适合的"
}

{
  "id": "AC-WF-DS-M-002",
  "version": "adult",
  "dimension": "workflow_design",
  "difficulty": "medium",
  "stem": "一个完整的市场调研任务：①确定研究方向→②收集数据→③分析数据→④写报告→⑤汇报演示。你认为哪几步最适合让AI辅助？",
  "options": [
    { "id": "A", "text": "②③④（数据收集+分析+报告）", "score": 4 },
    { "id": "B", "text": "全部", "score": 2 },
    { "id": "C", "text": "只做④（写报告）", "score": 1 },
    { "id": "D", "text": "都不适合", "score": 0 }
  ],
  "theoreticalBasis": "人机分工策略：AI适合数据密集型任务，人类适合方向设定"
}
```

---

## 进阶层：D04-D06（7题）

### D04 AI创造力 (ai_creativity)

```json
{
  "id": "AC-AI-CR-M-001",
  "version": "adult",
  "dimension": "ai_creativity",
  "difficulty": "medium",
  "stem": "用AI写产品文案，但生成的版本都'太像AI'了。你会怎么改进？",
  "options": [
    { "id": "A", "text": "用AI多生成几版直到看到满意的", "score": 2 },
    { "id": "B", "text": "给AI一个具体的品牌调性参考（如'语气像Apple的广告文案'）", "score": 4 },
    { "id": "C", "text": "放弃AI自己写", "score": 1 },
    { "id": "D", "text": "换个AI工具试试", "score": 0 }
  ],
  "theoreticalBasis": "人机共创（Davis, 2024）：瓶颈不在AI能生成多少，而在人类能否给出好的创意约束"
}

{
  "id": "AC-AI-CR-M-002",
  "version": "adult",
  "dimension": "ai_creativity",
  "difficulty": "medium",
  "stem": "AI生成了一个方案，你觉得方向不对。最佳做法是？",
  "options": [
    { "id": "A", "text": "保留AI的内容直接提交", "score": 1 },
    { "id": "B", "text": "删除AI的内容，自己重做", "score": 2 },
    { "id": "C", "text": "告诉AI'方向偏了，回到XX问题上重新思考'", "score": 4 },
    { "id": "D", "text": "换个工具重新生成", "score": 0 }
  ],
  "theoreticalBasis": "迭代式Prompt工程：创造力是多轮迭代的产物"
}
```

### D05 AI判断力 (ai_judgment)

```json
{
  "id": "AC-AI-JD-M-001",
  "version": "adult",
  "dimension": "ai_judgment",
  "difficulty": "medium",
  "stem": "AI说：'根据世界卫生组织2025年数据，全球抑郁症患病率上升了15%。'你会怎么做？",
  "options": [
    { "id": "A", "text": "世卫组织的数据应该可靠，直接引用", "score": 1 },
    { "id": "B", "text": "先搜索'WHO 2025 depression'核实数据", "score": 4 },
    { "id": "C", "text": "觉得数据不对但说不清为什么", "score": 2 },
    { "id": "D", "text": "相信AI不会瞎说", "score": 0 }
  ],
  "theoreticalBasis": "AI输出可信度评估：转发前先验证应成为习惯",
  "securityTag": true
}

{
  "id": "AC-AI-JD-M-002",
  "version": "adult",
  "dimension": "ai_judgment",
  "difficulty": "medium",
  "stem": "你用AI生成了一份竞品分析报告，发现AI错误地引用了一家公司的内部数据。你会？",
  "options": [
    { "id": "A", "text": "反正别人不知道，直接用", "score": 0 },
    { "id": "B", "text": "修改掉那段不准确的数据继续用", "score": 2 },
    { "id": "C", "text": "在报告中标注'此数据无法核实，仅供参考'", "score": 3 },
    { "id": "D", "text": "弃用整份报告", "score": 4 }
  ],
  "theoreticalBasis": "AI伦理（Floridi et al., 2018）：AI使用中的伦理责任在于人",
  "securityTag": true
}
```

### D06 人机协作力 (human_ai_collab)

```json
{
  "id": "AC-HA-CL-M-001",
  "version": "adult",
  "dimension": "human_ai_collab",
  "difficulty": "medium",
  "stem": "时间紧迫，需要同时完成：①思考战略方向、②写会议纪要、③做数据图表。如何分配自己和AI？",
  "options": [
    { "id": "A", "text": "自己全部做——AI不靠谱", "score": 1 },
    { "id": "B", "text": "AI做①②③——反正都行", "score": 0 },
    { "id": "C", "text": "自己思考战略方向→AI做会议纪要+AI生成数据图表→自己审核", "score": 4 },
    { "id": "D", "text": "找同事帮忙分担", "score": 2 }
  ],
  "theoreticalBasis": "人机分工原则：人类做不确定性高/创造性的任务，AI做模式化任务"
}

{
  "id": "AC-HA-CL-M-002",
  "version": "adult",
  "dimension": "human_ai_collab",
  "difficulty": "medium",
  "stem": "AI写了一版方案，但内容方向偏了——不是你想要的。你第一反应是什么？",
  "options": [
    { "id": "A", "text": "先判断：是我指令不清、还是AI本身处理不了这个问题", "score": 4 },
    { "id": "B", "text": "重新改写一次Prompt", "score": 3 },
    { "id": "C", "text": "换个AI工具重新问", "score": 1 },
    { "id": "D", "text": "算了，自己写", "score": 0 }
  ],
  "theoreticalBasis": "过程中元认知：问题定位能力"
}
```

---

## 领导层：D07-D08（6题）

### D07 AI策略力 (ai_strategy)

```json
{
  "id": "AC-AI-ST-M-001",
  "version": "adult",
  "dimension": "ai_strategy",
  "difficulty": "medium",
  "stem": "听说'AI Agent将在2027年取代大量客服岗位'。怎么判断这个说法？",
  "options": [
    { "id": "A", "text": "肯定是真的，技术发展太快了", "score": 1 },
    { "id": "B", "text": "分析客服工作的哪些部分可以被自动化、哪些需要人工", "score": 4 },
    { "id": "C", "text": "不太确定", "score": 2 },
    { "id": "D", "text": "觉得和自己没关系", "score": 0 }
  ],
  "theoreticalBasis": "技术趋势批判分析：区分技术可能和落地时间"
}

{
  "id": "AC-AI-ST-H-002",
  "version": "adult",
  "dimension": "ai_strategy",
  "difficulty": "hard",
  "stem": "公司需要制定一个'AI+业务'方向，你会优先选择以下哪个策略？",
  "options": [
    { "id": "A", "text": "投入资源打造一个AI Agent平台", "score": 1 },
    { "id": "B", "text": "识别现有业务中3个重复率最高且出错率高的环节，先用AI优化", "score": 4 },
    { "id": "C", "text": "购买市场上最火的AI SaaS工具给全员使用", "score": 2 },
    { "id": "D", "text": "等竞争对手先试", "score": 0 }
  ],
  "theoreticalBasis": "技术采纳理论（Rogers, 2003）：成功的AI战略是先找对问题"
}
```

### D08 AI元认知 (ai_self_awareness) — 来自humanaifit v3a

```json
{
  "id": "AC-AI-SA-E-001",
  "version": "adult",
  "dimension": "ai_self_awareness",
  "difficulty": "easy",
  "stem": "刚用AI写完一份报告，关掉对话窗口的时候——你能说清楚这次用得好不好吗？",
  "options": [
    { "id": "A", "text": "能清楚地分清哪些步骤AI帮了大忙、哪些地方是它乱编的", "score": 4 },
    { "id": "B", "text": "大概知道AI起了作用，但具体哪里好哪里不好说不清楚", "score": 2 },
    { "id": "C", "text": "不太确定，做完就关掉了", "score": 1 },
    { "id": "D", "text": "很少去回想自己用AI的过程", "score": 0 }
  ],
  "theoreticalBasis": "元认知（Flavell, 1979）：自我觉察是元认知的起点"
}

{
  "id": "AC-AI-SA-E-002",
  "version": "adult",
  "dimension": "ai_self_awareness",
  "difficulty": "easy",
  "stem": "手上有一个新任务，和你平时用AI做的任务不太一样。你怎么决定'哪些部分交给AI、哪些部分自己做'？",
  "options": [
    { "id": "A", "text": "先分析任务特点，根据具体情况判断什么该给AI、什么该自己做", "score": 4 },
    { "id": "B", "text": "有一套管用的习惯做法——AI先出初稿我再改", "score": 3 },
    { "id": "C", "text": "全部给AI试试，不行再自己来", "score": 1 },
    { "id": "D", "text": "全部自己做——新任务用AI心里没底", "score": 0 }
  ],
  "theoreticalBasis": "策略调适：元认知的第二个成分"
}

{
  "id": "AC-AI-SA-M-003",
  "version": "adult",
  "dimension": "ai_self_awareness",
  "difficulty": "medium",
  "stem": "如果让你给自己的AI使用水平打个分（1-10分），然后让一个了解你工作方式的同事也给你打分——你觉得结果会怎样？",
  "options": [
    { "id": "A", "text": "我会先猜猜同事会打几分，对比我的自评，差距大的地方值得留意", "score": 4 },
    { "id": "B", "text": "大概差不多，差也不会差太多", "score": 2 },
    { "id": "C", "text": "同事不了解我用AI的情况，打分不准确", "score": 1 },
    { "id": "D", "text": "从没想过别人怎么评价我的AI水平", "score": 0 }
  ],
  "theoreticalBasis": "元认知校准：对比自评与他评是校准自我认知的关键方法"
}

{
  "id": "AC-AI-SA-M-004",
  "version": "adult",
  "dimension": "ai_self_awareness",
  "difficulty": "medium",
  "stem": "你用AI写一份方案，AI的输出方向偏了——不是你想要的。你第一反应是什么？",
  "options": [
    { "id": "A", "text": "先判断：是指令不清楚、问题AI处理不好、还是这个任务不该用AI", "score": 4 },
    { "id": "B", "text": "重新改写一次Prompt", "score": 3 },
    { "id": "C", "text": "换个AI工具重新问", "score": 1 },
    { "id": "D", "text": "算了，自己写", "score": 0 }
  ],
  "theoreticalBasis": "过程中元认知：问题定位能力——是我设计的问题还是AI的问题"
}

{
  "id": "AC-AI-SA-H-005",
  "version": "adult",
  "dimension": "ai_self_awareness",
  "difficulty": "hard",
  "stem": "经过一段时间使用AI，你发现自己在某个方面确实有短板——比如'总不知道怎么让AI做数据分析'或'AI绘图时控制不了风格'。以下哪句话最接近你会做的事？",
  "options": [
    { "id": "A", "text": "复盘最近几次失败的过程，找到具体卡在那个步骤，然后针对那个步骤去搜索教程", "score": 4 },
    { "id": "B", "text": "先搁着，下次遇到再说——碰到问题再搜", "score": 2 },
    { "id": "C", "text": "告诉自己下次多试试，用着用着就熟了", "score": 3 },
    { "id": "D", "text": "这个短板不太影响我工作，不急着补", "score": 0 }
  ],
  "theoreticalBasis": "元认知学习策略：有效的学习规划不是报课，而是设计具体可量化的练习"
}
```

---

## 题目清单总表（20题）

| 序号 | 编码 | 维度 | 难度 | 题目前10字 |
|:----:|:----:|:----:|:----:|:----------:|
| 1 | AC-AI-TC-E-001 | D01 工具力 | easy | 刚接触AI想让它帮你… |
| 2 | AC-AI-TC-M-002 | D01 工具力 | medium | 你需要整理会议纪要… |
| 3 | AC-DD-DM-E-001 | D02 决策力 | easy | AI说根据数据分析… |
| 4 | AC-DD-DM-M-002 | D02 决策力 | medium | AI根据去年的月销量… |
| 5 | AC-WF-DS-E-001 | D03 工作流 | easy | 每周要写周报以下分工… |
| 6 | AC-WF-DS-M-002 | D03 工作流 | medium | 一个完整的市场调研… |
| 7 | AC-AI-CR-M-001 | D04 创造力 | medium | 用AI写产品文案… |
| 8 | AC-AI-CR-M-002 | D04 创造力 | medium | AI生成了一个方案… |
| 9 | AC-AI-JD-M-001 | D05 判断力 | medium | AI说根据世界卫生… |
| 10 | AC-AI-JD-M-002 | D05 判断力 | medium | 用AI生成竞品分析… |
| 11 | AC-HA-CL-M-001 | D06 协作力 | medium | 时间紧迫需要同时完成… |
| 12 | AC-HA-CL-M-002 | D06 协作力 | medium | AI写了一版方案方向… |
| 13 | AC-AI-ST-M-001 | D07 策略力 | medium | 听说AI Agent将在… |
| 14 | AC-AI-ST-H-002 | D07 策略力 | hard | 公司需要制定AI加… |
| 15 | AC-AI-SA-E-001 | D08 元认知 | easy | 刚用AI写完一份报告… |
| 16 | AC-AI-SA-E-002 | D08 元认知 | easy | 手上有一个新任务… |
| 17 | AC-AI-SA-M-003 | D08 元认知 | medium | 给自己AI水平打分… |
| 18 | AC-AI-SA-M-004 | D08 元认知 | medium | 用AI写方案方向偏了… |
| 19 | AC-AI-SA-H-005 | D08 元认知 | hard | 经过一段时间使用AI… |

**注意**：20题删除的是AC-AI-JD-E-003（判断力easy没有, 保持medium×2）。实际可用19+题（D08有5题可自选3）。

---

*题库JSON。所有题目可直接复制为JSON数组使用。*
