Feature: User upload version text file to google disk
  Scenario: User is able to upload to google disk
    Given user create file with ruby version
    When user send file to google storage
    Then check file with selenium