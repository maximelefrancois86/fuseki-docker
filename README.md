# Fuseki

Apache [Jena Fuseki](https://jena.apache.org/documentation/fuseki2/index.html).

Available also in Docker Hub: [maximelefrancois86/fuseki](https://hub.docker.com/r/maximelefrancois86/fuseki/).

The Fuseki administrative interface is accessible at `http://localhost:8080/<ctx>` with the `/ctx` and admin password defined as `docker run` parameter (see `Run` below).

The datasets are stored in the container at `/var/lib/jetty/fuseki/databases`. This volume can be mounted to a folder outside the container with docker option `-v /some/path:/var/lib/jetty/fuseki/databases`

## Build

`docker build -t maximelefrancois86/fuseki .`

## Run

Run and hold 

`docker run --rm -it -p 8080:8080 -v /some/path:/var/lib/jetty/fuseki/databases --name fuseki [-e JETTY_CONTEXT="ctx"] [-e ADMIN_PASSWORD="pw"] maximelefrancois86/fuseki`

The same command can be used to pull and run the container from Docker Hub (no need to build the image first).


# Acknowledgement

Forked from https://hub.docker.com/u/secoresearch and adapted to run with the war on jetty to have a context
