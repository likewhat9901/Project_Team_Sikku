package com.edu.springboot.auth;

import jakarta.servlet.DispatcherType;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;

@Configuration
public class WebSecurityConfig {

    @Autowired
    private MyAuthFailureHandler myAuthFailureHandler;

    @Autowired
    private MyAuthSuccessHandler myAuthSuccessHandler; 

    @Autowired
    private DataSource dataSource;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.jdbcAuthentication()
            .dataSource(dataSource)
            .usersByUsernameQuery("SELECT userid, userpw, enabled FROM members WHERE userid = ?")
            .authoritiesByUsernameQuery("SELECT userid, authority FROM members WHERE userid = ?")
            .passwordEncoder(bCryptPasswordEncoder);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
            .cors(cors -> cors.disable())
            .authorizeHttpRequests(request -> request
            	    .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
            	    .requestMatchers("/css/**", "/js/**", "/images/**").permitAll()
            	    .requestMatchers("/", "/signup.do", "/signupAction.do", "/guest/**", "/about/**", "/mbti.**").permitAll() // ← 추가!
            	    .requestMatchers("/member/**").hasAnyRole("USER", "ADMIN")
            	    .requestMatchers("/admin/**").hasRole("ADMIN")
            	    .anyRequest().permitAll()
            	);

        http.formLogin(formLogin -> formLogin
            .loginPage("/myLogin.do")
            .loginProcessingUrl("/myLoginAction.do")
            .usernameParameter("my_id")
            .passwordParameter("my_pass")
            .successHandler(myAuthSuccessHandler) 
            .failureHandler(myAuthFailureHandler)
            .permitAll());

        http.logout(logout -> logout
            .logoutUrl("/myLogout.do")
            .logoutSuccessUrl("/main/nonMember.do")
            .permitAll());

        http.exceptionHandling(exp -> exp
            .accessDeniedPage("/denied.do"));

        return http.build();
    }
    // URL 조합할때 // 안생기게 보장 -> // 슬래쉬 두개 생기면 400에러
    @Bean
    public HttpFirewall allowUrlEncodedDoubleSlashHttpFirewall() {
        StrictHttpFirewall firewall = new StrictHttpFirewall();
        firewall.setAllowUrlEncodedDoubleSlash(true);
        return firewall;
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.httpFirewall(allowUrlEncodedDoubleSlashHttpFirewall());
    }
}
