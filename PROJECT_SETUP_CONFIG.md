# Spring Boot Project Configuration Guide

> Tài liệu này mô tả chi tiết cấu hình dự án Spring Boot với JWT Authentication, JPA Entities, và Security. Sử dụng để tái tạo cấu hình tương tự cho các dự án mới.

## 📋 Thông Tin Cần Chuẩn Bị

Trước khi bắt đầu, cần chuẩn bị các thông tin sau:

1. **Tên Project**: `{PROJECT_NAME}` (ví dụ: `GymAndPTManagement`)
2. **Base Package**: `com.{PROJECT_PREFIX}` (ví dụ: `com.se100`)
3. **Database Type**: MySQL hoặc PostgreSQL
4. **Database Info**:
   - Database Name: `{DB_NAME}`
   - Username: `{DB_USERNAME}`
   - Password: `{DB_PASSWORD}`
   - Host: `{DB_HOST}` (default: localhost)
   - Port: `{DB_PORT}` (MySQL: 3306, PostgreSQL: 5432)
5. **JWT Secret Key**: `{JWT_SECRET}` (base64 encoded string)

---

## 🏗️ 1. Cấu Trúc Thư Mục

```
src/main/java/com/{PROJECT_PREFIX}/{PROJECT_NAME}/
├── config/                          # Configuration classes
│   ├── SecurityConfiguration.java
│   ├── OpenAPIConfig.java
│   └── CustomAuthenticationEntryPoint.java
├── controller/                      # REST Controllers
├── domain/
│   ├── requestDTO/                  # Request DTOs
│   ├── responseDTO/                 # Response DTOs
│   └── table/                       # JPA Entities
│       ├── User.java
│       ├── Role.java
│       └── Permission.java
├── repository/                      # JPA Repositories
├── service/                         # Business Logic Services
└── util/                           # Utility classes
    ├── annotation/
    ├── enums/
    ├── error/
    ├── FormatRestResponse.java
    └── SecurityUtil.java
```

---

## 📦 2. Dependencies (build.gradle.kts)

```kotlin
plugins {
    java
    id("org.springframework.boot") version "3.5.9"
    id("io.spring.dependency-management") version "1.1.7"
}

group = "com.{PROJECT_PREFIX}"
version = "0.0.1-SNAPSHOT"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(17)
    }
}

configurations {
    compileOnly {
        extendsFrom(configurations.annotationProcessor.get())
    }
}

repositories {
    mavenCentral()
}

dependencies {
    // Spring Boot Starters
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-oauth2-resource-server")
    implementation("org.springframework.boot:spring-boot-starter-security")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-web")
    
    // Database Driver (chọn một trong hai)
    runtimeOnly("com.mysql:mysql-connector-j")              // MySQL
    // runtimeOnly("org.postgresql:postgresql")             // PostgreSQL
    
    // Development Tools
    developmentOnly("org.springframework.boot:spring-boot-devtools")
    
    // Lombok
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")
    
    // OpenAPI/Swagger
    implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.8.14")
    
    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.springframework.security:spring-security-test")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType<Test> {
    useJUnitPlatform()
}
```

---

## ⚙️ 3. Application Properties

**File**: `src/main/resources/application.properties`

```properties
spring.application.name={PROJECT_NAME}

#============================================
# Database Configuration
#============================================
spring.jpa.hibernate.ddl-auto=update

# MySQL Configuration
spring.datasource.url=jdbc:mysql://{DB_HOST}:{DB_PORT}/{DB_NAME}?useSSL=false&serverTimezone=UTC
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# PostgreSQL Configuration (uncomment if using PostgreSQL)
# spring.datasource.url=jdbc:postgresql://{DB_HOST}:{DB_PORT}/{DB_NAME}
# spring.datasource.driver-class-name=org.postgresql.Driver

# Database Credentials
spring.datasource.username={DB_USERNAME}
spring.datasource.password={DB_PASSWORD}

# JPA Configuration
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

#============================================
# JWT Configuration
#============================================
{PROJECT_PREFIX}.jwt.base64-secret=${JWT_SECRET:{DEFAULT_JWT_SECRET}}
# Expiration time in seconds (10 days = 864000 seconds)
{PROJECT_PREFIX}.jwt.access-token-validity-in-seconds=864000
{PROJECT_PREFIX}.jwt.refresh-token-validity-in-seconds=864000

#============================================
# File Upload Configuration
#============================================
# Max file size (default = 1MB)
spring.servlet.multipart.max-file-size=50MB
# Max request size (form data) (default = 10MB)
spring.servlet.multipart.max-request-size=50MB

#============================================
# DevTools Configuration
#============================================
spring.devtools.restart.enabled=true
spring.devtools.livereload.enabled=true

#============================================
# Pagination Configuration
#============================================
spring.data.web.pageable.default-page-size=20
spring.data.web.pageable.max-page-size=2000
spring.data.web.pageable.one-indexed-parameters=true

#============================================
# Actuator Configuration
#============================================
management.endpoints.web.exposure.include=health,info,metrics,env,beans,mappings
management.endpoint.health.show-details=when-authorized
management.health.defaults.enabled=true
```

**Lưu ý**: Thay thế các placeholder `{...}` bằng giá trị thực tế:
- `{PROJECT_NAME}`: GymAndPTManagement
- `{PROJECT_PREFIX}`: se100
- `{DB_HOST}`: localhost
- `{DB_PORT}`: 3306 (MySQL) hoặc 5432 (PostgreSQL)
- `{DB_NAME}`: tên database
- `{DB_USERNAME}`: username database
- `{DB_PASSWORD}`: password database
- `{DEFAULT_JWT_SECRET}`: JWT secret key (base64)

---

## 🗃️ 4. JPA Entities với Audit Fields

### 4.1 User Entity

**File**: `src/main/java/com/{PROJECT_PREFIX}/{PROJECT_NAME}/domain/table/User.java`

```java
package com.{PROJECT_PREFIX}.{PROJECT_NAME}.domain.table;

import java.time.Instant;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import com.{PROJECT_PREFIX}.{PROJECT_NAME}.util.SecurityUtil;
import lombok.*;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    
    @NotBlank(message = "Không được để trống email")
    private String email;
    
    @NotBlank(message = "Không được để trống mật khẩu")
    private String password;

    // Relationship: n User -> 1 Role
    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;

    // Audit fields
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at")
    private Instant updatedAt;

    @Column(name = "created_by", length = 100)
    private String createdBy;

    @Column(name = "updated_by", length = 100)
    private String updatedBy;

    @PrePersist
    protected void onCreate() {
        createdAt = Instant.now();
        createdBy = SecurityUtil.getCurrentUserLogin().orElse("system");
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = Instant.now();
        updatedBy = SecurityUtil.getCurrentUserLogin().orElse("system");
    }
}
```

### 4.2 Role Entity

**File**: `src/main/java/com/{PROJECT_PREFIX}/{PROJECT_NAME}/domain/table/Role.java`

```java
package com.{PROJECT_PREFIX}.{PROJECT_NAME}.domain.table;

import java.time.Instant;
import java.util.Set;
import jakarta.persistence.*;
import com.{PROJECT_PREFIX}.{PROJECT_NAME}.util.SecurityUtil;
import lombok.*;

@Entity
@Table(name = "roles")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private boolean active;

    // Relationship: 1 Role -> n User
    @OneToMany(mappedBy = "role")
    private Set<User> users;

    // Relationship: n Role <-> n Permission
    @ManyToMany
    @JoinTable(
        name = "role_permission",
        joinColumns = @JoinColumn(name = "role_id"),
        inverseJoinColumns = @JoinColumn(name = "permission_id")
    )
    private Set<Permission> permissions;

    // Audit fields
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at")
    private Instant updatedAt;

    @Column(name = "created_by", length = 100)
    private String createdBy;

    @Column(name = "updated_by", length = 100)
    private String updatedBy;

    @PrePersist
    protected void onCreate() {
        createdAt = Instant.now();
        createdBy = SecurityUtil.getCurrentUserLogin().orElse("system");
        if (!active) {
            active = true;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = Instant.now();
        updatedBy = SecurityUtil.getCurrentUserLogin().orElse("system");
    }
}
```

### 4.3 Permission Entity

**File**: `src/main/java/com/{PROJECT_PREFIX}/{PROJECT_NAME}/domain/table/Permission.java`

```java
package com.{PROJECT_PREFIX}.{PROJECT_NAME}.domain.table;

import java.time.Instant;
import java.util.Set;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import com.{PROJECT_PREFIX}.{PROJECT_NAME}.util.SecurityUtil;
import lombok.*;

@Entity
@Table(
    name = "permissions",
    uniqueConstraints = {
        @UniqueConstraint(columnNames = {"apiPath", "method"})
    }
)
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Permission {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Name không được để trống")
    private String name;

    private String apiPath;
    private String method;
    private String module;

    // Relationship: n Permission <-> n Role
    @ManyToMany(mappedBy = "permissions")
    private Set<Role> roles;

    // Audit fields
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at")
    private Instant updatedAt;

    @Column(name = "created_by", length = 100)
    private String createdBy;

    @Column(name = "updated_by", length = 100)
    private String updatedBy;

    @PrePersist
    protected void onCreate() {
        createdAt = Instant.now();
        createdBy = SecurityUtil.getCurrentUserLogin().orElse("system");
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = Instant.now();
        updatedBy = SecurityUtil.getCurrentUserLogin().orElse("system");
    }
}
```

---

## 🔐 5. Security Configuration

### 5.1 SecurityUtil Class

**File**: `src/main/java/com/{PROJECT_PREFIX}/{PROJECT_NAME}/util/SecurityUtil.java`

```java
package com.{PROJECT_PREFIX}.{PROJECT_NAME}.util;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.security.oauth2.jwt.JwsHeader;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.stereotype.Service;

import com.nimbusds.jose.util.Base64;
import com.{PROJECT_PREFIX}.{PROJECT_NAME}.domain.responseDTO.ResLoginDTO;

@Service
public class SecurityUtil {
    public static final MacAlgorithm JWT_ALGORITHM = MacAlgorithm.from("HS256");
    
    private final JwtEncoder jwtEncoder;

    public SecurityUtil(JwtEncoder jwtEncoder) {
        this.jwtEncoder = jwtEncoder;
    }

    @Value("${" + "{PROJECT_PREFIX}" + ".jwt.base64-secret}")
    private String jwtKey;

    @Value("${" + "{PROJECT_PREFIX}" + ".jwt.access-token-validity-in-seconds}")
    private Long accessTokenExpiration;

    @Value("${" + "{PROJECT_PREFIX}" + ".jwt.refresh-token-validity-in-seconds}")
    private Long refreshTokenExpiration;

    public String createAccessToken(String email, ResLoginDTO dto) {
        ResLoginDTO.UserInsideToken userInsideToken = new ResLoginDTO.UserInsideToken();
        userInsideToken.setId(dto.getUser().getId());
        userInsideToken.setEmail(dto.getUser().getEmail());
        userInsideToken.setName(dto.getUser().getName());

        Instant now = Instant.now();
        Instant expirationTime = now.plusSeconds(accessTokenExpiration);

        // Get permissions from user's role
        List<String> listAuthorities = new ArrayList<>();
        if (dto.getUser().getRole() != null && dto.getUser().getRole().getPermissions() != null) {
            listAuthorities = dto.getUser().getRole().getPermissions().stream()
                    .map(permission -> permission.getName())
                    .toList();
        }

        JwtClaimsSet claims = JwtClaimsSet.builder()
                .issuedAt(now)
                .expiresAt(expirationTime)
                .subject(email)
                .claim("user", userInsideToken)
                .claim("permission", listAuthorities)
                .build();

        JwsHeader jwsHeader = JwsHeader.with(JWT_ALGORITHM).build();
        return this.jwtEncoder.encode(JwtEncoderParameters.from(jwsHeader, claims)).getTokenValue();
    }

    public String createRefreshToken(String email, ResLoginDTO dto) {
        ResLoginDTO.UserInsideToken userInsideToken = new ResLoginDTO.UserInsideToken();
        userInsideToken.setId(dto.getUser().getId());
        userInsideToken.setEmail(dto.getUser().getEmail());
        userInsideToken.setName(dto.getUser().getName());

        Instant now = Instant.now();
        Instant expirationTime = now.plusSeconds(refreshTokenExpiration);

        JwtClaimsSet claims = JwtClaimsSet.builder()
                .issuedAt(now)
                .expiresAt(expirationTime)
                .subject(email)
                .claim("user", userInsideToken)
                .build();

        JwsHeader jwsHeader = JwsHeader.with(JWT_ALGORITHM).build();
        return this.jwtEncoder.encode(JwtEncoderParameters.from(jwsHeader, claims)).getTokenValue();
    }

    public Jwt checkValidRefreshToken(String token) {
        NimbusJwtDecoder jwtDecoder = NimbusJwtDecoder.withSecretKey(
                getSecretKey()).macAlgorithm(JWT_ALGORITHM).build();
        try {
            return jwtDecoder.decode(token);
        } catch (Exception e) {
            System.out.println(">>>> Refresh token error: " + e.getMessage());
            throw e;
        }
    }

    public static Optional<String> getCurrentUserLogin() {
        SecurityContext securityContext = SecurityContextHolder.getContext();
        return Optional.ofNullable(extractPrincipal(securityContext.getAuthentication()));
    }

    private static String extractPrincipal(Authentication authentication) {
        if (authentication == null) {
            return null;
        } else if (authentication.getPrincipal() instanceof UserDetails springSecurityUser) {
            return springSecurityUser.getUsername();
        } else if (authentication.getPrincipal() instanceof Jwt jwt) {
            return jwt.getSubject();
        } else if (authentication.getPrincipal() instanceof String s) {
            return s;
        }
        return null;
    }

    public static Optional<String> getCurrentUserJWT() {
        SecurityContext securityContext = SecurityContextHolder.getContext();
        return Optional.ofNullable(securityContext.getAuthentication())
            .filter(authentication -> authentication.getCredentials() instanceof String)
            .map(authentication -> (String) authentication.getCredentials());
    }

    public static boolean hasCurrentUserAnyOfAuthorities(String... authorities) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null && 
               getAuthorities(authentication).anyMatch(authority -> Arrays.asList(authorities).contains(authority));
    }

    public static boolean hasCurrentUserNoneOfAuthorities(String... authorities) {
        return !hasCurrentUserAnyOfAuthorities(authorities);
    }

    public static boolean hasCurrentUserThisAuthority(String authority) {
        return hasCurrentUserAnyOfAuthorities(authority);
    }

    private static Stream<String> getAuthorities(Authentication authentication) {
        return authentication.getAuthorities().stream().map(GrantedAuthority::getAuthority);
    }

    private SecretKey getSecretKey() {
        byte[] keyBytes = Base64.from(jwtKey).decode();
        return new SecretKeySpec(keyBytes, 0, keyBytes.length, JWT_ALGORITHM.getName());
    }
}
```

### 5.2 SecurityConfiguration Class

**File**: `src/main/java/com/{PROJECT_PREFIX}/{PROJECT_NAME}/config/SecurityConfiguration.java`

```java
package com.{PROJECT_PREFIX}.{PROJECT_NAME}.config;

import java.util.List;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtEncoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.nimbusds.jose.jwk.source.ImmutableSecret;
import com.nimbusds.jose.util.Base64;
import com.{PROJECT_PREFIX}.{PROJECT_NAME}.util.SecurityUtil;

@Configuration
@EnableMethodSecurity(securedEnabled = true)
public class SecurityConfiguration {
    
    @Value("${" + "{PROJECT_PREFIX}" + ".jwt.base64-secret}")
    private String jwtKey;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public JwtDecoder jwtDecoder() {
        NimbusJwtDecoder jwtDecoder = NimbusJwtDecoder.withSecretKey(
                getSecretKey()).macAlgorithm(SecurityUtil.JWT_ALGORITHM).build();
        return token -> {
            try {
                return jwtDecoder.decode(token);
            } catch (Exception e) {
                System.out.println(">>>> JWT error: " + e.getMessage());
                throw e;
            }
        };
    }

    @Bean
    public JwtEncoder jwtEncoder() {
        return new NimbusJwtEncoder(new ImmutableSecret<>(getSecretKey()));
    }

    private SecretKey getSecretKey() {
        byte[] keyBytes = Base64.from(jwtKey).decode();
        return new SecretKeySpec(keyBytes, 0, keyBytes.length, SecurityUtil.JWT_ALGORITHM.getName());
    }

    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtGrantedAuthoritiesConverter grantedAuthoritiesConverter = new JwtGrantedAuthoritiesConverter();
        grantedAuthoritiesConverter.setAuthorityPrefix("");
        grantedAuthoritiesConverter.setAuthoritiesClaimName("permission");
        
        JwtAuthenticationConverter jwtAuthenticationConverter = new JwtAuthenticationConverter();
        jwtAuthenticationConverter.setJwtGrantedAuthoritiesConverter(grantedAuthoritiesConverter);
        return jwtAuthenticationConverter;
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOrigins(List.of("http://localhost:5173")); // Frontend URL
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        config.setAllowedHeaders(List.of("*"));
        config.setExposedHeaders(List.of("*"));
        config.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }

    @Bean
    public SecurityFilterChain filterChain(
            HttpSecurity http,
            CustomAuthenticationEntryPoint customAuthenticationEntryPoint) throws Exception {

        String[] whiteList = {
            "/",
            "/api/v1/auth/login",
            "/api/v1/auth/refresh",
            "/api/v1/auth/register",
            "/actuator/**",
            "/v3/api-docs/**",
            "/swagger-ui/**",
            "/swagger-ui.html",
            "/storage/**"
        };

        http
            .csrf(c -> c.disable())
            .authorizeHttpRequests(authz -> authz
                .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                .requestMatchers(whiteList).permitAll()
                .anyRequest().authenticated()
            )
            .cors(Customizer.withDefaults())
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(Customizer.withDefaults())
                .authenticationEntryPoint(customAuthenticationEntryPoint)
            )
            .formLogin(f -> f.disable())
            .sessionManagement(session -> 
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            );

        return http.build();
    }
}
```

---

## 📝 6. Checklist Khi Tái Tạo Project

- [ ] Tạo cấu trúc thư mục theo mục 1
- [ ] Copy dependencies vào `build.gradle.kts` (mục 2)
- [ ] Tạo file `application.properties` và thay thế các placeholder (mục 3)
- [ ] Tạo 3 entities: User, Role, Permission với audit fields (mục 4)
- [ ] Tạo `SecurityUtil.java` (mục 5.1)
- [ ] Tạo `SecurityConfiguration.java` (mục 5.2)
- [ ] Tạo `CustomAuthenticationEntryPoint.java` (nếu cần)
- [ ] Tạo `ResLoginDTO.java` với nested class `UserInsideToken`
- [ ] Sync/Build project để download dependencies
- [ ] Chạy application và kiểm tra kết nối database

---

## 🔑 Generate JWT Secret Key

Để tạo JWT secret key (base64 encoded):

```bash
# Linux/Mac
openssl rand -base64 64

# Windows PowerShell
[Convert]::ToBase64String((1..64 | ForEach-Object { Get-Random -Maximum 256 }))

# Online: https://generate-secret.vercel.app/64
```

---

## 📊 Database Relationships

```
User (n) ──────> (1) Role (n) ←────> (n) Permission
         Many-to-One           Many-to-Many
                              (role_permission table)
```

**Audit Fields** (tất cả entities):
- `created_at`: Timestamp khi tạo
- `updated_at`: Timestamp khi cập nhật
- `created_by`: User tạo (từ SecurityContext hoặc "system")
- `updated_by`: User cập nhật (từ SecurityContext hoặc "system")

---

## 🎯 Lưu Ý Quan Trọng

1. **Project-specific properties**: Các property như `{PROJECT_PREFIX}.jwt.*` phải match với `@Value` annotation trong code
2. **Database Driver**: Chỉ enable một driver (MySQL hoặc PostgreSQL) trong dependencies
3. **CORS Origins**: Cập nhật `allowedOrigins` trong `corsConfigurationSource()` theo frontend URL thực tế
4. **White List**: Thêm/bớt endpoints trong `whiteList` array theo yêu cầu bảo mật
5. **JWT Algorithm**: Hiện tại sử dụng HS256, có thể thay đổi trong `SecurityUtil.JWT_ALGORITHM`
6. **Audit Fields**: Sử dụng `@PrePersist` và `@PreUpdate` để tự động populate audit fields

---

**Created**: January 2, 2026  
**Version**: 1.0
