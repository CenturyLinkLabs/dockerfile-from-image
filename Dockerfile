FROM centurylink/ruby-base:2.1.2

RUN gem install docker-api
ADD dockerfile-from-image.rb /usr/src/app/dockerfile-from-image.rb
WORKDIR /usr/src/app
RUN chmod +x dockerfile-from-image.rb

CMD ["--help"]
ENTRYPOINT ["/usr/src/app/dockerfile-from-image.rb"]
