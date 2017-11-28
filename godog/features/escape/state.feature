Feature: escape state

    Scenario: No extra args
      When I run "escape state unknown" which fails
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

      Scenario: Creates state
        Given a new Escape plan called "release"
        When I run "escape state create"
        Then I should see "_/release" in the output
          And Escape state should exist
          And Escape state should have the deployment "_/release" in environment "dev"
          And the stage "build" is empty
          And the stage "deploy" is empty

      Scenario: Creates state and uses environment flag
        Given a new Escape plan called "release"
        When I run "escape state create --environment test"
        Then I should see "_/release" in the output
          And Escape state should exist
          And Escape state should have the deployment "_/release" in environment "test"
          And the stage "build" is empty
          And the stage "deploy" is empty

      Scenario: Creates state using different project name
        Given a new Escape plan called "test/release"
        When I run "escape state create"
        Then I should see "test/release" in the output
          And Escape state should exist
          And Escape state should have the deployment "test/release" in environment "dev"
          And the stage "build" is empty
          And the stage "deploy" is empty

      Scenario: Errors with no escape file
        When I run "escape state create" which fails
        Then I should see "Error: Escape plan 'escape.yml' was not found." in the output
          And I should see "Use 'escape plan init' to create it." in the output

  Scenario: escape state list-deployments

      Scenario: No extra args
        When I run "escape state list-deployments unknown" which fails
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape state list-deployments --help"
        Then I should see "Usage" in the output

      Scenario: Lists deployments
        Given a new Escape plan called "release"
          And I release the application
        Given a new Escape plan called "new/release"
          And I release the application
        When I run "escape state list-deployments"
        Then I should see "_/release" in the output
          And I should see "new/release" in the output

  Scenario: escape state show-deployment

      Scenario: No extra args
        When I run "escape state show-deployment unknown" which fails
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape state show-deployment --help"
        Then I should see "Usage" in the output

      Scenario: Shows deployment pending if not deployed
        Given a new Escape plan called "release"
          And I release the application
        When I run "escape state show-deployment" which fails
        Then I should see "_/release" in the output
          And I should see "pending" in the output

      Scenario: Shows deployment pending if deployed
        Given a new Escape plan called "release"
          And I release the application
          And I deploy
        When I run "escape state show-deployment" which fails
        Then I should see "_/release" in the output
          And I should see "ok" in the output

  Scenario: escape state show-providers

      Scenario: No extra args
        When I run "escape state show-providers unknown" which fails
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape state show-providers --help"
        Then I should see "Usage" in the output

      Scenario: Prints message when there are no providers
        When I run "escape state show-providers"
        Then I should see "No providers found in the environment state." in the output
          And I should see "Try deploying one." in the output

      Scenario: Shows providers
        Given a new Escape plan called "release"
          And it provides "test-provider"
          And it provides "test-provider-two"
          And I release the application
          When I deploy
        When I run "escape state show-providers"
        Then I should see "test-provider" in the output
          And I should see "test-provider-two" in the output