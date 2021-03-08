Feature: Articles

    Background: Define base URL
        Given url url

    Scenario: Create a new article
        Given path '/articles'
        And request { "article": { "body": "Body test 2", "description": "Description test 2", "tagList": [], "title": "Title test 2" } }
        When method Post
        Then status 200
        And match response.article.title == "Title test 2"
        And match response.article.description == "Description test 2"
        And match response.article.body == "Body test 2"

    Scenario: Create and delete article
        # Create a new article and get slug
        Given path '/articles'
        And request { "article": { "body": "Deleted article x", "description": "Deleted article x", "tagList": [], "title": "Deleted article x" } }
        When method Post
        Then status 200
        And match response.article.slug == '#string'
        * def articleSlug = response.article.slug

        # Get createad article
        Given path '/articles', articleSlug
        When method Get
        Then status 200
        And match response.article.title == "Deleted article x"
        And match response.article.description == "Deleted article x"
        And match response.article.body == "Deleted article x"
        
        # Delete article
        Given path '/articles', articleSlug
        When method Delete
        Then status 200

        # Get createad article
        Given path '/articles', articleSlug
        When method Get
        Then status 404
        And match response.status == "404"
        And match response.error == "Not Found"

        

