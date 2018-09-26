@provider-activation
Feature: Provider Activation and Deactivation
    Scenario: Build activates/deactivates providers
      Given a new Escape plan called "my-provider"
        And it provides "provider"
        And it has "echo AAactivate" as an inline provider activation script
        And it has "echo DDdeactivate" as an inline provider deactivation script
        And I release the application

       Given a new Escape plan called "output"
        And it consumes "provider"
        And it has "echo parent" as an inline build script

       When I build the application
       Then I should see "AAactivate" in the output
       Then I should see "parent" in the output
       Then I should see "DDdeactivate" in the output

    Scenario: Provider (de)activation scripts have access to deployment inputs and outputs
      Given a new Escape plan called "my-provider"
        And input variable "input_variable" with default "testinput"
         And output variable "output_variable" with default "testoutput"
        And it provides "provider"
        And it has "echo activate $INPUT_input_variable $OUTPUT_output_variable" as an inline provider activation script
        And it has "echo deactivate $INPUT_input_variable $OUTPUT_output_variable" as an inline provider deactivation script
        And I release the application
        And I deploy "_/my-provider-v0.0.0"

       Given a new Escape plan called "output"
        And it consumes "provider"
        And it has "echo parent" as an inline build script

       When I build the application
       Then I should see "activate testinput testoutput" in the output
       Then I should see "parent" in the output
       Then I should see "deactivate testinput testoutput" in the output

    Scenario: Provider (de)activation scripts are also called for a provider's providers
      Given a new Escape plan called "my-parent-provider"
        And it provides "parent-provider"
        And it has "echo activate-parent-provider" as an inline provider activation script
        And it has "echo deactivate-parent-provider" as an inline provider deactivation script
        And I release the application
        And I deploy "_/my-parent-provider-v0.0.0"

      Given a new Escape plan called "my-provider"
        And it consumes "parent-provider"
        And it provides "provider"
        And it has "echo activate-provider" as an inline provider activation script
        And it has "echo deactivate-provider" as an inline provider deactivation script
        And I release the application
        And I deploy "_/my-provider-v0.0.0"

       Given a new Escape plan called "output"
        And it consumes "provider"
        And it has "echo parent" as an inline build script

       When I build the application
       Then I should see "activate-parent-provider" in the output
       Then I should see "activate-provider" in the output
       Then I should see "parent" in the output
       Then I should see "deactivate-provider" in the output
       Then I should see "deactivate-parent-provider" in the output

    Scenario: Build activates/deactivates dependencies configured as providers for other dependencies
      Given a new Escape plan called "my-provider"
        And it provides "provider"
        And it has "echo AAactivate" as an inline provider activation script
        And it has "echo DDdeactivate" as an inline provider deactivation script
        And I release the application

      Given a new Escape plan called "my-consumer"
        And it consumes "provider"
        And I release the application

       Given a new Escape plan called "output"
        And it has "my-provider-latest as p1" as a dependency
        And it has "my-consumer-latest as c1" as a dependency mapping consumer "provider" to "$p1.deployment"
        And it has "echo parent" as an inline build script

       When I build the application
       Then I should see "AAactivate" in the output
       Then I should see "parent" in the output
       Then I should see "DDdeactivate" in the output

    Scenario: Provider activation scripts are also called for a provider's providers on deployment
      Given a new Escape plan called "gcp"
        And it provides "gcp"
        And it has "echo activate" as an inline provider activation script
        And I release the application
        And I deploy "gcp-latest"

      Given a new Escape plan called "kubernetes-gce"
        And it provides "kubernetes"
        And it consumes "gcp"
        And I release the application
        And I deploy "kubernetes-gce-latest"

      Given a new Escape plan called "kubespec-notification-service"
        And it consumes "kubernetes"
        And I release the application
        And I run "escape run deploy -d separate_for_clarity kubespec-notification-service-latest"
       Then I should see "activate" in the output

    Scenario: Provider deactivation scripts are also called for a provider's providers on deployment
      Given a new Escape plan called "gcp"
        And it provides "gcp"
        And it has "echo deactivate" as an inline provider deactivation script
        And I release the application
        And I deploy "gcp-latest"

      Given a new Escape plan called "kubernetes-gce"
        And it provides "kubernetes"
        And it consumes "gcp"
        And I release the application
        And I deploy "kubernetes-gce-latest"

      Given a new Escape plan called "kubespec-notification-service"
        And it consumes "kubernetes"
        And I release the application
        And I run "escape run deploy -d separate_for_clarity kubespec-notification-service-latest"
       Then I should see "deactivate" in the output

    Scenario: Provider activation scripts are not called (by default) if the consumer has been added to the parent because of a dependency
      Given a new Escape plan called "gcp"
        And it provides "gcp"
        And it has "echo activate >> /tmp/escape_integration_test_log.txt" as an inline provider activation script
        And it has "echo deactivate >> /tmp/escape_integration_test_log.txt" as an inline provider deactivation script
        And I release the application
        And I deploy "gcp-latest"

      Given a new Escape plan called "kubernetes-gce"
        And it provides "kubernetes"
        And it consumes "gcp"
        And I release the application
        And I deploy "kubernetes-gce-latest"

      Given a new Escape plan called "kubespec-notification-service"
        And it has "kubernetes-gce-latest" as a dependency
        And I release the application
        And I delete the file "/tmp/escape_integration_test_log.txt"
        And I run "escape run deploy -d separate_for_clarity kubespec-notification-service-latest"
       Then the file "/tmp/escape_integration_test_log.txt" is equal to "activate\ndeactivate\n"
