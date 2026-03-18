#!/usr/bin/env bash
set -euo pipefail

# 替换为你的 Notion 页面 ID（页面 URL 末尾的 32 位字符串）
PAGE_ID="your-page-id-here"

echo "=== 测试 1：基础提取（默认参数）==="
ntn workers exec extractFullDocument --local -d "{\"pageId\": \"${PAGE_ID}\"}"

echo ""
echo "=== 测试 2：限制递归深度为 2 层 ==="
ntn workers exec extractFullDocument --local -d "{\"pageId\": \"${PAGE_ID}\", \"maxDepth\": 2}"

echo ""
echo "=== 测试 3：同时递归进入子页面 ==="
ntn workers exec extractFullDocument --local -d "{\"pageId\": \"${PAGE_ID}\", \"followChildPages\": true}"
