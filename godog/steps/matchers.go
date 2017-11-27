package steps

import (
	"encoding/json"
	"fmt"
	"io/ioutil"

	core_state "github.com/ankyra/escape-core/state"
	"github.com/ankyra/escape/model/config"
	"github.com/ankyra/escape/model/escape_plan"
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
	_, err := loadEscapeState(stateLocation)
	if err != nil {
		return err
	}
	return nil
}

var lastDeploymentName string
var lastDeploymentEnv string

func matcherEscapeStateHasDeployment(name, env string) error {
	state, err := loadEscapeState("escape_state.json")
	if err != nil {
		return err
	}
	environment := state.Environments[env]
	if environment == nil {
		return fmt.Errorf("Escape state environment %s not found", env)
	}

	deployment := environment.Deployments[name]

	if deployment == nil {
		fmt.Println(environment.Deployments)
		return fmt.Errorf("Escape state deployment %s not found in environemnt %s", name, env)
	}

	lastDeploymentName = name
	lastDeploymentEnv = env

	return nil
}

func matcherEscapeStateDeploymentStageEmpty(stage string) error {
	state, err := loadEscapeState("escape_state.json")
	if err != nil {
		return err
	}

	environment := state.Environments[lastDeploymentEnv]
	if environment == nil {
		return fmt.Errorf("Escape state environment %s not found", lastDeploymentEnv)
	}

	deployment := environment.Deployments[lastDeploymentName]

	if deployment == nil {
		fmt.Println(environment.Deployments)
		return fmt.Errorf("Escape state deployment %s not found in environemnt %s", lastDeploymentName, lastDeploymentEnv)
	}

	deploymentStage := deployment.Stages[stage]
	if deploymentStage == nil {
		return fmt.Errorf("Escape state stage %s not found on deployment %s in environment %s", stage, lastDeploymentName, lastDeploymentEnv)
	}

	if deploymentStage.Status.Code != "empty" {
		return fmt.Errorf("Escape state stage %s was not empty", stage)
	}

	return nil
}

func loadEscapeState(path string) (*core_state.ProjectState, error) {
	fileBytes, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("Could not open %s, %s", path, err.Error())
	}

	state := &core_state.ProjectState{}
	err = json.Unmarshal(fileBytes, state)
	if err != nil {
		return nil, fmt.Errorf("Could not unmarshal %s, %s", path, err.Error())
	}

	return state, nil
}
