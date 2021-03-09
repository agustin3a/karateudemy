Feature: Sign up new user

    Background:
        * def dataGenerator = Java.type("helpers.DataGenerator")
        * def randomEmail = dataGenerator.getRandomEmail();
        * def randomUsername = dataGenerator.getRandomUsername();
        Given url url

    Scenario: Sign up user
        * def timeValidator = read("classpath:helpers/timeValidator.js")
        Given path '/users'
        And request
        """
            {"user": { 
                "email":"#(randomEmail)",
                "password":"karate123",
                "username":"#(randomUsername)"
            }}
        """ 
        When method Post
        Then status 200
        And match response ==
        """
            { 
                "user": { 
                        "id": "#number",
                        "email": "#(randomEmail)",
                        "createdAt": "#? timeValidator(_)",
                        "updatedAt": "#? timeValidator(_)",
                        "username": "#(randomUsername)",
                        "bio": "##string",
                        "image": "##string",
                        "token": "#string"
                    }
            }
        """

    Scenario Outline: Validate Sign Up error messages
        Given path '/users'
        And request
        """
            {"user": { 
                "email":"<email>",
                "password":"<password>",
                "username":"<username>"
            }}
        """ 
        When method Post
        Then status 422
        And match response == <errorResponse>

        Examples:
        | email               | password      | username              | errorResponse
        | #(randomEmail)      | karate123     |  britta.walkertgs3a   | {"errors":{"username":["has already been taken"]}}
        | testag3ax@test.com  | karate123     | #(randomUsername)     | {"errors":{"email":["has already been taken"]}}
