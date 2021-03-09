Feature: Articles

    Background: Define base URL
        * def articleRequestBody = read("classpath:conduitApp/json/newArticleRequest.json")
        * def dataGenerator = Java.type("helpers.DataGenerator")
        * set articleRequestBody.article.title = dataGenerator.getRandomArticleTitle()
        * set articleRequestBody.article.description = dataGenerator.getRandomArticleDescription()
        * set articleRequestBody.article.body = dataGenerator.getRandomArticleBody()
        Given url url

    Scenario: Create a new article
        Given path '/articles'
        And request articleRequestBody
        When method Post
        Then status 200
        And match response.article.title == articleRequestBody.article.title
        And match response.article.description == articleRequestBody.article.description
        And match response.article.body == articleRequestBody.article.body

    Scenario: Create and delete article
        # Create a new article and get slug
        Given path '/articles'
        And request articleRequestBody
        When method Post
        Then status 200
        And match response.article.slug == '#string'
        * def articleSlug = response.article.slug

        # Get createad article
        Given path '/articles', articleSlug
        When method Get
        Then status 200
        And match response.article.title == articleRequestBody.article.title
        And match response.article.description == articleRequestBody.article.description
        And match response.article.body == articleRequestBody.article.body
        
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

        

