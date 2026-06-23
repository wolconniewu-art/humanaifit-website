#!/bin/bash
# rollback.sh — 从备份 tarball 回滚并重新部署
# 用法: bash scripts/rollback.sh [备份文件路径]
#       无参时使用 __backups/latest 记录的最新备份
set -euo pipefail

SITE_DIR="/home/connie/.openclaw/workspace/humanaifit-website"
BACKUP_DIR="$SITE_DIR/__backups"
LATEST_FILE="$BACKUP_DIR/latest"

# 确定备份文件
BACKUP_FILE="${1:-}"
if [ -z "$BACKUP_FILE" ]; then
  if [ -f "$LATEST_FILE" ]; then
    BACKUP_FILE=$(cat "$LATEST_FILE")
  else
    echo "❌ 无备份文件可用。请指定: bash scripts/rollback.sh /path/to/backup.tar.gz"
    exit 1
  fi
fi

if [ ! -f "$BACKUP_FILE" ]; then
  echo "❌ 备份文件不存在: $BACKUP_FILE"
  exit 1
fi

echo ""
echo "========================================"
echo "  ⚡ 回滚操作"
echo "========================================"
echo "  备份文件: $(basename $BACKUP_FILE)"
echo ""

cd "$SITE_DIR"

# 保留 node_modules 和 dist（避免重新安装）
echo "⏳ 移除当前 src/ + 配置文件..."
rm -rf \
  src \
  public \
  astro.config.mjs \
  package.json \
  wrangler.toml

echo "⏳ 从备份恢复..."
tar xzf "$BACKUP_FILE"

echo "⏳ 重新构建..."
npm run build 2>&1 | tail -5

echo ""
echo "🚀 重新部署..."
bash deploy_humanaifit.sh

echo ""
echo "✅ 回滚完成！"
echo "   源备份: $(basename $BACKUP_FILE)"
echo "   请访问 https://www.humanaifit.com 验证"
