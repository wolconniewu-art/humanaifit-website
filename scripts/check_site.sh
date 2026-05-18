#!/bin/bash
# =============================================
# check_site.sh - 网站功能完整检查
# 每次网站操作后必须运行
# 用法: bash scripts/check_site.sh [slug]
#   - 不带参数: 检查主站+CBAM+博客
#   - 带slug: 额外检查指定文章
# =============================================

BASE_URL="https://www.humanaifit.com"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERR=0
SLUG="$1"

check_url() {
    local url="$1"
    local label="$2"
    local code=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null)
    if [ "$code" = "200" ]; then
        echo -e "  ${GREEN}✅${NC} $label ($code)"
    elif [ "$code" = "404" ]; then
        echo -e "  ${YELLOW}⚠️${NC} $label ($code — 预期删除)"
    else
        echo -e "  ${RED}❌${NC} $label ($code)"
        ERR=1
    fi
}

echo ""
echo "=========================================="
echo "  🔍 网站功能完整性检查"
echo "  $(date '+%Y-%m-%d %H:%M')"
echo "=========================================="

echo ""
echo "📌 核心服务："
check_url "$BASE_URL/" "主站"
check_url "https://cbam.humanaifit.com" "CBAM助手"
check_url "$BASE_URL/blog/" "博客中文版"
check_url "$BASE_URL/en/blog/" "博客英文版"

if [ -n "$SLUG" ]; then
    echo ""
    echo "📰 指定文章："
    check_url "$BASE_URL/blog/$SLUG/" "中文: $SLUG"
    check_url "$BASE_URL/en/blog/$SLUG/" "英文: $SLUG"
fi

# 检查中文版最新文章日期
echo ""
echo "📅 最新文章检查："
LATEST_ZH=$(curl -s "$BASE_URL/blog/" | grep -oP '2026-\d{2}-\d{2}' | sort -r | head -1)
LATEST_EN=$(curl -s "$BASE_URL/en/blog/" | grep -oP '2026-\d{2}-\d{2}' | sort -r | head -1)
echo "  中文博客最新文章: $LATEST_ZH"
echo "  英文博客最新文章: $LATEST_EN"

echo ""
echo "=========================================="
if [ "$ERR" -eq 0 ]; then
    echo -e "  ${GREEN}✅ 全部检查通过${NC}"
else
    echo -e "  ${RED}❌ 有 $ERR 项检查失败${NC}"
fi
echo "=========================================="
exit $ERR
