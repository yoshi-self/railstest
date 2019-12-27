FROM ruby:2.6-alpine

RUN apk add --no-cache \
        nginx \
        nodejs \
        tzdata \
        mariadb-connector-c

WORKDIR /webapp
COPY Gemfile Gemfile.lock /webapp/
RUN apk add --no-cache --virtual .build-deps \
        libxml2-dev curl-dev make gcc libc-dev g++ mariadb-connector-c-dev && \
    bundle update --bundler && \
#    bundle install --without development test && \
    bundle install && \
    apk del --no-cache .build-deps && \
    wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz && \
    tar -xzvf entrykit_0.4.0_Linux_x86_64.tgz && \
    rm entrykit_0.4.0_Linux_x86_64.tgz && \
    mv entrykit /usr/local/bin/entrykit && \
    chmod +x /usr/local/bin/entrykit && \
    entrykit --symlink && \
    mkdir -p /run/nginx && \
    sed -i -e 's/user nginx/user root/' /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf


COPY nginx-site.conf /etc/nginx/conf.d/
COPY . /webapp
RUN mkdir -p /webapp/tmp/pids && \
    mkdir -p /webapp/tmp/sockets && \
    mkdir -p /webapp/log

# CMD bundle exec puma -d -C config/puma.rb ; /usr/sbin/nginx -g 'daemon off;'
# CMD ["/webapp/start.sh"]
CMD ["codep", \
        "puma -C /webapp/config/puma.rb", \
        "/usr/sbin/nginx"]
