Feature: escape help

    Scenario: Prints help
      When I run "escape help"
      Then I should see "Usage" in the output