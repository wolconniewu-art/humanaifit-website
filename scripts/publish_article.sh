#!/bin/bash
# =============================================
# publish_article.sh - 文章发布脚本（2026-05-19 重写）
#
# 排序规则：
#   blog.astro 和 en/blog.astro 的 articles 数组按日期降序排列（最新在最前）
#   同一日期的文章，按插入顺序排列（后注册在前，后插入的在数组顶部）
#   手工维护，每次新增文章时插入到数组最顶部
#
# 流程（已验证可用）：
#   1. 检查中英文文章文件存在
#   2. 检查中英文 blog.astro 已注册
#   3. 构建
#   4. 复制dist到 C:\Users\connie\Dist\dist
#   5. Connie手动上传到Cloudflare Dashboard
#   6. 自行验证（可手动运行 check_site.sh）
#
# 用法: bash scripts/publish_article.sh <slug>
# 示例: bash scripts/publish_article.sh embodied_ai_retail_manufacturing_2026
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
    echo "用法: bash scripts/publish_article.sh <slug>"
    echo "示例: bash scripts/publish_article.sh is_ai_dulling_minds_2026"
    exit 1
fi

cd "$BASE"

echo ""
echo "=========================================="
echo "  📰 文章发布流水线: $SLUG"
echo "=========================================="

ERR=0

# =============================================
# Step 0: Pre-check
# =============================================
echo ""
echo "📄 [0/6] Pre-check..."

ZH_FILE="src/pages/blog/${SLUG}.astro"
EN_FILE="src/pages/en/blog/${SLUG}.astro"
ZH_BLOG="src/pages/blog.astro"
EN_BLOG="src/pages/en/blog.astro"

if [ ! -f "$ZH_FILE" ]; then
    echo -e "  ${RED}❌ 中文文章不存在: $ZH_FILE${NC}"
    ERR=1
else
    echo -e "  ${GREEN}✅ 中文文章存在${NC}"
fi

if [ ! -f "$EN_FILE" ]; then
    echo -e "  ${YELLOW}⚠️ 英文版不存在: $EN_FILE${NC}"
    ERR=1
else
    echo -e "  ${GREEN}✅ 英文文章存在${NC}"
fi

# =============================================
# Step 1: 检查 blog.astro 注册
# =============================================
echo ""
echo "📋 [1/6] 检查列表注册..."
if grep -q "$SLUG" "$ZH_BLOG"; then
    echo -e "  ${GREEN}✅ 中文列表已注册${NC}"
else
    echo -e "  ${YELLOW}⚠️ 中文列表未注册${NC}"
    ERR=1
fi

if grep -q "$SLUG" "$EN_BLOG"; then
    echo -e "  ${GREEN}✅ 英文列表已注册${NC}"
else
    echo -e "  ${YELLOW}⚠️ 英文列表未注册${NC}"
    ERR=1
fi

# =============================================
# Step 2: 构建
# =============================================
echo ""
echo "🔧 [2/6] 构建..."
rm -rf dist
if npx astro build 2>&1 | tail -3 | grep -q "Complete"; then
    echo -e "  ${GREEN}✅ 构建成功${NC}"
else
    echo -e "  ${RED}❌ 构建失败${NC}"
    ERR=1
fi

# 验证构建产物
CN_PAGE=$(test -d "dist/blog/$SLUG" && echo 1 || echo 0)
EN_PAGE=$(test -d "dist/en/blog/$SLUG" && echo 1 || echo 0)
CN_BLOG=$(grep -c "$SLUG" "dist/blog/index.html" 2>/dev/null || echo 0)
EN_BLOG=$(grep -c "$SLUG" "dist/en/blog/index.html" 2>/dev/null || echo 0)

if [ "$CN_PAGE" -eq 0 ] || [ "$EN_PAGE" -eq 0 ]; then
    echo -e "  ${RED}❌ 构建产物缺失文章页面${NC}"
    ERR=1
else
    echo -e "  ${GREEN}✅ 文章页面构建成功${NC}"
fi

if [ "$CN_BLOG" -eq 0 ] || [ "$EN_BLOG" -eq 0 ]; then
    echo -e "  ${RED}❌ 博客首页缺少文章链接${NC}"
    ERR=1
else
    echo -e "  ${GREEN}✅ 博客首页有文章链接${NC}"
fi

# =============================================
# Step 3: 复制dist到 C:\Users\connie\Dist
# =============================================
echo ""
echo "📦 [3/6] 复制dist到 Dist/..."
rm -rf "$DIST_DIR/dist"
cp -r dist "$DIST_DIR/dist"
echo -e "  ${GREEN}✅ dist 已复制到 $DIST_DIR/dist/${NC}"
echo "  大小: $(du -sh "$DIST_DIR/dist" | cut -f1)"

# =============================================
# Step 4: git commit + push（版本控制，不触发部署）
# =============================================
echo ""
echo "📤 [4/6] Git 提交 + 推送..."

git add -A
if git diff --cached --quiet; then
    echo -e "  ${YELLOW}⚠️ 没有变更需要提交${NC}"
else
    if git commit --no-verify -m "publish: $SLUG" >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅ 提交成功${NC}"
        if git push >/dev/null 2>&1; then
            echo -e "  ${GREEN}✅ 推送到 GitHub${NC}"
        else
            echo -e "  ${YELLOW}⚠️ 推送失败（不影响发布）${NC}"
        fi
    else
        echo -e "  ${YELLOW}⚠️ 提交失败（不影响发布）${NC}"
    fi
fi

# =============================================
# Step 5: 验证构建产物完整性
# =============================================
echo ""
echo "🔎 [5/6] 构建产物验证..."

# 检查关键文件
KEY_FILES=(
    "dist/index.html"
    "dist/blog/index.html"
    "dist/en/blog/index.html"
    "dist/blog/$SLUG/index.html"
    "dist/en/blog/$SLUG/index.html"
)
for f in "${KEY_FILES[@]}"; do
    if [ -f "$f" ]; then
        echo -e "  ${GREEN}✅${NC} $f ($(wc -c < "$f") bytes)"
    else
        echo -e "  ${RED}❌${NC} $f 缺失"
        ERR=1
    fi
done

# =============================================
# Step 6: 生成部署通知
# =============================================
echo ""
echo "📋 [6/6] 部署通知..."

echo ""
echo "=========================================="
if [ "$ERR" -eq 0 ]; then
    echo -e "  ${GREEN}🎉 $SLUG 准备就绪，等待上传${NC}"
    echo ""
    echo "  📍 文件位置: C:\\Users\\connie\\Dist\\dist"
    echo "  📤 上传方式:"
    echo "    1. 打开 https://dash.cloudflare.com"
    echo "    2. Workers & Pages → humanaifit-website"
    echo "    3. 上传文件夹 C:\\Users\\connie\\Dist\\dist"
    echo "  ✅ 上传后验证: bash scripts/check_site.sh $SLUG"
    echo "=========================================="
else
    echo -e "  ${RED}❌ 发布失败，请修复后重试${NC}"
    echo "=========================================="
    exit 1
fi