FROM alpine:latest
MAINTAINER CenturyLink Labs <clt-labs-futuretech@centurylink.com>

RUN apk --update add \
    gcc \
    libc-dev \
    make \
    ruby \
    ruby-dev \
    ruby-irb \
    ruby-json && \
    gem install --no-rdoc --no-ri bundler -v 1.16.1 && \
    rm /var/cache/apk/*

WORKDIR /usr/src/app
ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle
ADD dockerfile-from-image.rb /usr/src/app/dockerfile-from-image.rb

ENTRYPOINT ["/usr/bin/bundle", "exec", "ruby", "/usr/src/app/dockerfile-from-image.rb"]
CMD ["--help"]
