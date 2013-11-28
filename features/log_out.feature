Feature: Log out

  Scenario: Valid user logs in
    Given a User "matt"
    When I log in as "matt"
    Then I should see "Hello matt"
    When I log out
    Then I should see "Hello there!"
