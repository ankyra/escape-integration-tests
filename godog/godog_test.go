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
	steps.AddSteps(s)

	s.BeforeSuite(func() {
		inventory.Start(InventoryPath)
		escape.EscapePath = EscapePath
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
		os.Mkdir("releases/", 0755)
	})

	s.AfterScenario(func(interface{}, error) {
		os.Remove("escape.yml")
		os.Remove("test.sh")
	})
}
