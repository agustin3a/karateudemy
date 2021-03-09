Feature: Tests for the home page

    Background: Define base URL
        Given url url
        
    Scenario: Get all tags
        Given path '/tags'
        When method Get
        Then status 200
        And match response.tags == '#[]'
        And match each response.tags == '#string'
        And match response.tags contains 'test'

    Scenario: Get 10 articles from the page
        * def timeValidator = read("classpath:helpers/timeValidator.js")
        Given path '/articles'
        Given params { limit : 10 , offset : 0 }
        When method Get
        Then status 200
        And match response.articles == '#[10]'
        And match response.articlesCount == 500
        And match each response.articles ==
        """
            {
                "title": "#string",
                "slug": "#string",
                "body": "#string",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "tagList": "#array",
                "description": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                },
                "favorited": "#boolean",
                "favoritesCount": "#number"
            }
        """
        
