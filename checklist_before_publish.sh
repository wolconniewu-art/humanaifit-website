#!/bin/bash
# 发布前强制检查清单
# 每次推文章前必须运行，失败任何一个则中止

set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
ERR=0

BASE="/home/connie/.openclaw/workspace/humanaifit-website"

echo ""
echo "=========================================="  
echo "  🔍 发布前强制验证清单"
echo "=========================================="
echo ""

# 参数：文章slug
SLUG="$1"
if [ -z "$SLUG" ]; then
    echo "用法: bash checklist_before_publish.sh <slug>"
    echo "示例: bash checklist_before_publish.sh trump_china_summit_16_ceos_2026"
    exit 1
fi

echo "目标文章: $SLUG"
echo ""

# 1. 文章文件存在
echo "📄 [1/6] 检查文章文件存在..."
if [ -f "$BASE/src/pages/blog/${SLUG}.astro" ]; then
    echo -e "  ${GREEN}✅ 中文文章存在${NC}"
else
    echo -e "  ${RED}❌ 中文文章不存在${NC}"; ERR=1
fi
if [ -f "$BASE/src/pages/en/blog/${SLUG}.astro" ]; then
    echo -e "  ${GREEN}✅ 英文文章存在${NC}"
else
    echo -e "  ${RED}❌ 英文文章不存在${NC}"; ERR=1
fi

# 2. 中文列表页已注册
echo ""
echo "📋 [2/6] 检查中文博客列表注册..."
if grep -q "$SLUG" "$BASE/src/pages/blog.astro"; then
    echo -e "  ${GREEN}✅ 中文列表已注册${NC}"
else
    echo -e "  ${RED}❌ 中文列表未注册！请修改 src/pages/blog.astro${NC}"; ERR=1
fi

# 3. 英文列表页已注册
echo ""
echo "📋 [3/6] 检查英文博客列表注册..."
if grep -q "$SLUG" "$BASE/src/pages/en/blog.astro"; then
    echo -e "  ${GREEN}✅ 英文列表已注册${NC}"
else
    echo -e "  ${RED}❌ 英文列表未注册！请修改 src/pages/en/blog.astro${NC}"; ERR=1
fi

# 4. 本地构建
echo ""
echo "🔧 [4/6] 执行本地构建..."
cd "$BASE"
rm -rf dist
if npm run build 2>&1 | tail -5 | grep -q "Completed"; then
    echo -e "  ${GREEN}✅ 构建成功${NC}"
else
    echo -e "  ${RED}❌ 构建失败${NC}"; ERR=1
fi

# 5. 构建产物验证
echo ""
echo "🔎 [5/6] 验证构建产物..."
CN_BLOG=$(grep -c "$SLUG" "$BASE/dist/blog/index.html" 2>/dev/null || echo 0)
EN_BLOG=$(grep -c "$SLUG" "$BASE/dist/en/blog/index.html" 2>/dev/null || echo 0)
CN_PAGE=$(test -d "$BASE/dist/blog/$SLUG" && echo 1 || echo 0)
EN_PAGE=$(test -d "$BASE/dist/en/blog/$SLUG" && echo 1 || echo 0)

if [ "$CN_PAGE" -eq 1 ]; then echo -e "  ${GREEN}✅ 中文文章页面存在${NC}"; else echo -e "  ${RED}❌ 中文文章页面缺失${NC}"; ERR=1; fi
if [ "$EN_PAGE" -eq 1 ]; then echo -e "  ${GREEN}✅ 英文文章页面存在${NC}"; else echo -e "  ${RED}❌ 英文文章页面缺失${NC}"; ERR=1; fi
if [ "$CN_BLOG" -ge 1 ]; then echo -e "  ${GREEN}✅ 中文博客首页有文章链接${NC}"; else echo -e "  ${RED}❌ 中文博客首页缺少文章链接${NC}"; ERR=1; fi
if [ "$EN_BLOG" -ge 1 ]; then echo -e "  ${GREEN}✅ 英文博客首页有文章链接${NC}"; else echo -e "  ${RED}❌ 英文博客首页缺少文章链接${NC}"; ERR=1; fi

# 6. 拷贝到桌面Temp
echo ""
echo "📦 [6/6] 拷贝到桌面Temp..."
TEMP_DIR="/mnt/c/Users/connie/Desktop/Temp/humanaifit_site"
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
cp -r "$BASE/dist/"* "$TEMP_DIR"
FILE_COUNT=$(find "$TEMP_DIR" -type f | wc -l)
echo -e "  ${GREEN}✅ 已拷贝 $FILE_COUNT 个文件到 C:\\Users\\connie\\Desktop\\Temp\\humanaifit_site\\${NC}"

echo ""
echo "=========================================="
if [ "$ERR" -eq 0 ]; then
    echo -e "  ${GREEN}🎉 全部6项检查通过，可以上传了${NC}"
    echo "=========================================="
    exit 0
else
    echo -e "  ${RED}❌ 有 $ERR 项检查未通过，请修复后重试${NC}"
    echo "=========================================="
    exit 1
fi
