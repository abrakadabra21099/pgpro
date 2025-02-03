#!/bin/bash

if which "$1">/dev/null 2>&1; then
  exec $*
else
  sudo /opt/pgpro/1c-17/bin/pg-wrapper links update
  sudo mkdir -p "$PGDATA" && \
  sudo chown "$POSTGRES_USER": "$PGDATA"
  initdb --username="$POSTGRES_USER" --pwfile=<(echo "$POSTGRES_PASSWORD")
  if [ "$?" = "0" ]; then
    /opt/pgpro/1c-17/share/1c.tune > "$PGDATA"/postgresql.conf
    echo 'host    all             all             0.0.0.0/0               md5' >> "$PGDATA"/pg_hba.conf
  fi
  exec postgres $*
fi
