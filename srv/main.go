package main

import (
	"flag"
	"log"
	"net/http"

	"github.com/google/uuid"
	"github.com/gorilla/websocket"
	"github.com/koki-morino/mweb/protos"
	"google.golang.org/protobuf/proto"
)

var addr = flag.String("addr", "localhost:8000", "http service address")

// Upgrader with default config.
var upgrader = websocket.Upgrader{}

func main() {
	flag.Parse()
	log.SetFlags(0)
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(*addr, nil))
}

func handler(w http.ResponseWriter, r *http.Request) {
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("Failed to upgrade websocket connection:", err)
		return
	}
	defer c.Close()

	id := uuid.New()
	todo := &protos.Todo{Id: id.String(), Title: "Hello", Description: "Hello, world!", Completed: false}
	out, err := proto.Marshal(todo)
	if err != nil {
		log.Println("Failed to marshall proto message:", err)
		return
	}

	c.WriteMessage(websocket.BinaryMessage, out)
}
