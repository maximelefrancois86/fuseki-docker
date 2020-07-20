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
FROM jetty:latest

MAINTAINER Maxime Lefrançois <maxime.lefrancois@emse.fr>

USER root
#RUN yum -y install wget nano && rm -rf /var/cache/yum

# Update below according to https://jena.apache.org/download/
ENV FUSEKI_SHA512 0a3ba1bb5704a3e2d9b0171f316f7696f306b9dec82c0fc35e7bc171076091688a825900475005b7e73d0efac206cca3af4ad025638b4a485e784f6977d53f60
ENV FUSEKI_VERSION 3.15.0

ENV MIRROR http://www.eu.apache.org/dist/
ENV ARCHIVE http://archive.apache.org/dist/

ENV FUSEKI_BASE "$JETTY_BASE/fuseki"
ENV FUSEKI_HOME "$JETTY_BASE/files"
ENV FUSEKI_CONTEXT "ROOT"

WORKDIR /tmp
USER jetty
RUN echo "$FUSEKI_SHA512  fuseki.tar.gz" > fuseki.tar.gz.sha512
RUN mkdir -p $FUSEKI_HOME && \
    wget -O fuseki.tar.gz $MIRROR/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz || \
    wget -O fuseki.tar.gz $ARCHIVE/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz && \
    sha512sum -c fuseki.tar.gz.sha512 && \
    tar zxf fuseki.tar.gz && \
    mv apache-jena-fuseki-$FUSEKI_VERSION/fuseki.war $JETTY_BASE/webapps/$FUSEKI_CONTEXT.war && \
    rm -rf apache* && rm -rf fuseki*

# Fuseki config
ENV ASSEMBLER $FUSEKI_HOME/configuration/assembler.ttl
COPY assembler.ttl $FUSEKI_BASE/configuration/assembler.ttl
COPY fuseki-config.ttl $FUSEKI_BASE/config.ttl
COPY shiro.ini $FUSEKI_BASE/shiro.ini

# entry point
USER root
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

# change owner to jetty
RUN chown -R jetty:jetty $JETTY_BASE/*

WORKDIR $JETTY_BASE
USER jetty
VOLUME ["/var/lib/jetty/log", "/var/lib/jetty/fuseki/databases"]
EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["java", "-jar", "/usr/local/jetty/start.jar"]
