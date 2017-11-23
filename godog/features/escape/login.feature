Feature: escape login

    Scenario: No extra args
      When I run "escape login unknown"
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

    Scenario: Errors when given an invalid URL
      When I run "escape login --url http://l/o/c/a/l/host:7777"
      Then I should see "Error: Couldn't get auth methods from server 'http://l/o/c/a/l/host:7777'" in the output