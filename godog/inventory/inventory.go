/*
Copyright 2017 Ankyra

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package inventory

import (
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"time"

	"github.com/ankyra/escape/util"
)

var ServerProcess *exec.Cmd

func Start(inventoryPath string) error {
	fmt.Println("Inventory starting")

	go func() {
		os.RemoveAll("test.db")
		os.RemoveAll("escape_state.json")
		os.RemoveAll("escape.yml")
		os.RemoveAll("releases/")
		os.RemoveAll("deps/")
		os.Mkdir("releases/", 0755)
		env := []string{
			"DATABASE=ql",
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
	checkStarted := time.Now()
	for status != 200 && time.Now().Before(checkStarted.Add(time.Second*10)) {
		time.Sleep(time.Second / 1000)
		resp, err := http.Get("http://localhost:7777/health")
		if err == nil {
			status = resp.StatusCode
		}
	}

	if status == 0 {
		return fmt.Errorf("Inventory did not start")
	}

	fmt.Println("Inventory started")
	return nil
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
