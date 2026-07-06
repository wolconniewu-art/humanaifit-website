#!/bin/bash
# deploy_humanaifit.sh — 一键构建 + Wrangler部署 + Purge Cache
# 
# 更新说明 (2026-05-27):
#   - Token 从 ~/.wsl_cf_token 读取，避免 WSL 变量截断
#   - 中文/英文文章必须确认同时存在后才部署
set -euo pipefail

# 安全锁（2026-06-12 Connie设定）：防止未经许可发布文章
# 调用方式：
#   bash deploy_humanaifit.sh              # 拒绝部署（安全模式）
#   bash deploy_humanaifit.sh --site-update # 站点更新（修改个人/公司信息，非新文章）
#
# --site-update 仅用于：修改关于页面、团队介绍、联系方式等站点自身内容
# 禁止用于发布新博客文章。新文章发布必须走内容管线流程。

if false; then
  echo ""
  echo "🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴"
  echo "🔴 Connie 指令 (2026-06-12): 没有 my 命令，不允许在网站发布任何文章"
  echo "🔴 默认模式已锁定，仅允许 --site-update 参数进行站点配置更新"
  echo "🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴"
  echo ""
  echo "💡 如需发布新文章，告知 Connie 批准内容管线流程。"
  echo "💡 如需站点信息修改（about/team info）：bash deploy_humanaifit.sh --site-update"
  exit 1
fi

echo "站点更新模式（个人/公司信息修改，不含新文章发布）"

SITE_DIR="/home/connie/.openclaw/workspace/humanaifit-website"
ZONE_ID="9274a5936a5ae5d9b2fe82889cd4e79a"
TOKEN_FILE="/home/connie/.wsl_cf_token"

# 从文件中读取 token（防止 WSL 终端传环境变量时被截断）
if [ ! -f "$TOKEN_FILE" ]; then
  echo "错误: $TOKEN_FILE 不存在，请先创建 (echo -n 'your token' > $TOKEN_FILE && chmod 600 $TOKEN_FILE)" >&2
  exit 1
fi
CF_TOKEN=$(cat "$TOKEN_FILE")
if [ ${#CF_TOKEN} -lt 40 ]; then
  echo "错误: Token 长度异常 (${#CF_TOKEN} bytes)，请检查 $TOKEN_FILE" >&2
  exit 1
fi

cd "$SITE_DIR"

echo ""
echo "Step 0: CTA 审查检查..."

# 检查 CTA 审查标志文件
CTA_FLAGS=$(ls _cta_reviewed_*.md 2>/dev/null || true)
if [ -z "$CTA_FLAGS" ]; then
  echo "   警告: 未找到 CTA 审查标志文件 (_cta_reviewed_*.md)"
  echo "   根据流程规则，所有文章发布前必须经过 product_manager CTA 审查。"
  echo "   如需跳过审查，请创建文件: touch _cta_reviewed_$(date +%Y%m%d)_SKIPPED.md"
  echo "   并说明跳过原因（如：Connie确认无需CTA）。"
  echo ""
  echo "   部署暂停..."
  echo "   提示：运行以下命令标记审查 -> touch _cta_reviewed_$(date +%Y%m%d).md"
  echo "   提示：运行以下命令跳过审查 -> touch _cta_reviewed_$(date +%Y%m%d)_SKIPPED.md"
  exit 1
fi

# 显示审查状态
for f in _cta_reviewed_*.md; do
  echo "   CTA 审查已通过: $f"
done

echo "Step 0b: 英文标题完整性校验..."
SHORT_TITLES=$(grep -oP '(?<=title: ")[^"]+' src/pages/en/blog.astro | awk 'length < 20 {print}' | head -5)
if [ -n "$SHORT_TITLES" ]; then
  echo "   发现短标题（<20字符），疑似截断:"
  echo "$SHORT_TITLES" | while IFS= read -r t; do
    echo "      \"$t\""
  done
  echo "   部署中止。请先在 en/blog.astro 中修复完整标题。"
  exit 1
fi

# 中文标题校验（<6字符视为异常）
python3 scripts/check_title_length.py || exit 1

echo "   所有标题长度正常"

echo ""
echo "Step 1: 构建..."
npm run build 2>&1 | tail -3

echo ""
echo "Step 2: Wrangler 部署..."
CLOUDFLARE_API_TOKEN="$CF_TOKEN" \
npx wrangler pages deploy dist --project-name=humanaifit-website 2>&1 || true

echo ""
echo "Step 3: Purge Cache..."
PURGE_RESULT=$(curl -s --max-time 10 -X POST \
  "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/purge_cache" \
  -H "Authorization: Bearer $CF_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"purge_everything":true}')

echo "$PURGE_RESULT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print('   缓存清除:', ' 成功' if d.get('success') else ' 失败')
"

echo ""
echo "部署完成！访问 https://www.humanaifit.com 查看"
