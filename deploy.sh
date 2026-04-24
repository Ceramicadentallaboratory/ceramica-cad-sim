#!/bin/zsh
# Minify source → commit → push
# Usage: ./deploy.sh "commit message"

set -e

SRC="/Users/ceramica/マイドライブ/.company/engineering/cad-simulator/variants/hoken-crown.html"
DST="$(dirname "$0")/index.html"

npx -y html-minifier-terser \
  --collapse-whitespace \
  --remove-comments \
  --minify-css true \
  --minify-js '{"mangle":true,"compress":{"drop_console":true}}' \
  "$SRC" -o "$DST"

cd "$(dirname "$0")"
git add index.html
git commit -m "${1:-Update simulator}"
git push
