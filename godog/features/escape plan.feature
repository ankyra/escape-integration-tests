Feature: Retrieving fields from the Escape plan
    As a Infrastructure engineer
    In order to validate my changes
    I need to be able to easily retrieve fields from the Escape plan

    Scenario: Get Escape plan name
      Given a new Escape plan called "my-release"
      When I get the Escape plan field name "name"
      Then I should see "my-release" in the output

    Scenario: Get Escape plan version
      Given a new Escape plan called "my-release"
      When I get the Escape plan field name "version"
      Then I should see "0.0.@" in the output

    @wip
    # BH - This scenario is blocked as the ProcessRecorder fails and I don't know enough about
    # the process recorder to change it.
    Scenario: Get unknownEscape plan field
      Given a new Escape plan called "my-release"
      When I get the Escape plan field name "unknown field"
      Then I should see "Error: This field is currently unsupported by this command." in the output