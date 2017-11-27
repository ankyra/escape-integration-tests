package steps

import (
	"fmt"

	"github.com/ankyra/escape/model/config"
	"github.com/ankyra/escape/model/escape_plan"
	"github.com/ankyra/escape/model/state"
)

// Config matching

func matcherActiveProfileFromConfig(profileName string) error {
	c := config.NewEscapeConfig()
	err := c.FromJson("/tmp/godog_escape_config")
	if err != nil {
		return err
	}

	if c.ActiveProfile != profileName {
		return fmt.Errorf("'%s' did not match current active profile '%s'", profileName, c.ActiveProfile)
	}

	return nil
}

func matcherProfileFromConfig(profileName string) error {
	c := config.NewEscapeConfig()
	err := c.FromJson("/tmp/godog_escape_config")
	if err != nil {
		return err
	}

	if c.Profiles[profileName] == nil {
		return fmt.Errorf("'%s' was not found in profiles", profileName)
	}

	return nil
}

// Plan matching

func matcherEscapePlanExists() error {
	return matcherEscapePlanExistsAt("escape.yml")
}

func matcherEscapePlanExistsAt(planLocation string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig(planLocation)
	if err != nil {
		return fmt.Errorf("Escape plan not found at %s", planLocation)
	}

	return nil
}

func matcherEscapePlanHasName(name string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return fmt.Errorf("Escape plan not found")
	}

	if plan.Name != name {
		fmt.Errorf("Escape plan name was %s, not %s", plan.Name, name)
	}

	return nil
}

func matcherEscapePlanHasVersion(version string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return fmt.Errorf("Escape plan not found")
	}

	if plan.Version != version {
		fmt.Errorf("Escape plan version was %s, not %s", plan.Version, version)
	}

	return nil
}

func matcherEscapePlanHasInclude(include string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return fmt.Errorf("Escape plan not found")
	}

	var found bool
	for _, includeFile := range plan.Includes {
		if includeFile == include {
			found = true
		}
	}
	if !found {
		fmt.Errorf("Escape plan did not include %s, contains %s", include, plan.Includes)
	}

	return nil
}

// State matching

func matcherEscapeStateExists() error {
	return matcherEscapeStateExistsAt("escape_state.json")
}

func matcherEscapeStateExistsAt(stateLocation string) error {
	_, err := state.NewLocalStateProvider("escape_state.json").Load("prj", "dev")
	if err != nil {
		return err
	}
	return nil
}
