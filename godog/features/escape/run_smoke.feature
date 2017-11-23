Feature: escape run smoke

    Scenario: No extra args
      When I run "escape run smoke unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help with flag
      When I run "escape smoke --help"
      Then I should see "Usage" in the output