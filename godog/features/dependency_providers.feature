@builds
Feature: Dependencies and Providers
    Scenario: If a dependency needs a provider
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency 
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: If a parent and dependency both need the same provider
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency 
        And it consumes "provider" in the "build" scope
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: Specify dependency consumers
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency mapping consumer "provider" to "_/my-provider4"
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: Map parent consumers to dependency consumers
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency mapping consumer "provider" to "$provider.deployment"
        And it consumes "provider" in the "build" scope
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: Map renamed parent consumers to dependency consumers
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency mapping consumer "provider" to "$p1.deployment"
        And it consumes "provider as p1" in the "build" scope
        And it consumes "provider as p2" in the "build" scope
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: Map renamed parent consumers to dependency consumers [part 2]
      Given a new Escape plan called "my-provider4"
        And it provides "provider"
        And I release the application
       When I deploy "_/my-provider4-v0.0.0"
       Then "_/my-provider4" version "0.0.0" is present in the deploy state

      Given a new Escape plan called "my-dep-consumer"
        And it consumes "provider" in the "deploy" scope
        And I release the application

      Given a new Escape plan called "parent-of-dep-consumer"
        And it has "my-dep-consumer-latest" as a dependency mapping consumer "provider" to "$p2.deployment"
        And it consumes "provider as p1" in the "build" scope
        And it consumes "provider as p2" 
       When I build the application
       Then "_/parent-of-dep-consumer" version "0.0.0" is present in the build state

    Scenario: Use one dependency as a provider for another dependency
      Given a new Escape plan called "my-provider"
        And it provides "provider"
        And I release the application

      Given a new Escape plan called "my-consumer"
        And it consumes "provider"
        And I release the application
        And I remove the state

      Given a new Escape plan called "parent-release"
        And it has "my-provider-latest as my-provider" as a dependency
        And it has "my-consumer-latest" as a dependency mapping consumer "provider" to "$my-provider.deployment"
       When I build the application
       Then "_/parent-release" version "0.0.0" is present in the build state

    Scenario: Use one dependency as a provider for another dependency during deployment
      Given a new Escape plan called "my-provider"
        And it provides "provider"
        And I release the application

      Given a new Escape plan called "my-consumer"
        And it consumes "provider"
        And I release the application
        And I remove the state

      Given a new Escape plan called "parent-release"
        And it has "my-provider-latest as my-provider" as a dependency
        And it has "my-consumer-latest as my-consumer" as a dependency mapping consumer "provider" to "$my-provider.deployment"
        And I release the application
       Then subdeployment "_/parent-release:my-consumer" has provider "provider" set to "_/parent-release:my-provider"
      Given I run "escape run deploy -d renamed2 parent-release-latest"
       Then subdeployment "renamed2:my-consumer" has provider "provider" set to "renamed2:my-provider"

    Scenario: Use the same dependency twice for two other dependencies
      Given a new Escape plan called "my-provider"
        And it provides "provider"
        And I release the application

      Given a new Escape plan called "my-consumer"
        And it consumes "provider"
        And I release the application
        And I remove the state

      Given a new Escape plan called "parent-release"
        And it has "my-provider-latest as p1" as a dependency
        And it has "my-provider-latest as p2" as a dependency
        And it has "my-consumer-latest as c1" as a dependency mapping consumer "provider" to "$p1.deployment"
        And it has "my-consumer-latest as c2" as a dependency mapping consumer "provider" to "$p2.deployment"
       When I build the application
       Then "_/parent-release" version "0.0.0" is present in the build state
        And "_/parent-release:p1" is the provider for "provider" in "_/parent-release:c1"
        And "_/parent-release:p2" is the provider for "provider" in "_/parent-release:c2"

