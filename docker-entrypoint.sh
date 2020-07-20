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
  if [ ! -z "$FUSEKI_CONTEXT" ] ; then
    mv $JETTY_BASE/webapps/ROOT.war $JETTY_BASE/webapps/$FUSEKI_CONTEXT.war
  fi
  sed -i "s/^admin=pw/admin=$ADMIN_PASSWORD/" "$FUSEKI_BASE/shiro.ini"
  echo "admin=$ADMIN_PASSWORD"
  echo ""
  echo "###################################"
  touch initialized
fi

exec "$@"