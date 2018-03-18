#!/bin/bash

FOUND_RPMS=$(find /usr/share/nginx/html -type f -name '*.rpm' -print -quit)

if test -n "$FOUND_RPMS"
then
  # For each non-repodata directory, run createrepo
  for directory in `find /usr/share/nginx/html -type d -not -path "*/repodata"`; do
    echo "Running createrepo on: ${directory}"
    createrepo ${directory}
  done
else
  echo "No RPM files were found; was the correct directory mounted into Docker?"
  exit 1
fi
