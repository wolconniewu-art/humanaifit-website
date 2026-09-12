// ============================================================
// 单一数据源：网站主题分区 + 文章归类
// 35篇重组文章 / 主题导航 / 标签筛选 都从这里读取
// 新增主题只需改此文件（呼应：后续会生成更多主题）
// ============================================================

// 主题定义（顺序 = 导航/分区展示顺序；key 用于 data-theme 匹配，中英双语显示名）
export const THEMES = [
  { key: "human-ai-fit",   cn: "人机契合",   en: "Human-AI Fit",     descCn: "人与AI如何真正协同，个人与组织的竞争力重构", descEn: "How humans and AI genuinely collaborate to rebuild personal & organizational competitiveness" },
  { key: "org-ai",         cn: "AI×组织",    en: "AI & Organization",descCn: "企业如何把AI从Demo变成生产力",               descEn: "How enterprises turn AI from demo into real productivity" },
  { key: "globalization",  cn: "中国全球化", en: "Globalization",    descCn: "中国企业出海的打法、市场评估与产业博弈",        descEn: "How Chinese companies go global: tactics, markets, industry competition" },
  { key: "carbon-cbam",    cn: "碳合规CBAM", en: "Carbon & CBAM",    descCn: "欧盟/英国CBAM、碳定价与碳数据核查",           descEn: "EU/UK CBAM, carbon pricing, carbon data verification" },
  { key: "ai-governance",  cn: "AI治理政策", en: "AI Governance",    descCn: "全球AI监管、出口管制与数据主权",              descEn: "Global AI regulation, export controls, data sovereignty" },
  { key: "ai-education",   cn: "AI教育与人", en: "AI & Education",   descCn: "儿童、终身学习、素养与培训重构",              descEn: "Children, lifelong learning, literacy, training redesign" },
  { key: "embodied-ai",    cn: "具身智能",   en: "Embodied AI",      descCn: "人形机器人、供应链、AI工厂与物理世界",        descEn: "Humanoids, supply chains, AI factories, the physical world" },
  { key: "digital-economy",cn: "数字经济",   en: "Digital Economy",  descCn: "消费科技、AI测评、创作与游戏",               descEn: "Consumer tech, AI benchmarking, creation, gaming" },
  { key: "opc-economy",    cn: "OPC个体经济",en: "OPC & Individual", descCn: "一人公司、个体竞争力与认知升级",             descEn: "One-person companies, individual competitiveness, cognitive upgrade" },
  { key: "special",        cn: "特殊栏",     en: "Featured",         descCn: "关于我们、政策表、文化纪实与公告",            descEn: "About us, policy tables, cultural series, announcements" },
];

// 35篇文章 → 主题归类
// key: slug（文章页路径）  theme: 归属主主题  pinned: 是否置顶
export const ARTICLES = {
  // —— 批1 合并（7篇）——
  "ai_agent_era":              { theme: "org-ai",          pinned: true },
  "ai_benchmarking":           { theme: "digital-economy", pinned: false },
  "china_going_global_auto":   { theme: "globalization",   pinned: false },
  "embodied_intelligence":     { theme: "embodied-ai",     pinned: true },
  "eu_compliance_carbon_guide":{ theme: "carbon-cbam",     pinned: true },
  "eu_compliance_carbon_roadmap":{ theme: "carbon-cbam",   pinned: false },
  "geotech_chips":             { theme: "ai-governance",   pinned: false },

  // —— 批2 合并（6篇）——
  "ai_children_parenting_2026":{ theme: "ai-education",    pinned: true },  // #8 孩子用上AI
  "ai_productivity_paradox":   { theme: "org-ai",          pinned: false }, // #9 AI生产力
  "china_going_global_structure":{ theme: "globalization", pinned: false }, // #10 出海结构
  "ai_consumer_trust_2026":    { theme: "digital-economy", pinned: false }, // #11 AI走向消费
  "ai_enterprise_landing_2026":{ theme: "org-ai",          pinned: false }, // #12 企业AI落地
  "ai_workforce_retraining_2026":{ theme: "org-ai",        pinned: false }, // #13 培训重构

  // —— 批次B 重新合并（3篇）——
  "ai_irreplaceability_2026":  { theme: "human-ai-fit",    pinned: false }, // #14 A篇人机契合个体
  "china_ai_global_macro_2026":{ theme: "globalization",   pinned: false }, // #15 B篇中国AI宏观
  "ai_regulation_literacy_2026":{ theme: "ai-governance",  pinned: false }, // #16 C篇AI监管教育

  // —— 特殊类（4篇）——
  "policy_table_nev_2026":     { theme: "special",         pinned: false }, // #17 政策表
  "opc_three_leaps":           { theme: "opc-economy",     pinned: true },  // #18 OPC
  "about_humanaifit":          { theme: "special",         pinned: true },  // #19 置顶About+隐私
  "lingnan_daily_61_tales":    { theme: "special",         pinned: true },  // #20 岭南文化

  // —— 待完成 15 篇（#21-36）——
  "ai_four_reasons_unreplacable":{ theme: "human-ai-fit",  pinned: false }, // #21
  "ai_widening_gap_2026":      { theme: "human-ai-fit",    pinned: false }, // #22
  "knowledge_skills_feed_ai_2026":{ theme: "human-ai-fit", pinned: false }, // #23
  "asking_questions_ai_2026":  { theme: "human-ai-fit",    pinned: false }, // #24
  "ai_adoption_people_2026":   { theme: "org-ai",          pinned: true },  // #26
  "digital_tech_reshape_collaboration":{ theme: "org-ai",  pinned: false }, // #27
  "hukou_reform_2026":         { theme: "globalization",   pinned: false }, // #28 户口
  "china_going_global_ace_2026":{ theme: "globalization",  pinned: false }, // #29 出海底牌
  "global_south_digital_livelihood":{ theme: "globalization", pinned: true },// #30 全球南方
  "china_trend_soft_power_2026":{ theme: "globalization",  pinned: false }, // #31 热词
  "parallel_currency_dedollarization_2026":{ theme: "globalization", pinned: false }, // #32
  "cbam_agent_1_plus_3_x":     { theme: "carbon-cbam",     pinned: false }, // #33 CBAM Agent
  "7agents_childrens_day_2026":{ theme: "ai-education",    pinned: false }, // #34 儿童节
  "ai_literacy_future_2026":   { theme: "ai-education",    pinned: true },  // #35 AI素养
  "education_skills_mismatch_2026":{ theme: "ai-education",pinned: false }, // #36 教育缺人

  // —— 已有 untracked 但非本次35篇清单主编号的补充 slug ——
  "global_ai_literacy_policy_2026":{ theme: "ai-education", pinned: false },
  "gigafactory-supply-chain":  { theme: "embodied-ai",     pinned: false },
  "ai_slow_code_quality_2026": { theme: "human-ai-fit",    pinned: false },
};
