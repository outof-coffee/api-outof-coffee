
GOOGLEAPIS:=$(shell find $(GOPATH)/pkg/mod/github.com/grpc-ecosystem -type d -name googleapis)
PROTO_INCLUDES=-I. -I$(GOPATH)/src -I$(GOOGLEAPIS)
PROTO_PATH=--proto_path=api/hambone/proto/v1
GRPC_PLUGINS=--plugin=protoc-gen-grpc-gateway=$(GOPATH)/bin/protoc-gen-grpc-gateway

proto:
	protoc ${PROTO_INCLUDES} ${PROTO_PATH} --go_out=plugins=grpc:api/hambone/v1 hambone.proto
	protoc ${PROTO_INCLUDES} ${PROTO_PATH} ${GRPC_PLUGINS} --grpc-gateway_out=logtostderr=true:api/hambone/v1 hambone.proto
	protoc ${PROTO_INCLUDES} ${PROTO_PATH} --swagger_out=logtostderr=true:api/hambone/v1 hambone.proto
hambone:
	go build -o hambone hambone.go
api/hambone/v1:
	mkdir -p  api/hambone/v1/

clean:
	rm -rf api/hambone/v1
	rm -rf hambone

all: api/hambone/v1 proto hambone