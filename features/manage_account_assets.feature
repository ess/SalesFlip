Feature: Manage contacts on the account's show page
  In order to keep track of the account's contacts
  A User
  wants to manage each contact along with its tasks and comments

  Scenario: Viewing comments for a contact
    Given I am registered and logged in as annika
    And Annika has invited user: "benny"
    And account: "careermee" exists with user: benny
    And a contact: "florian" exists with user: benny, account: the account
    And a comment exists with text: "CareerMee is cool", user: benny, commentable: the contact
    And I am on the account's page
    Then I should see "CareerMee is cool" within "#main"

  Scenario: Viewing tasks for a contact
    Given I am registered and logged in as annika
    And Annika has invited Benny
    And account: "careermee" exists with user: benny
    And a contact: "florian" exists with user: benny, account: the account
    And a task exists with name: "Follow up and close the deal", user: Annika, asset: the contact
    And I am on the account's page
    Then I should see "Follow up and close the deal" within "#main"
