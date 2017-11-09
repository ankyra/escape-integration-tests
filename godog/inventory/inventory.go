package inventory

import (
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"time"

	"github.com/ankyra/escape-core/util"
)

var ServerProcess *exec.Cmd

func Start(inventoryPath string) {
	go func() {
		os.RemoveAll("test.db")
		os.RemoveAll("escape_state.json")
		os.RemoveAll("escape.yml")
		os.RemoveAll("releases/")
		os.RemoveAll("deps/")
		os.Mkdir("releases/", 0755)
		env := []string{
			"DATABASE=sqlite",
			"DATABASE_SETTINGS_PATH=test.db",
			"STORAGE_BACKEND=local",
			"STORAGE_SETTINGS_PATH=releases/",
			"PORT=7777",
			"DEV=true",
		}
		binary := inventoryPath
		if !util.PathExists(binary) {
			binary = "escape-inventory"
		}
		ServerProcess = exec.Command(binary)
		ServerProcess.Env = env
		if err := ServerProcess.Start(); err != nil {
			panic(err)
		}
	}()

	status := 0
	for status != 200 {
		time.Sleep(time.Second / 2)
		resp, err := http.Get("http://localhost:7777/health")
		if err == nil {
			status = resp.StatusCode
		}
	}
}

func Wipe() error {
	req, _ := http.NewRequest("DELETE", "http://localhost:7777/api/v1/internal/database", nil)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return err
	}

	if resp.StatusCode != 200 {
		return fmt.Errorf("Inventory database wipe failed")
	}

	return nil
}

func Stop() {
	ServerProcess.Process.Kill()
}
