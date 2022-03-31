package stu.kms.WebSecurity.config;

import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;
import stu.kms.WebSecurity.security.CustomAccessDeniedHandler;
import stu.kms.WebSecurity.security.CustomLoginSuccessHandler;
import stu.kms.WebSecurity.security.CustomUserDetailsService;

import javax.sql.DataSource;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true, securedEnabled = true)//@Pre,PostAuthorize 활성화
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private UserDetailsService customUserDetailsService;

    @Bean
    public AccessDeniedHandler accessDeniedHandler() {
        return new CustomAccessDeniedHandler();
    }

//    @Bean
//    public AuthenticationSuccessHandler successHandler() {
//        return new CustomLoginSuccessHandler();
//    }

    @Bean
    public PasswordEncoder passwordEncoder () {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public PersistentTokenRepository tokenRepository() {
        JdbcTokenRepositoryImpl jdbcTokenRepository = new JdbcTokenRepositoryImpl();
        jdbcTokenRepository.setDataSource(dataSource);
        return jdbcTokenRepository;
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(customUserDetailsService);
//        String userQuery = "select userid, userpw, enabled from tbl_member where userid = ?";
//        String authQuery = "select userid, auth from tbl_member_auth where userid = ?";
//        auth.jdbcAuthentication()
//                .dataSource(dataSource)
//                .usersByUsernameQuery(userQuery)
//                .authoritiesByUsernameQuery(authQuery);

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
                .loginProcessingUrl("/login");
//                .successHandler(successHandler());

        http.logout()
                .logoutUrl("/customLogout")
                .deleteCookies("remember-me", "JSESSIONID");

        http.exceptionHandling()
                .accessDeniedHandler(accessDeniedHandler());

        http.rememberMe()
                .tokenRepository(tokenRepository())
                .tokenValiditySeconds(604800);
    }
}
