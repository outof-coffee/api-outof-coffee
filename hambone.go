package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net"
	"net/http"
	"os"
	"sync"
	"time"

	"github.com/grpc-ecosystem/grpc-gateway/runtime"
	v1 "github.com/outof-coffee/api-outof-coffee/api/hambone/v1"
	"google.golang.org/grpc"
)

const (
	apiVersion = "v1"
)

type hamboneJSONData struct {
	Name     string `json:"name,omitempty"`
	Img      string `json:"img,omitempty"`
	Position string `json:"position,omitempty"`
}

// HamboneServiceServerV1 implement the gRPC bridged JSON service for hambones
type HamboneServiceServerV1 struct {
	data []hamboneJSONData
	wg   sync.WaitGroup
}

func New(data io.Reader) *HamboneServiceServerV1 {
	var jsonData []hamboneJSONData
	jsonData = make([]hamboneJSONData, 0)
	jsonBytes, err := ioutil.ReadAll(data)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	err = json.Unmarshal(jsonBytes, &jsonData)
	if err != nil {
		panic(err)
	}
	fmt.Println(jsonData)
	return &HamboneServiceServerV1{data: jsonData}
}

func (h *HamboneServiceServerV1) checkAPI(api string) error {
	var err error
	if len(api) > 0 {
		if apiVersion != api {
			return fmt.Errorf("incompatible api version; service implements %s, requested %s", apiVersion, api)
		}
	}
	return err // assume v1 for now
}

func (h HamboneServiceServerV1) GetHambones(ctx context.Context, req *v1.GetRequest) (*v1.GetResponse, error) {
	var err error
	if err = h.checkAPI(req.Api); err != nil {
		return nil, err
	}
	hambones := make([]*v1.Hambone, len(h.data))
	for i, hambone := range h.data {
		fmt.Println("processing hambone: ", hambone)
		pHambone := v1.Hambone{
			Name: hambone.Name,
			Img:  hambone.Img,
		}
		hambones[i] = &pHambone // preserve range order; TODO: preserve data order, too
	}
	return &v1.GetResponse{
		Api:      apiVersion,
		Hambones: hambones,
	}, err
}

func (h *HamboneServiceServerV1) Start() {
	backChannel := make(chan struct{})
	h.wg.Add(1)
	go func() {
		err := h.startGRPC(backChannel)
		if err != nil {
			fmt.Println(err)
		}
		h.wg.Done()
	}()
	h.wg.Add(1)
	time.Sleep(2 * time.Second)
	go func() {
		err := h.startREST(backChannel)
		if err != nil {
			fmt.Println(err)
		}
		h.wg.Done()
	}()
}

func (h *HamboneServiceServerV1) startGRPC(backChannel chan<- struct{}) error {
	fmt.Println("starting gRPC host...")
	listen, err := net.Listen("tcp", "localhost:8070")
	if err != nil {
		return err
	}
	grpcServer := grpc.NewServer()
	v1.RegisterHamboneServiceServer(grpcServer, h)
	backChannel <- struct{}{}
	err = grpcServer.Serve(listen)
	return err
}

func (h *HamboneServiceServerV1) startREST(backChannel <-chan struct{}) error {
	fmt.Println("waiting for gRPC host...")
	_ = <-backChannel
	fmt.Println("starting REST host...")
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	mux := runtime.NewServeMux()
	opts := []grpc.DialOption{grpc.WithInsecure()}
	err := v1.RegisterHamboneServiceHandlerFromEndpoint(ctx, mux, "localhost:8070", opts)
	if err != nil {
		return err
	}
	return http.ListenAndServe(":8080", mux)
}

func main() {
	var data io.Reader
	dataFile, err := os.Open("data.json")
	defer dataFile.Close()
	data = dataFile
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	h := New(data)
	h.Start()
	h.wg.Wait()
}
