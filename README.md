# Fuseki

Apache [Jena Fuseki](https://jena.apache.org/documentation/fuseki2/index.html).

Available also in Docker Hub: [maximelefrancois86/fuseki](https://hub.docker.com/r/maximelefrancois86/fuseki/).

The Fuseki administrative interface is accessible at `http://localhost:8080/<ctx>` with the `/ctx` and admin password defined as `docker run` parameter (see `Run` below).

The container has a preconfigured service/dataset `kg` (see [assembler.ttl](https://gitlab.emse.fr/maxime.lefrancois/fuseki-docker/blob/master/assembler.ttl) for configuration).

The dataset is stored in the container at `/var/lib/jetty/db`. This volume can be mounted to a folder outside the container with docker option `-v /some/path:/var/lib/jetty/db`

The data can be accessed via the default endpoints:
* [SPARQL 1.1 query](https://www.w3.org/TR/sparql11-query/): `http://localhost:8080/<ctx>/ds/sparql`

Other endpoints are enabled, as well (see the Run section for instructions):
* [SPARQL 1.1 Update](https://www.w3.org/TR/sparql11-update/): `http://localhost:8080/<ctx>/ds/update`
* Graph Store HTTP Protocol with write access: `http://localhost:8080/<ctx>/ds/data`
* File Upload: `http://localhost:8080/<ctx>/ds/upload`
* [Graph Store HTTP Protocol](https://www.w3.org/TR/sparql11-http-rdf-update/): `http://localhost:8080/<ctx>/ds/data`

**Note on running in OpenShift**, if you use this image as a parent image (e.g. use your own Dockerfile to load the data inside the image using TDBLOADER): as containers are run as an arbitrary user, you'll have to ensure the write permission on the TDB and index directories, e.g. by adding the following lines in your Dockerfile after the tdbloader and indexing commands:

```
# Set permissions to allow fuseki to run as an arbitrary user
RUN chgrp -R 0 $FUSEKI_BASE \
    && chmod -R g+rwX $FUSEKI_BASE
```

## Build

`docker build -t maximelefrancois86/fuseki .`

## Run

Run and hold 

`docker run --rm -it -p 8080:8080 -v /some/path:/var/lib/jetty/db --name fuseki [-e JETTY_CONTEXT="ctx"] [-e ADMIN_PASSWORD="pw"] maximelefrancois86/fuseki`

The same command can be used to pull and run the container from Docker Hub (no need to build the image first).


# Acknowledgement

Forked from https://hub.docker.com/u/secoresearch and adapted to run with the war on jetty to have a context
