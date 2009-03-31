Feature: User login and logout management
  In order to control user's access
  as a basic function

  Scenario: User input wrong number
    Given User Peter has role named admin
    And I am on login page
    When I fill in "Login" with "Peter"
    And I fill in "Password" with "wrong password"
    And I press "Login"
    Then I should see "Login failed"
