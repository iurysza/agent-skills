#!/usr/bin/env python3
"""Inline woff2 fonts into an explainer so it works offline.

Usage: embed-fonts.py <in.html> <out.html> NAME=path.woff2 [NAME=path.woff2 ...]

Replaces each __NAME__ placeholder in the input with the base64 of the font file.
Write @font-face rules like: src:url(data:font/woff2;base64,__SANS400__) format("woff2")
"""
import base64, sys

if len(sys.argv) < 4:
    sys.exit(__doc__)
src, out, *pairs = sys.argv[1:]
html = open(src, encoding="utf-8").read()
for pair in pairs:
    name, path = pair.split("=", 1)
    token = f"__{name}__"
    if token not in html:
        sys.exit(f"placeholder {token} not found in {src}")
    html = html.replace(token, base64.b64encode(open(path, "rb").read()).decode())
if "__" in html and any(f"__{p.split('=')[0]}__" in html for p in pairs):
    sys.exit("some placeholders were not replaced")
open(out, "w", encoding="utf-8").write(html)
print(f"{out}: {len(html)//1024} KB")
