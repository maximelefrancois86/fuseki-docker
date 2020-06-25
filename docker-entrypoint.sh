#!/bin/sh

set -e

if [ ! -f initialized ] ; then
  # First time
  echo "###################################"
  echo "Initializing Apache Jena Fuseki"
  echo ""
  if [ -z "$ADMIN_PASSWORD" ] ; then
    ADMIN_PASSWORD=$(gpg -q --homedir $FUSEKI_HOME/.gnupg --gen-random --armor 1 15)
    echo "Randomly generated admin password:"
    echo ""
  fi
  sed -i "s/^admin=[^,\*]*/admin=$ADMIN_PASSWORD/" "$FUSEKI_BASE/shiro.ini"
  echo "admin=$ADMIN_PASSWORD"
  echo ""
  echo "###################################"
  touch initialized
fi

exec "$@"