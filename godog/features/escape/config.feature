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

      Scenario: Gets the active profile
        When I run "escape config active-profile"
        Then I should see "default" in the output

      Scenario: Gets the active profile again
        Given I have the profile "alt" in my config
          And I set "alt" to be the active profile      
        When I run "escape config active-profile"
        Then I should see "alt" in the output

  Scenario: escape config create-profile

      Scenario: Prints help
        When I run "escape config create-profile"
        Then I should see "Usage" in the output      

      Scenario: Prints help with flag
        When I run "escape config create-profile --help"
        Then I should see "Usage" in the output

      Scenario: Creates new profile
        When I run "escape config create-profile alt"
        Then I should see "Profile 'alt' has been created." in the output
          And "alt" is a profile in my config

  Scenario: escape config list-profiles

       Scenario: No extra args
        When I run "escape config list-profiles unknown"
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape config list-profiles --help"
        Then I should see "Usage" in the output

      Scenario: Prints profiles
        Given I have the profile "alt" in my config`
        When I run "escape config list-profiles"
        Then I should see "default" in the output
          And I should see "alt" in the output

  Scenario: escape config profile

      Scenario: Prints help with flag
        When I run "escape config profile --help"
        Then I should see "Usage" in the output

      Scenario: Prints active profile
        When I run "escape config profile"
        Then I should see "Profile: default" in the output
          And I should see "escape_auth_token:" in the output
          And I should see "insecure_skip_verify: false" in the output
          And I should see "api_server: http://localhost:7777" in the output

      Scenario: Prints active profile's escape_auth_token config
        When I run "escape config profile escape_auth_token"
        Then I should see "escape_auth_token:" in the output

      Scenario: Prints active profile's insecure_skip_verify config
        When I run "escape config profile insecure_skip_verify"
        Then I should see "insecure_skip_verify: false" in the output

      Scenario: Prints active profile's api_server config
        When I run "escape config profile api_server"
        Then I should see "api_server: http://localhost:7777" in the output

      Scenario: Errors on unknown config config
        When I run "escape config profile unknown"
        Then I should see "Error: 'unknown' is not a valid field name" in the output

  Scenario: escape config set-profile

      Scenario: Prints help
        When I run "escape config set-profile"
        Then I should see "Usage" in the output

      Scenario: Prints help with flag
        When I run "escape config set-profile --help"
        Then I should see "Usage" in the output

      Scenario: Sets the default
        Given I have the profile "alt" in my config
        When I run "escape config set-profile alt"
        Then I should see "Profile has been set" in the output
          And "alt" is the active profile in my config

      Scenario: Errors if the profile does not exist
        When I run "escape config set-profile alt"
        Then I should see "Error: Referenced profile 'alt' was not found in the Escape configuration file." in the output
          And "default" is the active profile in my config