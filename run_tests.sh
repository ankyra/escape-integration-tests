#!/bin/bash -e

set -euf -o pipefail

rm -rf godog/vendor/github.com/ankyra/escape-core
mkdir -p godog/vendor/github.com/ankyra/
cp -r deps/_/escape-core/ godog/vendor/github.com/ankyra/escape-core
rm -rf godog/vendor/github.com/ankyra/escape-core/vendor/

docker rm src || true
docker create -v /go/src/github.com/ankyra/ --name src golang:1.9.0 /bin/true
docker cp "$PWD" src:/go/src/github.com/ankyra/tmp
docker run --rm --volumes-from src \
    -w /go/src/github.com/ankyra/ \
    golang:1.9.0 mv tmp escape-integration-tests
docker run --rm \
    --volumes-from src \
    -w /go/src/github.com/ankyra/escape-integration-tests/godog \
    golang:1.9.0 bash -c "go get github.com/DATA-DOG/godog/cmd/godog && godog"
docker rm src
