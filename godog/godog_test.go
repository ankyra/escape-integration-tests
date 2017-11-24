package godog

import (
	"os"

	"github.com/ankyra/escape-integration-tests/godog/escape"
	"github.com/ankyra/escape-integration-tests/godog/steps"

	"github.com/DATA-DOG/godog"
	"github.com/ankyra/escape-integration-tests/godog/inventory"
)

const InventoryPath = "../deps/_/escape-inventory/escape-inventory"
const EscapePath = "../deps/_/escape/escape"

func FeatureContext(s *godog.Suite) {

	escape.EscapePath = EscapePath

	steps.AddSteps(s)

	s.BeforeSuite(func() {
		err := inventory.Start(InventoryPath)
		if err != nil {
			panic(err)
		}
	})

	s.AfterSuite(func() {
		inventory.Stop()
	})

	s.BeforeScenario(func(interface{}) {
		if err := inventory.Wipe(); err != nil {
			panic(err.Error())
		}
		os.RemoveAll("escape_state.json")
		os.RemoveAll("escape.yml")
		os.RemoveAll("releases/")
		os.RemoveAll("deps/")
		os.RemoveAll("/tmp/godog_escape_config")
		os.Mkdir("releases/", 0755)
	})

	s.AfterScenario(func(interface{}, error) {
		os.Remove("escape.yml")
		os.Remove("test.sh")
	})
}
