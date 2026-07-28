#!/usr/bin/env python3
"""
auto_sync_check.py — 中英文文章同步巡检

每次部署前自动运行，检查：
1. 中文文章数 == 英文文章数
2. 每个中文 slug 都有对应的英文 slug
3. 中英文 blog.astro 的文章条目是否匹配
4. 英文 blog.astro 标题是否截断

用法:
  python3 scripts/auto_sync_check.py          # 标准检查
  python3 scripts/auto_sync_check.py --fix    # 尝试自动修复小问题
  python3 scripts/auto_sync_check.py --report # 输出详细报告

返回码:
  0 = 全部通过
  1 = 有问题但可修正
  2 = 严重问题（需要人工介入）
"""

import os, sys, glob, re

SITE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ZH_DIR = os.path.join(SITE_DIR, "src/pages/blog")
EN_DIR = os.path.join(SITE_DIR, "src/pages/en/blog")
ZH_BLOG = os.path.join(SITE_DIR, "src/pages/blog.astro")
EN_BLOG = os.path.join(SITE_DIR, "src/pages/en/blog.astro")

def get_slugs(directory):
    """获取目录下所有 .astro 文件的 slug（不含前缀）"""
    paths = glob.glob(os.path.join(directory, "*.astro"))
    slugs = set()
    for p in paths:
        basename = os.path.basename(p)
        if basename.endswith(".astro"):
            slug = basename[:-6]  # 去掉 .astro
            slugs.add(slug)
    return slugs

def get_blog_entries(blog_path):
    """从 blog.astro 中提取所有已注册文章条目"""
    if not os.path.exists(blog_path):
        return []
    with open(blog_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    entries = []
    # 匹配 blog.astro data array 中的文章条目，格式灵活：
    # { date: "...", slug: "...", title: "...", tags: "..." }
    # 字段顺序可变，用 slug 存在与否作为判断
    # 逐行扫描以避免复杂的跨行正则
    for line in content.split('\n'):
        line_stripped = line.strip()
        # 跳过空行、注释、数组边界
        if not line_stripped or line_stripped in ('];', '[', ','):
            continue
        # 去掉尾部的逗号
        if line_stripped.endswith(','):
            line_stripped = line_stripped[:-1]
        
        # 必须是对象开始
        if not line_stripped.startswith('{'):
            continue
        
        # 提取 slug（支持单引号或双引号）
        slug_match = re.search(r"slug:\s*['\"]([^'\"]+)['\"]", line_stripped)
        if not slug_match:
            continue
        slug = slug_match.group(1)
        
        # 提取 title（支持单引号或双引号）
        title_match = re.search(r"title:\s*['\"]([^'\"]*)['\"]", line_stripped)
        title = title_match.group(1) if title_match else ''
        
        # 提取 date（支持单引号或双引号）
        date_match = re.search(r"date:\s*['\"]([^'\"]+)['\"]", line_stripped)
        date_val = date_match.group(1) if date_match else ''
        
        entries.append({
            'slug': slug,
            'title': title,
            'date': date_val
        })
    return entries

def check_sync(fix_mode=False, report_mode=False):
    issues = []
    warnings = []
    
    # 1. 文件数量检查
    zh_slugs = get_slugs(ZH_DIR)
    en_slugs = get_slugs(EN_DIR)
    
    zh_count = len(zh_slugs)
    en_count = len(en_slugs)
    
    if report_mode:
        print(f"文件数量: 中文={zh_count} 英文={en_count}")
    
    if zh_count != en_count:
        only_zh = zh_slugs - en_slugs
        only_en = en_slugs - zh_slugs
        issues.append(f"中英文文章数量不一致: 中文={zh_count} 英文={en_count}")
        if only_zh:
            issues.append(f"  仅有中文: {', '.join(sorted(only_zh))}")
        if only_en:
            issues.append(f"  仅有英文: {', '.join(sorted(only_en))}")
    
    # 2. 交叉匹配（部分匹配的情况）
    common = zh_slugs & en_slugs
    if not report_mode and zh_count == en_count and len(common) == zh_count:
        print(f"✅ 中英文完全匹配: {zh_count} 对文章")
    
    if report_mode:
        print(f"完全匹配: {len(common)}/{zh_count}")
        if zh_slugs - en_slugs:
            print(f"  ⚠️ 仅有中文: {zh_slugs - en_slugs}")
        if en_slugs - zh_slugs:
            print(f"  ⚠️ 仅有英文: {en_slugs - zh_slugs}")
    
    # 3. blog.astro 注册检查
    zh_entries = get_blog_entries(ZH_BLOG)
    en_entries = get_blog_entries(EN_BLOG)
    
    zh_registered_slugs = set(e['slug'] for e in zh_entries)
    en_registered_slugs = set(e['slug'] for e in en_entries)
    
    # 检查是否有文章文件存在但未注册到 blog.astro
    zh_unregistered = zh_slugs - zh_registered_slugs
    en_unregistered = en_slugs - en_registered_slugs
    
    if zh_unregistered:
        issues.append(f"中文 blog.astro 未注册: {', '.join(sorted(zh_unregistered))}")
    if en_unregistered:
        issues.append(f"英文 blog.astro 未注册: {', '.join(sorted(en_unregistered))}")
    
    if report_mode:
        print(f"blog.astro 注册: 中文={len(zh_entries)} 英文={len(en_entries)}")
        if zh_unregistered:
            print(f"  ⚠️ 中文未注册: {zh_unregistered}")
        if en_unregistered:
            print(f"  ⚠️ 英文未注册: {en_unregistered}")
    
    # 4. 英文标题截断检查
    SHORT_TITLE_THRESHOLD = 20
    short_titles = []
    for e in en_entries:
        if len(e['title']) < SHORT_TITLE_THRESHOLD:
            short_titles.append((e['slug'], e['title'], len(e['title'])))
    
    if short_titles:
        for slug, title, length in short_titles:
            warnings.append(f"英文标题可能截断: '{title}' ({length} chars) — slug: {slug}")
    
    if report_mode and warnings:
        print(f"\n⚠️  警告 ({len(warnings)}):")
        for w in warnings:
            print(f"  {w}")
    
    # 5. 中英文 blog.astro 条目数量一致性
    if len(zh_entries) != len(en_entries):
        warnings.append(f"中英文 blog.astro 条目数不一致: 中文={len(zh_entries)} 英文={len(en_entries)}")
    
    # 输出
    if issues:
        print(f"\n❌ 问题 ({len(issues)}):")
        for i in issues:
            print(f"  {i}")
        
        if fix_mode:
            print("\n🔧 自动修复模式: 以上问题需要手动处理")
            print("   中英文同步问题无法自动修复，需要人工创建缺失的 .astro 文件")
    
    if not issues and not warnings:
        print("✅ 中英文同步检查全部通过")
        return 0
    elif issues:
        return 2
    else:
        return 1

if __name__ == "__main__":
    fix_mode = "--fix" in sys.argv
    report_mode = "--report" in sys.argv
    
    if report_mode:
        print(f"===== 中英文同步巡检报告 =====")
        print(f"站点目录: {SITE_DIR}")
        print(f"检查时间: {__import__('datetime').datetime.now().isoformat()}")
        print()
    
    result = check_sync(fix_mode, report_mode)
    sys.exit(result)
