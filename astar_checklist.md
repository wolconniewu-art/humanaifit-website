# Astro文章推送前置检查清单

**每次推送新文章到humanaifit-website前，必须手动过一遍这个清单，不可凭记忆操作。**

## 1. 引号检查（最常见的报错原因）
- [ ] **标题title=""属性中的中文引号必须转义** — 不要写 `"项目制"`，要写 `&quot;项目制&quot;`
  - Astro的JSX模板中，中文引号（实际是U+0022英文双引号）会被esbuild误解析为属性值结束符
- [ ] **正文`<p>`内的中文引号必须转义** — 用`&quot;`或`&#8220;`/`&#8221;`
- [ ] **参考已有的成功模板** — 只创建不检查：`mckinsey_rigor_ai_impact_2026.astro`（标题中含引号且构建通过的）

## 2. 构建验证
- [ ] **本地build** — 先跑 `npx astro build` 确认无报错（不要只push等Pages构建）
- [ ] **检查dist/** — 确认新文章的HTML目录在dist/blog/下
- [ ] **内容正确** — 抽查dist里的HTML，确认中文引号渲染正确

## 3. 推送后检查
- [ ] **事后退化检查（5项）**
  1. `www.humanaifit.com` HTTP 200
  2. `www.humanaifit.com/blog/` HTTP 200
  3. `www.humanaifit.com/en/blog/` HTTP 200
  4. 新文章URL HTTP 200
  5. cbam.humanaifit.com HTTP 200
