Feature: escape run deploy

    Scenario: Prints help with flag
      When I run "escape run deploy --help" which fails
      Then I should see "Usage" in the output