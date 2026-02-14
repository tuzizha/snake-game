# CNB.cool 平台部署指南

## 项目信息
- 项目名称：贪吃蛇游戏（头部动作控制）
- 部署平台：https://cnb.cool
- 用户名：pcxiang

## 准备工作

### 1. 本地环境要求
- Git 已安装
- 可以访问 cnb.cool 网站
- 微信（用于扫码登录）

### 2. 项目文件
您的项目已经包含以下文件：
- `index.html` - 游戏主文件
- `.cnb.yml` - CNB 平台配置文件
- `.gitignore` - Git 忽略文件配置

## 部署步骤

### 步骤 1：登录 CNB 平台
1. 打开浏览器，访问 https://cnb.cool
2. 点击右上角的 "登录" 按钮
3. 使用微信扫码登录

### 步骤 2：创建新仓库
1. 登录后，点击右上角的 "新建仓库" 按钮
2. 在 "仓库名称" 中输入：`snake-game`
3. "仓库描述" 可填写：`头部动作控制的贪吃蛇游戏`
4. 可见性选择：`公开` 或 `私有`（根据您的需求）
5. 点击 "创建" 按钮

### 步骤 3：推送代码
在您的本地项目目录中执行以下命令：

```bash
# 进入项目目录
cd /path/to/snake-game

# 添加远程仓库
git remote add origin https://cnb.cool/pcxiang/snake-game.git

# 推送代码（首次推送需要输入 CNB 平台的账号密码）
git push -u origin master
```

### 步骤 4：配置构建
1. 代码推送成功后，返回 CNB 平台的仓库页面
2. 点击左侧导航栏的 "构建" 选项
3. 系统会自动检测 `.cnb.yml` 配置文件
4. 点击 "立即构建" 按钮

### 步骤 5：查看部署状态
1. 构建过程中，您可以查看构建日志
2. 构建成功后，平台会显示部署状态
3. 点击 "访问" 按钮，即可打开部署后的网站

## 配置说明

### .cnb.yml 配置文件
```yaml
# CNB 云原生构建配置
# 参考文档: https://cnb.cool/docs

name: snake-game
version: 1.0.0
description: 头部动作控制的贪吃蛇游戏

# 构建环境
build:
  # 使用 Docker 镜像作为构建环境
  image: nginx:alpine
  # 构建命令
  commands:
    - echo "Building snake game..."
    - ls -la
    - cp index.html /usr/share/nginx/html/

# 部署配置
deploy:
  # 部署类型
  type: static
  # 静态文件目录
  static_dir: /usr/share/nginx/html
  # 端口配置
  port: 80

# 依赖配置
deps:
  - name: nginx
    version: latest

# 环境变量
env:
  - name: NODE_ENV
    value: production
```

## 常见问题

### 1. 推送代码时认证失败
- **解决方法**：确保您输入的是 CNB 平台的正确账号密码
- **提示**：如果您使用的是微信登录，可能需要设置专门的 Git 访问凭证

### 2. 构建失败
- **检查**：查看构建日志，确认错误信息
- **常见原因**：
  - 网络问题
  - 配置文件错误
  - 依赖缺失

### 3. 访问网站时出现 404
- **检查**：确保 `index.html` 文件存在且位于正确位置
- **解决方法**：检查 `.cnb.yml` 中的 `static_dir` 配置

## 成功部署后

部署成功后，您可以：
1. 分享游戏链接给朋友
2. 在 CNB 平台上管理构建和部署
3. 继续开发和更新游戏功能

祝您游戏愉快！🎉
