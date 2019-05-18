
GOOGLEAPIS:=$(shell find $(GOPATH)/pkg/mod/github.com/grpc-ecosystem -type d -name googleapis)
PROTO_INCLUDES=-I. -I$(GOPATH)/src -I$(GOOGLEAPIS)
PROTO_PATH=--proto_path=api/hambone/proto/v1

proto:
	protoc ${PROTO_INCLUDES} ${PROTO_PATH} --go_out=plugins=grpc:api/hambone/v1 hambone.proto
	protoc ${PROTO_INCLUDES} ${PROTO_PATH} --grpc-gateway_out=logtostderr=true:api/hambone/v1 hambone.proto
	protoc ${PROTO_INCLUDES} ${PROTO_PATH} --swagger_out=logtostderr=true:api/hambone/v1 hambone.proto
hambone:
	go build -o hambone hambone.go

clean:
	rm -rf api/v1
	rm -rf hambone

all: proto hambone