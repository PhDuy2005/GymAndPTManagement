# ⚙️ Algorithms & Business Logic Documentation

> Tài liệu này mô tả chi tiết các thuật toán và business logic được sử dụng trong dự án.

---

## 📋 Nguyên Tắc

1. **Kiểm tra trước khi implement**: Luôn kiểm tra file này trước khi viết thuật toán mới
2. **Tái sử dụng**: Nếu đã có thuật toán tương tự, sử dụng lại thay vì viết mới
3. **Document sau khi implement**: Mọi thuật toán mới phải được document vào file này
4. **Clear naming**: Đặt tên thuật toán rõ ràng, dễ tìm kiếm

---

## 🔐 Authentication & Authorization

### 1. Password Hashing

**Algorithm**: BCrypt  
**Strength**: 10 rounds (default)  
**Usage**: Mã hóa password trước khi lưu vào database

```java
/**
 * Hash password using BCrypt
 * @param plainPassword - Password người dùng nhập vào
 * @return Hashed password
 */
public String hashPassword(String plainPassword) {
    PasswordEncoder encoder = new BCryptPasswordEncoder();
    return encoder.encode(plainPassword);
}

/**
 * Verify password
 * @param plainPassword - Password người dùng nhập vào
 * @param hashedPassword - Password đã hash trong database
 * @return true nếu match, false nếu không match
 */
public boolean verifyPassword(String plainPassword, String hashedPassword) {
    PasswordEncoder encoder = new BCryptPasswordEncoder();
    return encoder.matches(plainPassword, hashedPassword);
}
```

**Lưu ý**:
- Không bao giờ lưu plain text password
- Không log password (plain hoặc hashed)
- Sử dụng PasswordEncoder bean đã config trong SecurityConfiguration

---

### 2. JWT Token Generation

**Algorithm**: HS256 (HMAC with SHA-256)  
**Access Token Expiration**: 10 days (864000 seconds)  
**Refresh Token Expiration**: 10 days (864000 seconds)

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

**Refresh Token**:
- Tương tự Access Token nhưng không chứa permissions
- Chỉ chứa thông tin user cơ bản (id, email, name)
- Dùng để renew access token khi hết hạn

**Lưu ý**:
- Access token chứa permissions để authorization
- Refresh token không chứa permissions (chỉ dùng để renew)
- Validate expiration time trước khi sử dụng token

---

### 3. Permission Check Algorithm

**Logic**: Kiểm tra user có permission cụ thể không

```java
/**
 * Check if current user has specific authority
 * @param authority - Permission name cần kiểm tra
 * @return true nếu có permission, false nếu không
 */
public static boolean hasCurrentUserThisAuthority(String authority) {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    return authentication != null && 
           getAuthorities(authentication).anyMatch(auth -> auth.equals(authority));
}

/**
 * Check if current user has any of the authorities
 * @param authorities - Array of permission names
 * @return true nếu có ít nhất 1 permission, false nếu không có
 */
public static boolean hasCurrentUserAnyOfAuthorities(String... authorities) {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    return authentication != null && 
           getAuthorities(authentication).anyMatch(authority -> 
               Arrays.asList(authorities).contains(authority));
}
```

**Usage**:
```java
// Check single permission
if (SecurityUtil.hasCurrentUserThisAuthority("USER_CREATE")) {
    // Allow create user
}

// Check multiple permissions (OR logic)
if (SecurityUtil.hasCurrentUserAnyOfAuthorities("USER_UPDATE", "ADMIN")) {
    // Allow if user has either USER_UPDATE or ADMIN permission
}
```

---

## 📊 Data Validation

### 1. Email Validation

**Pattern**: Standard RFC 5322 email format  
**Implementation**: Jakarta Validation `@Email` annotation

```java
@Email(message = "Email không đúng định dạng")
@NotBlank(message = "Email không được để trống")
private String email;
```

**Additional Check**: Email uniqueness
```java
/**
 * Check if email already exists
 * @param email - Email cần kiểm tra
 * @return true nếu email đã tồn tại, false nếu chưa
 */
public boolean isEmailExists(String email) {
    return userRepository.existsByEmail(email);
}
```

---

### 2. Password Strength Validation

**Minimum Requirements**:
- Độ dài: Ít nhất 8 ký tự
- Có thể thêm requirements sau: chữ hoa, chữ thường, số, ký tự đặc biệt

```java
@NotBlank(message = "Mật khẩu không được để trống")
@Size(min = 8, message = "Mật khẩu phải có ít nhất 8 ký tự")
private String password;
```

**Custom Validation** (nếu cần thêm requirements):
```java
/**
 * Validate password strength
 * Requirements:
 * - At least 8 characters
 * - At least one uppercase letter
 * - At least one lowercase letter
 * - At least one digit
 * - At least one special character
 */
public boolean isStrongPassword(String password) {
    if (password == null || password.length() < 8) {
        return false;
    }
    
    boolean hasUpper = password.chars().anyMatch(Character::isUpperCase);
    boolean hasLower = password.chars().anyMatch(Character::isLowerCase);
    boolean hasDigit = password.chars().anyMatch(Character::isDigit);
    boolean hasSpecial = password.chars().anyMatch(ch -> "!@#$%^&*()_+-=[]{}|;:,.<>?".indexOf(ch) >= 0);
    
    return hasUpper && hasLower && hasDigit && hasSpecial;
}
```

---

## 🔄 Audit Trail

### 1. Auto-populate Audit Fields

**Trigger**: `@PrePersist` và `@PreUpdate` lifecycle callbacks  
**Logic**: Tự động điền created_at, updated_at, created_by, updated_by

```java
@PrePersist
protected void onCreate() {
    createdAt = Instant.now();
    createdBy = SecurityUtil.getCurrentUserLogin().orElse("system");
    // Additional logic for specific entities
}

@PreUpdate
protected void onUpdate() {
    updatedAt = Instant.now();
    updatedBy = SecurityUtil.getCurrentUserLogin().orElse("system");
}
```

**Lưu ý**:
- `getCurrentUserLogin()` lấy username từ SecurityContext
- Fallback về "system" nếu không có user authentication (ví dụ: scheduled tasks)

---

## 📄 Pagination

### 1. Standard Pagination

**Default Page Size**: 20  
**Max Page Size**: 2000  
**Page Index**: 1-based (page 1 là trang đầu tiên)

```java
/**
 * Get paginated list
 * @param pageNumber - Trang cần lấy (bắt đầu từ 1)
 * @param pageSize - Số items mỗi trang
 * @return Page object với content và metadata
 */
public Page<Entity> getPaginatedList(int pageNumber, int pageSize) {
    // Spring Data JPA uses 0-based index internally
    Pageable pageable = PageRequest.of(pageNumber - 1, pageSize);
    return repository.findAll(pageable);
}
```

**Response Format**:
```json
{
  "content": [...],
  "pageNumber": 1,
  "pageSize": 20,
  "totalElements": 100,
  "totalPages": 5,
  "first": true,
  "last": false
}
```

---

## 🔍 Search & Filter

### 1. Case-insensitive Search

**Use Case**: Tìm kiếm không phân biệt hoa thường

```java
/**
 * Search by name (case-insensitive)
 * @param name - Tên cần tìm (không phân biệt hoa thường)
 * @return List of matching entities
 */
@Query("SELECT e FROM Entity e WHERE LOWER(e.name) LIKE LOWER(CONCAT('%', :name, '%'))")
List<Entity> searchByNameIgnoreCase(@Param("name") String name);
```

---

### 2. Multiple Criteria Filter

**Use Case**: Lọc theo nhiều điều kiện (AND logic)

```java
/**
 * Filter with multiple criteria using Specification
 */
public Page<Entity> filterEntities(FilterCriteria criteria, Pageable pageable) {
    Specification<Entity> spec = Specification.where(null);
    
    if (criteria.getName() != null) {
        spec = spec.and((root, query, cb) -> 
            cb.like(cb.lower(root.get("name")), "%" + criteria.getName().toLowerCase() + "%"));
    }
    
    if (criteria.getStatus() != null) {
        spec = spec.and((root, query, cb) -> 
            cb.equal(root.get("status"), criteria.getStatus()));
    }
    
    return repository.findAll(spec, pageable);
}
```

---

## 📝 Template Cho Algorithm Mới

Khi document algorithm mới, sử dụng template sau:

```markdown
### {Serial}. {Algorithm Name}

**Use Case**: {Mô tả use case}  
**Complexity**: O({time_complexity}) time, O({space_complexity}) space  
**Author**: {Người implement}  
**Date**: {Ngày implement}

**Description**:
{Mô tả chi tiết thuật toán}

**Pseudocode/Code**:
```java
// Code implementation
```

**Example**:
```java
// Usage example
```

**Edge Cases**:
- Case 1: {Mô tả}
- Case 2: {Mô tả}

**Testing Notes**:
- Test case 1: {Mô tả}
- Test case 2: {Mô tả}

**Lưu ý**:
- Lưu ý 1
- Lưu ý 2
```

---

## 🚨 Lưu Ý Chung

1. **Reusability**: Viết algorithms có thể tái sử dụng, tránh hardcode
2. **Performance**: Cân nhắc performance, đặc biệt với large datasets
3. **Security**: Không log sensitive data (passwords, tokens, etc.)
4. **Error Handling**: Handle edge cases và invalid inputs
5. **Documentation**: Document rõ ràng input, output, và side effects
6. **Testing**: Viết unit tests cho critical algorithms

---

## 📚 References

- [Spring Security Documentation](https://docs.spring.io/spring-security/reference/index.html)
- [JWT Best Practices](https://tools.ietf.org/html/rfc8725)
- [BCrypt Algorithm](https://en.wikipedia.org/wiki/Bcrypt)
- [JPA Specification](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#specifications)

---

**Version**: 1.0  
**Last Updated**: 2026-01-03  
**Next Review**: Khi có algorithm mới cần document
