package stu.kms.WebSecurity.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;

@Slf4j
public class CustomNoOpPasswordEncoder implements PasswordEncoder {

    public String encode(CharSequence rawPassword) {
        log.warn("before password : " + rawPassword);
        return rawPassword.toString();
    }

    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        log.warn("matches : " + rawPassword + ":" + encodedPassword);
        return rawPassword.toString().equals(encodedPassword);
    }
}
