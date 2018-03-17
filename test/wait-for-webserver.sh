#!/bin/bash
ATTEMPTS=0

until [ $(docker logs simple-yum-repo-webserver-rpm | grep -q "Starting webserver") ] || [ $ATTEMPTS -eq 2 ]
do
  echo "Waiting for webserver, attempt $ATTEMPTS"
  docker logs --tail 10 simple-yum-repo-webserver-rpm
  sleep 2
  ATTEMPTS=$(( $ATTEMPTS + 1 ))
done

docker inspect simple-yum-repo-webserver-nofiles

EXITCODE=$(docker inspect --format={{.State.ExitCode}} simple-yum-repo-webserver-nofiles)
if [ "$EXITCODE" -eq 1 ]; then
  echo "Container exited with expected failure"
else
  echo "Container did not exit with expected failure"
  exit 1
fi

docker inspect simple-yum-repo-webserver-rpm

RUNNING=$(docker inspect --format={{.State.Running}} simple-yum-repo-webserver-rpm)
if [ "$RUNNING" == "true" ]; then
  echo "Container is running as expected"
else
  echo "Container is unexpectedly not running"
  exit 1
fi
