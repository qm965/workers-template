#!/usr/bin/env bash
set -euo pipefail

# 进入 Linux 容器，挂载当前项目目录，自动安装依赖和 ntn CLI
# 用法：bash docker-shell.sh

echo "启动 Linux 容器..."
echo "提示：容器内的 /app 目录对应你本地的项目目录，文件是实时同步的。"
echo "提示：退出容器后所有文件改动都会保留在本地。"
echo ""

docker run -it --rm \
  -v "$(pwd):/app" \
  -w /app \
  --name ntn-workspace \
  node:22 bash -c '
    echo "=== 安装 ntn CLI ==="
    npm install -g ntn --silent

    echo ""
    echo "=== 安装项目依赖 ==="
    npm install --silent

    echo ""
    echo "=== 环境准备完毕 ==="
    echo "现在可以运行："
    echo "  ntn login                  # 登录 Notion"
    echo "  npm run check              # 类型检查"
    echo "  ntn workers deploy         # 部署 worker"
    echo "  ntn workers exec extractFullDocument --local -d '"'"'{...}'"'"'"
    echo ""
    exec bash
  '
