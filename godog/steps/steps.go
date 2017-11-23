package steps

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"strings"

	"github.com/DATA-DOG/godog"
	state_types "github.com/ankyra/escape-core/state"
	"github.com/ankyra/escape-integration-tests/godog/escape"
	"github.com/ankyra/escape/model/escape_plan"
	"github.com/ankyra/escape/model/state"
	yaml "gopkg.in/yaml.v2"
)

var CapturedDeployment *state_types.DeploymentState
var CapturedStage string

func AddSteps(s *godog.Suite) {
	s.Step(`^a new Escape plan called "([^"]*)"$`, aNewEscapePlanCalled)
	s.Step(`^I preview the plan$`, iPreviewThePlan)
	s.Step(`^I should have valid release metadata$`, iShouldHaveValidReleaseMetadata)
	s.Step(`^the metadata should have its "([^"]*)" set to "([^"]*)"$`, theMetadataShouldHaveItsSetTo)
	s.Step(`^I build the application$`, iBuildTheApplication)
	s.Step(`^I build the application again$`, iBuildTheApplication)
	s.Step(`^I deploy "([^"]*)"$`, iDeployRelease)
	s.Step(`^I deploy$`, iDeploy)
	s.Step(`^"([^"]*)" version "([^"]*)" is present in the build state$`, versionIsPresentInTheBuildState)
	s.Step(`^"([^"]*)" version "([^"]*)" is present in the deploy state$`, versionIsPresentInTheDeployState)
	s.Step(`^input variable "([^"]*)" with default "([^"]*)"$`, inputVariableWithDefault)
	s.Step(`^input variable "([^"]*)" with default "([^"]*)" in scope "([^"]*)"$`, inputVariableWithDefaultInScope)
	s.Step(`^input variable "([^"]*)" with default "([^"]*)" and items "([^"]*)"$`, inputVariableWithDefaultAndItems)
	s.Step(`^its calculated input "([^"]*)" is set to "([^"]*)"$`, itsCalculatedInputIsSetTo)
	s.Step(`^its calculated input "([^"]*)" is not set$`, itsCalculatedInputIsNotSet)
	s.Step(`^its calculated output "([^"]*)" is set to "([^"]*)"$`, itsCalculatedOutputIsSetTo)

	s.Step(`^I release the application$`, iReleaseTheApplication)
	s.Step(`^it has "([^"]*)" as a dependency$`, itHasAsADependency)
	s.Step(`^it has "([^"]*)" set to "([^"]*)"$`, itHasSetTo)
	s.Step(`^"([^"]*)" version "([^"]*)" is present in its deployment state$`, versionIsPresentInItsDeploymentState)
	s.Step(`^it provides "([^"]*)"$`, itProvides)
	s.Step(`^it consumes "([^"]*)"$`, itConsumes)
	s.Step(`^it consumes "([^"]*)" in the "([^"]*)" scope$`, itConsumesInTheScope)
	s.Step(`^"([^"]*)" is the provider for "([^"]*)"$`, isTheProviderFor)
	s.Step(`^output variable "([^"]*)" with default "([^"]*)"$`, outputVariableWithDefault)
	s.Step(`^output variable "([^"]*)" with default '([^']*)'$`, outputVariableWithDefault)
	s.Step(`^list output variable "([^"]*)" with default '([^']*)'$`, outputListVariableWithDefault)
	s.Step(`^template "([^"]*)" containing "([^"]*)" with "([^"]*)" scope$`, templateContainingWithScope)
	s.Step(`^I should not have a file "([^"]*)"$`, iShouldNotHaveAFile)
	s.Step(`^template "([^"]*)" containing "([^"]*)"$`, templateContaining)
	s.Step(`^I should have a file "([^"]*)" with contents "([^"]*)"$`, iShouldHaveAFileWithContents)
	s.Step(`^errand "([^"]*)" with script "([^"]*)"$`, errandWithScript)
	s.Step(`^I list the errands in the deployment "([^"]*)"$`, iListTheErrandsInTheDeployment)
	s.Step(`^I should see "([^"]*)" in the output$`, iShouldSeeInTheOutput)
	s.Step(`^I list the local errands$`, iListTheLocalErrands)
	s.Step(`^I run the errand "([^"]*)" in "([^"]*)"$`, iRunTheErrandIn)
	s.Step(`^I delete the file "([^"]*)"$`, iDeleteTheFile)
	s.Step(`I get the Escape plan field name "([^"]*)`, iGetEscapePlanField)
	s.Step(`I promote "([^"]*)" to "([^"]*)"`, iPromote)
	s.Step(`I promote "([^"]*)" as "([^"]*)" to "([^"]*)"`, iPromoteWithDifferentName)
	s.Step(`^"([^"]*)" is present in "([^"]*)" environment state$`, deploymentNameIsPresentInEnvironmentState)
}

func aNewEscapePlanCalled(name string) error {
	return escape.Run([]string{"plan", "init", "-f", "-n", name})
}

func iPreviewThePlan() error {
	return escape.Run([]string{"plan", "preview"})
}

func inputVariableWithDefault(variableId, defaultValue string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Inputs = append(plan.Inputs, map[string]interface{}{
		"id":      variableId,
		"default": defaultValue,
	})
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
}

func inputVariableWithDefaultInScope(variableId, defaultValue, scope string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Inputs = append(plan.Inputs, map[string]interface{}{
		"id":      variableId,
		"default": defaultValue,
		"scopes":  []string{scope},
	})
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
}

func inputVariableWithDefaultAndItems(variableId, defaultValue, items string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Inputs = append(plan.Inputs, map[string]interface{}{
		"id":      variableId,
		"default": defaultValue,
		"items":   items,
	})
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
}

func outputVariableWithDefault(variableId, defaultValue string) error {
	return outputVariable("string", variableId, defaultValue)
}

func errandWithScript(errand, script string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Errands[errand] = map[string]interface{}{
		"script": script,
	}
	if err := ioutil.WriteFile(script, []byte("#!/bin/bash -e\necho hello"), 0644); err != nil {
		return err
	}
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
}

func outputVariable(typ, variableId, defaultValue string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Outputs = append(plan.Outputs, map[string]interface{}{
		"id":      variableId,
		"default": defaultValue,
		"type":    typ,
	})
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
}

func outputListVariableWithDefault(variableId, defaultValue string) error {
	return outputVariable("list[string]", variableId, defaultValue)
}

func templateContaining(filename, content string) error {
	return templateContainingWithScope(filename, content, "")
}

func templateContainingWithScope(filename, content, scope string) error {
	scopes := []string{"build", "deploy"}
	if scope != "" {
		scopes = []string{scope}
	}
	plan := escape_plan.NewEscapePlan()
	if err := plan.LoadConfig("escape.yml"); err != nil {
		return nil
	}
	plan.Templates = append(plan.Templates, map[string]interface{}{
		"file":   filename,
		"scopes": scopes,
	})
	if err := ioutil.WriteFile(filename, []byte(content), 0644); err != nil {
		return err
	}
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
}

func iShouldNotHaveAFile(arg1 string) error {
	_, err := os.Stat(arg1)
	if err == nil {
		return fmt.Errorf("File '%s' exists", arg1)
	}
	return nil
}

func iShouldHaveAFileWithContents(filename, expectedContent string) error {
	bytes, err := ioutil.ReadFile(filename)
	if err != nil {
		return err
	}
	if string(bytes) != expectedContent {
		return fmt.Errorf("Expecting '%s' got '%s'", expectedContent, string(bytes))
	}
	return nil
}

func itHasSetTo(arg1, arg2 string) error {
	plan := map[string]interface{}{}
	bytes, err := ioutil.ReadFile("escape.yml")
	if err != nil {
		return err
	}
	if err := yaml.Unmarshal(bytes, &plan); err != nil {
		return err
	}
	plan[arg1] = arg2
	bytes, err = yaml.Marshal(plan)
	if err != nil {
		return err
	}
	return ioutil.WriteFile("escape.yml", bytes, 0644)
}

func itsCalculatedInputIsSetTo(key, value string) error {
	inputs := CapturedDeployment.GetCalculatedInputs(CapturedStage)
	v, found := inputs[key]
	if !found {
		return fmt.Errorf("'%s' not found in calculated inputs", key)
	}
	if v != value {
		return fmt.Errorf("Expecting '%s', got '%s'", value, v)
	}
	return nil
}

func itsCalculatedInputIsNotSet(key string) error {
	inputs := CapturedDeployment.GetCalculatedInputs(CapturedStage)
	v, found := inputs[key]
	if !found {
		return nil
	}
	return fmt.Errorf("Found '%s' in calculated inputs with value '%s'", key, v)
}

func itsCalculatedOutputIsSetTo(key, value string) error {
	inputs := CapturedDeployment.GetCalculatedOutputs(CapturedStage)
	v, found := inputs[key]
	if !found {
		return fmt.Errorf("'%s' not found in calculated outputs", key)
	}
	if v != value {
		return fmt.Errorf("Expecting '%s', got '%s'", value, v)
	}
	return nil
}

func iListTheErrandsInTheDeployment(deploymentName string) error {
	return escape.Run([]string{"errands", "list", "-d", deploymentName})
}

func iListTheLocalErrands() error {
	return escape.Run([]string{"errands", "list", "--local"})
}
func iRunTheErrandIn(errand, deployment string) error {
	return escape.Run([]string{"errands", "run", "-d", deployment, errand})
}

func iShouldSeeInTheOutput(value string) error {
	if strings.Index(escape.CapturedStdout, value) == -1 {
		return fmt.Errorf("'%s' was not found in the output:\n%s", value, escape.CapturedStdout)
	}
	return nil
}

func iBuildTheApplication() error {
	return escape.Run([]string{"run", "build"})
}

func iDeploy() error {
	err := escape.Run([]string{"run", "deploy"})
	CapturedStage = "deploy"
	return err
}

func iDeployRelease(arg1 string) error {
	err := escape.Run([]string{"run", "deploy", arg1})
	CapturedStage = "deploy"
	return err
}

func iReleaseTheApplication() error {
	return escape.Run([]string{"run", "release", "-f"})
}

func itHasAsADependency(dependency string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Depends = append(plan.Depends, dependency)
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
}

func itProvides(arg1 string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Provides = append(plan.Provides, arg1)
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
}

func itConsumes(provider string) error {
	return itConsumesInTheScope(provider, "")
}

func itConsumesInTheScope(provider, scope string) error {
	scopes := []string{"build", "deploy"}
	if scope != "" {
		scopes = []string{scope}
	}
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Consumes = append(plan.Consumes, map[interface{}]interface{}{
		"name":   provider,
		"scopes": scopes,
	})
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
}

func isTheProviderFor(deploymentName, providerName string) error {
	d := CapturedDeployment.GetDeploymentOrMakeNew("build", deploymentName)
	prov, found := d.GetProviders("build")[providerName]
	if !found {
		return fmt.Errorf("'%s' provider not found", providerName)
	}
	if prov != deploymentName {
		return fmt.Errorf("'%s' provider is '%s' not expected '%s'", providerName, prov, deploymentName)
	}
	return nil
}

func versionIsPresentInItsDeploymentState(deploymentName, version string) error {
	d := CapturedDeployment.GetDeploymentOrMakeNew("build", deploymentName)
	if d.GetVersion("deploy") != version {
		return fmt.Errorf("Expecting '%s', got '%s'", version, d.GetVersion("deploy"))
	}
	CapturedDeployment = d
	CapturedStage = "deploy"
	return nil
}

func versionIsPresentInTheBuildState(deploymentName, version string) error {
	env, err := state.NewLocalStateProvider("escape_state.json").Load("prj", "dev")
	if err != nil {
		return err
	}
	d := env.GetOrCreateDeploymentState(deploymentName)
	if d.GetVersion("build") != version {
		return fmt.Errorf("Expecting '%s', got '%s'", version, d.GetVersion("build"))
	}
	CapturedDeployment = d
	CapturedStage = "build"
	return nil
}

func versionIsPresentInTheDeployState(deploymentName, version string) error {
	env, err := state.NewLocalStateProvider("escape_state.json").Load("prj", "dev")
	if err != nil {
		return err
	}
	d := env.GetOrCreateDeploymentState(deploymentName)
	if d.GetVersion("deploy") != version {
		return fmt.Errorf("Expecting '%s', got '%s'", version, d.GetVersion("build"))
	}
	CapturedDeployment = d
	CapturedStage = "deploy"
	return nil
}

func iShouldHaveValidReleaseMetadata() error {
	result := map[string]interface{}{}
	err := json.Unmarshal([]byte(escape.CapturedStdout), &result)
	if err != nil {
		return err
	}
	return nil
}

func theMetadataShouldHaveItsSetTo(key, value string) error {
	result := map[string]interface{}{}
	err := json.Unmarshal([]byte(escape.CapturedStdout), &result)
	if err != nil {
		return err
	}
	v, found := result[key]
	if !found {
		return fmt.Errorf("'%s' not found in metadata", key)
	}
	if v != value {
		return fmt.Errorf("Expecting '%s', got '%s'", value, v)
	}
	return nil
}
func iDeleteTheFile(arg1 string) error {
	return os.Remove(arg1)
}

func iGetEscapePlanField(fieldName string) error {
	return escape.Run([]string{"plan", "get", fieldName})
}

func iPromote(deploymentName, toEnvironment string) error {
	return escape.Run([]string{"run", "promote", "-f", "--deployment", deploymentName, "--to", toEnvironment})
}

func iPromoteWithDifferentName(deploymentName, toDeploymentName, toEnvironment string) error {
	return escape.Run([]string{"run", "promote", "-f", "--deployment", deploymentName, "--to", toEnvironment, "--to-deployment", toDeploymentName})
}

func deploymentNameIsPresentInEnvironmentState(deploymentName, environment string) error {
	env, err := state.NewLocalStateProvider("escape_state.json").Load("prj", "dev")
	if err != nil {
		return err
	}

	deployment := env.Project.GetEnvironmentStateOrMakeNew(environment).Deployments[deploymentName]
	if deployment == nil {
		return fmt.Errorf("%s not found in %s environment state", deploymentName, environment)
	}

	return nil
}
