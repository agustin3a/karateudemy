Feature: Create Token

    Scenario: Get Token
        Given url url
        Given path '/users/login'
        And request { "user": { "email": "#(userEmail)", "password": "#(userPassword)"} }
        When method Post
        Then status 200
        And match response.user.token == '#string'
        * def token = response.user.token