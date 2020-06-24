#!/bin/bash
#   Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

set -e

echo "hello"

if [ ! -f "initialized" ] ; then
  # First time
  echo "###################################"
  echo "Initializing Apache Jena Fuseki"
  echo ""
  if [ -z "$ADMIN_PASSWORD" ] ; then
    ADMIN_PASSWORD=$(gpg -q --homedir $.gnupg --gen-random --armor 1 15)
    #rm -r -f $FUSEKI_HOME/.gnupg
    echo "Randomly generated admin password:"
    echo ""
  fi
  if [ -n "$FUSEKI_CONTEXT" ] ; then
    for file in $JETTY_BASE/webapps/* ; do mv $file $JETTY_BASE/webapps/$FUSEKI_CONTEXT.jar ; done
  fi
  echo "admin=$ADMIN_PASSWORD"
  echo ""
  echo "###################################"
  touch "initialized"
fi

# $ADMIN_PASSWORD can always override
if [ -n "$ADMIN_PASSWORD" ] ; then
  sed -i "s/^admin=.*/admin=$ADMIN_PASSWORD/" "$FUSEKI_HOME/shiro.ini"
fi

test "${ENABLE_DATA_WRITE}" = true && sed -i 's/\(fuseki:serviceReadGraphStore\)/#\1/' $ASSEMBLER && sed -i 's/#\s*\(fuseki:serviceReadWriteGraphStore\)/\1/' $ASSEMBLER
test "${ENABLE_UPDATE}" = true && sed -i 's/#\s*\(fuseki:serviceUpdate\)/\1/' $ASSEMBLER
test "${ENABLE_UPLOAD}" = true && sed -i 's/#\s*\(fuseki:serviceUpload\)/\1/' $ASSEMBLER

exec "$@"