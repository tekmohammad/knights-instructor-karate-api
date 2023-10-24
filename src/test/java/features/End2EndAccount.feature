@Regression
Feature: End to end account creation

  Background: Setup Test get token
    Given url BASE_URL
    * def tokenResult = callonce read('GenerateToken.feature')
    * def token = "Bearer " + tokenResult.response.token

  @End2End
  Scenario: Create Account end to end.
    Given path "/api/accounts/add-primary-account"
    * def data = Java.type('data.DataGenerator')
    * def emailData = data.getEmail()
    And request
    """
    {
      "email": "#(emailData)",
      "title": "Mr.",
      "firstName": "John",
      "lastName": "Smith",
      "gender": "MALE",
      "maritalStatus": "DIVORCED",
      "employmentStatus": "Actor",
      "dateOfBirth": "1976-10-23"
    }
    """
    And header Authorization = token
    When method post
    Then status 201
    And assert response.email == emailData
    * def createdAccountId = response.id
    Given path "/api/accounts/add-account-address"
    And param primaryPersonId = createdAccountId
    And header Authorization = token
    And request
    """
    {
      "addressType": "12345 hollywood road",
      "addressLine1": "",
      "city": "Falls Church",
      "state": "Virginia",
      "postalCode": "22653",
      "countryCode": "",
      "current": true
    }
    """
    When method post
    Then status 201
    And assert response.postalCode == "22653"
    Given path "/api/accounts/add-account-car"
    And param primaryPersonId = createdAccountId
    And header Authorization = token
    And request
    """
    {
      "make": "Toyota",
      "model": "Camry",
      "year": "2023",
      "licensePlate": "ABC-1234"
    }
    """
    When method post
    Then status 201
    And assert response.make == "Toyota"
    Given path "/api/accounts/add-account-phone"
    And param primaryPersonId = createdAccountId
    And header Authorization = token
    And request
    """
    {
      "phoneNumber": "1234567890",
      "phoneExtension": "",
      "phoneTime": "Anytime",
      "phoneType": "Mobile"
    }
    """
    When method post
    Then status 201
    And assert response.phoneNumber == "1234567890"
    And print createdAccountId
    Given path "/api/accounts/delete-account"
    And param primaryPersonId = createdAccountId
    And header Authorization = token
    When method delete
    Then status 200
    And match response == {"status": true,"httpStatus": "OK","message": "Account Successfully deleted"}
