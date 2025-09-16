#!/bin/sh
# /docker-entrypoint.d/40-env-subst.sh

# Substitui variáveis de ambiente nos arquivos JavaScript
for file in /usr/share/nginx/html/static/js/*.js; do
  if [ -f "$file" ]; then
    echo "Substituindo variáveis de ambiente em $file"
    sed -i "s|REACT_APP_API_URL_PLACEHOLDER|${REACT_APP_API_URL}|g" "$file"
  fi
done

# Também substitui no index.html se necessário
if [ -f "/usr/share/nginx/html/index.html" ]; then
  echo "Substituindo variáveis de ambiente no index.html"
  sed -i "s|REACT_APP_API_URL_PLACEHOLDER|${REACT_APP_API_URL}|g" "/usr/share/nginx/html/index.html"
fi

exec "$@"