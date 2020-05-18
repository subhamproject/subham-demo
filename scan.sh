#!/bin/bash
docker run -d --name db arminc/clair-db
sleep 15 # wait for db to come up
docker run -p 6060:6060 --link db:postgres -d --name clair arminc/clair-local-scan
sleep 1
DOCKER_GATEWAY=$(docker network inspect bridge --format "{{range .IPAM.Config}}{{.Gateway}}{{end}}")
wget -qO clair-scanner https://github.com/arminc/clair-scanner/releases/download/v8/clair-scanner_linux_amd64 && chmod +x clair-scanner
./clair-scanner --ip="$DOCKER_GATEWAY" -t High -r scan-report.json subham-test-image
[ $? -ne 0 ] && { echo "image scan had some bugs,please fix and re-run it again" ; exit 1 ; } || :
