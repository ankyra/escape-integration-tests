package steps

import (
	"fmt"
	"io/ioutil"
)

func OutputEscapeState() {
	b, _ := ioutil.ReadFile("escape_state.json")
	fmt.Println(string(b))
}

func OutputEscapeStateOnError(err error) error {
	if err != nil {
		OutputEscapeState()
	}
	return err
}
