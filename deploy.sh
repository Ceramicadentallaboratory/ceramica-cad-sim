#!/bin/zsh
# Minify source → obfuscate JS → commit → push
# Usage: ./deploy.sh "commit message"

set -e

SRC="/Users/ceramica/ceramica-business/engineering/cad-simulator/hoken-crown.html"
DST="$(dirname "$0")/index.html"

# Also mirror unminified copy to sales/materials/ for offline reference
SALES_COPY="/Users/ceramica/ceramica-business/sales/materials/cad-preset-simulator.html"

cd "$(dirname "$0")"

# Step 1: HTML minification + base JS mangling
./node_modules/.bin/html-minifier-terser \
  --collapse-whitespace \
  --remove-comments \
  --minify-css true \
  --minify-js '{"mangle":true,"compress":{"drop_console":true}}' \
  "$SRC" -o "$DST"

# Step 2: Strong JS obfuscation on the main inline script (skips tiny SW loader)
DST="$DST" node -e '
const fs = require("fs");
const JS = require("javascript-obfuscator");
const html = fs.readFileSync(process.env.DST, "utf8");
let idx = 0;
const out = html.replace(/<script>([\s\S]*?)<\/script>/g, (m, code) => {
  idx++;
  if (idx === 1) return m;
  const obf = JS.obfuscate(code, {
    compact: true,
    stringArray: true,
    stringArrayEncoding: ["base64"],
    stringArrayThreshold: 0.7,
    splitStrings: true,
    splitStringsChunkLength: 12,
    selfDefending: true,
    disableConsoleOutput: true,
    identifierNamesGenerator: "mangled-shuffled"
  }).getObfuscatedCode();
  return "<script>" + obf + "</script>";
});
fs.writeFileSync(process.env.DST, out);
console.log("Obfuscated:", (out.length/1024).toFixed(1) + "KB");
'

# Step 3: Mirror unminified source to sales/materials/ (offline reference)
cp "$SRC" "$SALES_COPY"

git add index.html
git commit -m "${1:-Update simulator}"
git push
