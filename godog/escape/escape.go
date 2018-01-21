/*
Copyright 2017, 2018 Ankyra

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

package escape

import (
	"fmt"

	"github.com/ankyra/escape/util"
	eutil "github.com/ankyra/escape/util"
)

var EscapePath string
var CapturedStdout string

func run(cmd []string, errorDebug bool) error {
	rec := util.NewProcessRecorder()
	env := []string{
		"ESCAPE_API_SERVER=http://localhost:7777",
	}
	binary := EscapePath
	if !util.PathExists(binary) {
		binary = "escape"
	}
	command := []string{binary, "-c", "/tmp/godog_escape_config"}
	for _, c := range cmd {
		command = append(command, c)
	}

	stdout, err := rec.Record(command, env, eutil.NewLoggerDummy())
	CapturedStdout = stdout
	if errorDebug && err != nil {
		fmt.Println(CapturedStdout)
	}

	return err
}

func Run(cmd []string) error {
	return run(cmd, true)
}

func RunAndFail(cmd []string) {
	run(cmd, false)
}
