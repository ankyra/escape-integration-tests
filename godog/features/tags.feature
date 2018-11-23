Feature: Release tags
  As a delivery person
  In order to get fine-grained control over when releases are ready
  I need to be able to tag releases

  Scenario: I can tag a release and then query by that tag
      Given a new Escape plan called "my-tagged-release"
        And I release the application
        And I run "escape tag my-tagged-release-latest my-tag"
        And I run "escape inventory query -p _ -a my-tagged-release -v my-tag"
       Then I should see "my-tagged-release" in the output

  Scenario: I can tag a release and then use it as a dependency
      Given a new Escape plan called "my-tagged-release"
        And I release the application
        And I run "escape tag my-tagged-release-latest my-tag"

        And a new Escape plan called "my-parent"
        And it has "my-tagged-release:my-tag" as a dependency 
        And I release the application
        And I run "escape inventory query -p _ -a my-parent -v latest"
       Then I should see "my-tagged-release-v0.0.0" in the output

  Scenario: I can tag a release and deploy on tag
      Given a new Escape plan called "my-tagged-release"
        And I release the application
        And I run "escape tag my-tagged-release-latest my-tag"

        And I run "escape run deploy my-tagged-release:my-tag"
        And "_/my-tagged-release" version "0.0.0" is present in the deploy state

        And I release the application
        And I run "escape run deploy my-tagged-release:my-tag"
        And "_/my-tagged-release" version "0.0.0" is present in the deploy state

        And I run "escape tag my-tagged-release-latest my-tag"
        And I run "escape run deploy my-tagged-release:my-tag"
        And "_/my-tagged-release" version "0.0.1" is present in the deploy state

  Scenario: I can tag a release and use it as an extension
      Given a new Escape plan called "my-tagged-release"
        And I release the application
        And I run "escape tag my-tagged-release-latest my-tag"

        And a new Escape plan called "my-parent"
        And it has "my-tagged-release:my-tag" as an extension
        And I release the application
        And I run "escape inventory query -p _ -a my-parent -v latest"
       Then I should see "my-tagged-release-v0.0.0" in the output
