FROM alpine:latest 
RUN apk update && apk add nginx
COPY default.conf /etc/nginx/http.d
CMD ["nginx", "-g", "daemon off;"]
