# JWT Token Generation Algorithm

**Category**: Authentication & Authorization  
**Algorithm**: HS256 (HMAC with SHA-256)  
**Author**: System  
**Date**: 2026-01-03

---

## 📋 Mô Tả

Thuật toán tạo JWT (JSON Web Token) cho authentication và authorization. Tạo 2 loại token:
- **Access Token**: Chứa user info + permissions, dùng để authorize requests
- **Refresh Token**: Chỉ chứa user info, dùng để renew access token

---

## ⚙️ Configuration

| Parameter                | Value                    | Description                     |
| ------------------------ | ------------------------ | ------------------------------- |
| Algorithm                | HS256                    | HMAC with SHA-256               |
| Access Token Expiration  | 864000 seconds (10 days) | Thời gian hết hạn access token  |
| Refresh Token Expiration | 864000 seconds (10 days) | Thời gian hết hạn refresh token |
| Secret Key               | From config              | Base64 encoded secret key       |

---

## 💻 Implementation

### Generate Access Token

```java
/**
 * Generate Access Token
 * Claims:
 * - subject: user email
 * - user: {id, email, name}
 * - permission: array of permission names
 */
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
```

### Generate Refresh Token

```java
/**
 * Generate Refresh Token
 * Claims:
 * - subject: user email
 * - user: {id, email, name}
 * Note: Không chứa permissions
 */
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
```

---

## 📊 Token Structure

### Access Token Claims

```json
{
  "sub": "user@example.com",
  "iat": 1704279600,
  "exp": 1705143600,
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "Nguyen Van A"
  },
  "permission": [
    "USER_READ",
    "USER_UPDATE",
    "PROFILE_MANAGE"
  ]
}
```

### Refresh Token Claims

```json
{
  "sub": "user@example.com",
  "iat": 1704279600,
  "exp": 1705143600,
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "Nguyen Van A"
  }
}
```

---

## 📝 Usage

```java
// Login - Generate both tokens
ResLoginDTO loginDTO = authService.login(email, password);
String accessToken = securityUtil.createAccessToken(email, loginDTO);
String refreshToken = securityUtil.createRefreshToken(email, loginDTO);

// Client stores tokens and sends access token with requests
// Authorization: Bearer {accessToken}

// When access token expires, use refresh token to get new one
String newAccessToken = authService.refreshToken(refreshToken);
```

---

## 🔒 Security Notes

1. **Access Token chứa permissions** để authorization ngay tại gateway/filter
2. **Refresh Token không chứa permissions** (chỉ dùng để renew)
3. **Validate expiration time** trước khi sử dụng token
4. **Secret key phải được bảo mật** (lưu trong environment variable)
5. **Token không thể revoke**: Cần implement token blacklist nếu cần logout
6. **HTTPS only**: Luôn truyền token qua HTTPS

---

## 🚨 Edge Cases

- **User không có role**: Permission list = empty array
- **Role không có permissions**: Permission list = empty array
- **Token expired**: JwtException khi decode, client cần refresh
- **Invalid signature**: JwtException, có thể do secret key sai
- **Malformed token**: JwtException khi parse

---

## 🧪 Testing

```java
@Test
public void testTokenGeneration() {
    ResLoginDTO dto = createMockLoginDTO();
    String token = securityUtil.createAccessToken("test@example.com", dto);
    
    // Verify token is not null and has 3 parts (header.payload.signature)
    assertNotNull(token);
    assertEquals(3, token.split("\\.").length);
    
    // Decode and verify claims
    Jwt jwt = jwtDecoder.decode(token);
    assertEquals("test@example.com", jwt.getSubject());
    assertNotNull(jwt.getClaim("user"));
    assertNotNull(jwt.getClaim("permission"));
}
```

---

## 📚 References

- [JWT Specification (RFC 7519)](https://tools.ietf.org/html/rfc7519)
- [JWT Best Practices (RFC 8725)](https://tools.ietf.org/html/rfc8725)
- [Spring Security OAuth2 JWT](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/jwt.html)

---

**Version**: 1.0  
**Last Updated**: 2026-01-03
