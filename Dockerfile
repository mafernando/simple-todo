FROM ubuntu

RUN apt-get update -qq && apt-get -q -y install libmysqlclient-dev ruby ruby-dev build-essential nodejs nodejs-dev

ENV DEVISE_SECRET_KEY="40ae0f919b6fd2342e1046a82c7958cf961483aa36b5cd5aa2d3b1368137134b37d6c45e50d54a22e33cea9432ed90ace5c093fa74d6f7a7a21a2805c5c6b4bb" \
    RAILS_ENV="production" \
    SECRET_KEY_BASE="$(openssl rand -base64 32)"

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc \
    && gem install bundler
RUN mkdir -p /app
WORKDIR /app
COPY Gemfile* /app/
RUN bundle install --without development test --jobs 4
COPY . /app/
RUN bundle exec rake assets:precompile

EXPOSE 3000
