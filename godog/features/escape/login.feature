Feature: escape login

    Scenario: No extra args
      When I run "escape login unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help with flag
      When I run "escape login --help"
      Then I should see "Usage" in the output