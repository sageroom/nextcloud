FROM nextcloud:23.0.3-apache

RUN apt-get update && apt-get install -y \
    supervisor postgresql-client unzip \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /var/log/supervisord /var/run/supervisord

RUN apt-get update && apt-get install -y lsb-release wget gnupg \
  && sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && apt-get update \
  && apt-get install -y postgresql-client-14 \
  && apt-get remove -y lsb-release wget gnupg \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt install -y dirmngr gnupg apt-transport-https ca-certificates software-properties-common \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && apt-add-repository 'deb https://download.mono-project.com/repo/ubuntu stable-focal main' \
  && apt install -y mono-complete \
  && rm -rf /var/lib/apt/lists/*

RUN cd /root && curl -O https://updates.duplicati.com/beta/duplicati-2.0.6.3_beta_2021-06-17.zip \
  && unzip duplicati-2.0.6.3_beta_2021-06-17.zip -d duplicati \
  && rm duplicati-2.0.6.3_beta_2021-06-17.zip

COPY supervisord.conf /

ENV NEXTCLOUD_UPDATE=1

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
