FROM ubuntu:16.04

# copy source
COPY ./ /gateway

WORKDIR /gateway

RUN apt-get update && \
    apt-get -y install tzdata nginx && \
    ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime &&\
    rm -rf /etc/nginx/sites-available/default && \
    cp nginx.conf /etc/nginx/sites-available/default && \
    service nginx reload

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
