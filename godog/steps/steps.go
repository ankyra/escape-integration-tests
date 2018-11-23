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

package steps

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"strings"

	"github.com/DATA-DOG/godog"
	core "github.com/ankyra/escape-core"
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
	s.Step(`^I remove the state$`, iRemoveTheState)
	s.Step(`^I build the application$`, iBuildTheApplication)
	s.Step(`^I build the application again$`, iBuildTheApplication)
	s.Step(`^I deploy "([^"]*)"$`, iDeployRelease)
	s.Step(`^I deploy$`, iDeploy)
	s.Step(`^"([^"]*)" version "([^"]*)" is present in the build state$`, versionIsPresentInTheBuildState)
	s.Step(`^"([^"]*)" version "([^"]*)" is present in the deploy state$`, versionIsPresentInTheDeployState)
	s.Step(`^input variable "([^"]*)" with default "([^"]*)"$`, inputVariableWithDefault)
	s.Step(`^input variable "([^"]*)" with default "([^"]*)" evaluated after dependencies$`, inputVariableWithDefaultEvalAfterDeps)
	s.Step(`^input variable "([^"]*)" with default "([^"]*)" in scope "([^"]*)"$`, inputVariableWithDefaultInScope)
	s.Step(`^input variable "([^"]*)" in scope "([^"]*)"$`, inputVariableInScope)
	s.Step(`^input variable "([^"]*)" with default "([^"]*)" and items "([^"]*)"$`, inputVariableWithDefaultAndItems)
	s.Step(`^its calculated input "([^"]*)" is set to "([^"]*)"$`, itsCalculatedInputIsSetTo)
	s.Step(`^its calculated input "([^"]*)" is not set$`, itsCalculatedInputIsNotSet)
	s.Step(`^its calculated output "([^"]*)" is set to "([^"]*)"$`, itsCalculatedOutputIsSetTo)

	s.Step(`^it has "([^"]*)" as an inline build script$`, setInlineBuild)
	s.Step(`^it has "([^"]*)" as an inline provider activation script$`, itHasAsAnInlineProviderActivationScript)
	s.Step(`^it has "([^"]*)" as an inline provider deactivation script$`, itHasAsAnInlineProviderDeactivationScript)

	s.Step(`^I release the application$`, iReleaseTheApplication)
	s.Step(`^it has "([^"]*)" as an extension$`, itHasAsAnExtension)
	s.Step(`^it has "([^"]*)" as a dependency$`, itHasAsADependency)
	s.Step(`^it has "([^"]*)" as a dependency mapping consumer "([^"]*)" to "([^"]*)"$`, itHasAsADependencyMappingConsumerTo)
	s.Step(`^it has "([^"]*)" as a dependency mapping "([^"]*)" to "([^"]*)"$`, itHasAsADependencyMappingTo)
	s.Step(`^it has "([^"]*)" set to "([^"]*)"$`, itHasSetTo)
	s.Step(`^"([^"]*)" version "([^"]*)" is present in its deployment state$`, versionIsPresentInItsDeploymentState)
	s.Step(`^it provides "([^"]*)"$`, itProvides)
	s.Step(`^it consumes "([^"]*)"$`, itConsumes)
	s.Step(`^it consumes "([^"]*)" in the "([^"]*)" scope$`, itConsumesInTheScope)
	s.Step(`^"([^"]*)" is the provider for "([^"]*)"$`, isTheProviderFor)
	s.Step(`^"([^"]*)" is the provider for "([^"]*)" in "([^"]*)"$`, isTheProviderForIn)
	s.Step(`^output variable "([^"]*)" with default "([^"]*)"$`, outputVariableWithDefault)
	s.Step(`^output variable "([^"]*)" with default '([^']*)'$`, outputVariableWithDefault)
	s.Step(`^list output variable "([^"]*)" with default '([^']*)'$`, outputListVariableWithDefault)
	s.Step(`^template "([^"]*)" containing "([^"]*)" with "([^"]*)" scope$`, templateContainingWithScope)
	s.Step(`^I should not have a file "([^"]*)"$`, iShouldNotHaveAFile)
	s.Step(`^template "([^"]*)" containing "([^"]*)"$`, templateContaining)
	s.Step(`^I should have a file "([^"]*)" with contents "([^"]*)"$`, iShouldHaveAFileWithContents)
	s.Step(`^errand "([^"]*)" with script "([^"]*)"$`, errandWithScript)
	s.Step(`^errand "([^"]*)" with script "([^"]*)" with description "([^"]*)"$`, errandWithScriptAndDescription)
	s.Step(`^I list the errands in the deployment "([^"]*)"$`, iListTheErrandsInTheDeployment)
	s.Step(`^I should see "([^"]*)" in the output$`, iShouldSeeInTheOutput)
	s.Step(`^I should not see "([^"]*)" in the output$`, iShouldNotSeeInTheOutput)
	s.Step(`^I list the local errands$`, iListTheLocalErrands)
	s.Step(`^I run the errand "([^"]*)" in "([^"]*)"$`, iRunTheErrandIn)
	s.Step(`^I delete the file "([^"]*)"$`, iDeleteTheFile)
	s.Step(`^the file "([^"]*)" contains "([^"]*)"$`, theFileContains)
	s.Step(`^the file "([^"]*)" is equal to "([^"]*)"$`, theFileIsEqualTo)
	s.Step(`I get the Escape plan field name "([^"]*)`, iGetEscapePlanField)
	s.Step(`I promote "([^"]*)" to "([^"]*)"`, iPromote)
	s.Step(`I promote "([^"]*)" as "([^"]*)" to "([^"]*)"`, iPromoteWithDifferentName)
	s.Step(`^"([^"]*)" is present in "([^"]*)" environment state$`, deploymentNameIsPresentInEnvironmentState)
	s.Step(`^subdeployment "([^"]*)" has provider "([^"]*)" set to "([^"]*)"$`, subdeploymentHasProviderSetTo)

	s.Step(`I run "([^"]*)" which fails`, runAndFailEscapeCmd)
	s.Step(`I run "([^"]*)"`, runEscapeCmd)
	s.Step(`I have the profile "([^"]*)" in my config`, addProfileToConfig)
	s.Step(`I set "([^"]*)" to be the active profile`, setActiveProfile)

	// Matchers

	s.Step(`"([^"]*)" is the active profile in my config`, matcherActiveProfileFromConfig)
	s.Step(`"([^"]*)" is a profile in my config`, matcherProfileFromConfig)

	s.Step(`an Escape plan should exist$`, matcherEscapePlanExists)
	s.Step(`an Escape plan should exist at "([^"]*)"$`, matcherEscapePlanExistsAt)
	s.Step(`the Escape plan should have the name "([^"]*)"`, matcherEscapePlanHasName)
	s.Step(`the Escape plan should have the version "([^"]*)"`, matcherEscapePlanHasVersion)
	s.Step(`the Escape plan should have the "([^"]*)" file included`, matcherEscapePlanHasInclude)

	s.Step(`Escape state should exist$`, matcherEscapeStateExists)
	s.Step(`Escape state should have the deployment "([^"]*)" in environment "([^"]*)"$`, matcherEscapeStateHasDeployment)
	s.Step(`the stage "([^"]*)" is empty$`, matcherEscapeStateDeploymentStageEmpty)
}

func runEscapeCmd(args string) error {
	return OutputEscapeStateOnError(escape.Run(strings.Split(args, " ")[1:]))
}

func runAndFailEscapeCmd(args string) error {
	escape.RunAndFail(strings.Split(args, " ")[1:])
	return nil
}

func addProfileToConfig(profileName string) error {
	return escape.Run([]string{"config", "create-profile", profileName})
}

func setActiveProfile(profileName string) error {
	return escape.Run([]string{"config", "set-profile", profileName})
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

func inputVariableWithDefaultEvalAfterDeps(variableId, defaultValue string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Inputs = append(plan.Inputs, map[string]interface{}{
		"id":                       variableId,
		"default":                  defaultValue,
		"eval_before_dependencies": false,
	})
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
}

func inputVariableInScope(variableId, scope string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Inputs = append(plan.Inputs, map[string]interface{}{
		"id":     variableId,
		"scopes": []string{scope},
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
	return errandWithScriptAndDescription(errand, script, "")
}

func errandWithScriptAndDescription(errand, script, description string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Errands[errand] = map[string]interface{}{
		"script": script,
	}

	if description != "" {
		plan.Errands[errand].(map[string]interface{})["description"] = description
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

func setInlineBuild(script string) error {
	return setInlineScriptOnFieldTo("build", script)
}
func itHasAsAnInlineProviderActivationScript(arg1 string) error {
	return setInlineScriptOnFieldTo("activate_provider", arg1)
}

func itHasAsAnInlineProviderDeactivationScript(arg1 string) error {
	return setInlineScriptOnFieldTo("deactivate_provider", arg1)
}

func setInlineScriptOnFieldTo(field, script string) error {
	plan := map[string]interface{}{}
	bytes, err := ioutil.ReadFile("escape.yml")
	if err != nil {
		return err
	}
	if err := yaml.Unmarshal(bytes, &plan); err != nil {
		return err
	}
	if plan[field] == nil {
		plan[field] = map[string]interface{}{}
	}
	plan[field].(map[string]interface{})["inline"] = script
	bytes, err = yaml.Marshal(plan)
	if err != nil {
		return err
	}
	return ioutil.WriteFile("escape.yml", bytes, 0644)
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

func iShouldNotSeeInTheOutput(value string) error {
	if strings.Index(escape.CapturedStdout, value) != -1 {
		return fmt.Errorf("'%s' was found in the output:\n%s", value, escape.CapturedStdout)
	}
	return nil
}

func iBuildTheApplication() error {
	err := escape.Run([]string{"run", "build"})
	return OutputEscapeStateOnError(err)
}

func iDeploy() error {
	err := escape.Run([]string{"run", "deploy"})
	CapturedStage = "deploy"
	return OutputEscapeStateOnError(err)
}

func iDeployRelease(arg1 string) error {
	err := escape.Run([]string{"run", "deploy", arg1})
	CapturedStage = "deploy"
	return OutputEscapeStateOnError(err)
}

func iReleaseTheApplication() error {
	err := escape.Run([]string{"run", "release", "-f"})
	return OutputEscapeStateOnError(err)
}

func itHasAsAnExtension(extension string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	plan.Extends = append(plan.Extends, extension)
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
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

func itHasAsADependencyMappingTo(dependency, key, value string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	dependencyCfg := core.NewDependencyConfig(dependency)
	dependencyCfg.Mapping[key] = value
	plan.Depends = append(plan.Depends, dependencyCfg)
	return ioutil.WriteFile("escape.yml", plan.ToMinifiedYaml(), 0644)
}

func itHasAsADependencyMappingConsumerTo(dependency, consumer, to string) error {
	plan := escape_plan.NewEscapePlan()
	err := plan.LoadConfig("escape.yml")
	if err != nil {
		return nil
	}
	dependencyCfg := core.NewDependencyConfig(dependency)
	dependencyCfg.Consumes[consumer] = to
	plan.Depends = append(plan.Depends, dependencyCfg)
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
	var err error
	d, err := CapturedDeployment.GetDeploymentOrMakeNew("build", deploymentName)
	if err != nil {
		return err
	}
	prov, found := d.GetProviders("build")[providerName]
	if !found {
		err = fmt.Errorf("'%s' provider not found", providerName)
	}
	if err == nil && prov != deploymentName {
		err = fmt.Errorf("'%s' provider is '%s' not expected '%s'", providerName, prov, deploymentName)
	}
	return OutputEscapeStateOnError(err)
}

func isTheProviderForIn(deploymentName, providerName, deploymentPath string) error {
	var err error
	d, err := CapturedDeployment.GetEnvironmentState().ResolveDeploymentPath("build", deploymentPath)
	if err != nil {
		return OutputEscapeStateOnError(err)
	}
	prov, found := d.GetProviders("deploy")[providerName]
	if !found {
		fmt.Println(d)
		err = fmt.Errorf("'%s' provider not found", providerName)
	}
	if err == nil && prov != deploymentName {
		err = fmt.Errorf("'%s' provider is '%s', but expecting '%s'", providerName, prov, deploymentName)
	}
	return OutputEscapeStateOnError(err)
}

func versionIsPresentInItsDeploymentState(deploymentName, version string) error {
	d, err := CapturedDeployment.GetDeploymentOrMakeNew("build", deploymentName)
	if err != nil {
		return err
	}
	if d.GetVersion("deploy") != version {
		OutputEscapeState()
		return fmt.Errorf("Expecting '%s', got '%s'", version, d.GetVersion("deploy"))
	}
	CapturedDeployment = d
	CapturedStage = "deploy"
	return nil
}

func iRemoveTheState() error {
	return os.RemoveAll("escape_state.json")
}

func versionIsPresentInTheBuildState(deploymentName, version string) error {
	env, err := state.NewLocalStateProvider("escape_state.json").Load("prj", "dev")
	if err != nil {
		return OutputEscapeStateOnError(err)
	}
	d, err := env.GetOrCreateDeploymentState(deploymentName)
	if err != nil {
		return err
	}
	if d.GetVersion("build") != version {
		OutputEscapeState()
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
	d, err := env.GetOrCreateDeploymentState(deploymentName)
	if err != nil {
		return err
	}
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
	_, err := os.Stat(arg1)
	if os.IsNotExist(err) {
		return nil
	}
	return os.Remove(arg1)
}

func theFileContains(file, content string) error {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		return err
	}
	if !strings.Contains(string(b), strings.Replace(content, "\\n", "\n", -1)) {
		return fmt.Errorf("The file '%s' does not contain '%s', but:\n '%s", file, content, string(b))
	}
	return nil
}

func theFileIsEqualTo(file, content string) error {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		return err
	}
	if !(string(b) == strings.Replace(content, "\\n", "\n", -1)) {
		return fmt.Errorf("The file '%s' does not contain '%s', but:\n '%s", file, content, string(b))
	}
	return nil
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
	e, err := env.Project.GetEnvironmentStateOrMakeNew(environment)
	if err != nil {
		return err
	}
	deployment := e.Deployments[deploymentName]
	if deployment == nil {
		return fmt.Errorf("%s not found in %s environment state", deploymentName, environment)
	}

	return nil
}

func subdeploymentHasProviderSetTo(subdeployment, provider, providerDepl string) error {
	env, err := state.NewLocalStateProvider("escape_state.json").Load("prj", "dev")
	if err != nil {
		return err
	}
	e, err := env.Project.GetEnvironmentStateOrMakeNew("dev")
	if err != nil {
		return err
	}
	deployment, err := e.ResolveDeploymentPath("deploy", subdeployment)
	if err != nil {
		return OutputEscapeStateOnError(err)
	}
	providers := deployment.GetProviders("deploy")
	depl, found := providers[provider]
	if !found {
		return OutputEscapeStateOnError(fmt.Errorf("Provider %s was not set", provider))
	}
	if depl != providerDepl {
		return OutputEscapeStateOnError(fmt.Errorf("Provider %s was set to %s not %s", provider, depl, providerDepl))
	}
	return nil
}
