FROM alpine:3.1
MAINTAINER CenturyLink Labs <clt-labs-futuretech@centurylink.com>

ENTRYPOINT ["/usr/src/app/dockerfile-from-image.rb"]
CMD ["--help"]

RUN apk update && apk add ruby-dev ca-certificates
RUN gem install --no-rdoc --no-ri docker-api

ADD dockerfile-from-image.rb /usr/src/app/dockerfile-from-image.rb
