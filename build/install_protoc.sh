#!/usr/bin/env bash

PROTOBUF_VERSION=3.5.1
PROTOC_FILENAME=protoc-${PROTOBUF_VERSION}-linux-x86_64.zip
pushd /home/travis
wget https://github.com/google/protobuf/releases/download/v${PROTOBUF_VERSION}/${PROTOC_FILENAME}
unzip ${PROTOC_FILENAME}
bin/protoc --version
popd
go get -u google.golang.org/genproto@v0.0.0-20190516172635-bb713bdc0e52
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
go get -u github.com/grpc-ecosystem/grpc-gateway@v1.9.0
go get -u github.com/golang/protobuf/protoc-gen-go@v1.3.1
