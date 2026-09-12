#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Split article hero <h1> titles into main-title + subtitle for better line presentation.

Rule: split on the FIRST occurrence of a natural main/subtitle separator:
  full-width colon  ":"
  half-width colon  ": " (EN)
  em-dash pair      "——"
  em-dash           "—"  (EN, single)
If a separator exists and both parts are non-trivial, render:
  <h1 ...>MAIN</h1>
  <p class="article-subtitle">SUB</p>
Otherwise keep a single <h1>.
"""
import re, glob, sys, os

SEP_RE = re.compile(r'[：]|——|—|: ', re.UNICODE)

def split_title(title: str):
    """Return (main, sub) or (title, None)."""
    t = title.strip()
    m = SEP_RE.search(t)
    if not m:
        return t, None
    idx = m.start()
    sep = m.group()
    main = t[:idx].strip()
    sub = t[idx+len(sep):].strip()
    # guard: both parts must be meaningful; skip if main empty or sub tiny/<3 chars
    if not main or len(sub) < 3:
        return t, None
    # guard: don't split if separator is mid-word for EN (e.g. "AI: " fine, but avoid splitting numbers/time "10:30")
    if sep == ': ' and re.search(r'\d\s*:\s', t):
        # e.g. "10:30" -> not a title sep; fall back to wrap-only single line
        return t, None
    return main, sub

SKIP = ('lingnan_daily_61_tales.astro',)

def transform_hero(path: str):
    """Transform the hero <h1> in an article file."""
    base = os.path.basename(path)
    if base in SKIP:
        print(f'  [SKIP-existing] {base} (already main+subtitle format)')
        return False
    with open(path, encoding='utf-8') as f:
        content = f.read()

    # Find the hero <h1> : from "<h1 " up to "</h1>"
    m = re.search(r'(<h1\s[^>]*>)(.*?)(</h1>)', content, re.DOTALL)
    if not m:
        print(f'  [SKIP] no hero h1: {path}')
        return False

    open_tag, raw = m.group(1), m.group(2)
    main, sub = split_title(raw)
    if sub is None:
        print(f'  [one-line] {os.path.basename(path)}: {raw[:40]}...')
        return False

    # h1 keeps its original inline style; add article-subtitle <p> after it
    new_h1 = f'{open_tag}{main}</h1>'
    sub_p = f'\n      <p class="article-subtitle">{sub}</p>'
    new_block = new_h1 + sub_p
    content = content[:m.start()] + new_block + content[m.end():]

    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f'  [SPLIT] {os.path.basename(path)}: "{main[:30]}..." / "{sub[:30]}..."')
    return True

def main():
    only = sys.argv[1] if len(sys.argv) > 1 else ''
    targets = (glob.glob('src/pages/blog/*.astro') +
               glob.glob('src/pages/en/blog/*.astro'))
    changed = 0
    for p in sorted(targets):
        if only and only not in p:
            continue
        if transform_hero(p):
            changed += 1
    print(f'\nDone. {changed} files updated.')

if __name__ == '__main__':
    main()
