@parallel=false
Feature: Articles

    Background: Define base URL
        * def articleRequestBody = read("classpath:conduitApp/json/newArticleRequest.json")
        * def dataGenerator = Java.type("helpers.DataGenerator")
        #* set articleRequestBody.article.title = dataGenerator.getRandomArticleTitle()
        * set articleRequestBody.article.title = __gatling.Title
        #* set articleRequestBody.article.description = dataGenerator.getRandomArticleDescription()
        * set articleRequestBody.article.description = __gatling.Description
        * set articleRequestBody.article.body = dataGenerator.getRandomArticleBody()
        Given url url
        * def sleep = function(ms){ java.lang.Thread.sleep(ms) }
        # or function(ms){ } for a no-op !
        * def pause = karate.get('__gatling.pause', sleep)

    Scenario: Create and delete article
        # Create a new article and get slug
        Given path '/articles'
        And request articleRequestBody
        When method Post
        Then status 200
        And match response.article.slug == '#string'
        * def articleSlug = response.article.slug

        # Think time
        * pause(5000)

        # Delete article
        Given path '/articles', articleSlug
        When method Delete
        Then status 200
        

