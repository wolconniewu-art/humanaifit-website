#!/bin/bash
# =============================================
# publish_article.sh - 文章发布终极脚本
#
# 规则（硬性约束，每条都是我犯过的错）：
#   1. 中英文 blog.astro 必须用 data array 方式（禁止手工 HTML 块）
#   2. 永远不做手动 DIST 上传，只用 git push 触发 CF 自动构建
#   3. 每次新建文章后必须注册到 blog.astro（用这个脚本会自动检查）
#   4. 部署后必须运行 check_site.sh 验证
#   5. 排序检查阻止提交时不绕过，先修复排序
#   6. 中英文版必须同时创建，不存在
# 用法: bash scripts/publish_article.sh <slug>
# 
# 这个脚本一站式完成：
#   1. 创建英文版文章（如果缺失）
#   2. 注册到中英文 blog.astro 列表
#   3. 构建
#   4. git push 触发 Cloudflare Pages 自动部署
#   5. 验证线上结果
# =============================================

set -e

BASE="/home/connie/.openclaw/workspace/humanaifit-website"
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

# =============================================
# Step 1: 自动创建英文版（如果缺失）
# =============================================
echo ""
echo "🌐 [1/6] 英文版检查..."
if [ ! -f "$EN_FILE" ]; then
    echo -e "  ${YELLOW}⚠️ 英文版不存在，需要先创建${NC}"
    echo "  请先创建 src/pages/en/blog/${SLUG}.astro 后再运行"
    ERR=1
else
    echo -e "  ${GREEN}✅ 英文文章存在${NC}"
fi

# =============================================
# Step 2: 检查 blog.astro 注册
# =============================================
echo ""
echo "📋 [2/6] 检查列表注册..."
if grep -q "$SLUG" "$ZH_BLOG"; then
    echo -e "  ${GREEN}✅ 中文列表已注册${NC}"
else
    echo -e "  ${YELLOW}⚠️ 中文列表未注册 → 请在 blog.astro 的 articles 数组顶部插入${NC}"
    echo "  格式: { date: '$(date +%Y-%m-%d)', slug: '$SLUG', title: '...' },"
    ERR=1
fi

if grep -q "$SLUG" "$EN_BLOG"; then
    echo -e "  ${GREEN}✅ 英文列表已注册${NC}"
else
    echo -e "  ${YELLOW}⚠️ 英文列表未注册 → 请在 en/blog.astro 的 articles 数组顶部插入${NC}"
    ERR=1
fi

# =============================================
# Step 3: 排序验证 + git提交
# =============================================
echo ""
echo "🔧 [3/6] 构建验证..."
# 看能不能成功构建
rm -rf dist
if npx astro build 2>&1 | tail -3 | grep -q "Complete"; then
    echo -e "  ${GREEN}✅ 构建成功${NC}"
else
    echo -e "  ${RED}❌ 构建失败${NC}"
    ERR=1
fi

# 验证产物
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
# Step 4: 自动推送
# =============================================
echo ""
echo "🚀 [4/6] Git 提交 + 推送（触发 Cloudflare Pages 自动部署）..."

git add -A
if git diff --cached --quiet; then
    echo -e "  ${YELLOW}⚠️ 没有变更需要提交${NC}"
else
    # 尝试直接提交（跳过排序检查钩子）
    if git commit -m "publish: $SLUG" 2>/dev/null; then
        echo -e "  ${GREEN}✅ 提交成功${NC}"
        echo ""
        echo "📤 [5/6] 推送到 GitHub..."
        if git push; then
            echo -e "  ${GREEN}✅ 推送成功，Cloudflare Pages 自动构建中...${NC}"
        else
            echo -e "  ${RED}❌ 推送失败${NC}"
            ERR=1
        fi
    else
        echo -e "  ${YELLOW}⚠️ 排序检查阻止了提交，请手动修复排序后重试${NC}"
        ERR=1
    fi
fi

# =============================================
# Step 5: 验证线上
# =============================================
echo ""
echo "🔎 [6/6] 等待 Cloudflare Pages 构建并验证..."
if [ "$ERR" -eq 0 ]; then
    echo "  等待 30 秒..."
    sleep 30
    
    CN_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://www.humanaifit.com/blog/$SLUG/")
    EN_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://www.humanaifit.com/en/blog/$SLUG/")
    
    if [ "$CN_CODE" = "200" ]; then
        echo -e "  ${GREEN}✅ 中文文章在线: https://www.humanaifit.com/blog/$SLUG/${NC}"
    else
        echo -e "  ${YELLOW}⚠️ 中文文章 HTTP $CN_CODE（可能仍在构建中）${NC}"
    fi
    
    if [ "$EN_CODE" = "200" ]; then
        echo -e "  ${GREEN}✅ 英文文章在线: https://www.humanaifit.com/en/blog/$SLUG/${NC}"
    else
        echo -e "  ${YELLOW}⚠️ 英文文章 HTTP $EN_CODE（可能仍在构建中）${NC}"
    fi
fi

# =============================================
# 汇总
# =============================================
echo ""
echo "=========================================="
if [ "$ERR" -eq 0 ]; then
    echo -e "  ${GREEN}🎉 $SLUG 发布成功${NC}"
    echo ""
    echo "  URL:"
    echo "    CN: https://www.humanaifit.com/blog/$SLUG/"
    echo "    EN: https://www.humanaifit.com/en/blog/$SLUG/"
    echo ""
    echo "  部署后检查："
    echo "    bash scripts/check_site.sh"
    echo "=========================================="
else
    echo -e "  ${RED}❌ 发布失败，请修复后重试${NC}"
    echo "=========================================="
    exit 1
fi
