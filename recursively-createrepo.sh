#!/bin/bash

# Recursively runs createrepo, starting from the base of the mounted volume.
for directory in `find /usr/share/nginx/html -type d`; do
  echo Running createrepo ${directory}
  createrepo ${directory}
done

