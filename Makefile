
proto:
	build/make_protos.sh

hambone:
	go build -o hambone hambone.go

clean:
	rm -rf api/v1
	rm -rf hambone

all: proto hambone