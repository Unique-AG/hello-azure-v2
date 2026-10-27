#!/usr/bin/env python3
"""Check the Renovate directives above terraform-modules sources.

1. Every terraform-modules source has a directive that the Renovate regex manager in .github/renovate.json5 matches.
2. Each directive's currentValue is the tag at the pinned SHA (tag <depName>@<currentValue>, via git ls-remote).

Run: python3 scripts/renovate-directives.test.py   (step 2 needs network; --offline skips it)
"""
import pathlib
import re
import subprocess
import sys

# Same pattern as the custom regex manager in .github/renovate.json5.
DIRECTIVE = re.compile(
    r"# renovate: datasource=(?P<datasource>[^\s]+) depName=(?P<depName>[^\s]+) packageName=(?P<packageName>[^\s]+)"
    r" currentValue=(?P<currentValue>[^\s]+)\n\s+source\s*=\s*\"[^\"]*\?ref=(?P<currentDigest>[a-f0-9]{40})\""
)
SOURCE = re.compile(r'source\s*=\s*"[^"]*terraform-modules[^"]*"', re.I)
REPO = "https://github.com/Unique-AG/terraform-modules.git"

root = pathlib.Path(__file__).resolve().parent.parent
files = [f for f in root.glob("0[12]_*/*/*.tf") if ".terraform" not in f.parts]
fail = 0
found = []
for f in files:
    text = f.read_text()
    matched = list(DIRECTIVE.finditer(text))
    if not len(matched) == len(SOURCE.findall(text)) == text.count("# renovate:"):
        print(f"FAIL: {f.relative_to(root)}: every terraform-modules source needs exactly one renovate directive right above it")
        fail = 1
    found += [(f.relative_to(root), m) for m in matched]

if "--offline" not in sys.argv:
    refs = {}
    for line in subprocess.run(["git", "ls-remote", "--tags", REPO], capture_output=True, text=True, check=True).stdout.splitlines():
        sha, ref = line.split("\t")
        refs[ref.removeprefix("refs/tags/")] = sha  # the peeled "^{}" entry of an annotated tag sorts after the tag
    for path, m in found:
        tag = f"{m['depName']}@{m['currentValue']}"
        commit = refs.get(tag + "^{}", refs.get(tag))
        if commit != m["currentDigest"]:
            print(f"FAIL: {path}: tag {tag} is {commit}, source pins {m['currentDigest']}")
            fail = 1

if not found:
    print("FAIL: no directives found")
    fail = 1
if not fail:
    print(f"renovate-directives.test.py: ok ({len(found)} directives)")
sys.exit(fail)
