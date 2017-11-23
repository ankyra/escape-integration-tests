Feature: escape config

    Scenario: No extra args
      When I run "escape config unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help
      When I run "escape config"
      Then I should see "Usage" in the output

    Scenario: Prints help with flag
      When I run "escape config --help"
      Then I should see "Usage" in the output

  Scenario: escape config active-profile

       Scenario: No extra args
        When I run "escape config active-profile unknown"
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape config active-profile --help"
        Then I should see "Usage" in the output

  Scenario: escape config create-profile

      Scenario: Prints help with flag
        When I run "escape config create-profile --help"
        Then I should see "Usage" in the output

  Scenario: escape config list-profiles

       Scenario: No extra args
        When I run "escape config list-profiles unknown"
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape config list-profiles --help"
        Then I should see "Usage" in the output

  Scenario: escape config profile

      Scenario: Prints help with flag
        When I run "escape config list-profiles --help"
        Then I should see "Usage" in the output

  Scenario: escape config set-profile

      Scenario: Prints help with flag
        When I run "escape config list-profiles --help"
        Then I should see "Usage" in the output