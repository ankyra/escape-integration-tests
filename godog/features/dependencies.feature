Feature: Dependencies
    As a Infrastructure engineer
    In order to compose my packages
    I need to be able to depend on different releases

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

    Scenario: Build with dependencies (using :v1.0 format)
      Given a new Escape plan called "my-dependency"
        And I release the application
      Given a new Escape plan called "my-release"
        And it has "my-dependency:v0.0.0" as a dependency 
      When I build the application
      Then "_/my-release" version "0.0.0" is present in the build state
       And "_/my-dependency" version "0.0.0" is present in its deployment state

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
       
