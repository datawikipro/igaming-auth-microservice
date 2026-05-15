package pro.datawiki.igaming.auth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = {
        "pro.datawiki.auth.base",
        "pro.datawiki.igaming.auth"
})
public class IgamingAuthApplication {
    public static void main(String[] args) {
        SpringApplication.run(IgamingAuthApplication.class, args);
    }
}
