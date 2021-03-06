Feature: Manage campaigns
  In order to track the progress of company goals
  As a user
  I want to manage campaigns

  Scenario: Creating a campaign
    Given I am registered and logged in as Matt
    And I am on the campaigns page
    When I follow "+Add Campaign"
    Then I should see "Add Campaign"

    When I fill in "Name" with "Generate 100 leads this month"
    And I fill in "Start date" with "1/12/2010"
    And I fill in "End date" with "31/12/2010"
    And I press "Save Campaign"

    Then I should be on the campaigns page
    And I should see "Campaign was successfully created"
    And I should not see "Objectives"

  Scenario: Setting campaign objectives
    Given I am registered and logged in as Matt
    And I am on the new campaign page

    When I fill in "Name" with "Generate leads"
    And I fill in "Number of leads" with "10"
    And I fill in "Conversion (%)" with "10"
    And I press "Save Campaign"
    And I follow "Generate leads"
    Then I should see "Objectives"
    And I should see "Leads 10 0"
    And I should see "Conversions 1 0"

    When I follow "Edit"
    And I fill in "Name" with "Lead lead leads leads"
    And I fill in "Number of leads" with ""
    And I press "Save Campaign"
    And I should see "can't be blank"

    When I fill in "Number of leads" with "5"
    And I fill in "Conversion (%)" with ""
    And I press "Save Campaign"
    Then I should see "Leads 5 0"
    And I should see "Conversions N/A 0"

  Scenario: Viewing campaign with objectives
    Given I am registered and logged in as Matt
    And a campaign: "generate_leads" exists
    And a lead: "erich" exists with campaign: generate_leads, status: "Converted"

    When I go to the campaign's page
    Then I should see "Leads 100 1"
    And I should see "Conversions 5 1"

  Scenario: Viewing list of campaigns with objectives
    Given I am registered and logged in as Matt
    And a campaign: "generate_leads" exists
    And a lead: "erich" exists with campaign: generate_leads, status: "Converted"

    When I go to the campaigns page
    Then I should see "Leads: 1/100"
    And I should see "Conversions: 1/5"

  Scenario: Viewing list of campaigns
    Given I am registered and logged in as Matt
    And a campaign exists with name: "Generate 100 leads this month", start_date: "1/12/2010", end_date: "31/12/2010"

    When I follow "Campaigns" within "#navigation"
    Then I should see "Generate 100 leads this month"
    And I should see "1. Dec - 31. Dec"

  Scenario: Viewing a campaign
    Given I am registered and logged in as Matt
    And a campaign exists with name: "Generate 100 leads this month", start_date: "1/12/2010", end_date: "31/12/2010"
    And I am on the campaigns page

    When I follow "Generate 100 leads this month"
    Then I should see "Generate 100 leads this month"
    And I should see "1. Dec - 31. Dec"

  Scenario: Viewing a campaign with leads
    Given I am registered and logged in as Matt
    And a campaign: "generate_leads" exists
    And a lead: "erich" exists with campaign: generate_leads

    When I go to that campaign's page
    Then I should see "Leads"
    And I should see "Erich Feldmeier"

  Scenario: Creating a lead from the campaign
    Given I am registered and logged in as Matt
    And a campaign: "generate_leads" exists
    And I am on that campaign's page

    When I follow "Add Lead"
    Then I should be on the new lead page

    When I fill in "First Name" with "Erich"
    And I fill in "Last Name" with "Feldmeier"
    And I press "Create Lead"
    Then I should be on the campaign page
    And I should see "Erich Feldmeier"

  Scenario: Deleting a campaign
    Given I am registered and logged in as Matt
    And the campaign exists with name: "Generate 100 leads this month", start_date: "1/12/2010", end_date: "31/12/2010", user: Matt
    And I am on that campaign's page

    When I press "Delete"
    Then I should be on the campaigns page
    And I should not see "Generate 100 leads this month" within "#main"

    When I go to the deleted items page
    Then I should see "Generate 100 leads this month" within "#main"

    When I press "restore"
    Then I should not see "Generate 100 leads this month" within "#main"

    When I go to the campaigns page
    Then I should see "Generate 100 leads this month" within "#main"

  Scenario: Editing a campaign
    Given I am registered and logged in as Matt
    And the campaign exists with name: "Generate 100 leads this month", start_date: "1/12/2010", end_date: "31/12/2010"
    And I am on that campaign's page

    When I follow "Edit"
    Then I should be on that campaign's edit page
    Then I should see "Edit Campaign"

    When I fill in "Name" with "Generate 20 leads next week"
    And I fill in "Start date" with "8/12/2010"
    And I fill in "End date" with "15/12/2010"
    And I follow "Save Campaign"
    Then I should be on that campaign's page
    And I should see "Campaign was successfully updated"
    And I should see "Generate 20 leads next week"
    And I should see "8. Dec - 15. Dec"

  Scenario: Viewing campaign creation event
    Given I am registered and logged in as Matt
    And a campaign exists with name: "Generate 100 leads this month", start_date: "1/12/2010", end_date: "31/12/2010", user: Matt

    When I go to the campaign's page
    Then I should see "Campaign Created by matt"

  Scenario: Viewing campaign update event
    Given I am registered and logged in as Matt
    And a campaign exists with name: "Generate 100 leads this month", start_date: "1/12/2010", end_date: "31/12/2010", user: Matt
    And I go to the campaign's edit page
    And I fill in "Start date" with "2/12/2010"

    When I press "Save Campaign"
    Then I should see "Campaign Updated by matt"

    When I go to the home page
    Then I should see "matt.beedle@1000jobboersen.de updated campaign Generate 100 leads this month"

  Scenario: Viewing campaign view events
    Given I am registered and logged in as Matt
    And a campaign exists with name: "Generate 100 leads this month", start_date: "1/12/2010", end_date: "31/12/2010", user: Matt
    And I go to the campaign's page

    When I refresh the page
    Then I should see "Campaign Viewed by matt"

  Scenario: Creating a comment for a campaign
    Given I am registered and logged in as Matt
    And a campaign exists with name: "Generate 100 leads this month", start_date: "1/12/2010", end_date: "31/12/2010", user: Matt

    When I go to the campaign page
    Then I should see "Comments"

    When I fill in "Add Comment" with "Good progress!"
    And I press "Save Comment"
    Then I should be on the campaign page
    And I should see "Good progress!"

  Scenario: Creating a task for a campaign
    Given I am registered and logged in as Matt
    And a campaign exists with name: "Generate 100 leads this month", start_date: "1/12/2010", end_date: "31/12/2010", user: Matt
    And I am on the campaign page

    When I follow "Add Task"
    And I fill in "Subject" with "Follow up on lead 3"
    And I select "Call" from "Category"
    And I press "Create Task"
    Then I should be on the campaign page
    And I should see "Tasks"
    And I should see "Follow up on lead 3"
