Feature: Running the build phase 
    As a Infrastructure engineer
    In order to validate my changes
    I need to be able to build a project locally

    Scenario: Build the default Escape plan
      Given a new Escape plan called "my-release"
      When I build the application
      Then "_/my-release" version "0.0.0" is present in the build state

    Scenario: Build with default input variables
      Given a new Escape plan called "my-release"
        And input variable "input_variable" with default "test"
        And input variable "input_variable2" with default "test2"
      When I build the application
      Then "_/my-release" version "0.0.0" is present in the build state
       And its calculated input "input_variable" is set to "test"
       And its calculated input "input_variable2" is set to "test2"

    Scenario: Build with scoped input variables
      Given a new Escape plan called "my-release"
        And input variable "input_variable" with default "test" in scope "build"
        And input variable "input_variable2" with default "test2" in scope "deploy"
      When I build the application
      Then "_/my-release" version "0.0.0" is present in the build state
       And its calculated input "input_variable" is set to "test"
       And its calculated input "input_variable2" is not set

    Scenario: Default input variables update on every build
      Given a new Escape plan called "my-release"
        And input variable "input_variable" with default "test"
       When I build the application
       Then "_/my-release" version "0.0.0" is present in the build state
        And its calculated input "input_variable" is set to "test"
        And input variable "input_variable" with default "new default baby"
       When I build the application
       Then "_/my-release" version "0.0.0" is present in the build state
        And its calculated input "input_variable" is set to "new default baby"

    Scenario: Build a template
      Given a new Escape plan called "my-release"
        And template "test.txt.tpl" containing "Hello World"
       When I build the application
       Then I should have a file "test.txt" with contents "Hello World"

    Scenario: Build a template that uses a variable
      Given a new Escape plan called "my-release"
        And input variable "input_variable" with default "test"
        And template "test.txt.tpl" containing "{{{version}}} {{input_variable}}"
       When I build the application
       Then I should have a file "test.txt" with contents "0.0.0 test"

    Scenario: Build skips template when not in build scope
      Given a new Escape plan called "my-release"
        And template "not_in_scope.txt.tpl" containing "Hello World" with "deploy" scope
       When I build the application
       Then I should not have a file "not_in_scope.txt"

    Scenario: Build does not skip template when in build scope
      Given a new Escape plan called "my-release"
        And template "inscope.txt.tpl" containing "Hello World" with "build" scope
       When I build the application
       Then I should have a file "inscope.txt" with contents "Hello World"

    Scenario: Default build with dependencies
      Given a new Escape plan called "my-dependency"
        And I release the application
        And a new Escape plan called "my-second-dependency"
        And it has "my-dependency-latest" as a dependency 
        And I release the application
        And a new Escape plan called "my-release"
        And it has "my-second-dependency-latest" as a dependency 
      When I build the application
      Then "_/my-release" version "0.0.0" is present in the build state
       And "_/my-second-dependency" version "0.0.0" is present in its deployment state

    Scenario: Default input variables update for dependencies on every build
      Given a new Escape plan called "my-input-dependency"
        And input variable "input_variable" with default "test"
        And I release the application
      Given a new Escape plan called "my-release"
        And it has "my-input-dependency-latest" as a dependency 
       When I build the application
       Then "_/my-release" version "0.0.0" is present in the build state
        And "_/my-input-dependency" version "0.0.0" is present in its deployment state
        And its calculated input "input_variable" is set to "test"
        And input variable "input_variable" with default "new default baby"
       When I build the application again
       Then "_/my-release" version "0.0.0" is present in the build state
        And "_/my-input-dependency" version "0.0.0" is present in its deployment state
        And its calculated input "PREVIOUS_input_variable" is set to "test"
        And its calculated input "input_variable" is set to "new default baby"

    Scenario: Dependency input variable scope is not added to parent if part of mapping
      Given a new Escape plan called "my-scoped-input-dependency"
        And input variable "input_variable" in scope "deploy"
        And I run "escape run release -f -v input_variable="
      Given a new Escape plan called "my-release"
        And it has "my-scoped-input-dependency-latest" as a dependency mapping "input_variable" to "test"
       When I build the application
       Then "_/my-release" version "0.0.0" is present in the build state

    Scenario: Dependency input variable scope is honoured
      Given a new Escape plan called "my-scoped-input-dependency"
        And input variable "input_variable" in scope "deploy"
        And I run "escape run release -f -v input_variable="
      Given a new Escape plan called "my-release"
        And it has "my-scoped-input-dependency-latest" as a dependency 
       When I run "escape run build" which fails

    Scenario: Dependency input variable scope is honoured - with default
      Given a new Escape plan called "my-scoped-input-dependency"
        And input variable "input_variable" with default "test" in scope "deploy"
        And I release the application
      Given a new Escape plan called "my-release"
        And it has "my-scoped-input-dependency-latest" as a dependency 
       When I build the application
       Then "_/my-release" version "0.0.0" is present in the build state

    Scenario: Dependency input variable scope is honoured - default is used
      Given a new Escape plan called "my-scoped-input-dependency"
        And input variable "input_variable" with default "test" in scope "deploy"
        And I release the application
      Given a new Escape plan called "my-release"
        And it has "my-scoped-input-dependency-latest" as a dependency 
        And input variable "input_variable" with default "alright" in scope "build"
       When I build the application
       Then "_/my-release" version "0.0.0" is present in the build state
        And its calculated input "input_variable" is set to "alright"

    Scenario: Using Dependency Outputs as Inputs
       Given a new Escape plan called "output"
         And output variable "output_variable" with default "test"
         And I release the application
       Given a new Escape plan called "parent"
         And it has "output-latest as dep" as a dependency 
         And input variable "input_variable" with default "$dep.outputs.output_variable" evaluated after dependencies
         And I release the application
        When I deploy "_/parent-v0.0.0"
        Then "_/parent" version "0.0.0" is present in the deploy state
         And its calculated input "input_variable" is set to "test"
       
    Scenario: Build with provider (simplest case)
      Given a new Escape plan called "my-provider"
        And it provides "provider"
        And I release the application
      Given a new Escape plan called "my-consumer"
        And it consumes "provider"
       When I deploy "my-provider-v0.0.0"
        And I build the application
       Then "_/my-consumer" version "0.0.0" is present in the build state
        And "_/my-provider" is the provider for "provider"


    Scenario: Build with provider (output -> default linking)
      Given a new Escape plan called "my-provider2"
        And it provides "provider"
        And output variable "output_variable" with default "test"
        And I release the application
       When I deploy "_/my-provider2-v0.0.0"
       Then "_/my-provider2" version "0.0.0" is present in the deploy state
        And its calculated output "output_variable" is set to "test"

      Given a new Escape plan called "my-consumer"
        And it consumes "provider"
        And input variable "input_variable" with default "$provider.outputs.output_variable"
       When I build the application
       Then "_/my-consumer" version "0.0.0" is present in the build state
        And "_/my-provider2" is the provider for "provider"
        And its calculated input "input_variable" is set to "test"


    Scenario: Build with provider (output -> items linking)
      Given a new Escape plan called "my-provider3"
        And it provides "provider"
        And output variable "default_output" with default "a"
        And list output variable "output_variable" with default '["a", "b", "c"]'
        And I release the application
       When I deploy "_/my-provider3-v0.0.0"
       Then "_/my-provider3" version "0.0.0" is present in the deploy state
        And its calculated output "default_output" is set to "a"

      Given a new Escape plan called "my-consumer"
        And it consumes "provider"
        And input variable "input_variable" with default "$provider.outputs.default_output" and items "$provider.outputs.output_variable"
       When I build the application
       Then "_/my-consumer" version "0.0.0" is present in the build state
        And "_/my-provider3" is the provider for "provider"
        And its calculated input "input_variable" is set to "a"

    Scenario: If a consumer is not in scope no provider is necessary
      Given a new Escape plan called "my-consumer"
        And it consumes "provider" in the "deploy" scope
       When I build the application
       Then "_/my-consumer" version "0.0.0" is present in the build state

    Scenario: If a consumer is in scope it will be used
      Given a new Escape plan called "my-provider3"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider3-v0.0.0"
       Then "_/my-provider3" version "0.0.0" is present in the deploy state
      Given a new Escape plan called "my-consumer"
        And it consumes "provider" in the "build" scope
       When I build the application
       Then "_/my-consumer" version "0.0.0" is present in the build state
        And "_/my-provider3" is the provider for "provider"

    Scenario: If a dependency needs a provider
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency 
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: If a parent and dependency both need the same provider
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency 
        And it consumes "provider" in the "build" scope
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: Specify dependency consumers
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency mapping consumer "provider" to "_/my-provider4"
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: Map parent consumers to dependency consumers
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency mapping consumer "provider" to "$provider.deployment"
        And it consumes "provider" in the "build" scope
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: Map renamed parent consumers to dependency consumers
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency mapping consumer "provider" to "$p1.deployment"
        And it consumes "provider as p1" in the "build" scope
        And it consumes "provider as p2" in the "build" scope
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: Map renamed parent consumers to dependency consumers [part 2]
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency mapping consumer "provider" to "$p2.deployment"
        And it consumes "provider as p1" in the "build" scope
        And it consumes "provider as p2" 
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: Use one dependency as a provider for another dependency
      Given a new Escape plan called "my-provider"
        And it provides "provider"
        And I release the application

      Given a new Escape plan called "my-consumer"
        And it consumes "provider"
        And I release the application
        And I remove the state

      Given a new Escape plan called "parent-release"
        And it has "my-provider-latest as my-provider" as a dependency
        And it has "my-consumer-latest" as a dependency mapping consumer "provider" to "$my-provider.deployment"
       When I build the application
       Then "_/parent-release" version "0.0.0" is present in the build state

    Scenario: Use the same dependency twice for two other dependencies
      Given a new Escape plan called "my-provider"
        And it provides "provider"
        And I release the application

      Given a new Escape plan called "my-consumer"
        And it consumes "provider"
        And I release the application
        And I remove the state

      Given a new Escape plan called "parent-release"
        And it has "my-provider-latest as p1" as a dependency
        And it has "my-provider-latest as p2" as a dependency
        And it has "my-consumer-latest as c1" as a dependency mapping consumer "provider" to "$p1.deployment"
        And it has "my-consumer-latest as c2" as a dependency mapping consumer "provider" to "$p2.deployment"
       When I build the application
       Then "_/parent-release" version "0.0.0" is present in the build state
        And "_/parent-release:p1" is the provider for "provider" in "_/parent-release:c1"
        And "_/parent-release:p2" is the provider for "provider" in "_/parent-release:c2"

    Scenario: Build twice creates PREVIOUS_OUTPUTS environment varaible
       Given a new Escape plan called "output"
         And output variable "output_variable" with default "previous_test_variable_value"
         And it has "echo $INPUT_PREVIOUS_OUTPUT_output_variable" as an inline build script
        When I build the application
         And I should not see "previous_test_variable_value" in the output
        Then I build the application again
         And I should see "previous_test_variable_value" in the output

    Scenario: Build activates/deactivates providers
      Given a new Escape plan called "my-provider"
        And it provides "provider"
        And it has "echo activate" as an inline provider activation script
        And it has "echo deactivate" as an inline provider deactivation script
        And I release the application

       Given a new Escape plan called "output"
        And it consumes "provider"
        And it has "echo parent" as an inline build script

       When I build the application
       Then I should see "activate" in the output
       Then I should see "parent" in the output
       Then I should see "deactivate" in the output
