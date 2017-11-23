Feature: escape deps

    Scenario: No extra args
      When I run "escape deps unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help
      When I run "escape deps"
      Then I should see "Usage" in the output

    Scenario: Prints help with flag
      When I run "escape deps --help"
      Then I should see "Usage" in the output

  Scenario: escape deps fetch

       Scenario: No extra args
        When I run "escape deps fetch unknown"
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape deps fetch --help"
        Then I should see "Usage" in the output