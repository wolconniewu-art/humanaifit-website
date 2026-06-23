#!/bin/bash
# backup_now.sh — 每次改动前运行此脚本，备份 src + 配置文件
# 用法: bash scripts/backup_now.sh [备注标签]
set -euo pipefail

DATE=$(date +%Y%m%d_%H%M%S)
SITE_DIR="/home/connie/.openclaw/workspace/humanaifit-website"
BACKUP_DIR="$SITE_DIR/__backups"
TAG="${1:-}"

mkdir -p "$BACKUP_DIR/$DATE"

BACKUP_FILE="$BACKUP_DIR/website_full_$DATE${TAG:+_$TAG}.tar.gz"

tar czf "$BACKUP_FILE" \
  --exclude=node_modules \
  --exclude=.git \
  --exclude=dist \
  --exclude=.astro \
  --exclude=.wrangler \
  --exclude=__backups \
  -C "$SITE_DIR" \
  src public astro.config.mjs package.json wrangler.toml

echo "$BACKUP_FILE" > "$BACKUP_DIR/latest"

echo "✅ 备份完成: $(basename $BACKUP_FILE) ($(du -h "$BACKUP_FILE" | cut -f1))"
echo "📄 最近备份: $(cat $BACKUP_DIR/latest)"
