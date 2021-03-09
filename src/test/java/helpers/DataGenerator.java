package helpers;

import com.github.javafaker.Faker;

public class  DataGenerator {

    public static String getRandomEmail() {
        Faker faker = new Faker();
        String email = faker.name().firstName().toLowerCase() + faker.random().nextInt(0,100) + "@tgs3a.com";
        return email;
    }

    public static String getRandomUsername() {
        Faker faker = new Faker();
        String username = faker.name().username() + "3a";
        return username;
    }

    public static String getRandomArticleTitle() {
        Faker faker = new Faker();
        String title = faker.gameOfThrones().house();
        return title;
    }

    public static String getRandomArticleDescription() {
        Faker faker = new Faker();
        String description = faker.gameOfThrones().character();
        return description;
    }

    public static String getRandomArticleBody() {
        Faker faker = new Faker();
        String body = faker.gameOfThrones().quote();
        return body;
    }

}