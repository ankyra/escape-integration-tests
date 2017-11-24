Feature: escape deps

    Scenario: No extra args
      When I run "escape deps unknown" which fails
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help
      When I run "escape deps"
      Then I should see "Usage" in the output

    Scenario: Prints help with flag
      When I run "escape deps --help"
      Then I should see "Usage" in the output

  Scenario: escape deps fetch

       Scenario: No extra args
        When I run "escape deps fetch unknown" which fails
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape deps fetch --help"
        Then I should see "Usage" in the output

      Scenario: Fetch deps
        Given a new Escape plan called "release-dep"
          And I release the application
        Given a new Escape plan called "release"
          And it has "release-dep-vlatest" as a dependency
        When I run "escape deps fetch"
        Then I should see "Dependencies have been fetched." in the output

      Scenario: Error when no escape plan
        When I run "escape deps fetch" which fails
        Then I should see "Error: Escape plan 'escape.yml' was not found." in the output
          And I should see "Use 'escape plan init' to create it" in the output