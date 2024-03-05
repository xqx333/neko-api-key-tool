# 使用node官方镜像作为构建环境
FROM node:16 as builder

# 设置工作目录
WORKDIR /app

# 复制项目文件到工作目录
COPY . .

RUN npm run lint -- --fix
# 安装项目依赖
RUN npm install

# 构建React应用
RUN npm run build

# 使用nginx官方镜像作为部署环境
FROM nginx:1.19.0-alpine

# 将构建的React应用复制到Nginx的html目录
COPY --from=builder /app/build /usr/share/nginx/html

# 如果你有自定义的nginx配置文件，也复制进去
# COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口80
EXPOSE 80

# 启动Nginx
CMD ["nginx", "-g", "daemon off;"]
