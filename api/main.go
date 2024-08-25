package main

import (
	"flag"
	"net/http"
	"strings"

	"github.com/gorilla/websocket"
	"github.com/koki-morino/mweb/protos"
	"google.golang.org/protobuf/proto"
)

// Upgrader with default config.
var upgrader = websocket.Upgrader{CheckOrigin: func(r *http.Request) bool {
	hostname := r.Host
	if idx := strings.IndexByte(hostname, ':'); idx >= 0 {
		hostname = r.Host[:idx]
	}

	logger.Debug("Client hostname: %s", hostname)
	// TODO: Use environment variable.
	return hostname == "localhost"
}}

func main() {
	flag.Parse()

	http.HandleFunc("/ping", ping)
	http.HandleFunc("/ws", ws)

	logger.Info("Listening to http://localhost:8000")
	if err := http.ListenAndServe(":8000", nil); err != nil {
		logger.Fatal(err)
	}
}

func ping(w http.ResponseWriter, r *http.Request) {
	logger.Info("%s %s", r.Method, r.URL.Path)

	w.Write([]byte("pong"))
}

func ws(w http.ResponseWriter, r *http.Request) {
	logger.Info("%s %s", r.Method, r.URL.Path)

	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		logger.Error("%s", err)
		return
	}
	defer c.Close()

	for {
		mt, message, err := c.ReadMessage()
		// Client disconnected.
		if err != nil {
			logger.Error("%s", err)
			break
		}

		// Binary data
		if mt == 2 {
			msg := protos.Message{}
			proto.Unmarshal(message, &msg)
			act(c, &msg)
		}
	}
}

func act(c *websocket.Conn, msg *protos.Message) {
	logger.Debug("Action: %s", msg.Action)

	switch msg.Action {

	case protos.Action_Ping:
		res := protos.Message{Action: protos.Action_Ping}

		resbin, err := proto.Marshal(&res)
		if err != nil {
			logger.Error("%s", err)
			break
		}

		err = c.WriteMessage(2, resbin)
		if err != nil {
			logger.Error("%s", err)
			break
		}

	case protos.Action_GetThemeMode:
		kvs, err := NewKvs("/data", "thememode")
		if err != nil {
			logger.Error("%s", err)
			break
		}

		modebin, err := kvs.Read("default")
		if err != nil {
			logger.Error("%s", err)
			break
		}

		mode := protos.ThemeMode{}
		if err := proto.Unmarshal(modebin, &mode); err != nil {
			logger.Error("%s", err)
			break
		}

		res := protos.Message{Action: protos.Action_GetThemeMode, ThemeMode: &mode}
		resbin, err := proto.Marshal(&res)
		if err != nil {
			logger.Error("%s", err)
			break
		}

		if err := c.WriteMessage(2, resbin); err != nil {
			logger.Error("%s", err)
			break
		}

	case protos.Action_UpdateThemeMode:
		kvs, err := NewKvs("/data", "thememode")
		if err != nil {
			logger.Error("%s", err)
			break
		}

		mode := protos.ThemeMode{IsDarkMode: msg.ThemeMode.IsDarkMode}
		modebin, err := proto.Marshal(&mode)
		if err != nil {
			logger.Error("%s", err)
			break
		}

		if err := kvs.Write("default", modebin); err != nil {
			logger.Error("%s", err)
			break
		}

	default:

	}
}
