#!/bin/bash

# CNB 平台部署脚本
# 使用方法: bash deploy_cnb.sh

set -e

echo "================================"
echo "CNB 平台部署脚本"
echo "================================"
echo "项目: snake-game"
echo "仓库: https://cnb.cool/pcxiang/snake-game"
echo "================================"
echo ""
echo "部署步骤:"
echo "1. 打开浏览器，访问: https://cnb.cool/pcxiang/snake-game"
echo "2. 登录您的账号 (使用微信扫码)"
echo "3. 在左侧导航栏中点击 '构建'"
echo "4. 点击 '立即构建' 按钮"
echo "5. 等待构建完成"
echo "6. 构建成功后，平台会显示部署链接"
echo ""
echo "================================"
echo "配置信息:"
echo "================================"
echo "构建环境: node:16-alpine"
echo "部署类型: 静态网站"
echo "静态目录: /app"
echo "端口: 80"
echo "================================"
echo ""
echo "提示: 构建完成后，您可以复制部署链接并分享给朋友!"
