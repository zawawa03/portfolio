FROM ruby:3.3.9
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
RUN apt-get update -qq && \
curl -fsSL https://deb.nodesource.com/setup_lts.x |bash - && \
apt-get install -y nodejs build-essential libpq-dev && \
npm install -g yarn
RUN apt-get update -qq && apt-get install -y libvips
WORKDIR /portfolio
RUN gem install bundler:2.6.2
COPY Gemfile /portfolio/Gemfile
COPY Gemfile.lock /portfolio/Gemfile.lock
COPY package.json /portfolio/package.json
RUN bundle install
RUN yarn install
COPY . /portfolio
CMD ["rails", "server", "-b", "0.0.0.0"]