# ./Dockerfile
FROM ruby:3.0.1 as base

# install bundler
ARG BUNDLER_VERSION=2.3.8
RUN gem update --system
RUN gem install bundler -v "${BUNDLER_VERSION}"

# Needed to assist with AWS/base OS commands
RUN apt-get update -y
RUN apt-get install -y less groff
RUN apt-get clean

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Convenience alias for aws commands linked to build args from docker-compose
RUN echo 'alias awslocal="AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} aws --endpoint-url=http://localstack:4566"' >> ~/.bashrc

# Copy files to contaner -- Docker compose mounts local to this directory for ease of development
WORKDIR /shoryuken
COPY . /shoryuken
