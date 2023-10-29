#!/bin/sh
echo "start read environment variables"

# URL 编码函数
urlencode() {
  echo "$1" | sed 's/"/%22/g; s/\//%2F/g; s/=/%3D/g; s/:/%3A/g; s/?/%3F/g; s/,/%2C/g'
}

# 检查 VUE_APP_SUBCONVERTER_REMOTE_CONFIG 是否非空
if [ -n "$VUE_APP_SUBCONVERTER_REMOTE_CONFIG" ]; then
  echo "VUE_APP_SUBCONVERTER_REMOTE_CONFIG: $VUE_APP_SUBCONVERTER_REMOTE_CONFIG"
  remoteConfigSample="$VUE_APP_SUBCONVERTER_REMOTE_CONFIG"
fi

# 检查 VUE_APP_SUBCONVERTER_DEFAULT_BACKEND 是否非空
if [ -n "$VUE_APP_SUBCONVERTER_DEFAULT_BACKEND" ]; then
  echo "VUE_APP_SUBCONVERTER_DEFAULT_BACKEND: $VUE_APP_SUBCONVERTER_DEFAULT_BACKEND"
  defaultBackend="$VUE_APP_SUBCONVERTER_DEFAULT_BACKEND"
fi

# 检查 VUE_APP_MYURLS_API 是否非空
if [ -n "$VUE_APP_MYURLS_API" ]; then
  echo "VUE_APP_MYURLS_API: $VUE_APP_MYURLS_API"
  shortUrlBackend="$VUE_APP_MYURLS_API"
fi

# 检查 VUE_APP_CONFIG_UPLOAD_API 是否非空
if [ -n "$VUE_APP_CONFIG_UPLOAD_API" ]; then
  echo "VUE_APP_CONFIG_UPLOAD_API: $VUE_APP_CONFIG_UPLOAD_API"
  configUploadBackend="$VUE_APP_CONFIG_UPLOAD_API"
fi

# 检查 VUE_APP_BACKEND_OPTIONS 是否非空
if [ -n "$VUE_APP_BACKEND_OPTIONS" ]; then
  echo "VUE_APP_BACKEND_OPTIONS: $VUE_APP_BACKEND_OPTIONS"
  backendOptions=$(urlencode "$VUE_APP_BACKEND_OPTIONS")
fi

# 检查 VUE_APP_REMOTE_CONFIG_LIST 是否非空
if [ -n "$VUE_APP_REMOTE_CONFIG_LIST" ]; then
  echo "VUE_APP_REMOTE_CONFIG: $VUE_APP_REMOTE_CONFIG_LIST"
  remoteConfigList=$(urlencode "$VUE_APP_REMOTE_CONFIG_LIST")
fi

# 构建 sed 命令字符串
sed_command="s@<html@<html data-remote-config-sample=\"$remoteConfigSample\" \
                           data-default-backend=\"$defaultBackend\" \
                           data-short-url-backend=\"$shortUrlBackend\" \
                           data-backend-options=\"$backendOptions\" \
                           data-remote-config-list=\"$remoteConfigList\" \
                           data-config-upload-backend=\"$configUploadBackend\"@"

# 在 index.html 文件中使用 sed 命令替换 <html 标签为指定的值
sed -i "$sed_command" /usr/share/nginx/html/index.html

# 启动 Nginx 服务器
nginx -g "daemon off;"
