#!/bin/bash

set +e
go version
GO_INSTALLED=$?
set -e
if [ $GO_INSTALLED -ne 0 ] || [ -z $GOPATH ] ; then
  echo "You need to install Go Language and set the GOPATH first."
  exit 1
fi

# need to install the cli before installing autopilot
# if [ -]
mkdir -p $GOPATH/src/github.com/cloudfoundry
pushd $GOPATH/src/github.com/cloudfoundry/
rm -rf cli
git clone https://github.com/cloudfoundry/cli.git
popd

echo 'Building new `autopilot` binary...'
go install

echo 'Installing the plugin...'
cf plugins | grep autopilot
AUTOPILOT_INSTALLED=$?

if [ $AUTOPILOT_INSTALLED -ne 0 ]; then
  cf uninstall-plugin Autopilot
fi

cf install-plugin $GOPATH/bin/autopilot
