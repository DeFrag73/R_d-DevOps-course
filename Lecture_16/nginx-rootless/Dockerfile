FROM alpine:latest 
RUN apk update && apk add nginx 
COPY index.html /usr/share/nginx/html/
COPY default.conf /etc/nginx/http.d
CMD ["nginx", "-g", "daemon off;"]
