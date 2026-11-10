# Publishing SOP — www.humanaifit.com 文章发布标准操作流程

> **版本**: 2.0 | **最后更新**: 2026-07-09
> **遵守范围**: 所有中英文博客文章
> **违反后果**: 部署时脚本自动拒绝
> **唯一依据**: 本文件是发布的唯一操作指引

---

## 核心流程（三阶段）

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  阶段一      │     │  阶段二      │     │  阶段三      │
│  写作端完成  │ ──→ │  publish-   │ ──→ │  Connie     │
│  MD文稿放   │     │  article.sh │     │  审批        │
│  临时文件夹  │     │  生成+注册   │     │  → 部署上线  │
└─────────────┘     └─────────────┘     └─────────────┘
```

**关键原则：**
1. 发布前必须经过 Connie 审批确认 — 不可跳过
2. 所有文件操作前自动备份 blog.astro — 发现异常自动回滚
3. 部署操作与内容操作分离 — deploy 只做构建/部署/验证
4. 每次部署验证 HTTP 200 + 已有文章零丢失

---

## 0. 前置条件

写作端完成，MD 文稿已就绪：

```
/mnt/c/Connie/临时文件夹/<slug>_zh.md    # 中文文稿
/mnt/c/Connie/临时文件夹/<slug>_en.md    # 英文文稿
```

如果首次使用本流程，建议先完成写前声明（可选）。

---

## 1. 一键发布准备

```bash
bash humanaifit-website/publish-article.sh <slug> <中文标题> <英文标题> <日期(YYYY-MM-DD)> <场景(A|B|C|D|M)>
```

### 参数说明

| 参数 | 说明 | 示例 |
|------|------|------|
| slug | 文章标识符（中英文共用） | ai_emotional_tax_2026 |
| 中文标题 | 博客列表显示的中文标题 | AI省下来的时间，正在变成新的"情绪税" |
| 英文标题 | 博客列表显示的英文标题 | The Time AI Saves Is Becoming a New 'Emotional Tax' |
| 日期 | 发布日期 | 2026-07-09 |
| 场景 | A=全球化 \| B=AI素养/教育 \| C=方法论 \| D=课程 \| M=快速 | B |

### 可选参数

| 参数 | 作用 |
|------|------|
| `--zh=FILE` | 指定中文 MD 路径（默认 `临时文件夹/<slug>_zh.md`） |
| `--en=FILE` | 指定英文 MD 路径（默认 `临时文件夹/<slug>_en.md`） |
| `--skip-preflight` | 跳过开工预检（紧急用） |
| `--force-deploy` | 跳过审批直接部署（不推荐） |

### 该命令自动完成

**阶段一：准备**
1. ✅ 开工预检（preflight_check）
2. ✅ 验证 MD 文稿文件存在
3. ✅ 话题重复检查
4. ✅ 写前声明检查（如缺失自动生成基础版）
5. ✅ 英文标题完整性检查（<20字符告警）

**阶段二：生成与注册（零影响已有文章）**
1. ✅ 备份 blog.astro 和 en/blog.astro
2. ✅ MD → .astro 文件转换
3. ✅ 按日期降序注册到 blog.astro
4. ✅ 验证注册成功 + 已有文章零丢失零修改
5. ✅ CTA 自动审查标记

**阶段三：等待审批**
1. ⏸️ 显示审批摘要
2. ⏸️ 生成审批标记文件
3. ⏸️ **等待 Connie 回复**
4. ⏸️ 本地文件已验证安全，不影响线上

---

## 2. 审批与发布

脚本执行到阶段三后，Connie 回复以下命令执行下一步：

### 批准发布

```bash
bash humanaifit-website/approve_publish.sh <slug>
```

该命令自动完成：
1. ✅ 验证审批状态
2. ✅ 验证 .astro 文件存在
3. ✅ 验证 blog.astro 注册
4. ✅ 执行部署（deploy_humanaifit.sh --ci-mode）
5. ✅ 生成知识卡片初稿
6. ✅ 发布记录 + 复盘待办
7. ✅ 清理临时备份

### 回滚撤销

```bash
bash humanaifit-website/approve_publish.sh --rollback <slug>
```

该命令撤销所有本地变更：
1. ✅ 从备份恢复 blog.astro
2. ✅ 删除新建的 .astro 文件
3. ✅ 删除 CTA 审查标记
4. ✅ 删除审批标记文件

---

## 3. 部署脚本（deploy_humanaifit.sh）

> 通常不直接调用，由 `publish-article.sh` 或 `approve_publish.sh` 自动触发。

### 用法

```bash
bash humanaifit-website/deploy_humanaifit.sh              # 标准模式
bash humanaifit-website/deploy_humanaifit.sh --ci-mode     # CI模式（被publish-article调用时）
bash humanaifit-website/deploy_humanaifit.sh --site-update # 站点信息更新
```

### 部署脚本自动执行

1. ✅ CTA 审查标记检查（标准模式）或跳过（CI模式）
2. ✅ 英文标题完整性校验（<20字符阻断）
3. ✅ 中英文同步巡检（warning only）
4. ✅ npm run build
5. ✅ wrangler pages deploy（Cloudflare Direct Upload API）
6. ✅ Purge Cache（Cloudflare API）
7. ✅ 线上验证 HTTP 200

---

## 4. 故障处理

### 4.1 部署失败

```bash
# 检查 Token
cat ~/.wsl_cf_token | wc -c   # 应 ≥ 40 chars

# 手动构建
cd humanaifit-website && npm run build

# 手动 wrangler
npx wrangler pages deploy dist --project-name=humanaifit-website

# 手动 Purge Cache
# Cloudflare Dashboard → Caching → Purge Everything
```

### 4.2 审批中断后恢复

如果 `publish-article.sh` 已完成阶段二但未收到审批：
- 文件已就绪（.astro + blog.astro 已注册）
- 直接运行 `approve_publish.sh <slug>` 即可继续

### 4.3 审批前发现错误

运行回滚：
```bash
bash approve_publish.sh --rollback <slug>
```

---

## 5. 错误速查表

| 错误类型 | 原因 | 怎么修 |
|---------|------|-------|
| Token读取失败 | Token文件权限/格式 | `cat ~/.wsl_cf_token | wc -c` 检查 |
| blog.astro顺序乱 | 手工排序出错 | 用 publish-article.sh 自动排，不要手改 |
| 英文标题截断 | title 中有未转义字符 | 用 publish-article.sh 注册，修复 register_blog_article.py |
| 中英文不一致 | 只建了一个语言的 .astro | publish-article.sh 强制同步创建 |
| 构建失败 | .astro 语法错误 | 检查 md_to_astro 输出，确保全 HTML 标签 |
| 线上 404 | wrangler 部署失败 | 重新部署或手动 wrangler |
| 已有文章丢失 | 手动编辑 blog.astro | 从备份恢复 |
| 参考文献被漏掉 | 写作时未同步记录 | 文末必须列参考文献 |

## 6. 文件清单

| 文件 | 作用 | 位于 |
|------|------|------|
| publishing_sop.md | **唯一操作指引** | humanaifit-website/ |
| publish-article.sh | **一键发布准备（审批前置）** | humanaifit-website/ |
| approve_publish.sh | **批准发布 / 回滚** | humanaifit-website/ |
| deploy_humanaifit.sh | 构建+部署+验证 | humanaifit-website/ |
| preflight_check.py | 开工预检 | scripts/ |
| cta_review.py | CTA 审查 | scripts/ |
| md_to_astro.py | MD → .astro 转换 | scripts/ |
| register_blog_article.py | blog.astro 注册 | scripts/ |
| pipeline_log.py | 执行记录 | scripts/ |
| check_topic_repeat.py | 话题重复检查 | . |
| auto_sync_check.py | 中英文同步巡检 | scripts/ |

## 7. 订阅邮件通知（Buttondown，2026-10-22 接入）

> 页脚「订阅更新」已接入免费 newsletter 服务 Buttondown：新文章发布成功后会**自动群发邮件**给所有订阅者。

### 7.1 订阅侧（自动，无需手动）

访客在页脚提交邮箱 → `POST /api/lead`（`source=subscribe`）→ `functions/api/lead.js` 调用 Buttondown `POST /v1/subscribers` 加入列表（`type=regular` 跳过双重确认）。非阻断：key 未配置时只退化为飞书留资，不影响原链路。

### 7.2 群发侧（发布时自动触发，无需手动）

`publish-article.sh` 导出 `PUBLISH_SLUG / PUBLISH_TITLE_ZH / PUBLISH_TITLE_EN` → `deploy_humanaifit.sh` 部署成功后 **Step 5** 调用 `scripts/notify_subscribers.py` 创建 email + `publish` 群发（中英文链接自动拼好）。无 key 时静默跳过（exit 0），**绝不阻断发布**。

### 7.3 密钥与配置（换 key / 换账号时必看）

Buttondown API key 存**两处**，缺一不可：

| 位置 | 用途 |
|------|------|
| `~/.buttondown_key`（权限 0600） | 发布时群发脚本 `notify_subscribers.py` 读取 |
| Cloudflare Pages 环境变量 `BUTTONDOWN_API_KEY`（secret_text） | 线上 `/api/lead` 订阅接口读取 |

用 wrangler 配 secret：
```bash
printf '%s' '<key>' | CLOUDFLARE_API_TOKEN="$(cat ~/.wsl_cf_token)" \
  npx wrangler pages secret put BUTTONDOWN_API_KEY --project-name humanaifit-website
```

### 7.4 踩坑（复用必看）

1. **新账号防火墙拦截**：Buttondown 新账号默认拦截所有新订阅者（报 `subscriber_blocked: blocked by your firewall`），**没有 API 可关**——必须在网页 https://buttondown.com/settings/firewall 手动关防火墙，并完成「Write your first email」激活。
2. **key 报 401 先别急着换**：先用「从文件读 key 并 `tr -d '\r\n'` 去换行」重测，大概率是传参转写问题而非 key 失效。
3. **端到端验证用 `recipients` 定向发送**：`send-draft` 支持 `recipients` 参数只发给测试邮箱，避免打扰真实订阅者；验证完 DELETE 清理测试邮箱/测试邮件。
4. **真正群发必须用 `publish` 端点，不是 `send-draft`**：`send-draft` 是「发测试预览」端点（邮件只停在 `draft` 状态，不会发给订阅者）；真正群发要 `POST /emails/{id}/publish`。曾误用 `send-draft` 导致通知邮件一直停在 draft 没发出去——脚本已改，别再改回去。

### 7.5 手动触发群发（补发 / 测试）

```bash
cd humanaifit-website
python3 scripts/notify_subscribers.py <slug> <中文标题> <英文标题> [中文URL] [英文URL]
```

---

## 8. 发布脚本踩坑（2026-10-22 血泪，复用必看）

> 以下三个 bug 均影响**所有走 publish-article.sh 流程的文章**，已修复；以后若遇到类似现象先查这里。

1. **`md_to_astro.py` 多位数有序列表 bug**：旧代码用 `stripped[0].isdigit() and stripped[1:2]=='.'` 判断有序列表，只能识别 `1.`–`9.` 单位数编号；`10.` 起（`10.` 的第二个字符是 `0` 不是 `.`）判断失败，被当成段落 → 参考文献第 10 条起全部崩坏（`<ol>` 里混进 `<p>`，参考文献格式门禁报错）。已改为 `re.match(r'^\d+\.\s', ...)`。**症状**：构建时报「参考文献 <ol> 内含 <p> 标签」，且恰好是第 10 条起。

2. **`md_to_astro.py` 缺 `# ` 一级标题处理**：旧代码只处理 `## `（h2）和 `### `（h3），`# 标题` 被当成普通段落（16px）+ 字面量 `#` 号。已补 `# ` → `<h1>`；同时 `BlogLayout.astro` 补了 `.article-body h1` 样式（桌面 clamp(1.75rem,2.5vw+0.5rem,2.25rem)，移动 1.6rem）。**症状**：文章标题字号异常小、前面还顶着个 `#`。

3. **`register_blog_article.py` 中英 tags 未翻译**：旧代码把同一套中文 tags 同时写进中英文两个 blog.astro，导致英文博客卡片显示中文标签。已加 `TAG_ZH2EN` 映射表 + `tags_to_en()`，注册英文 blog 时自动翻译。**症状**：英文 `/en/blog/` 卡片封面/标签显示中文。

4. **`md_to_astro.py` 用 `layout: "@/layouts/BlogLayout.astro"` 导致页面缺 charset → 中文乱码**：这种 frontmatter `layout:` 写法渲染时 `<html><head><body><meta charset>` 整个外壳丢失（只剩 `<!DOCTYPE html>` + 正文）。**必须改用老文章同款 `import Article from '../../layouts/Article.astro'` + `<Article>` 组件写法**（41 篇老文章已验证）。`md_to_astro.py` 已重写为 Article 组件结构。**症状**：文章页标题/正文中文乱码，`curl` 页面 HTML 里 grep 不到 `<meta charset>`。

5. **`register_blog_article.py` 的 `safe_title()` 把 `'` 转成 `&apos;` 导致英文卡片标题乱码**：blog.astro 的标题放在 **JS 字符串**（`title: "..."`）里，不是 HTML 属性，所以单引号、`&` 必须原样保留，只需转义反斜杠和双引号。旧代码用 HTML 实体转义（`'`→`&apos;`），Astro 渲染时又转义 `&`→`&amp;`，最终浏览器显示字面量 `&apos;`。**症状**：英文 `/en/blog/` 卡片标题显示 `Isn&apos;t` 这种乱码（文章页标题正常，因为那里是 HTML 属性）。

---

## 附录：禁用操作

- ❌ 禁止绕过 publish-article.sh 直接编辑 blog.astro
- ❌ 禁止在 `.astro body` 中使用 Markdown 语法
- ❌ 禁止发布不含参考文献列表的文章
- ❌ 禁止创建中文文章后不同步创建英文版
- ❌ 禁止批准发布前部署到线上
- ❌ 禁止发布不验证 HTTP 200
- ❌ 禁止在未告知的情况下删除文件
