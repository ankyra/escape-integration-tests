Feature: escape login

    Scenario: No extra args
      When I run "escape login unknown" which fails
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help
      When I run "escape login"
      Then I should see "Usage" in the output

    Scenario: Prints help with flag
      When I run "escape login --help"
      Then I should see "Usage" in the output

    Scenario: Logs in when given a Inventory URL
      When I run "escape login --url http://localhost:7777"
      Then I should see "Authentication not required" in the output
        And I should see "Successfully logged in to http://localhost:7777" in the output

    Scenario: Logs in and creates new profile using --target-profile
      When I run "escape login --url http://localhost:7777 --target-profile alt"
      Then I should see "Authentication not required" in the output
        And I should see "Successfully logged in to http://localhost:7777" in the output
        And "alt" is a profile in my config
        And "alt" is the active profile in my config

    Scenario: Errors when given an invalid URL which fails
      When I run "escape login --url http://localhost:77777" which fails
      Then I should see "Couldn't get authentication methods from server, because the Inventory at 'http://localhost:7777/' could not be reached: Get http://localhost:77777/api/v1/auth/login-methods:" in the output
