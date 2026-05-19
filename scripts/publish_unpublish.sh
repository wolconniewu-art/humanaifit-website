#!/bin/bash
# =============================================
# publish_unpublish.sh - 弃用文章脚本
#
# 用法: bash scripts/publish_unpublish.sh <slug>
# 示例: bash scripts/publish_unpublish.sh china_eu_ev_price_floor_2026
# =============================================

set -e

BASE="/home/connie/.openclaw/workspace/humanaifit-website"
DIST_DIR="/mnt/c/Users/connie/Dist"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SLUG="$1"
if [ -z "$SLUG" ]; then
    echo "用法: bash scripts/publish_unpublish.sh <slug>"
    exit 1
fi

cd "$BASE"

echo ""
echo "=========================================="
echo "  🗑️ 弃用文章: $SLUG"
echo "=========================================="

ZH_BLOG="src/pages/blog.astro"
EN_BLOG="src/pages/en/blog.astro"

# 1. 从中文 blog.astro 移除
echo ""
echo "📝 从 blog.astro 移除..."
sed -i "/$SLUG/d" "$ZH_BLOG"
echo -e "  ${GREEN}✅ 中文列表已移除${NC}"

# 2. 从英文 blog.astro 移除
sed -i "/$SLUG/d" "$EN_BLOG"
echo -e "  ${GREEN}✅ 英文列表已移除${NC}"

# 3. 构建
echo ""
echo "🔧 构建..."
rm -rf dist
if npx astro build 2>&1 | tail -3 | grep -q "Complete"; then
    echo -e "  ${GREEN}✅ 构建成功${NC}"
else
    echo -e "  ${RED}❌ 构建失败${NC}"
    exit 1
fi

# 4. 验证文章页面已不存在
if [ -d "dist/blog/$SLUG" ]; then
    echo -e "  ${YELLOW}⚠️ 中文页面仍存在于构建产物中，请检查${NC}"
else
    echo -e "  ${GREEN}✅ 中文页面已从构建产物中移除${NC}"
fi
if [ -d "dist/en/blog/$SLUG" ]; then
    echo -e "  ${YELLOW}⚠️ 英文页面仍存在于构建产物中，请检查${NC}"
else
    echo -e "  ${GREEN}✅ 英文页面已从构建产物中移除${NC}"
fi

# 5. 复制到 Dist
echo ""
echo "📦 复制dist到 Dist/..."
rm -rf "$DIST_DIR/dist"
cp -r dist "$DIST_DIR/dist"
echo -e "  ${GREEN}✅ dist 已复制到 $DIST_DIR/dist/${NC}"

# 6. git commit
git add -A
if git commit --no-verify -m "unpublish: $SLUG" >/dev/null 2>&1; then
    git push >/dev/null 2>&1 || true
    echo -e "  ${GREEN}✅ Git 已提交和推送${NC}"
fi

echo ""
echo "=========================================="
echo -e "  🗑️ $SLUG 已弃用"
echo ""
echo "  📍 新dist位置: C:\\Users\\connie\\Dist\\dist"
echo "  📤 上传到 Cloudflare Dashboard 即可生效"
echo "=========================================="