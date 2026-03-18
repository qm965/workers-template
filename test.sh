#!/usr/bin/env bash
set -euo pipefail

# 替换为你的 Notion 页面 ID（页面 URL 末尾的 32 位字符串）
PAGE_ID="2f55301e0f7380129b90c13d8f65448c"

echo "=== 测试 1：基础提取（不递归子页面）==="
ntn workers exec extractFullDocument --local -d "{\"pageId\": \"${PAGE_ID}\", \"followChildPages\": null}"

echo ""
echo "=== 测试 2：递归进入子页面 ==="
ntn workers exec extractFullDocument --local -d "{\"pageId\": \"${PAGE_ID}\", \"followChildPages\": true}"
