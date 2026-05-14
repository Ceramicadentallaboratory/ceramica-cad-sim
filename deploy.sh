#!/bin/zsh
# Minify source → commit → push
# Usage: ./deploy.sh "commit message"

set -e

SRC="/Users/ceramica/ceramica-business/engineering/cad-simulator/hoken-crown.html"
DST="$(dirname "$0")/index.html"

# Also mirror unminified copy to sales/materials/ for offline reference
SALES_COPY="/Users/ceramica/ceramica-business/sales/materials/cad-preset-simulator.html"

npx -y html-minifier-terser \
  --collapse-whitespace \
  --remove-comments \
  --minify-css true \
  --minify-js '{"mangle":true,"compress":{"drop_console":true}}' \
  "$SRC" -o "$DST"

# Mirror unminified source to sales/materials/ (for offline reference)
cp "$SRC" "$SALES_COPY"

cd "$(dirname "$0")"
git add index.html
git commit -m "${1:-Update simulator}"
git push
