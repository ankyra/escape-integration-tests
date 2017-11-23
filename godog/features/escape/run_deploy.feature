Feature: escape run deploy

    Scenario: Prints help with flag
      When I run "escape deploy --help"
      Then I should see "Usage" in the output