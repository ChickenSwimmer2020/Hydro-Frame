# For cleaning up the language used in commits, ngl probably only i use this :/ --ChickenSwimmer2020
# NO this wasnt made by ai.
# i know bits and peices of Python and i hate this lanuage but its fast enouygh and i dont wanna do it in lua or batch.

import argparse
import os
import re
import sys
from pathlib import Path

DEFAULT_WORDS = [
    "fuck", "shit", "bullshit", "bitch", "bastard", "asshole", "dumbass",
    "damn", "crap", "piss", "dick", "cunt", "ass",
]
SKIP_DIRS = [
    ".git", "bin", ".vscode"
]
SUFFIXES = r"(?:s|es|ed|ing|er|ers|y)?"

def load_words(path):
    words = []
    for line in Path(path).read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line and not line.startswith("#"):
            words.append(line)
    return words

def build_pattern(words):
    alternatives = "|".join(re.escape(w) for w in sorted(set(words), key=len, reverse=True))
    return re.compile(rf"(?<![A-Za-z])(?:{alternatives}){SUFFIXES}(?![A-Za-z])", re.IGNORECASE)

def read_text_file(path):
    try:
        raw = path.read_bytes()
    except OSError:
        return None
    if b"\x00" in raw[:1024]:
        return None
    try:
        return raw.decode("utf-8")
    except UnicodeDecodeError:
        return None

def iter_files(root, extensions, ignore):
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]  # prune in place
        for name in filenames:
            path = Path(dirpath) / name
            if path.resolve() in ignore:
                continue
            if extensions and path.suffix.lower() not in extensions:
                continue
            yield path
 
 
def main():
    parser = argparse.ArgumentParser(description="Scan a folder for swear words.")
    parser.add_argument("folder", nargs="?", default=".", help="folder to scan (default: .)")
    parser.add_argument("--words", help="text file with one word per line")
    parser.add_argument("--ext", nargs="+", help="only scan these extensions, e.g. --ext .hx .py")
    args = parser.parse_args()
 
    root = Path(args.folder)
    if not root.is_dir():
        print(f"ERROR: {root} is not a folder.")
        return 2
 
    words = load_words(args.words) if args.words else DEFAULT_WORDS
    pattern = build_pattern(words)
 
    extensions = None
    if args.ext:
        extensions = {e.lower() if e.startswith(".") else "." + e.lower() for e in args.ext}
 
    # Don't flag this script or the word list for containing the words.
    ignore = {Path(__file__).resolve()}
    if args.words:
        ignore.add(Path(args.words).resolve())
 
    files_scanned = 0
    hits = 0
    for path in iter_files(root, extensions, ignore):
        text = read_text_file(path)
        if text is None:
            continue
        files_scanned += 1
 
        for lineno, line in enumerate(text.splitlines(), start=1):
            found = [m.group(0) for m in pattern.finditer(line)]
            if found:
                hits += len(found)
                snippet = line.strip()
                if len(snippet) > 100:
                    snippet = snippet[:97] + "..."
                print(f"{path}:{lineno}: [{', '.join(found)}] {snippet}")
 
    print(f"\nScanned {files_scanned} files, found {hits} match(es).")
    return 1 if hits else 0  # non-zero exit code is handy for CI / git hooks
 
 
if __name__ == "__main__":
    sys.exit(main())