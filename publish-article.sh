#!/bin/bash
# publish-article.sh — 一键发布流程 (v3.0)
# 
# 核心原则:
#   1. 仅在生成 .astro 和注册 blog.astro 层面操作，不动已发布文章
#   2. 所有文件操作前做备份
#   3. 生成后等待 Connie 审批 → 审批后才执行部署
#   4. 中英文同步创建/注册
#
# 使用前提:
#   写作端已完成: /mnt/c/Connie/临时文件夹/<slug>_zh.md 和 <slug>_en.md
#   如果第一次使用本脚本，需先生成写前声明

set -euo pipefail

SITE_DIR="/home/connie/.openclaw/workspace/humanaifit-website"
TEMP_DIR="/mnt/c/Connie/临时文件夹"
SCRIPTS_DIR="/home/connie/.openclaw/workspace/scripts"

usage() {
  echo "用法: bash publish-article.sh <slug> <中文标题> <英文标题> <日期(YYYY-MM-DD)> <场景(A|B|C|D|M)>"
  echo ""
  echo "参数说明:"
  echo "  slug     — 文章标识符（必须唯一，中英文共用）"
  echo "  中文标题 — 博客列表显示的中文标题"
  echo "  英文标题 — 博客列表显示的英文标题"
  echo "  日期     — 发布日期，格式 YYYY-MM-DD"
  echo "  场景     — A=全球化 | B=AI素养/教育 | C=方法论 | D=课程 | M=快速"
  echo ""
  echo "可选参数:"
  echo "  --zh=FILE    — 中文 MD 文件路径（默认 \${TEMP_DIR}/\${slug}_zh.md）"
  echo "  --en=FILE    — 英文 MD 文件路径（默认 \${TEMP_DIR}/\${slug}_en.md）"
  echo "  --skip-preflight — 跳过开工预检（紧急用，不推荐）"
  echo "  --force-deploy   — 跳过审批直接部署（紧急用，不推荐）"
  exit 1
}

[ $# -lt 5 ] && usage

SLUG="$1"
TITLE_ZH="$2"
TITLE_EN="$3"
DATE="$4"
SCENE="$5"
shift 5

ZH_FILE=""; EN_FILE=""
SKIP_PREFLIGHT=false
FORCE_DEPLOY=false
while [ $# -gt 0 ]; do
  case "$1" in
    --zh=*) ZH_FILE="${1#--zh=}" ;;
    --en=*) EN_FILE="${1#--en=}" ;;
    --skip-preflight) SKIP_PREFLIGHT=true ;;
    --force-deploy) FORCE_DEPLOY=true ;;
    *) echo "未知参数: $1"; usage ;;
  esac; shift
done

[ -z "$ZH_FILE" ] && ZH_FILE="${TEMP_DIR}/${SLUG}_zh.md"
[ -z "$EN_FILE" ] && EN_FILE="${TEMP_DIR}/${SLUG}_en.md"

echo ""
echo "===================================================================="
echo "  📝 一键发布流程"
echo "  Slug:  $SLUG"
echo "  中文:  $TITLE_ZH"
echo "  英文:  $TITLE_EN"
echo "  日期:  $DATE | 场景: $SCENE"
echo "  版本:  v3.0（审批前置）"
echo "===================================================================="

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 阶段一：准备（仅本地文件操作 — 零影响）
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo ""; echo "╔═══════════════════════════════════════════════╗"
echo "║  阶段一：准备与本地生成                        ║"
echo "╚═══════════════════════════════════════════════╝"

# 1a: 开工预检
echo ""; echo "■ [1a] 开工预检..."
if [ "$SKIP_PREFLIGHT" = false ]; then
  cd "$SITE_DIR"
  python3 "${SCRIPTS_DIR}/preflight_check.py" "$SCENE" "$SLUG"
  echo "  ✅ 预检通过"
else
  echo "  ⏩ 已跳过预检"
fi

# 1b: 验证文稿文件
echo ""; echo "■ [1b] 验证文稿文件..."
for f in "$ZH_FILE" "$EN_FILE"; do
  if [ ! -f "$f" ]; then
    echo "  ❌ 文件不存在: $f"
    echo "  请先完成文章写作，将 MD 文件放在: $TEMP_DIR/"
    exit 1
  fi
done
echo "  ✅ 中文: $ZH_FILE ($(wc -c < "$ZH_FILE") bytes)"
echo "  ✅ 英文: $EN_FILE ($(wc -c < "$EN_FILE") bytes)"

# 1c: 话题重复检查（不阻断，仅警告）
echo ""; echo "■ [1c] 话题重复检查..."
cd "$SITE_DIR/.."
python3 check_topic_repeat.py --create-silent "$TITLE_ZH" "$SLUG" || true

# 1d: 写前声明（如不存在，生成基础版）
echo ""; echo "■ [1d] 写前声明检查..."
WRITING_CARD="${SITE_DIR}/../memory/${SLUG}_writing_card.json"
if [ ! -f "$WRITING_CARD" ]; then
  echo "  ℹ️  未找到写前声明，生成基础版本"
  cat > "$WRITING_CARD" << EOF
{
  "writing_card": {
    "slug": "${SLUG}",
    "title_zh": "${TITLE_ZH}",
    "title_en": "${TITLE_EN}",
    "scene": "${SCENE}",
    "created_at": "$(date +%Y-%m-%dT%H:%M:%S+08:00)",
    "core_thesis": "（发布时自动生成，建议手动完善）",
    "reader_profile": "（发布时自动生成）",
    "cognitive_path": "（发布时自动生成）"
  },
  "agents_involved": [],
  "version": "1.0-baseline"
}
EOF
  echo "  ✅ 基础写前声明已生成"
else
  echo "  ✅ 写前声明已存在"
fi

# 1e: 验证英文标题完整性
echo ""; echo "■ [1e] 标题完整性检查..."
if [ ${#TITLE_EN} -lt 20 ]; then
  echo "  ⚠️  英文标题过短 (${#TITLE_EN} chars): \"$TITLE_EN\""
  echo "  建议检查是否为截断标题。如需继续请确认。"
fi
if [ ${#TITLE_ZH} -lt 6 ]; then
  echo "  ⚠️  中文标题过短 (${#TITLE_ZH} chars): \"$TITLE_ZH\""
fi
echo "  中文标题: ${#TITLE_ZH} chars | 英文标题: ${#TITLE_EN} chars"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 阶段二：生成与注册（仅在本地修改 — 0风险控制）
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo ""; echo "╔═══════════════════════════════════════════════╗"
echo "║  阶段二：.astro 生成与 blog 注册               ║"
echo "╚═══════════════════════════════════════════════╝"

# 2a: 备份现有 blog.astro
echo ""; echo "■ [2a] 备份 blog.astro（安全措施）..."
BACKUP_SUFFIX="_pre_${SLUG}_$(date +%Y%m%d_%H%M%S)"
cp "$SITE_DIR/src/pages/blog.astro" "$SITE_DIR/src/pages/blog.astro${BACKUP_SUFFIX}"
cp "$SITE_DIR/src/pages/en/blog.astro" "$SITE_DIR/src/pages/en/blog.astro${BACKUP_SUFFIX}"
echo "  ✅ 已备份: blog.astro${BACKUP_SUFFIX}"
echo "  ✅ 已备份: en/blog.astro${BACKUP_SUFFIX}"

# 2b: 生成 .astro 文件
echo ""; echo "■ [2b] 生成 .astro 文件..."
cd "$SITE_DIR"
export SLUG ZH_FILE EN_FILE TITLE_ZH TITLE_EN DATE
python3 "${SCRIPTS_DIR}/md_to_astro.py"

# 验证 .astro 存在
ZH_ASTRO="$SITE_DIR/src/pages/blog/${SLUG}.astro"
EN_ASTRO="$SITE_DIR/src/pages/en/blog/${SLUG}.astro"
if [ ! -f "$ZH_ASTRO" ] || [ ! -f "$EN_ASTRO" ]; then
  echo "  ❌ .astro 文件生成失败"
  exit 1
fi
echo "  ✅ 中文: ${ZH_ASTRO#$SITE_DIR/}"
echo "  ✅ 英文: ${EN_ASTRO#$SITE_DIR/}"

# 2c: 注册到 blog.astro
echo ""; echo "■ [2c] 注册到 blog.astro..."
export TAGS="${TAGS:-前沿科技, 人机契合}"
python3 "${SCRIPTS_DIR}/register_blog_article.py"

# 2d: 验证注册成功（文章已出现在数组中）
echo ""; echo "■ [2d] 验证注册..."
if grep -q "${SLUG}" "$SITE_DIR/src/pages/blog.astro"; then
  echo "  ✅ 中文 blog.astro 已收录"
else
  echo "  ❌ 中文 blog.astro 未收录，回滚中..."
  cp "$SITE_DIR/src/pages/blog.astro${BACKUP_SUFFIX}" "$SITE_DIR/src/pages/blog.astro"
  exit 1
fi
if grep -q "${SLUG}" "$SITE_DIR/src/pages/en/blog.astro"; then
  echo "  ✅ 英文 en/blog.astro 已收录"
else
  echo "  ❌ 英文 en/blog.astro 未收录，回滚中..."
  cp "$SITE_DIR/src/pages/en/blog.astro${BACKUP_SUFFIX}" "$SITE_DIR/src/pages/en/blog.astro"
  exit 1
fi

# 2e: 验证完整性（加固版 — 零影响保证）
echo ""; echo "■ [2e] 验证已有文章完整性（加固版）..."

# 对中文和英文分别做完整性检查
for ASTRO in "$SITE_DIR/src/pages/blog.astro" "$SITE_DIR/src/pages/en/blog.astro"; do
  ASTRO_BACKUP="${ASTRO}${BACKUP_SUFFIX}"
  LANG_NAME=$(basename "$(dirname "$ASTRO")")
  [ "$LANG_NAME" = "pages" ] && LANG_NAME="zh"
  
  # 从备份提取 slug 集合
  BAK_SLUGS=$(grep -oP '(?<=slug: ")[^"]+' "$ASTRO_BACKUP" | sort)
  NEW_SLUGS=$(grep -oP '(?<=slug: ")[^"]+' "$ASTRO" | sort)
  
  BAK_COUNT=$(echo "$BAK_SLUGS" | wc -l)
  NEW_COUNT=$(echo "$NEW_SLUGS" | wc -l)
  
  # 检查数量
  if [ "$NEW_COUNT" -lt "$BAK_COUNT" ]; then
    echo "  ❌ [${LANG_NAME}] 文章丢失！备份 $BAK_COUNT 个 → 现有 $NEW_COUNT 个"
    echo "  自动回滚..."
    cp "$ASTRO_BACKUP" "$ASTRO"
    exit 1
  fi
  
  # 检查丢失
  MISSING=false
  while IFS= read -r slug; do
    if ! echo "$NEW_SLUGS" | grep -q "^${slug}$"; then
      echo "  ❌ [${LANG_NAME}] 原有文章丢失: $slug"
      cp "$ASTRO_BACKUP" "$ASTRO"
      exit 1
    fi
  done <<< "$BAK_SLUGS"
  
  echo "  ✅ [${LANG_NAME}] 原有 $BAK_COUNT 篇全部保留；现有 $NEW_COUNT 篇（含新文章）"
done

# 中英文 slug 数量一致性验证
ZH_SLUGS_CNT=$(grep -oP '(?<=slug: ")[^"]+' "$SITE_DIR/src/pages/blog.astro" | wc -l)
EN_SLUGS_CNT=$(grep -oP '(?<=slug: ")[^"]+' "$SITE_DIR/src/pages/en/blog.astro" | wc -l)
if [ "$ZH_SLUGS_CNT" -ne "$EN_SLUGS_CNT" ]; then
  echo "  ❌ 中英文 slug 数量不一致！中文 $ZH_SLUGS_CNT 篇 ≠ 英文 $EN_SLUGS_CNT 篇"
  echo "  自动回滚..."
  cp "$SITE_DIR/src/pages/blog.astro${BACKUP_SUFFIX}" "$SITE_DIR/src/pages/blog.astro"
  cp "$SITE_DIR/src/pages/en/blog.astro${BACKUP_SUFFIX}" "$SITE_DIR/src/pages/en/blog.astro"
  exit 1
fi
echo "  ✅ 中英文 slug 数量一致: $ZH_SLUGS_CNT = $EN_SLUGS_CNT"

# 2f: CTA 自动审查（v3.0 自动化）
echo ""; echo "■ [2f] CTA 自动审查..."
CTA_DATE=$(date +%Y%m%d)
CTA_FILE="${SITE_DIR}/_cta_reviewed_${CTA_DATE}_${SLUG}.md"
case "$SCENE" in
  A) CTA_STRATEGY="cbam"; CTA_ZH="了解CBAM"; CTA_EN="Learn about CBAM" ;;
  B) CTA_STRATEGY="ai_education"; CTA_ZH="测一测你的AI素养水平"; CTA_EN="Assess Your AI Literacy" ;;
  C|D) CTA_STRATEGY="general"; CTA_ZH="加入AI时代生存手册知识星球"; CTA_EN="Join the AI Era Survival Guide Knowledge Planet" ;;
  *) CTA_STRATEGY="auto"; CTA_ZH=""; CTA_EN="" ;;
esac
cat > "$CTA_FILE" << CTAEOF
# CTA 审查记录（自动完成 — v3.0 审批前置发布）
slug: ${SLUG}
date: $(date +%Y-%m-%d)
scene: ${SCENE}
strategy: ${CTA_STRATEGY}
cta_zh: ${CTA_ZH}
cta_en: ${CTA_EN}
review_type: auto_publish_v3
CTAEOF
echo "  ✅ CTA标记已创建: $(basename $CTA_FILE)"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 阶段三：审批（等待 Connie 确认）
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo ""; echo "╔═══════════════════════════════════════════════╗"
echo "║  阶段三：审批流程                                ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""
echo "  ✅ 本地准备工作全部完成！文件清单："
echo "    └─ src/pages/blog/${SLUG}.astro"
echo "    └─ src/pages/en/blog/${SLUG}.astro"
echo "    └─ blog.astro 已注册（备份: blog.astro${BACKUP_SUFFIX}）"
echo "    └─ en/blog.astro 已注册（备份: en/blog.astro${BACKUP_SUFFIX}）"
echo "    └─ CTA 标记: _cta_reviewed_${CTA_DATE}_${SLUG}.md"
echo "    └─ 写前声明: memory/${SLUG}_writing_card.json"
echo ""

# 生成审批摘要文件
APPROVAL_FILE="${TEMP_DIR}/_approval_${SLUG}_$(date +%Y%m%d%H%M%S).md"
cat > "$APPROVAL_FILE" << EOF
# 发布审批请求

**Slug:** ${SLUG}
**中文标题:** ${TITLE_ZH}
**英文标题:** ${TITLE_EN}
**日期:** ${DATE}
**场景:** ${SCENE}

## 预览

- 中文: https://www.humanaifit.com/blog/${SLUG}/
- 英文: https://www.humanaifit.com/en/blog/${SLUG}/

## 审批提示

请确认以下内容：

1. □ 标题是否正确、完整（无截断）
2. □ 中英文文章内容是否经人工审阅
3. □ 参考文献是否完整
4. □ 是否可以发布到线上

**回复 "发布 $SLUG" 以确认部署，回复 "回滚 $SLUG" 以撤销变更。**
EOF

if [ "$FORCE_DEPLOY" = false ]; then
  echo "  ⏸️  等待 Connie 审批..."
  echo "  审批文件已生成: $APPROVAL_FILE"

  # 创建审批标记
  echo "pending" > "${TEMP_DIR}/_approval_status_${SLUG}.txt"
  echo "$APPROVAL_FILE" > "${TEMP_DIR}/_approval_file_${SLUG}.txt"

  echo ""
  echo "===================================================================="
  echo "  审批待定。请回复: 发布 $SLUG"
  echo "===================================================================="
  exit 0
else
  echo "  ⏩ 强制部署模式（跳过审批）"
fi

echo ""; echo "■ [4] 执行部署..."
bash "$SITE_DIR/deploy_humanaifit.sh" --ci-mode

echo ""; echo "■ [5] 发布后处理..."
cd "$SITE_DIR/.."
python3 scripts/pipeline_log.py record "$SLUG" --stage=post 2>/dev/null || true
python3 -c "
import json, os, datetime
BJT = datetime.timezone(datetime.timedelta(hours=8))
now = datetime.datetime.now(BJT)
review_by = (now + datetime.timedelta(hours=72)).isoformat()
task = {
    'id': '${SLUG}_review',
    'type': 'post_publish_review',
    'title': '文章发布后72小时复盘: ${TITLE_ZH}',
    'slug': '${SLUG}',
    'created_at': now.isoformat(),
    'deadline': review_by,
    'status': 'pending'
}
queue_file = '${SITE_DIR}/../pending_task_queue.json'
if os.path.exists(queue_file):
    with open(queue_file) as f:
        queue = json.load(f)
else:
    queue = {'format_version': '1.0', 'created_at': now.isoformat(), 'tasks': []}
queue['last_updated'] = now.isoformat()
if not any(t.get('id') == task['id'] for t in queue['tasks']):
    queue['tasks'].append(task)
    print(f'  ✅ 复盘待办已注册. 截止: {review_by}')
with open(queue_file, 'w') as f:
    json.dump(queue, f, ensure_ascii=False, indent=2)
" 2>/dev/null || true
rm -f "${TEMP_DIR}/_approval_status_${SLUG}.txt"
rm -f "${TEMP_DIR}/_approval_file_${SLUG}.txt"
rm -f "$SITE_DIR/src/pages/blog.astro${BACKUP_SUFFIX}"
rm -f "$SITE_DIR/src/pages/en/blog.astro${BACKUP_SUFFIX}"

  # 知识库回流：发布后自动生成知识卡片
  echo ""; echo "■ [6] 知识库回流..."
  cd "$SITE_DIR/.."
  ZH_SRC="${TEMP_DIR}/${SLUG}_zh.md"
  EN_SRC="${TEMP_DIR}/${SLUG}_en.md"
  if [ -f "$ZH_SRC" ]; then
    python3 scripts/knowledge_sink.sh "$ZH_SRC" --type knowledge_card --source publish 2>/dev/null || echo "  ⚠️ 中文知识卡片生成跳过（非阻断）"
  fi
  if [ -f "$EN_SRC" ]; then
    python3 scripts/knowledge_sink.sh "$EN_SRC" --type knowledge_card --source publish 2>/dev/null || echo "  ⚠️ 英文知识卡片生成跳过（非阻断）"
  fi
  python3 scripts/update_catalog.py 2>/dev/null || echo "  ⚠️ 目录更新跳过（非阻断）"
  echo "  ✅ 知识库回流完成"

  # 部署后验证
  echo ""; echo "■ [7] 部署后线上验证..."
  for BLOG_URL in "https://www.humanaifit.com/blog/" "https://www.humanaifit.com/en/blog/"; do
    HTTP_CODE=""
    for i in 1 2 3; do
      HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BLOG_URL" 2>/dev/null || echo "000")
      [ "$HTTP_CODE" = "200" ] && break
      sleep 2
    done
    if [ "$HTTP_CODE" != "200" ]; then
      echo "  ⚠️  $BLOG_URL → $HTTP_CODE（非阻断，可能CDN延迟）"
    else
      echo "  ✅ $BLOG_URL → HTTP 200"
    fi
  done

  echo ""; echo "=========================================="
  echo "  ✅ 发布完成 — $SLUG"; echo "=========================================="
