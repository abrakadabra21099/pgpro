FROM debian:12

LABEL maintainer "4i! aka \$oRRy <abrakadabra21099@gmail.com>"
LABEL description "This image based on Postgres Pro 1c 17. Homepage: http://www.postgrespro.ru/"

ENV TZ Europe/Samara
ENV DEBIAN_FRONTEND noninteractive
ENV PATH "/opt/pgpro/1c-17/bin:$PATH"
ENV PGDATA "/var/lib/pgpro/1c-17/data"
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD=

COPY entry.sh /entry.sh
#ADD https://repo.postgrespro.ru/pg1c-17/keys/apt-repo-add.sh /apt-repo-add.sh
ADD https://repo.postgrespro.ru/pg1c-17/keys/pgpro-repo-add.sh /apt-repo-add.sh

RUN apt-get -q=2 update && \
  apt-get --show-progress --no-install-recommends -q=2 -y install gnupg procps locales tzdata sudo && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
  localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 && export LANG=ru_RU.utf8 && \
  echo 'postgres ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && sh /apt-repo-add.sh && \
  apt-get --no-install-recommends --show-progress -q=2 -y install postgrespro-1c-17-contrib && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /opt/pgpro/1c-17/man /apt-repo-add.sh

ENV LANG ru_RU.utf8
USER postgres

EXPOSE 5432/tcp

VOLUME ["/var/lib/pgpro/1c-17"]

ENTRYPOINT ["/entry.sh"]
