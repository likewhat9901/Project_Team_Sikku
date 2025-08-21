package com.edu.springboot.auth;
import java.util.List;

import javax.sql.DataSource;
// 필요하면: import org.springframework.security.crypto.password.PasswordEncoder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.edu.springboot.flutteruser.JWTAuthAPIFilter;
import com.edu.springboot.flutteruser.JWTUtil;

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

    //기존 진경 코드 주석 처리
    /*
    @Autowired
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.jdbcAuthentication()
            .dataSource(dataSource)
            .usersByUsernameQuery("SELECT userid, userpw, enabled FROM members WHERE userid = ?")
            .authoritiesByUsernameQuery("SELECT userid, authority FROM members WHERE userid = ?")
            .passwordEncoder(bCryptPasswordEncoder);
    }
    
    */
    
    @Bean
    public JWTAuthAPIFilter jwtAuthApiFilter(JWTUtil jwtUtil, UserDetailsService userDetailsService) {
        return new JWTAuthAPIFilter(jwtUtil, userDetailsService);
    }
    
    @Bean
    public UserDetailsService userDetailsService() {
        JdbcUserDetailsManager manager = 
            new JdbcUserDetailsManager(dataSource);
        manager.setUsersByUsernameQuery("SELECT userid, userpw, enabled FROM members WHERE userid = ?");
        manager.setAuthoritiesByUsernameQuery("SELECT userid, authority FROM members WHERE userid = ?");
        return manager;
    }
    
    /* ========= CORS (API 전용) ========= */
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        var c = new CorsConfiguration();
        // 필요에 맞게 수정(플러터는 브라우저가 아니면 CORS 영향 없음, 웹 프런트에서 호출 시에만 필요)
        c.setAllowedOrigins(List.of("http://localhost:8577", "http://192.168.0.9:8577"));
        c.setAllowedMethods(List.of("GET","POST","PUT","DELETE","OPTIONS"));
        c.setAllowedHeaders(List.of("*"));
        c.setExposedHeaders(List.of("Authorization"));
        c.setAllowCredentials(true);

        var src = new UrlBasedCorsConfigurationSource();
        src.registerCorsConfiguration("/api/**", c);
        return src;
    }

    /* ========= 체인 #1: API (/api/**) — JWT, 무상태 ========= */
    @Bean @Order(0)
    public SecurityFilterChain apiChain(HttpSecurity http, JWTAuthAPIFilter jwtAuthAPIFilter) 
    		throws Exception {
        http.securityMatcher("/api/**")
            .csrf(csrf -> csrf.disable())
            .cors(Customizer.withDefaults())
            .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                // 공개 API 엔드포인트
                .requestMatchers(HttpMethod.OPTIONS, "/api/auth/register", "/api/auth/login").permitAll()
                .requestMatchers("/api/weather", "/api/ranking", "/api/top10boards").permitAll()
                // 그 외 API는 인증 필요
                .anyRequest().authenticated()
            )
            //
            .exceptionHandling(ex -> ex
                .authenticationEntryPoint((req, res, e) -> res.sendError(401))
                .accessDeniedHandler((req, res, e) -> res.sendError(403))
            )
            // JWT는 API 체인에만
            .addFilterBefore(jwtAuthAPIFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
    
    /* ========= 체인 #2: 웹 페이지 — order 수정 ========= */
//    @Bean
    @Bean @Order(1)
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
    
    @Bean
    public AuthenticationManager authenticationManager(
            AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }
    
    @Bean
    public AuthenticationProvider authenticationProvider(
    		UserDetailsService userDetailsService,BCryptPasswordEncoder bCryptPasswordEncoder) {
        DaoAuthenticationProvider authProvider = 
            new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(bCryptPasswordEncoder);
        // UserDetailsService는 자동으로 JDBC 기반으로 생성됩니다
        return authProvider;
    }
}
