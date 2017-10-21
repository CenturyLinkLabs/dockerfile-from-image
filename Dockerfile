FROM alpine:3.6
MAINTAINER CenturyLink Labs <clt-labs-futuretech@centurylink.com>

RUN apk add  --update ruby-dev ruby-json && \
    gem install --no-rdoc --no-ri docker-api && \
    apk del ruby-dev && \
    apk add ruby ruby-json && \
    rm /var/cache/apk/*

ADD dockerfile-from-image.rb /usr/src/app/dockerfile-from-image.rb

ENTRYPOINT ["/usr/src/app/dockerfile-from-image.rb"]
CMD ["--help"]
