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
