package data;

public class DataGenerator {

    public static String getEmail() {
        String email = "instructor_mohammad_";
        int random = (int) (Math.random() * 8921000);
        return email + random + "@tekschool.us";
    }
}
