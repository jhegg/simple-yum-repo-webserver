# simple-yum-repo-webserver

## What is this for?

I wanted a simple way to spin up a YUM repo behind a webserver, given one or more RPM files in a directory, so that I can easily provide one-off updates for RHEL/CentOS based systems.

## Prerequisites

* One or more RPM files to put in the YUM repo.
* Docker

## Usage

1. Create a directory from where the RPM files will be hosted as a YUM repo.
2. Copy the desired RPM files into that directory.
3. Fetch and run the container, changing `/path/to/local/rpms` to be the directory where the RPMs exist:
  `docker run -it --rm -p 80:80 -v /path/to/local/rpms:/usr/share/nginx/html --name simple-yum-repo-webserver joshhegg/simple-yum-repo-webserver`
4. Verify that the YUM repo metadata was generated and can be fetched from the webserver, by browsing to: http://localhost/repodata/repomd.xml (you should see an XML response instead of an error).
5. When finished, `Ctrl+C` to stop and remove the Docker container.

## Other ways to run the container

The example in the Usage section runs the container in the foreground (`-it`), removes the container on exit (`--rm`), maps port 80 on the host to port 80 in the container (`-p 80:80`), maps a directory on the host to the webserver content directory in the container (`-v /path/to/local/rpms:/usr/share/nginx/html`), and specifies a stable container name rather than a randomly generated name (`--name simple-yum-repo-webserver`).

You could also run the container in the background, by replacing `-it` with `-d`: `docker run -d --rm -p 80:80 -v /path/to/local/rpms:/usr/share/nginx/html --name simple-yum-repo-webserver simple-yum-repo-webserver` . You will then need to stop the container using `docker stop simple-yum-repo-webserver` instead of `Ctrl+C`.

You could choose to use a random port on the host, in particular if port 80 is already used, by replacing `-p 80:80` with `-P`: `docker run -d --rm -P -v /path/to/local/rpms:/usr/share/nginx/html --name simple-yum-repo-webserver joshhegg/simple-yum-repo-webserver` . You will then need to inspect the container port status using `docker ps` to see which port has been selected.

## Notes

* You can have any number of subdirectories, each as their own YUM repo. For example, if you use `-v /tmp/yum-repo:/usr/share/nginx/html`, if subdirectories with RPM files exist underneath `/tmp/yum-repo`, then when the Docker container starts it will recursively visit each subdirectory, and run the `createrepo` command which generates the YUM metadata.
* The webserver does not have a default page, and will return an HTTP 403 Forbidden if you browse to the root path, rather than listing the files.
* If zero RPM files are found, the container will stop running with an error.

## How to build the image

`docker build -t simple-yum-repo-webserver .`
