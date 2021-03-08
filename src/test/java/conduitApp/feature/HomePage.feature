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
        Given path '/articles'
        Given params { limit : 10 , offset : 0 }
        When method Get
        Then status 200
        And match response.articles == '#[10]'
        And match response.articlesCount == 500
        
