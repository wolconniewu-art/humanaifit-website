#!/usr/bin/env python3
import os, subprocess, datetime

WORKSPACE = "/home/connie/.openclaw/workspace"
WEBSITE_DIR = f"{WORKSPACE}/humanaifit-website"

checks = {
    "网站目录结构完整": False,
    "构建可通过": False,
    "备份目录存在": False,
}

# 1. 结构
pages_dir = f"{WEBSITE_DIR}/src/pages"
if os.path.isdir(pages_dir) and os.path.isdir(f"{pages_dir}/blog") and os.path.isdir(f"{pages_dir}/en/blog"):
    checks["网站目录结构完整"] = True

# 2. 备份
backup_dir = f"{WEBSITE_DIR}/__backups"
if os.path.isdir(backup_dir):
    checks["备份目录存在"] = True

# 3. 构建
r = subprocess.run(["npm", "run", "build"], capture_output=True, text=True, cwd=WEBSITE_DIR, timeout=120)
if r.returncode == 0:
    checks["构建可通过"] = True
else:
    with open("/tmp/preflight_build_error.log", "w") as f:
        f.write(f"STDOUT:\n{r.stdout[:5000]}\n\nSTDERR:\n{r.stderr[:5000]}")

print(f"=== 🛠️ 预检开工锁 — {datetime.datetime.now().isoformat()} ===")
print()
all_pass = True
for name, status in checks.items():
    icon = "✅" if status else "❌"
    print(f"  {icon} {name}")
    if not status:
        all_pass = False

if all_pass:
    print(f"\n✅ 所有 {len(checks)} 项通过，安全可开工。")
else:
    print(f"\n❌ 请先处理失败项。未通过项日志见 /tmp/preflight_build_error.log")
