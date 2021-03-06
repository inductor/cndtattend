FROM node:lts as front
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn

FROM ruby:2.7.1 as fetch-lib
WORKDIR /app
COPY Gemfile* ./
RUN bundle install

FROM ruby:2.7.1
ENV RAILS_ENV=development, RAILS_LOG_TO_STDOUT=ON
WORKDIR /app
RUN apt-get update && apt-get install -y curl
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y nodejs yarn
COPY --from=fetch-lib /usr/local/bundle /usr/local/bundle
COPY . .
EXPOSE 3000
ENTRYPOINT ["./entrypoint.sh"]
