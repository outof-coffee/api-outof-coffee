# api-outof-coffee ![Deploy](https://github.com/outof-coffee/api-outof-coffee/workflows/Deploy/badge.svg?branch=master)
public APIs for outof.coffee

### Development

Install `protoc` for your OS.  How to do that is out of scope.

You also need go 1.12.x or higher.  1.13.x will be the minimum once it is GA.

```
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
go get -u github.com/golang/protobuf/protoc-gen-go
make all
```
