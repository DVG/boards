FROM ruby:2.2.1

RUN apt-get update -qq && apt-get install -y build-essential libxml2-dev libxslt1-dev

ENV APP_HOME /code
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME
RUN bundle install
