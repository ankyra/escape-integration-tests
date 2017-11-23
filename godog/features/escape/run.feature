Feature: escape run

    Scenario: No extra args
      When I run "escape run unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help
      When I run "escape run"
      Then I should see "Usage" in the output

    Scenario: Prints help with flag
      When I run "escape run --help"
      Then I should see "Usage" in the output