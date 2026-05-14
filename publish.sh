#!/bin/bash
# publish.sh - humanaifit.com 文章发布脚本
# 用法: bash publish.sh <slug1> [slug2] [slug3] ...
# 示例: bash publish.sh servicenow_ai_workforce_2026
#
# 前置条件:
#   文章 .astro 文件已在 src/pages/blog/ 和 src/pages/en/blog/ 下
#   中英文博客列表页 (blog.astro / en/blog.astro) 已更新
#
# 流程: 引号检查 → 文件存在检查 → 构建 → 拷贝到桌面Temp

set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

BASE_DIR="/home/connie/.openclaw/workspace/humanaifit-website"
TEMP_DIR="/mnt/c/Users/connie/Desktop/Temp/humanaifit_site"

pass() { echo -e "  ${GREEN}✅${NC} $1"; }
fail() { echo -e "  ${RED}❌${NC} $1"; ERR=1; }
warn() { echo -e "  ${YELLOW}⚠️${NC} $1"; }

echo ""
echo "=========================================="
echo "  humanaifit.com 发布前置检查"
echo "=========================================="
echo ""

SLUGS=("$@")
if [ ${#SLUGS[@]} -eq 0 ]; then
    echo "用法: bash publish.sh <slug1> [slug2] ..."
    echo "示例: bash publish.sh servicenow_ai_workforce_2026"
    exit 1
fi

cd "$BASE_DIR"
ERR=0

# =============================================
# 检查1: 中文文章文件存在
# =============================================
echo "📄 检查文章文件..."
for slug in "${SLUGS[@]}"; do
    if [ -f "src/pages/blog/${slug}.astro" ]; then
        pass "中文文章 ${slug}.astro 存在"
    else
        fail "中文文章 src/pages/blog/${slug}.astro 不存在"
    fi
    
    if [ -f "src/pages/en/blog/${slug}.astro" ]; then
        pass "英文文章 ${slug}.astro 存在"
    else
        fail "英文文章 src/pages/en/blog/${slug}.astro 不存在"
    fi
done

# =============================================
# 检查2: 中文博客列表已注册
# =============================================
echo ""
echo "📋 检查博客列表注册..."
for slug in "${SLUGS[@]}"; do
    if grep -q "$slug" src/pages/blog.astro 2>/dev/null; then
        pass "中文列表已注册 ${slug}"
    else
        fail "中文列表未注册 ${slug} → 请在 src/pages/blog.astro 的 articles 数组中添加"
    fi
done

# =============================================
# 检查3: 英文博客列表已注册
# =============================================
for slug in "${SLUGS[@]}"; do
    if grep -q "$slug" src/pages/en/blog.astro 2>/dev/null; then
        pass "英文列表已注册 ${slug}"
    else
        fail "英文列表未注册 ${slug} → 请在 src/pages/en/blog.astro 中添加文章条目"
    fi
done

# =============================================
# 检查4: 中文标题中无原始中文引号
# =============================================
echo ""
echo "🔍 检查中文引号..."
for slug in "${SLUGS[@]}"; do
    file="src/pages/blog/${slug}.astro"
    # 检查title属性行是否有\u201c\u201d（中文左右引号）
    if grep -Pn 'title="[^"]*[\x{201c}\x{201d}]' "$file" 2>/dev/null; then
        fail "${slug} 标题中含中文引号 → 请用 &quot; 或去掉"
    else
        pass "${slug} 标题引号合规"
    fi
done

# =============================================
# 检查5: 本地构建
# =============================================
echo ""
echo "🔧 本地构建..."
rm -rf dist
if npm run build 2>&1 | tail -3; then
    pass "构建成功"
else
    fail "构建失败 → 查看上方错误信息"
fi

# =============================================
# 检查6: 新文章在dist中
# =============================================
echo ""
echo "🔎 验证构建产物..."
for slug in "${SLUGS[@]}"; do
    if [ -d "dist/blog/${slug}" ]; then
        pass "dist/blog/${slug}/ 存在"
    else
        fail "dist/blog/${slug}/ 不存在"
    fi
    if [ -d "dist/en/blog/${slug}" ]; then
        pass "dist/en/blog/${slug}/ 存在"
    else
        fail "dist/en/blog/${slug}/ 不存在"
    fi
done

# =============================================
# 汇总并交付
# =============================================
echo ""
echo "=========================================="
if [ "$ERR" -ne 0 ]; then
    echo -e "  ${RED}❌ 检查未通过，请修复后重试${NC}"
    echo "=========================================="
    exit 1
fi

echo -e "  ${GREEN}✅ 全部检查通过${NC}"
echo "=========================================="
echo ""

# 交付到桌面Temp
echo "📦 拷贝到桌面Temp..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
cp -r dist/* "$TEMP_DIR"
echo "    → C:\\Users\\connie\\Desktop\\Temp\\humanaifit_site\\"

echo ""
echo "🎉 下一步：请Connie在Cloudflare Pages上传 Temp\\humanaifit_site 文件夹"
echo ""
echo "部署后脚本会自动运行退化检查。"
echo ""
