FROM nextcloud:25.0.10-apache


RUN apt-get update && apt-get install -y \
    supervisor postgresql-client \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /var/log/supervisord /var/run/supervisord

RUN apt-get update && apt-get install -y lsb-release wget gnupg \
  && sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && apt-get update \
  && apt-get install -y postgresql-client-14 \
  && apt-get remove -y lsb-release wget gnupg \
  && rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /

ENV NEXTCLOUD_UPDATE=1

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
