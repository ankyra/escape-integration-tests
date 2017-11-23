Feature: escape run package

    Scenario: No extra args
      When I run "escape run package unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help with flag
      When I run "escape package --help"
      Then I should see "Usage" in the output