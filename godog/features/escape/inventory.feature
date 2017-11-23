Feature: escape inventory

    Scenario: No extra args
      When I run "escape inventory unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help
      When I run "escape inventory"
      Then I should see "Usage" in the output

    Scenario: Prints help with flag
      When I run "escape inventory --help"
      Then I should see "Usage" in the output

    Scenario: escape inventory query

      Scenario: No extra args
        When I run "escape inventory query unknown"
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape inventory query --help"
        Then I should see "Usage" in the output