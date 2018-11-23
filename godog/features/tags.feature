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
