FROM ruby:latest

RUN apt-get update && apt-get install -y redis-server

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install

ENV PATH /usr/local/bundle/bin:$PATH

COPY . .

EXPOSE 9393

ENV SECRET_KEY "fudo_challenge_secret_key"

COPY ./bin/start.sh /start.sh
CMD ["/bin/sh", "/start.sh"]