Feature: escape plan

    Scenario: No extra args
      When I run "escape plan unknown" which fails
      Then I should see "Error: Unknown command 'unknown'" in the output

    Scenario: Prints help
      When I run "escape plan"
      Then I should see "Usage" in the output
      
    Scenario: Prints help with flag
      When I run "escape plan --help"
      Then I should see "Usage" in the output

    Scenario: escape plan diff

      Scenario: No extra args
        When I run "escape plan diff unknown" which fails
        Then I should see "Error: Unknown command 'unknown'" in the output

      Scenario: Prints help with flag
        When I run "escape plan diff --help"
        Then I should see "Usage" in the output

    Scenario: escape plan fmt

      Scenario: No extra args
        When I run "escape plan fmt unknown" which fails
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
        When I run "escape plan get" which fails
        Then I should see "Error: Escape plan 'escape.yml' was not found. Use 'escape plan init' to create it" in the output

      Scenario: Prints help with flag
        When I run "escape plan get --help"
        Then I should see "Usage" in the output

      Scenario: Get unknown plan field name error
        Given a new Escape plan called "my-app"
        When I run "escape plan get unknown" which fails
        Then I should see "Error: This field is currently unsupported by this command." in the output

    Scenario: escape plan init

      Scenario: No extra args
        When I run "escape plan init unknown" which fails
        Then I should see "Error: Unknown command 'unknown'" in the output

      Scenario: Prints help with flag
        When I run "escape plan get --help"
        Then I should see "Usage" in the output

      Scenario: Creates escape plan
        When I run "escape plan init --name release"
        Then I should see "" in the output
          And an Escape plan should exist
          And the Escape plan should have the name "release"
          And the Escape plan should have the version "0.0.@"
          And the Escape plan should have the "README.md" file included

      Scenario: Creates escape plan supports project and package name
        When I run "escape plan init --name my/release"
        Then I should see "" in the output
          And an Escape plan should exist
          And the Escape plan should have the name "my/release"
                    
      Scenario: Errors if plan exists
        Given a new Escape plan called "release"
          When I run "escape plan init --name my/release" which fails
          Then I should see "Error: 'escape.yml' already exists." in the output
            And I should see "Use --force / -f to overwrite." in the output

      Scenario: Overwrites escape plan with --force
        Given a new Escape plan called "release"
        When I run "escape plan init --name my/release --force"
        Then I should see "" in the output
          And an Escape plan should exist
          And the Escape plan should have the name "my/release"

      Scenario: Creates escape plan at the --output
        When I run "escape plan init --name release --output escape2.yml"
        Then I should see "" in the output
          And an Escape plan should exist at "escape2.yml"

    Scenario: escape plan minify

      Scenario: No extra args
        When I run "escape plan minify unknown" which fails
        Then I should see "Error: Unknown command 'unknown'" in the output

      Scenario: Prints help with flag
        When I run "escape plan minify --help"
        Then I should see "Usage" in the output


    Scenario: escape plan preview

      Scenario: No extra args
        When I run "escape plan preview unknown" which fails
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
      When I run "escape plan get unknown field" which fails
      Then I should see "Error: This field is currently unsupported by this command." in the output