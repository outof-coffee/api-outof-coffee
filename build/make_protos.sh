#!/usr/bin/env bash
protoc -I/usr/local/include \
    -I. -I$GOPATH/src \
    -I$GOPATH/pkg/mod/github.com/grpc-ecosystem/grpc-gateway@v1.9.0/third_party/googleapis \
    --proto_path=api/hambone/proto/v1 \
    --go_out=plugins=grpc:api/hambone/v1 hambone.proto

protoc -I/usr/local/include \
    -I. -I$GOPATH/src \
    -I$GOPATH/pkg/mod/github.com/grpc-ecosystem/grpc-gateway@v1.9.0/third_party/googleapis \
    --proto_path=api/hambone/proto/v1 \
    --grpc-gateway_out=logtostderr=true:api/hambone/v1 hambone.proto

protoc -I/usr/local/include \
    -I. -I$GOPATH/src \
    -I$GOPATH/pkg/mod/github.com/grpc-ecosystem/grpc-gateway@v1.9.0/third_party/googleapis \
    --proto_path=api/hambone/proto/v1 \
    --swagger_out=logtostderr=true:api/hambone/v1 hambone.proto
