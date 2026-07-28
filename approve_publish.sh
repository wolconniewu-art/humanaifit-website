#!/bin/bash
# approve_publish.sh — 批准文章发布（Connie 确认后调用）
#
# 用法:
#   bash approve_publish.sh <slug>
#
# 流程:
#   1. 检查是否有等待审批的文章
#   2. 验证本地变更（.astro + blog.astro 注册）
#   3. 调 deploy_humanaifit.sh --ci-mode 执行部署
#
# 回滚:
#   bash approve_publish.sh --rollback <slug>

set -euo pipefail

SITE_DIR="/home/connie/.openclaw/workspace/humanaifit-website"
TEMP_DIR="/mnt/c/Connie/临时文件夹"

usage() {
  echo "用法:"
  echo "  bash approve_publish.sh <slug>      — 批准发布"
  echo "  bash approve_publish.sh --rollback <slug>  — 回滚发布（撤销本地文件变更）"
  exit 1
}

if [ $# -lt 1 ]; then usage; fi

ROLLBACK=false
if [ "$1" = "--rollback" ]; then
  ROLLBACK=true
  shift
fi
SLUG="$1"
[ -z "$SLUG" ] && usage

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 回滚模式
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$ROLLBACK" = true ]; then
  echo "=========================================="
  echo "  🔄 回滚操作 — $SLUG"
  echo "=========================================="
  
  # 找到备份文件
  ZH_BAK=$(ls "$SITE_DIR/src/pages/blog.astro_pre_${SLUG}_"* 2>/dev/null | tail -1 || true)
  EN_BAK=$(ls "$SITE_DIR/src/pages/en/blog.astro_pre_${SLUG}_"* 2>/dev/null | tail -1 || true)
  
  if [ -z "$ZH_BAK" ] || [ -z "$EN_BAK" ]; then
    echo "  ❌ 未找到备份文件，无法回滚 blog.astro"
    echo "  可能原因: 备份已被清理（部署成功后）或 slug 错误"
  else
    cp "$ZH_BAK" "$SITE_DIR/src/pages/blog.astro"
    cp "$EN_BAK" "$SITE_DIR/src/pages/en/blog.astro"
    rm -f "$ZH_BAK" "$EN_BAK"
    echo "  ✅ blog.astro 已回滚"
    echo "  ✅ en/blog.astro 已回滚"
  fi
  
  # 删除 .astro 文件
  ZH_ASTRO="$SITE_DIR/src/pages/blog/${SLUG}.astro"
  EN_ASTRO="$SITE_DIR/src/pages/en/blog/${SLUG}.astro"
  [ -f "$ZH_ASTRO" ] && rm "$ZH_ASTRO" && echo "  ✅ 已删除: ${ZH_ASTRO#$SITE_DIR/}"
  [ -f "$EN_ASTRO" ] && rm "$EN_ASTRO" && echo "  ✅ 已删除: ${EN_ASTRO#$SITE_DIR/}"
  
  # 删除 CTA 标记
  rm -f "$SITE_DIR/_cta_reviewed_"*"_${SLUG}.md"
  
  # 删除审批标记
  rm -f "${TEMP_DIR}/_approval_status_${SLUG}.txt"
  rm -f "${TEMP_DIR}/_approval_file_${SLUG}.txt"
  
  echo ""
  echo "  ✅ 回滚完成 — 所有与 $SLUG 相关的本地变更已撤销"
  exit 0
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 批准模式
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "=========================================="
echo "  ✅ 批准发布 — $SLUG"
echo "=========================================="

# 检查审批状态
STATUS_FILE="${TEMP_DIR}/_approval_status_${SLUG}.txt"
if [ -f "$STATUS_FILE" ]; then
  STATUS=$(cat "$STATUS_FILE")
  if [ "$STATUS" != "pending" ]; then
    echo "  ❌ 审批状态异常: $STATUS"
    echo "  预期: pending"
    echo "  请确认该文章是否已发布或已回滚"
    exit 1
  fi
  echo "  ✅ 审批状态: pending（可发布）"
else
  echo "  ℹ️  未找到审批标记文件"
  echo "  可能直接跑 publish-article.sh --force-deploy 了仍在进行中"
  echo "  继续执行..."
fi

# 验证关键文件存在
echo ""; echo "■ 验证文件... "
ZH_ASTRO="$SITE_DIR/src/pages/blog/${SLUG}.astro"
EN_ASTRO="$SITE_DIR/src/pages/en/blog/${SLUG}.astro"
if [ ! -f "$ZH_ASTRO" ]; then
  echo "  ❌ 中文 .astro 不存在: ${ZH_ASTRO}"
  echo "  请先运行: bash publish-article.sh ..."
  exit 1
fi
if [ ! -f "$EN_ASTRO" ]; then
  echo "  ❌ 英文 .astro 不存在: ${EN_ASTRO}"
  exit 1
fi

# 从 .astro 文件读取标题用于摘要
TITLE_ZH=$(head -5 "$ZH_ASTRO" | grep -oP '(?<=title: ")[^"]+')
TITLE_EN=$(head -5 "$EN_ASTRO" | grep -oP '(?<=title: ")[^"]+')
echo "  中文: $TITLE_ZH"
echo "  英文: $TITLE_EN"
echo "  ✅ 文件完整"

# 验证 blog.astro 已注册
echo ""; echo "■ 验证 blog.astro 注册..."
if grep -q "${SLUG}" "$SITE_DIR/src/pages/blog.astro"; then
  echo "  ✅ 中文 blog.astro 已注册"
else
  echo "  ❌ 中文 blog.astro 未注册"
  exit 1
fi
if grep -q "${SLUG}" "$SITE_DIR/src/pages/en/blog.astro"; then
  echo "  ✅ 英文 en/blog.astro 已注册"
else
  echo "  ❌ 英文 en/blog.astro 未注册"
  exit 1
fi

# 执行部署
echo ""; echo "■ 执行部署..."
bash "$SITE_DIR/deploy_humanaifit.sh" --ci-mode

# 部署成功后清理
echo ""; echo "■ 后处理..."
# 清除审批标记
rm -f "${TEMP_DIR}/_approval_status_${SLUG}.txt"
rm -f "${TEMP_DIR}/_approval_file_${SLUG}.txt"

# 知识卡片
CARD_DIR="$SITE_DIR/../knowledge-cards"
mkdir -p "$CARD_DIR"
CARD_FILE="${CARD_DIR}/${SLUG}.md"
if [ ! -f "$CARD_FILE" ]; then
  cat > "$CARD_FILE" << EOF
# 知识卡片: ${TITLE_ZH}

- slug: ${SLUG}
- 英文标题: ${TITLE_EN}
- 发布日期: $(date +%Y-%m-%d)
- 自动生成: $(date '+%Y-%m-%d %H:%M')

## 核心论点

（待完善）

## 读者画像

（待完善）

## 线上链接

- 中文: https://www.humanaifit.com/blog/${SLUG}/
- 英文: https://www.humanaifit.com/en/blog/${SLUG}/

---
_知识卡片初稿 — 请于72小时内人工完善_
EOF
  echo "  ✅ 知识卡片已生成: ${SLUG}.md"
fi

# 发布记录
cd "$SITE_DIR/.."
python3 scripts/pipeline_log.py record "$SLUG" --stage=post 2>/dev/null || true

# 清理备份
find "$SITE_DIR/src/pages/" -name "blog.astro_pre_${SLUG}_*" -delete 2>/dev/null || true
echo "  ✅ 临时备份已清理"

echo ""
echo "=========================================="
echo "  ✅ 发布完成 — $SLUG"
echo "  https://www.humanaifit.com/blog/${SLUG}/"
echo "  https://www.humanaifit.com/en/blog/${SLUG}/"
echo "=========================================="
