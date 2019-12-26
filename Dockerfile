FROM ruby:2.6-alpine

RUN apk add --no-cache \
        nginx \
        nodejs \
        mariadb-connector-c

WORKDIR /webapp
COPY Gemfile Gemfile.lock /webapp/
RUN apk add --no-cache --virtual .build-deps \
        libxml2-dev curl-dev make gcc libc-dev g++ mariadb-connector-c-dev && \
    bundle update --bundler && \
    bundle install --without development test && \
    apk del --no-cache .build-deps


COPY nginx-site.conf /etc/nginx/conf.d/

COPY . /webapp
RUN mkdir -p /webapp/tmp/pids && \
    mkdir -p /webapp/tmp/sockets && \
    mkdir -p /webapp/log && \
    mkdir -p /run/nginx && \
    sed -i -e 's/user nginx/user root/' /etc/nginx/nginx.conf && \
    chmod +x start.sh

# CMD bundle exec puma -d -C config/puma.rb ; /usr/sbin/nginx -g 'daemon off;'
CMD ["/webapp/start.sh"]
