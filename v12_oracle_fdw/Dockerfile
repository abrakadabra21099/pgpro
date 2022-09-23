FROM debian:10

LABEL maintainer "4i! aka \$oRRy <abrakadabra21099@gmail.com>"
LABEL description "This image based on Postgres Pro 1c 12_oracle_fdw. Homepage: http://www.postgrespro.ru/"

ENV TZ Europe/Samara
ENV DEBIAN_FRONTEND noninteractive
ENV PATH "/opt/pgpro/1c-12/bin:$PATH"
ENV PGDATA "/var/lib/pgpro/1c-12/data"
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD=

# ORCL
ARG ORACLE_CLIENT_URL=https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linuxx64.zip
ARG ORACLE_SQLPLUS_URL=https://download.oracle.com/otn_software/linux/instantclient/instantclient-sqlplus-linuxx64.zip
ARG ORACLE_SDK_URL=https://download.oracle.com/otn_software/linux/instantclient/instantclient-sdk-linuxx64.zip
ENV ORACLE_HOME=/usr/lib/oracle/client
# ##

COPY entry.sh /entry.sh
ADD https://repo.postgrespro.ru/pg1c-12/keys/apt-repo-add.sh /apt-repo-add.sh

RUN apt-get -q=2 update && \
  apt-get --show-progress --no-install-recommends -q=2 -y install gnupg procps locales tzdata sudo wget unzip && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
  localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 && export LANG=ru_RU.utf8 && \
  echo 'postgres ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && sh /apt-repo-add.sh && \
  apt-get --no-install-recommends --show-progress -q=2 -y install postgrespro-1c-12-contrib && \
  \
  wget --no-check-certificate -O instant_client.zip ${ORACLE_CLIENT_URL}; \
  unzip instant_client.zip; \
  # sqlplus
  wget --no-check-certificate -O sqlplus.zip ${ORACLE_SQLPLUS_URL}; \
  unzip sqlplus.zip; \
  # sdk
  wget --no-check-certificate -O sdk.zip ${ORACLE_SDK_URL}; \
  unzip sdk.zip; \
  # install
  mkdir -p ${ORACLE_HOME}; \
  mv instantclient*/* ${ORACLE_HOME}; \
  rm -r instantclient*; \
  rm instant_client.zip sqlplus.zip sdk.zip; \
  apt-get install -y --no-install-recommends libaio1; \
  apt-get purge -y --auto-remove; \
  # ##
  \
  apt-get clean && rm -rf /var/lib/apt/lists/* /opt/pgpro/1c-12/man /apt-repo-add.sh

ENV LANG ru_RU.utf8

# ORCL
  ENV PATH $PATH:${ORACLE_HOME}
  ARG ORACLE_FDW_VERSION=2_3_0
  ARG ORACLE_FDW_URL=https://github.com/laurenz/oracle_fdw/archive/ORACLE_FDW_${ORACLE_FDW_VERSION}.tar.gz
  ARG SOURCE_FILES=tmp/oracle_fdw

RUN mkdir -p ${SOURCE_FILES}; \
    wget --no-check-certificate -O - ${ORACLE_FDW_URL} | tar -zx --strip-components=1 -C ${SOURCE_FILES}; \
    cd ${SOURCE_FILES}; \
    # install
    apt-get -q=2 update && \
    apt-get install -y --no-install-recommends make gcc postgrespro-1c-12-dev build-essential; \
    echo 'make is run'>&2; \
    make; \
    echo 'make install is run'>&2; \
    ln -s /bin/mkdir /usr/bin/mkdir; \
    make install; \
    echo 'make install is done'>&2; \
    echo ${ORACLE_HOME} > /etc/ld.so.conf.d/oracle_instantclient.conf; \
    ldconfig; \
    # cleanup
    apt-get purge -y --auto-remove postgrespro-1c-12-dev gcc make build-essential \
    && rm -rf /var/lib/apt/lists/*

# ##

USER postgres

EXPOSE 5432/tcp

VOLUME ["/var/lib/pgpro/1c-12"]

ENTRYPOINT ["/entry.sh"]
