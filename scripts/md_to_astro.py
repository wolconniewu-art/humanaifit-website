#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Markdown 深度稿 -> humanaifit 站点 .astro 文章文件。

用法:
  python3 scripts/md_to_astro.py <in.md> <out.astro> --lang zh|en --slug <slug>

规则（与现有文章结构一致）:
- 用 Article layout
- 标题/描述/日期/tags/lang 通过 props 传入
- 正文转成 Article body 内的 HTML（h2/h3/p/table/hr/ul/ol/blockquote）
- 中文引号在 frontmatter 的 description 中替换为 &quot; 避免引号冲突
"""
import sys, re, os, html, subprocess

PANDOC = "/home/connie/.local/lib/python3.12/site-packages/pypandoc/files/pandoc"

TEMPLATE = """---
import Article from {layout_path};
const tags = {tags_js};
const articleDate = '{date}';
---

<Article
  title={title_js}
  description={desc_js}
  date={{articleDate}}
  tags={{tags}}
  lang="{lang}"
>
  <section class="article-hero">
    <div class="container" style="max-width:720px;">
      <a href="{back_href}" class="article-back">{back_label}</a>
      <p class="section-label" style="color:var(--color-accent);">{blog_label} · {date}</p>
      <h1 style="font-size:2rem;line-height:1.35;">{title_html}</h1>
      <div class="article-meta">
        <span>{date}</span>
        {{tags.filter(Boolean).map(t => <span class="tag">{{t}}</span>)}}
      </div>
    </div>
  </section>
  <div class="article-body">

{body}

  </div>
</Article>
"""


def parse_md(path):
    text = open(path, encoding='utf-8').read()
    fm = {}
    m = re.match(r'^---\n(.*?)\n---\n', text, re.S)
    if m:
        block = m.group(1)
        text = text[m.end():]
        for line in block.splitlines():
            mm = re.match(r'^(\w+):\s*(.*)$', line)
            if mm:
                fm[mm.group(1)] = mm.group(2).strip()
        # tags list
        tags = re.findall(r'^\s*-\s*(.+)$', block, re.M)
        if 'tags' in block:
            fm['_tags_all'] = tags
    return fm, text


def md_body_to_html(md_text):
    r = subprocess.run(
        [PANDOC, '-f', 'gfm+pipe_tables', '-t', 'html', '--wrap=none'],
        input=md_text, capture_output=True, text=True)
    if r.returncode != 0:
        sys.exit("pandoc failed: " + r.stderr)
    return r.stdout


def main():
    if len(sys.argv) < 4:
        sys.exit(__doc__)
    src = sys.argv[1]
    out = sys.argv[2]
    lang = 'zh'
    slug = None
    args = sys.argv[3:]
    for i, a in enumerate(args):
        if a == '--lang':
            lang = args[i + 1]
        if a == '--slug':
            slug = args[i + 1]

    fm, md = parse_md(src)
    title = fm.get('title', '').strip('"').strip("'")
    date = fm.get('date', '2026-09-12')
    sources = [s.strip() for s in re.findall(r'^\s*-\s*(.+)$', fm.get('_sources_raw', ''), re.M)]

    # body: drop the top H1 (title is in hero)
    body_md = re.sub(r'^#\s+.*\n', '', md, count=1)
    body_html = md_body_to_html(body_md).strip()

    # tags: take from frontmatter tags block
    all_list = fm.get('_tags_all', [])
    # filter out sources entries (those follow 'sources:')
    tags = []
    seen_sources = False
    raw = open(src, encoding='utf-8').read()
    m = re.match(r'^---\n(.*?)\n---\n', raw, re.S)
    if m:
        for line in m.group(1).splitlines():
            if re.match(r'^sources:', line):
                seen_sources = True
            if re.match(r'^tags:', line):
                seen_sources = False
                continue
            if re.match(r'^\w+:', line):
                continue
            if line.strip().startswith('- ') and not seen_sources:
                t = line.strip()[2:].strip().strip('"').strip("'")
                if t:
                    tags.append(t)

    tags_js = '[' + ', '.join('"%s"' % t.replace('"', '\\"') for t in tags) + ']'

    # description: first paragraph after 摘要/Abstract
    desc = ''
    dm = re.search(r'##\s*(摘要|Abstract)\s*\n+(.+?)\n', body_md, re.S)
    if dm:
        desc = re.sub(r'\s+', ' ', dm.group(2)).strip()
    if not desc:
        desc = title
    desc = desc.replace('"', '&quot;')
    if len(desc) > 200:
        desc = desc[:197] + '…'

    title_js = '"%s"' % title.replace('"', '&quot;')
    title_html = html.escape(title)
    desc_js = '"%s"' % desc

    if lang == 'zh':
        layout = '../../layouts/Article.astro'
        back_href, back_label, blog_label = '/blog/', '← 返回博客', '博客'
    else:
        layout = '../../../layouts/Article.astro'
        back_href, back_label, blog_label = '/en/blog/', '← Back to Blog', 'Blog'

    out_text = TEMPLATE.format(
        layout_path=layout, tags_js=tags_js, date=date,
        title_js=title_js, desc_js=desc_js, title_html=title_html,
        lang=lang, back_href=back_href, back_label=back_label,
        blog_label=blog_label, body=body_html)

    os.makedirs(os.path.dirname(out), exist_ok=True)
    open(out, 'w', encoding='utf-8').write(out_text)
    print("WROTE", out, len(out_text), "bytes")


if __name__ == '__main__':
    main()
