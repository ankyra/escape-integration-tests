@wip
Feature: escape run promote

    Scenario: No extra args
      When I run "escape run promote unknown" which fails
      Then I should see "Error: Unknown command 'unknown" in the output

    Scenario: Prints help with flag
      When I run "escape run promote --help"
      Then I should see "Usage" in the output

    Scenario: Promoting a release to a new environment
      Given a new Escape plan called "my-app"
        And I build the application
        And I deploy
        And I release the application
      When I promote "_/my-app" to "new-env"
      Then I should see "Deployment _/my-app in environment dev has _/my-app-v0.0.0." in the output
        And I should see "Deployment _/my-app in environment new-env is not present." in the output
        And I should see "Promoting _/my-app-v0.0.0 from dev to new-env." in the output
        And I should see "Successfully deployed my-app-v0.0.0 with deployment name _/my-app in the new-env environment." in the output
        And "_/my-app" is present in "new-env" environment state

    Scenario: Promoting a package to a new environment with a new deployment
      Given a new Escape plan called "my-app"
        And I build the application
        And I deploy
        And I release the application
      When I promote "_/my-app" as "_/deployment" to "new-env"
      Then I should see "Deployment _/my-app in environment dev has _/my-app-v0.0.0." in the output
        And I should see "Deployment _/deployment in environment new-env is not present." in the output
        And I should see "Promoting _/my-app-v0.0.0 from dev to new-env." in the output
        And I should see "Successfully deployed my-app-v0.0.0 with deployment name _/deployment in the new-env environment." in the output
        And "_/deployment" is present in "new-env" environment state

    Scenario: No deployment name
      When I run "escape run promote -f --to new-env" which fails
      Then I should see "Error: Missing deployment name." in the output
      
    Scenario: Unknown deployment name
      When I run "escape run promote -f --deployment _/unknown --to new-env" which fails
      Then I should see "Error: Deployment _/unknown was not found in the environment dev." in the output

    Scenario: Deployment not deployed
      Given a new Escape plan called "not-deployed"
        And I build the application
      When I run "escape run promote -f --deployment _/not-deployed --to new-env" which fails
      Then I should see "Error: Deployment _/not-deployed has not been deployed in the environment dev." in the output

    Scenario: Errors when no --to environment flag
      Given a new Escape plan called "not-deployed"
        And I build the application
        And I deploy
        And I release the application
      When I run "escape run promote -f --deployment _/not-deployed" which fails
      Then I should see "Error: Missing target environment." in the output
        And I should see "Use '--to' to define your target environment." in the output