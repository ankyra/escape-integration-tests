Feature: escape run release

    Scenario: No extra args
      When I run "escape run release unknown" which fails
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help with flag
      When I run "escape run release --help"
      Then I should see "Usage" in the output