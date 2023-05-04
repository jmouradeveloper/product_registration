FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -y nodejs
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY . ./
RUN bundle install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]