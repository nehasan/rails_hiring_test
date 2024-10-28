FROM ruby:3.3-alpine

RUN apk update && \
    apk add --no-cache build-base \
    postgresql-client libpq-dev tzdata curl \
    nodejs yarn

RUN node --version
RUN yarn --version

RUN mkdir -p /app
COPY ./Gemfile /app
COPY ./Gemfile.lock /app
COPY ./package*.json /app
COPY ./yarn.lock /app

WORKDIR /app
RUN bundle install
RUN yarn install

COPY . .

RUN chmod +x /app/entrypoint.sh
RUN ls -la /
RUN ls -la /app
EXPOSE 3000
ENTRYPOINT [ "/app/entrypoint.sh" ]
