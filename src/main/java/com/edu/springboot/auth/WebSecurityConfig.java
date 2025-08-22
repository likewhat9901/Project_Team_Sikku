package com.edu.springboot.auth;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;

import com.edu.springboot.flutter.auth.JwtAuthenticationFilter;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletResponse;

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

    // ✅ 1. Flutter 로그인용 - 인증 없이 허용
    @Bean
    @Order(1)
    public SecurityFilterChain flutterLoginFilterChain(HttpSecurity http) throws Exception {
        http.securityMatcher("/api/flutter/login", "/api/flutter/check-id/**", "/api/flutter/register")
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth.anyRequest().permitAll())
            .formLogin(form -> form.disable())
            .httpBasic(basic -> basic.disable());

        return http.build();
    }

    // ✅ 2. Flutter 인증된 API 요청용
    @Bean
    @Order(2)
    public SecurityFilterChain flutterApiFilterChain(HttpSecurity http) throws Exception {
    	//플러터에서 받을때 mydiary
        http.securityMatcher("/api/flutter/**")
            .csrf(csrf -> csrf.disable())
            .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .requestCache(rc -> rc.disable())
            .exceptionHandling(ex -> ex
                .authenticationEntryPoint((req, res, ex2) -> {
                    res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    res.setContentType("application/json;charset=UTF-8");
                    res.getWriter().write("{\"error\": \"Unauthorized\"}");
                })
            )
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
            .formLogin(form -> form.disable())
            .httpBasic(basic -> basic.disable())
            .addFilterBefore(new JwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    @Order(2)
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
            .cors(cors -> cors.disable())
            .authorizeHttpRequests(req -> req
            	    .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()

            	    // 정적/공개 리소스
            	    .requestMatchers("/predict","/css/**","/js/**","/images/**").permitAll()
            	    .requestMatchers("/uploads/**").permitAll()

            	    // 식물도감 페이지 비회원도 공개
            	    .requestMatchers("/dict/**").permitAll()

            	    // 비회원 메인
            	    .requestMatchers("/main/nonMember.do").permitAll()
            	    // 날씨, 랭킹
            	    .requestMatchers("/api/weather").permitAll()
            	    .requestMatchers("/api/ranking").permitAll()
            	    .requestMatchers("/api/top10boards").permitAll()
            	    .requestMatchers("/api/dashboard/weekly-posts/**").permitAll()
            	    .requestMatchers("/mydiary/**").authenticated()

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
        firewall.setAllowSemicolon(true);
        return firewall;
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.httpFirewall(allowUrlEncodedDoubleSlashHttpFirewall());
    }
}
