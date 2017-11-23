Feature: escape state

    Scenario: No extra args
      When I run "escape state unknown"
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help
      When I run "escape state"
      Then I should see "Usage" in the output

    Scenario: Prints help with flag
      When I run "escape state --help"
      Then I should see "Usage" in the output

  Scenario: escape state create

      Scenario: Prints help with flag
        When I run "escape state create --help"
        Then I should see "Usage" in the output

  Scenario: escape state list-deployments

      Scenario: No extra args
        When I run "escape state list-deployments unknown"
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape state list-deployments --help"
        Then I should see "Usage" in the output

  Scenario: escape state show-deployment

      Scenario: No extra args
        When I run "escape state show-deployment unknown"
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape state show-deployment --help"
        Then I should see "Usage" in the output

  Scenario: escape state show-providers

      Scenario: No extra args
        When I run "escape state show-providers unknown"
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape state show-providers --help"
        Then I should see "Usage" in the output