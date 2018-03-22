FROM ubuntu:latest

LABEL maintainer "alan@teamzerolabs.com"

# copy required files into img
COPY ./celery_tasks /app
COPY ./celery_config /app
COPY ./utils/dumb-init /usr/bin/dumb-init

# run operations
RUN apt-get update -y && \
  apt-get install -y curl python-pip python-dev build-essential && \
  pip install --upgrade pip && \
  cd /app && pip install -r requirements.txt && \
  chmod +x /usr/bin/dumb-init

WORKDIR /app
ENTRYPOINT ["/usr/bin/dumb-init", "--"]