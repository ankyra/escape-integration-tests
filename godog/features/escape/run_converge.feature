Feature: escape run converge

    Scenario: No extra args
      When I run "escape run converge unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help with flag
      When I run "escape converge --help"
      Then I should see "Usage" in the output