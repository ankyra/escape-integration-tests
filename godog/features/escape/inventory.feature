Feature: escape inventory

    Scenario: No extra args
      When I run "escape inventory unknown" which fails
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help
      When I run "escape inventory"
      Then I should see "Usage" in the output

    Scenario: Prints help with flag
      When I run "escape inventory --help"
      Then I should see "Usage" in the output

    Scenario: escape inventory query

      Scenario: No extra args
        When I run "escape inventory query unknown" which fails
        Then I should see "Error: Unknown command 'unknown" in the output

      Scenario: Prints help with flag
        When I run "escape inventory query --help"
        Then I should see "Usage" in the output

      Scenario: Query projects with no projects
        When I run "escape inventory query"
        Then I should see "Inventory returned 0 results" in the output

      Scenario: Query projects with two projects
        Given a new Escape plan called "_/release-one"
          And I release the application
          And I deploy
        Given a new Escape plan called "two/release-one"
          And I release the application
          And I deploy
        When I run "escape inventory query"
        Then I should see "_" in the output
          And I should see "two" in the output

      Scenario: Query applications with two applications
        Given a new Escape plan called "release-one"
          And I release the application
          And I deploy
        Given a new Escape plan called "release-two"
          And I release the application
          And I deploy
        When I run "escape inventory query -p _"
        Then I should see "release-one" in the output
          And I should see "release-two" in the output

      Scenario: Errors when query applications with wrong project
        Given a new Escape plan called "release-one"
          And I release the application
          And I deploy
        When I run "escape inventory query -p two" which fails
         And I should see "Couldn't list applications for project 'two', because the project 'two' could not be found in the Inventory at 'http://localhost:7777/'" in the output

      Scenario: Query versions with two versions
        Given a new Escape plan called "release-one"
          And I release the application
          And I deploy
          And I release the application
          And I deploy
        When I run "escape inventory query -p _ -a release-one"
        Then I should see "v0.0.0" in the output
          And I should see "v0.0.1" in the output

      Scenario: Errors when query versions with wrong application
        Given a new Escape plan called "release-one"
          And I release the application
          And I deploy
        When I run "escape inventory query -p _ -a release-two" which fails
         And I should see "Couldn't list versions for application 'release-two' in project '_', because the project '_' or application 'release-two' could not be found in the Inventory at 'http://localhost:7777/'" in the output

      Scenario: Query release with version
        Given a new Escape plan called "release-one"
          And I release the application
          And I deploy
          And I release the application
          And I deploy
        When I run "escape inventory query -p _ -a release-one -v 0.0.0"
        Then I should see "_" in the output
          And I should see "release-one" in the output
          And I should see "0.0.0" in the output

      
      Scenario: Errors when query release with wrong version
        Given a new Escape plan called "release-one"
          And I release the application
          And I deploy
        When I run "escape inventory query -p _ -a release-one -v 0.0.1" which fails
         And I should see "Couldn't get release metadata for 'release-one-v0.0.1', because the release metadata could not be found in the Inventory at 'http://localhost:7777/'. You probably need to release the 'release-one-v0.0.1' package first." in the output
