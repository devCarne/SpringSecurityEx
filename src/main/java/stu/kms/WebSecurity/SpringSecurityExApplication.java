package stu.kms.WebSecurity;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication
public class SpringSecurityExApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringSecurityExApplication.class, args);
    }

}
