Feature: An array

    Scenario: Append to an array
    Given an empty array
    When the number 1 is added to the array
    Then the array has 1 items

    Scenario: Filter an array
    Given an array with the numbers 1 through 5
    When the array is filtered for even numbers
    Then the array has 2 items
