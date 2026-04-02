# 第一阶段：构建前端项目
FROM node:20-alpine AS builder

# 设置工作目录
WORKDIR /app

# 先复制依赖文件，利用缓存
COPY package*.json ./

# 安装依赖
RUN npm install

# 再复制项目全部文件
COPY . .

# 打包项目
RUN npm run build

# 第二阶段：用 nginx 托管静态文件
FROM nginx:alpine

# 删除 nginx 默认静态文件
RUN rm -rf /usr/share/nginx/html/*

# 把第一阶段打包出来的 dist 拷贝到 nginx 目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露 80 端口
EXPOSE 80

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]