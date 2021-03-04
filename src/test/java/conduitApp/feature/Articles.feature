@ignore
Feature: Articles

    Background: Define base URL
        Given url 'https://conduit.productionready.io/api' 
        Given path '/users/login'
        And request { "user": { "email": "testag3a@test.com", "password": "karate123"} }
        When method Post
        Then status 200
        And match response.user.token == '#string'
        * def token = response.user.token

    Scenario: Create a new article
        Given header Authorization = 'Token ' + token
        Given path '/articles'
        And request { "article": { "body": "Body test 2", "description": "Description test 2", "tagList": [], "title": "Title test 2" } }
        When method Post
        Then status 200
        And match response.article.title == "Title test 2"
        And match response.article.description == "Description test 2"
        And match response.article.body == "Body test 2"

