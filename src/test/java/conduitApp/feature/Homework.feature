@parallel=false
Feature: Home Work

    Background: Preconditions
        * url url 
        * def timeValidator = read("classpath:helpers/timeValidator.js")

    Scenario: Favorite articles
        # Step 1: Get atricles of the global feed
        Given path '/articles'
        And params { limit : 10 , offset : 0 }
        When method Get
        Then status 200
        And match response.articles == '#[10]'
        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        * def firstArticle = response.articles[0]
        * def articleSlug = firstArticle.slug
        * def articleFavoritesCount = firstArticle.favoritesCount
        * def articleFavorited = firstArticle.favorited
        # Step 3: Make POST request to increse favorites count for the first article
        Given path "/articles/",articleSlug,"/favorite"
        And request {}
        When method Post
        Then status 200
        # Step 4: Verify response schema
        And match response ==
        """
            {
                article: {
                    author: { 
                        username: "#string", 
                        bio: "##string", 
                        image: "#string",
                        following: "#boolean"
                    },
                    body: "#string",
                    createdAt: "#? timeValidator(_)",
                    description: "#string",
                    favorited: "#boolean",
                    favoritesCount: "#number",
                    slug: "#string",
                    tagList: "#array",
                    title: "#string",
                    updatedAt: "#? timeValidator(_)"
                }
            }
        """ 
        # Step 5: Verify that favorites article incremented by 1
        * def updatedArticlesfavoritesCount = response.article.favoritesCount
        * def addUpFavorite = articleFavorited ? 0 : 1
        * def expectedFavoritesCount = articleFavoritesCount + addUpFavorite
        * match expectedFavoritesCount == updatedArticlesfavoritesCount
        # Step 6: Get all favorite articles
        Given path '/articles'
        And params { limit : 10 , offset : 0, favorited: "ags3a"}
        When method Get
        Then status 200
        # Step 7: Verify response schema
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
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        And match response.articles[*].slug contains articleSlug
        
    Scenario: Comment articles
        * def dataGenerator = Java.type("helpers.DataGenerator")
        * def randomComment = dataGenerator.getRandomArticleBody()
        # Step 1: Get atricles of the global feed
        Given path '/articles'
        And params { limit : 10 , offset : 0 }
        When method Get
        Then status 200
        And match response.articles == '#[10]'
        # Step 2: Get the slug ID for the first arice, save it to variable
        * def firstArticle = response.articles[0]
        * def articleSlug = firstArticle.slug
        # Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path "/articles/",articleSlug,"/comments"
        When method Get
        Then status 200
        # Step 4: Verify response schema
        # Step 5: Get the count of the comments array lentgh and save to variable
        * def initialCommentsCount = response.comments.length
        # Step 6: Make a POST request to publish a new comment
        Given path "/articles/",articleSlug,"/comments"
        And request { comment : { body : "#(randomComment)" } } 
        When method Post
        Then status 200
        # Step 7: Verify response schema that should contain posted comment text
        And match response ==
        """
            {
                comment: {
                    author: { 
                        username: "#string", 
                        bio: "##string", 
                        image: "#string",
                        following: "#boolean"
                    },
                    body: "#(randomComment)",
                    createdAt: "#? timeValidator(_)",
                    id: "#number",
                    updatedAt: "#? timeValidator(_)"
                }
            }
        """ 
        * def commentId = response.comment.id
        # Step 8: Get the list of all comments for this article one more time
        Given path "/articles/",articleSlug,"/comments"
        When method Get
        Then status 200
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        * def createCommentsCount = response.comments.length
        And match createCommentsCount == initialCommentsCount + 1
        # Step 10: Make a DELETE request to delete comment
        Given path "/articles/",articleSlug,"/comments/",commentId
        When method Delete
        Then status 200
        # Step 11: Get all comments again and verify number of comments decreased by 1
        Given path "/articles/",articleSlug,"/comments"
        When method Get
        Then status 200
        * def deleteCommentsCount = response.comments.length
        And match deleteCommentsCount == initialCommentsCount

