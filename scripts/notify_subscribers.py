#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""notify_subscribers.py — 新文章发布后，通过 Buttondown 向所有订阅者群发通知邮件。

用法:
  python3 scripts/notify_subscribers.py <slug> <标题中文> <标题英文> [中文URL] [英文URL]

API key 读取顺序（未配置则静默跳过，exit 0，不阻断发布流程）:
  1. 环境变量 BUTTONDOWN_API_KEY
  2. ~/.buttondown_key（内容为 key，无换行）
"""
import json
import os
import sys
import urllib.request
import urllib.error

BASE = "https://api.buttondown.com/v1"


def get_key():
    key = os.environ.get("BUTTONDOWN_API_KEY", "").strip()
    if key:
        return key
    f = os.path.expanduser("~/.buttondown_key")
    if os.path.exists(f):
        key = open(f).read().strip()
        if key:
            return key
    return ""


def api(path, key, payload=None, method="GET"):
    url = BASE + path
    data = json.dumps(payload).encode("utf-8") if payload is not None else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Authorization", "Token " + key)
    if data is not None:
        req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            raw = r.read().decode("utf-8", "ignore")
            return r.status, (json.loads(raw) if raw.strip() else {})
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode("utf-8", "ignore")


def main():
    if len(sys.argv) < 4:
        print("用法: notify_subscribers.py <slug> <标题中文> <标题英文> [中文URL] [英文URL]")
        sys.exit(1)
    slug, tz, te = sys.argv[1], sys.argv[2], sys.argv[3]
    uz = sys.argv[4] if len(sys.argv) > 4 else f"https://www.humanaifit.com/blog/{slug}/"
    ue = sys.argv[5] if len(sys.argv) > 5 else f"https://www.humanaifit.com/en/blog/{slug}/"

    key = get_key()
    if not key:
        print("⏭️  未配置 Buttondown API key，跳过订阅者通知（发布流程不受影响）")
        return

    subject = f"humanAIfit 新文章｜{tz}"
    body = (
        f"新文章已上线 humanAIfit 官网。\n\n"
        f"**{tz}**\n"
        f"{te}\n\n"
        f"📖 中文阅读：{uz}\n"
        f"🌐 English：{ue}\n\n"
        f"—— humanAIfit（彼恳企业管理咨询）"
    )

    s1, created = api("/emails", key, {"subject": subject, "body": body}, method="POST")
    if s1 not in (200, 201):
        print(f"❌ 创建邮件失败: {s1} {created}")
        sys.exit(1)
    email_id = created.get("id")
    if not email_id:
        print(f"❌ 创建邮件未返回 id: {created}")
        sys.exit(1)

    s2, sent = api(f"/emails/{email_id}/publish", key, {}, method="POST")
    if s2 in (200, 201, 202, 204):
        print(f"✅ 已向所有订阅者发送新文章通知（email id={email_id}）")
    else:
        print(f"❌ 发送失败: {s2} {sent}")
        sys.exit(1)


if __name__ == "__main__":
    main()
