Feature: escape version

    Scenario: Get version
      When I run "escape version"
      Then I should see "Escape v" in the output

    Scenario: No extra args
      When I run "escape version unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help with flag
      When I run "escape version --help"
      Then I should see "Usage" in the output