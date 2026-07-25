# AI素养诊断引擎 — 架构底座

版本: v1.0 | 2026-07-25

## 目录结构

```
diagnosis/
├── data/                     # 题库数据（JSON）
│   ├── adult_questions.json  # 成人版MVP 19题
│   ├── child_questions.json  # （预留）儿童版50题
│   └── senior_scenarios.json # （预留）老年人版4场景
├── engine/                   # 评分器（TS逻辑）
│   ├── types.ts              # 共享接口定义
│   ├── scorer.ts             # Scorer抽象基类
│   ├── child-scorer.ts       # 儿童5维评分器
│   ├── adult-scorer.ts       # 成人8维评分器 (含第8维AI元认知)
│   ├── senior-matcher.ts     # 老年人场景匹配器
│   ├── question-selector.ts  # 自适应选题逻辑
│   └── security-aggregator.ts# 安全维度聚合（出海预留, Phase2启用）
├── api/                      # API路由（Cloudflare Pages Functions）
│   ├── start.ts              # POST 开始诊断
│   ├── submit.ts             # POST 提交答案
│   └── [id]/result.ts        # GET  获取结果
└── components/               # Astro前端组件（预留）
    ├── QuestionCard.astro    # 题目卡片
    ├── DimensionBar.astro    # 8维条形图
    ├── FirstAction.astro     # 三段式第一次行动
    └── FeedbackRing.astro    # 同心圆反馈
```

## 开发指引

### 1. 本地运行

```bash
cd ../..
npm install
npm run dev
```

### 2. 题库管理

题库存储在 `data/` 目录的 JSON 文件中。添加新题：
1. 编辑对应 JSON 文件，按编码方案添加
2. 编码方案：`AC-{维度ID}-{难度}-{序号}`（成人版）

### 3. 评分器

`engine/` 下的每个评分器实现 `Scorer` 接口：
- `score(input: ScoreInput): ScoreOutput`
- 新增版本只需新增评分器类，路由层自动识别

### 4. 数据库

数据库使用当前项目的存储方案。表结构见：
`/mnt/c/Connie/临时文件夹/AI素养诊断产品迭代/dev_docs/01_架构底座_技术规格.md`
