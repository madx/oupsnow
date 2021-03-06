Feature: Deleting project
  To ensure a project can be delete by user authorized
  An admin user, or project admin or user
  Must or not delete a project

  Scenario:
    Given I have one admin user "shingara" with password "tintinpouet"
    And I have a project "yahoo"
    When logged with "shingara" with password "tintinpouet"
    And I go to /projects/1/settings
    Then I should see "Delete project"
    When I follow "Delete project"
    Then the request should be success
    And I should see "Delete"
    Given I press "Delete"
    Then I should see a notice message
    And I should see "Project yahoo is delete"
    And "Project" "name" "yahoo" doesn't exist


  Scenario:
    Given I have one user "shingara" with password "tintinpouet"
    And I have a project "yahoo"
    And "shingara" is project admin of "yahoo" project
    When logged with "shingara" with password "tintinpouet"
    And I follow "yahoo"
    And I follow "Settings"
    Then I should not see "Delete project"

  Scenario:
    Given I have one user "shingara" with password "tintinpouet"
    And I have a project "yahoo"
    When logged with "shingara" with password "tintinpouet"
    Then I follow "yahoo"
    And I should not see "Settings"
