
GOOGLEAPIS:=$(shell find $(GOPATH)/pkg/mod/github.com/grpc-ecosystem -type d -name googleapis)
PROTO_INCLUDES=-I. -I$(GOPATH)/src -I$(GOOGLEAPIS)
HAMBONE_PATH=--proto_path=api/hambone/proto/v1
FROWNS_PATH=--proto_path=api/frowns/proto/v1

api/hambone/v1:
	mkdir -p  api/hambone/v1/
hamboneproto: api/hambone/v1
	protoc ${PROTO_INCLUDES} ${HAMBONE_PATH} --go_out=plugins=grpc:api/hambone/v1 hambone.proto
	protoc ${PROTO_INCLUDES} ${HAMBONE_PATH} --grpc-gateway_out=logtostderr=true:api/hambone/v1 hambone.proto
	protoc ${PROTO_INCLUDES} ${HAMBONE_PATH} --swagger_out=logtostderr=true:api/hambone/v1 hambone.proto
hambone:
	go build -o hambone hambone.go
api/frowns/v1:
	mkdir -p api/frowns/v1/
frownsproto: api/frowns/v1
	protoc ${PROTO_INCLUDES} ${FROWNS_PATH} --go_out=plugins=grpc:api/frowns/v1 frowns.proto
	protoc ${PROTO_INCLUDES} ${FROWNS_PATH} --grpc-gateway_out=logtostderr=true:api/frowns/v1 frowns.proto
	protoc ${PROTO_INCLUDES} ${FROWNS_PATH} --swagger_out=logtostderr=true:api/frowns/v1 frowns.proto
clean:
	rm -rf api/hambone/v1
	rm -rf hambone
all: hambone