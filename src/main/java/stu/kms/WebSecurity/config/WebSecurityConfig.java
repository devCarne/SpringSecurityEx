package stu.kms.WebSecurity.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import stu.kms.WebSecurity.security.CustomAccessDeniedHandler;
import stu.kms.WebSecurity.security.CustomLoginSuccessHandler;
import stu.kms.WebSecurity.security.CustomNoOpPasswordEncoder;

import javax.sql.DataSource;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private DataSource dataSource;

    @Bean
    public AccessDeniedHandler accessDeniedHandler() {
        return new CustomAccessDeniedHandler();
    }

    @Bean
    public AuthenticationSuccessHandler successHandler() {
        return new CustomLoginSuccessHandler();
    }

    @Bean
    public PasswordEncoder passwordEncoder () {
        return new CustomNoOpPasswordEncoder();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        String userQuery = "select username, password, enabled from users where username = ?";
        String authQuery = "select username, authority from authorities where username = ?";
        auth.jdbcAuthentication()
                .dataSource(dataSource)
                .usersByUsernameQuery(userQuery)
                .authoritiesByUsernameQuery(authQuery);

//        auth.inMemoryAuthentication()
//                .withUser("member").password(passwordEncoder().encode("member")).roles("MEMBER")
//                .and()
//                .withUser("admin").password(passwordEncoder().encode("admin")).roles("ADMIN", "MEMBER");
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
                .antMatchers("/sample/all/**").permitAll()
                .antMatchers("/sample/member/**").hasRole("MEMBER")
                .antMatchers("/sample/admin/**").hasRole("ADMIN");

        http.formLogin()
                .loginPage("/customLogin")
                .loginProcessingUrl("/login")
                .successHandler(successHandler());

        http.logout()
                .logoutUrl("/customLogout");

        http.exceptionHandling()
                .accessDeniedHandler(accessDeniedHandler());
    }
}
