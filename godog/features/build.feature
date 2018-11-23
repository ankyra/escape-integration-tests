@builds
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

    Scenario: Build twice creates PREVIOUS_OUTPUTS environment varaible
       Given a new Escape plan called "output"
         And output variable "output_variable" with default "previous_test_variable_value"
         And it has "echo $INPUT_PREVIOUS_OUTPUT_output_variable" as an inline build script
        When I build the application
         And I should not see "previous_test_variable_value" in the output
        Then I build the application again
         And I should see "previous_test_variable_value" in the output

