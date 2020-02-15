FROM alpine:3.4 as builder
RUN \
    apk update && \
    apk --no-cache add ruby ruby-dev ruby-bundler ruby-json ruby-irb ruby-rake ruby-bigdecimal && \
    apk --no-cache add make gcc libc-dev \
    && gem install bundler --no-ri --no-rdoc \
    && rm -rf /var/cache/apk/* \
    && rm -rf /root/.cache/*

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
COPY Gemfile* /$APP_HOME/
RUN bundle install
COPY . /$APP_HOME

# ENV POST_SERVICE_HOST post
# ENV POST_SERVICE_PORT 5000
# ENV COMMENT_SERVICE_HOST comment
# ENV COMMENT_SERVICE_PORT 9292

ENTRYPOINT ["puma"]
