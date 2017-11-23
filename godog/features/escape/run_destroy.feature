Feature: escape run destroy

    Scenario: No extra args
      When I run "escape run destroy unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help with flag
      When I run "escape destroy --help"
      Then I should see "Usage" in the output