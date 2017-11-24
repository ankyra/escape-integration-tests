Feature: escape errands

    Scenario: No extra args
      When I run "escape errands unknown" which fails
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help
      When I run "escape errands"
      Then I should see "Usage" in the output

    Scenario: Prints help with flag
      When I run "escape errands --help"
      Then I should see "Usage" in the output

  Scenario: escape errands list

       Scenario: No extra args
        When I run "escape errands list unknown" which fails
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help
        When I run "escape errands list"
        Then I should see "Usage" in the output
        
      Scenario: Prints help with flag
        When I run "escape errands list --help"
        Then I should see "Usage" in the output
      
      Scenario: Prints list of errands
        Given a new Escape plan called "errand-release"
          And errand "test-errand" with script "test.sh"
          And errand "second-errand" with script "test.sh" with description "2nd"
          And I release the application
          And I deploy "_/errand-release-v0.0.0"
        When I run "escape errands list --deployment _/errand-release"
        Then I should see "- test-errand" in the output
          And I should see "- second-errand" in the output
          And I should see "2nd" in the output

      Scenario: Prints list of local errands without needing to deploy
        Given a new Escape plan called "errand-release"
          And errand "test-errand" with script "test.sh"
          And errand "second-errand" with script "test.sh" with description "2nd"
        When I run "escape errands list --local"
        Then I should see "- test-errand" in the output
          And I should see "- second-errand" in the output
          And I should see "2nd" in the output

      Scenario: Error when deployment not found
        When I run "escape errands list --deployment _/errand-release" which fails
        Then I should see "Error: The deployment '_/errand-release' could not be found in environment 'dev'" in the output

      Scenario: Error when no escape plan when listing local errands
        When I run "escape errands list --local" which fails
        Then I should see "Error: Escape plan 'escape.yml' was not found. Use 'escape plan init' to create it" in the output

  Scenario: escape errands run

      Scenario: Prints help
        When I run "escape errands run"
        Then I should see "Usage" in the output

      Scenario: Prints help with flag
        When I run "escape errands run --help"
        Then I should see "Usage" in the output

      Scenario: Runs errand
        Given a new Escape plan called "errand-release"
          And errand "test-errand" with script "test.sh"
          And I release the application
          And I deploy "_/errand-release-v0.0.0"
        When I run "escape errands run test-errand --deployment _/errand-release"
        Then I should see "hello" in the output

      Scenario: Errors when errand is not found
        Given a new Escape plan called "errand-release"
          And I release the application  
          And I deploy "_/errand-release-v0.0.0"
        When I run "escape errands run test-errand --deployment _/errand-release" which fails
        Then I should see "Error: The errand 'test-errand' could not be found in deployment '_/errand-release'." in the output
          And I should see "You can use 'escape errands list' to see the available errands." in the output
        
      Scenario: Errors when deployment is not released or deployed
        When I run "escape errands run test-errand --deployment _/errand-release" which fails
        Then I should see "Error: The deployment '_/errand-release' could not be found in environment 'dev'." in the output

      Scenario: Errors when deployment is not deployed
        Given a new Escape plan called "errand-release"
          And I release the application  
        When I run "escape errands run test-errand --deployment _/errand-release" which fails
        Then I should see "Error: '_/errand-release' has not been deployed in the environment 'dev'." in the output

      Scenario: Errors without deployment
        Given a new Escape plan called "errand-release"
          And I release the application
          And I deploy "_/errand-release-v0.0.0"
        When I run "escape errands run test-errand" which fails
        Then I should see "Error: Missing deployment name" in the output

      Scenario: Runs local errand
        Given a new Escape plan called "errand-release"
          And errand "test-errand" with script "test.sh"
          And I deploy
        When I run "escape errands run test-errand --deployment _/errand-release --local"
        Then I should see "hello" in the output

      Scenario: Runs local errand without deployment flag
        Given a new Escape plan called "errand-release"
          And errand "test-errand" with script "test.sh"
          And I deploy
        When I run "escape errands run test-errand --local"
        Then I should see "hello" in the output

      Scenario: Errors when local errand is not found
        Given a new Escape plan called "errand-release"
          And I release the application   
          And I deploy "_/errand-release-v0.0.0"
        When I run "escape errands run test-errand --deployment _/errand-release --local" which fails
        Then I should see "Error: The errand 'test-errand' could not be found in deployment '_/errand-release'." in the output
          And I should see "You can use 'escape errands list' to see the available errands." in the output

      Scenario: Errors when deployment is not released or deployed
        Given a new Escape plan called "errand-release"
        When I run "escape errands run test-errand --deployment _/errand-release --local" which fails
        Then I should see "Error: The deployment '_/errand-release' could not be found in environment 'dev'." in the output

      Scenario: Errors when deployment is not deployed
        Given a new Escape plan called "errand-release"
          And I release the application  
        When I run "escape errands run test-errand --deployment _/errand-release --local" which fails
        Then I should see "Error: '_/errand-release' has not been deployed in the environment 'dev'." in the output
          And I should see "Use 'escape run deploy' to deploy it." in the output

      Scenario: Errors with no plan locally
        When I run "escape errands run test-errand --deployment _/errand-release --local" which fails
        Then I should see "Error: Escape plan 'escape.yml' was not found." in the output
          And I should see "Use 'escape plan init' to create it" in the output
