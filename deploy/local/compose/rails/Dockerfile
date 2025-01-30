# deploy/local/compose/rails/Dockerfile
FROM ruby:3.4.1-slim

# Install system dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    git \
    curl \
    wait-for-it \
    libjemalloc2 \
    redis-tools \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

# Configure jemalloc
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

# Create app directory
WORKDIR /app

# Install application dependencies
COPY Gemfile ./
RUN bundle install

# Copy entrypoint and start scripts
COPY ./deploy/local/compose/rails/entrypoint /entrypoint
COPY ./deploy/local/compose/rails/start /start
RUN sed -i 's/\r$//g' /entrypoint \
    && sed -i 's/\r$//g' /start \
    && chmod +x /entrypoint /start

COPY ./deploy/local/compose/rails/sidekiq/start /sidekiq-start
RUN sed -i 's/\r$//g' /sidekiq-start
RUN chmod +x /sidekiq-start

# Copy application code
COPY . .

ENTRYPOINT ["/entrypoint"]