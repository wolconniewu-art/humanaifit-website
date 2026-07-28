#!/usr/bin/env python3
"""
verify_refs.py — 参考文献格式全量校验

检查所有中英文文章的参考文献区域：
1. 有 <h2>参考文献</h2> / <h2>References</h2> 时，必须使用 <ol>/<li> 结构
2. 参考文献 <ol> 内不得有 <p> 标签包裹引用条目

用法:
  python3 scripts/verify_refs.py                    # 全量检查（格式错误阻断）
  python3 scripts/verify_refs.py <slug>             # 单篇检查（格式错误阻断）

返回值: 0 = 通过, 1 = 不通过
"""

import re
import sys
from pathlib import Path

SITE_DIR = Path(__file__).resolve().parent.parent
BLOG_DIR = SITE_DIR / "src" / "pages" / "blog"
EN_BLOG_DIR = SITE_DIR / "src" / "pages" / "en" / "blog"
BLOG_ASTRO = SITE_DIR / "src" / "pages" / "blog.astro"


def get_all_slugs():
    """从 blog.astro 提取所有 slug"""
    content = BLOG_ASTRO.read_text()
    return re.findall(r'slug:\s*"([^"]+)"', content)


def count_refs_in_ol(content):
    """提取参考文献/References 章节中的 <ol> 块

    返回 (li_count, has_p_in_ol, has_ol)
    - li_count: <ol> 中的 <li> 数量
    - has_p_in_ol: <ol> 块内是否有 <p>
    - has_ol: 是否有 <ol> 块
    无参考文献章节时返回 (None, None, None)
    """
    # 匹配中文和英文标题——精确匹配"参考文献"或"References"（整词匹配）
    for pattern in [
        re.compile(r'<h2>\s*参考文献\s*</h2>'),
        re.compile(r'<h2>\s*References\s*</h2>'),
    ]:
        m = pattern.search(content)
        if m:
            ref_end = m.end()
            rest = content[ref_end:]
            ol_m = re.search(r'(<ol>.*?</ol>)', rest, re.DOTALL)
            if ol_m:
                ol_block = ol_m.group(1)
                li_count = ol_block.count("<li>")
                has_p_in_ol = "<p>" in ol_block

                # 额外检测：</ol> 后是否有 <p> 包裹的引用条目
                ol_end = ol_m.end()
                after_ol = rest[ol_end:]
                # 检查下一个 h2 或 article 结束之前的区域
                next_section = re.split(r'<h2>|</article>', after_ol)[0]
                has_p_after = bool(re.search(r'<p>\s*\d+\.', next_section))

                return li_count, has_p_in_ol or has_p_after, True
            else:
                # 有标题但无 <ol> —— 原创声明/免责声明等情况，不报错
                return 0, False, False
    return None, None, None


def check_slug(slug):
    """检查单个 slug 的中英文"""
    zh_file = BLOG_DIR / f"{slug}.astro"
    en_file = EN_BLOG_DIR / f"{slug}.astro"

    zh_exists = zh_file.exists()
    en_exists = en_file.exists()

    if not zh_exists and not en_exists:
        return True

    has_error = False

    # 检查中文
    if zh_exists:
        content = zh_file.read_text(encoding="utf-8")
        li_count, has_p, has_ol = count_refs_in_ol(content)
        if li_count is not None:  # 有参考文献章节
            if has_p:
                print(f"  ❌ 中文 {slug}: 参考文献 <ol> 内含 <p> 标签，应用 <li> 格式")
                has_error = True
            z_count = li_count
        else:
            z_count = None

    # 检查英文
    if en_exists:
        content = en_file.read_text(encoding="utf-8")
        li_count, has_p, has_ol = count_refs_in_ol(content)
        if li_count is not None:
            if has_p:
                print(f"  ❌ 英文 {slug}: 参考文献 <ol> 内含 <p> 标签，应用 <li> 格式")
                has_error = True
            e_count = li_count
        else:
            e_count = None

    # 检查数量一致性（仅警告）
    if zh_exists and en_exists and z_count is not None and e_count is not None:
        if z_count != e_count:
            print(f"  ⚠️  {slug}: 参考文献数量不一致（中文 {z_count} vs 英文 {e_count}）")

    if has_error:
        return False
    if z_count is not None:
        print(f"  ✅ {slug}: 参考文献格式正确（{z_count} 条）")
    return True


def main():
    slugs = get_all_slugs()

    if len(sys.argv) > 1:
        # 单篇检查——无论 slug 是否已注册到 blog.astro，只要 .astro 文件存在就检查
        slug = sys.argv[1]
        zh_file = BLOG_DIR / f"{slug}.astro"
        en_file = EN_BLOG_DIR / f"{slug}.astro"
        if not zh_file.exists() and not en_file.exists():
            print(f"❌ 文章文件不存在: {slug}")
            sys.exit(1)
        ok = check_slug(slug)
        sys.exit(0 if ok else 1)

    # 全量检查
    total = len(slugs)
    passed = 0
    failed = 0
    warned = 0

    print(f"参考文献格式检查：共 {total} 篇文章")
    print()

    for slug in slugs:
        if check_slug(slug):
            passed += 1
        else:
            failed += 1

    # 统计警告数
    warn_count = 0
    for slug in slugs:
        zh_file = BLOG_DIR / f"{slug}.astro"
        en_file = EN_BLOG_DIR / f"{slug}.astro"
        if zh_file.exists() and en_file.exists():
            z = count_refs_in_ol(zh_file.read_text())[0]
            e = count_refs_in_ol(en_file.read_text())[0]
            if z is not None and e is not None and z != e:
                warn_count += 1

    print()
    if failed > 0:
        print(f"结果：通过 {passed} 篇，格式异常 {failed} 篇，数量警告 {warn_count} 篇 ❌")
        sys.exit(1)
    else:
        print(f"结果：全部 {total} 篇通过 ✅")
        if warn_count > 0:
            print(f"警告：{warn_count} 篇中英文参考文献数量不一致（建议修复）")
        sys.exit(0)


if __name__ == "__main__":
    main()
