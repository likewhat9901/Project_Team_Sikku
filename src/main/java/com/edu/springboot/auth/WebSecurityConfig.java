package com.edu.springboot.auth;
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

import jakarta.servlet.DispatcherType;

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
            .authorizeHttpRequests(req -> req
            	    .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()

            	    // 정적/공개 리소스
            	    .requestMatchers("/css/**","/js/**","/images/**").permitAll()
            	    .requestMatchers("/uploads/**").permitAll()

            	    // 식물도감 페이지 비회원도 공개
            	    .requestMatchers("/dict/**").permitAll()

            	    // 비회원 메인
            	    .requestMatchers("/main/nonMember.do").permitAll()
            	    
            	    // 날씨, 랭킹
            	    .requestMatchers("/api/weather").permitAll()
            	    .requestMatchers("/api/ranking").permitAll()
            	    .requestMatchers("/api/top10boards").permitAll()

            	    // 공개 엔드포인트
            	    .requestMatchers("/", "/signup.do", "/signupAction.do",
            	                     "/guest/**", "/about/**", "/mbti/**",
            	                     "/myLogin.do", "/myLoginAction.do", "/myLogout.do",
            	                     "/fonts/**").permitAll()

            	    // 보호 구간
            	    .requestMatchers("/admin/**").hasRole("ADMIN")
            	    .requestMatchers("/member/**").hasAnyRole("USER","ADMIN")
            	    .requestMatchers("/mypage/**").authenticated()
            	    .anyRequest().authenticated()
            	)

            .formLogin(form -> form
                .loginPage("/myLogin.do")
                .loginProcessingUrl("/myLoginAction.do")
                .usernameParameter("my_id")
                .passwordParameter("my_pass")
                .successHandler(myAuthSuccessHandler)
                .failureHandler(myAuthFailureHandler)
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/myLogout.do")
                .logoutSuccessUrl("/main/nonMember.do")
                .permitAll()
            )
            .exceptionHandling(exp -> exp.accessDeniedPage("/denied.do"));
        return http.build();
    }

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
