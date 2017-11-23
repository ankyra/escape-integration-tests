Feature: escape plan

    Scenario: No extra args
      When I run "escape plan unknown"
      Then I should see "Error: Unknown command 'unknown'" in the output

    Scenario: Prints help
      When I run "escape plan"
      Then I should see "Usage" in the output
      
    Scenario: Prints help with flag
      When I run "escape plan --help"
      Then I should see "Usage" in the output

    Scenario: escape plan diff

      Scenario: No extra args
        When I run "escape plan diff unknown"
        Then I should see "Error: Unknown command 'unknown'" in the output

      Scenario: Prints help with flag
        When I run "escape plan diff --help"
        Then I should see "Usage" in the output

    Scenario: escape plan fmt

      Scenario: No extra args
        When I run "escape plan fmt unknown"
        Then I should see "Error: Unknown command 'unknown'" in the output

      Scenario: Prints help with flag
        When I run "escape plan fmt --help"
        Then I should see "Usage" in the output

    Scenario: escape plan get

      Scenario: Prints help
        Given a new Escape plan called "my-app"
        When I run "escape plan get"
        Then I should see "Usage" in the output

      Scenario: Prints error if no escape plan
        When I run "escape plan get"
        Then I should see "Error: Escape plan 'escape.yml' was not found. Use 'escape plan init' to create it" in the output

      Scenario: Prints help with flag
        When I run "escape plan get --help"
        Then I should see "Usage" in the output

      Scenario: Get unknown plan field name error
      Given a new Escape plan called "my-app"
        When I run "escape plan get unknown"
        Then I should see "Error: This field is currently unsupported by this command." in the output

    Scenario: escape plan init

      Scenario: No extra args
        When I run "escape plan init unknown"
        Then I should see "Error: Unknown command 'unknown'" in the output

      Scenario: Prints help with flag
        When I run "escape plan get --help"
        Then I should see "Usage" in the output

    Scenario: escape plan minify

      Scenario: No extra args
        When I run "escape plan minify unknown"
        Then I should see "Error: Unknown command 'unknown'" in the output

      Scenario: Prints help with flag
        When I run "escape plan minify --help"
        Then I should see "Usage" in the output


    Scenario: escape plan preview

      Scenario: No extra args
        When I run "escape plan preview unknown"
        Then I should see "Error: Unknown command 'unknown'" in the output

      Scenario: Prints help with flag
        When I run "escape plan preview --help"
        Then I should see "Usage" in the output




    Scenario: Get Escape plan name
      Given a new Escape plan called "my-release"
      When I get the Escape plan field name "name"
      Then I should see "my-release" in the output

    Scenario: Get Escape plan version
      Given a new Escape plan called "my-release"
      When I get the Escape plan field name "version"
      Then I should see "0.0.@" in the output

    Scenario: Get unknownEscape plan field
      Given a new Escape plan called "my-release"
      When I get the Escape plan field name "unknown field"
      Then I should see "Error: This field is currently unsupported by this command." in the output