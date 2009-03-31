Feature: Users messages
  In order to talk with other users
  as a normal user
  wants to send or receive message

  Scenario: Send a message to other user
    Given I logged in as a normal user Jerry
    And I am on a page about user named Tom
    When I send a message
    Then I should see "Message was successfully created"
    And user Tom should received a message from Jerry

  Scenario: Delete messages from message list
    Given I logged in as a normal user Jerry
    And I am on my message list page
    And the following list messages:
      |title|body|sender|
      |title 1|body 1|tom|
      |title 2|body 2|aux|
      |title 3|body 3|feder|
    When I check the 2nd message
    And I press "Delete"
    Then I should see the message list:
      |title|
      |title 1|
      |title 3|

  Scenario: Mark unread messages as read
    Given I logged in as a normal user Jerry
    And the following list messages:
      |title|body|sender|status|
      |title1|body 1|tom|unread|
    When I am on my message list page
    And I check the 1st message
    And I press "Mark as read"
    Then I should not see "Mark as read"

  Scenario: Mark messages as delete
    Given I logged in as a normal user Jerry
    And the following list messages:
      |title|body|sender|status|
      |title 1|body 1|tom|open|
    When I am on my message list page
    And I check the 1st message
    And I press "Delete"
    Then I should not see "title 1"

  Scenario: Undelete messages
    Given I logged in as a normal user Jerry
    And the following list messages:
      |title|body|sender|status|
      |title 1|body 1|tom|suspend|
    When I am on my message list page
    And I follow "Trash"
    And I check the 1st message
    And I press "Move to inbox"
    Then I am on my message list page
    And I should see "title 1"

  Scenario: Reply a message from other user
    Given I logged in as a normal user Jerry
    And the following list messages:
      |title|body|sender|
      |title 1|body 1|tom|
    When I am on my message list page
    And I follow "Reply"
    And I fill in "Title" with "title 1"
    And I fill in "Body" with "body 1"
    And I press "Create"
    Then I should see "Message was successfully created"
