FROM nginx:1.27.1-alpine

RUN apk add --no-cache \
    gcc \
    libc-dev \
    make \
    libmaxminddb-dev \
    pcre-dev \
    zlib-dev \
    openssl-dev \
    curl \
    git

RUN wget http://nginx.org/download/nginx-1.27.1.tar.gz && \
    tar zxvf nginx-1.27.1.tar.gz

RUN git clone https://github.com/leev/ngx_http_geoip2_module.git

RUN cd nginx-1.27.1 && \
    ./configure --with-compat --add-dynamic-module=../ngx_http_geoip2_module && \
    make modules && \
    cp objs/ngx_http_geoip2_module.so /etc/nginx/modules/

RUN mkdir -p /etc/nginx/geoip

RUN apk del gcc libc-dev make pcre-dev zlib-dev openssl-dev

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
