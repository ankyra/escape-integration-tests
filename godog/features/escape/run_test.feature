Feature: escape run test

    Scenario: No extra args
      When I run "escape run test unknown" which fails
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help with flag
      When I run "escape run test --help"
      Then I should see "Usage" in the output