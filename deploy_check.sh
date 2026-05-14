#!/bin/bash
# deploy_check.sh - 部署后退化检查脚本
# 用法: bash deploy_check.sh <slug1> [slug2] ...
# Connie上传完成后运行，确认所有功能正常

set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}✅${NC} $1"; }
fail() { echo -e "  ${RED}❌${NC} $1"; ERR=1; }

SLUGS=("$@")
BASE_URL="https://www.humanaifit.com"
ERR=0

echo ""
echo "=========================================="
echo "  humanaifit.com 退化检查"
echo "=========================================="
echo ""

# 基础页面
echo "🌐 基础页面..."
for url in "$BASE_URL" "$BASE_URL/blog/" "$BASE_URL/en/blog/" "https://cbam.humanaifit.com"; do
    code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "$url" 2>/dev/null || echo "000")
    if [ "$code" = "200" ]; then
        pass "$url → $code"
    else
        fail "$url → $code"
    fi
done

# 新文章
echo ""
echo "📝 新文章..."
for slug in "${SLUGS[@]}"; do
    code_cn=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "$BASE_URL/blog/$slug/" 2>/dev/null || echo "000")
    code_en=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "$BASE_URL/en/blog/$slug/" 2>/dev/null || echo "000")
    
    if [ "$code_cn" = "200" ]; then
        pass "中文 /blog/$slug/ → $code_cn"
    else
        fail "中文 /blog/$slug/ → $code_cn"
    fi
    if [ "$code_en" = "200" ]; then
        pass "英文 /en/blog/$slug/ → $code_en"
    else
        fail "英文 /en/blog/$slug/ → $code_en"
    fi
done

# 博客列表含新文章
echo ""
echo "🔎 验证列表链接..."
for slug in "${SLUGS[@]}"; do
    cn=$(curl -s "$BASE_URL/blog/" 2>/dev/null | grep -c "$slug" || true)
    en=$(curl -s "$BASE_URL/en/blog/" 2>/dev/null | grep -c "$slug" || true)
    if [ "$cn" -ge 1 ]; then
        pass "中文列表含 $slug"
    else
        fail "中文列表缺 $slug"
    fi
    if [ "$en" -ge 1 ]; then
        pass "英文列表含 $slug"
    else
        fail "英文列表缺 $slug"
    fi
done

echo ""
echo "=========================================="
if [ "$ERR" -ne 0 ]; then
    echo -e "  ${RED}❌ 退化检查有失败项${NC}"
    echo "=========================================="
    exit 1
fi
echo -e "  ${GREEN}✅ 全部通过，发布完成 🎉${NC}"
echo "=========================================="
