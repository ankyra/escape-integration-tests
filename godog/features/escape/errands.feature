Feature: escape errands

    Scenario: No extra args
      When I run "escape errands unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help
      When I run "escape errands"
      Then I should see "Usage" in the output

    Scenario: Prints help with flag
      When I run "escape errands --help"
      Then I should see "Usage" in the output

  Scenario: escape errands list

       Scenario: No extra args
        When I run "escape errands list unknown"
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape errands list --help"
        Then I should see "Usage" in the output

  Scenario: escape errands run

      Scenario: Prints help with flag
        When I run "escape errands run --help"
        Then I should see "Usage" in the output