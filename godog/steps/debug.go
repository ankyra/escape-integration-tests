package steps

import (
	"fmt"
	"io/ioutil"

	"github.com/ankyra/escape-integration-tests/godog/escape"
)

func OutputEscapeState() {
	b, _ := ioutil.ReadFile("escape_state.json")
	fmt.Println(string(b))
}

func OutputEscapeStateOnError(err error) error {
	if err != nil {
		fmt.Println(escape.CapturedStdout)
		OutputEscapeState()
	}
	return err
}
