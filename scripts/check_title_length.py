#!/usr/bin/env python3
"""Check blog.astro title entries for truncation (too-short titles)."""
import re
import sys

def check_titles(filename, min_len, label):
    with open(filename) as f:
        content = f.read()
    short_titles = []
    for line in content.split('\n'):
        line = line.strip()
        if not line.startswith('{'):
            continue
        m = re.search(r"\btitle\s*:\s*['\"`]([^'\"`\n]+?)['\"`]\s*,\s*tags\s*:", line)
        # 若标题内含转义引号(\\"), 上面的非贪婪可能在首个转义引号处截断；
        # 处理含转义双引号的标题
        m2 = re.search(r'\btitle\s*:\s*"((?:[^"\\]|\\.)*)"\s*,\s*tags\s*:', line)
        if m2:
            t = m2.group(1).replace('\\"', '"').strip()
            if len(t) < min_len:
                short_titles.append(t)
            continue
        if m:
            t = m.group(1).strip()
            if len(t) < min_len:
                short_titles.append(t)
    if short_titles:
        print(f"   ❌ {label}: {len(short_titles)} short titles (<{min_len} chars):")
        for t in short_titles:
            print(f"      ⚠️ \"{t}\"")
        return False
    print(f"   ✅ {label}: all OK ({min_len}+ chars)")
    return True

ok_en = check_titles('src/pages/en/blog.astro', 20, 'EN titles')
ok_zh = check_titles('src/pages/blog.astro', 6, 'ZH titles')
sys.exit(0 if ok_en and ok_zh else 1)
