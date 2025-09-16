FROM node:18-alpine as build

WORKDIR /app

COPY package*.json ./
RUN npm ci --silent

COPY . .
RUN npm run build

# Fase de produção
FROM nginx:alpine

# Copiar build do React
COPY --from=build /app/build /usr/share/nginx/html

# Configuração do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Script para substituir variáveis de ambiente em tempo de execução
COPY env.sh /docker-entrypoint.d/40-env-subst.sh
RUN chmod +x /docker-entrypoint.d/40-env-subst.sh

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]