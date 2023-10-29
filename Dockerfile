# ---- Dependencies ----
FROM node:16-alpine AS build
WORKDIR /app
COPY . .
RUN yarn install
RUN yarn build

FROM nginx:1.24-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY ./start.sh /app/
RUN chmod 777 /app/start.sh
EXPOSE 80
# CMD [ "nginx", "-g", "daemon off;" ]
ENTRYPOINT ["/app/start.sh"]
