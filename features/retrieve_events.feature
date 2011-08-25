Feature: Get lists of events
  In order to know where to get punters
  As a taxi driver
  I want to be able to retrieve lists of events and when they finish

  Scenario: Get nearby events
    Given I send and accept XML
    And I have imported 3 events near the Soho Theatre
    And I have imported 1 event more than 5 kilometres away from the Soho Theatre
    When I send a GET request for "/events/nearby?latitude=51.51442&longitude=-0.13298&distance=5"
    Then the response should be an array with 3 "event" elements

  Scenario: Get nearly finished events
    Given I send and accept XML
    And I have imported 3 events near the Soho Theatre that finish in 5 minutes
    And I have imported 2 events near the Soho Theatre that finish in 30 minutes
    When I send a GET request for "/events/nearby?latitude=51.51442&longitude=-0.13298&distance=5&time_limit=10"
    Then the response should be an array with 3 "event" elements
