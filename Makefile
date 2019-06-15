export PROTOC ?= $(shell which protoc)
export GOPATH ?= $(HOME)/go
export PATH := $(GOPATH)/bin:$(PATH)
GOOGLEAPIS:=$(shell find $(GOPATH)/pkg/mod/github.com/grpc-ecosystem -type d -name googleapis)
PROTO_INCLUDES=-I. -I$(GOOGLEAPIS)
HAMBONE_PATH=--proto_path=api/hambone/proto/v1
FROWNS_PATH=--proto_path=api/frowns/proto/v1

api/hambone/v1:
	mkdir -p  api/hambone/v1/
hamboneproto: api/hambone/v1
	$(PROTOC) ${PROTO_INCLUDES} ${HAMBONE_PATH} --go_out=plugins=grpc:api/hambone/v1 hambone.proto
	$(PROTOC) ${PROTO_INCLUDES} ${HAMBONE_PATH} --grpc-gateway_out=logtostderr=true:api/hambone/v1 hambone.proto
	$(PROTOC) ${PROTO_INCLUDES} ${HAMBONE_PATH} --swagger_out=logtostderr=true:api/hambone/v1 hambone.proto
hambone: hamboneproto
	go build -o hambone hambone.go
api/frowns/v1:
	mkdir -p api/frowns/v1/
frownsproto: api/frowns/v1
	$(PROTOC) ${PROTO_INCLUDES} ${FROWNS_PATH} --go_out=plugins=grpc:api/frowns/v1 frowns.proto
	$(PROTOC) ${PROTO_INCLUDES} ${FROWNS_PATH} --grpc-gateway_out=logtostderr=true:api/frowns/v1 frowns.proto
	$(PROTOC) ${PROTO_INCLUDES} ${FROWNS_PATH} --swagger_out=logtostderr=true:api/frowns/v1 frowns.proto
clean:
	rm -rf api/hambone/v1
	rm -rf api/frowns/v1
	rm -rf hambone
	rm -rf frowns
all: hambone frownsproto