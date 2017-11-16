package escape

import (
	"github.com/ankyra/escape/util"
	eutil "github.com/ankyra/escape/util"
)

var EscapePath string
var CapturedStdout string

func Run(cmd []string) error {
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
	stdout, _ := rec.Record(command, env, eutil.NewLoggerDummy())
	CapturedStdout = stdout
	return nil
}
