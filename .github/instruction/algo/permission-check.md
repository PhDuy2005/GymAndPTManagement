# Permission Check Algorithm

**Category**: Authentication & Authorization  
**Algorithm**: Spring Security Authority Check  
**Author**: System  
**Date**: 2026-01-03

---

## 📋 Mô Tả

Thuật toán kiểm tra xem user hiện tại có permission cụ thể hay không. Sử dụng Spring Security Context để lấy authorities từ JWT token.

---

## 💻 Implementation

### Check Single Permission

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
```

### Check Multiple Permissions (OR Logic)

```java
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

### Check No Permission

```java
/**
 * Check if current user has none of the authorities
 * @param authorities - Array of permission names
 * @return true nếu không có permission nào, false nếu có ít nhất 1
 */
public static boolean hasCurrentUserNoneOfAuthorities(String... authorities) {
    return !hasCurrentUserAnyOfAuthorities(authorities);
}
```

### Helper Method - Get Authorities

```java
/**
 * Extract authorities from authentication
 */
private static Stream<String> getAuthorities(Authentication authentication) {
    return authentication.getAuthorities().stream()
           .map(GrantedAuthority::getAuthority);
}
```

---

## 📝 Usage

### In Service/Business Logic

```java
// Check single permission
if (SecurityUtil.hasCurrentUserThisAuthority("USER_CREATE")) {
    // Allow create user
    userService.createUser(dto);
} else {
    throw new ForbiddenException("Bạn không có quyền tạo user");
}

// Check multiple permissions (OR logic)
if (SecurityUtil.hasCurrentUserAnyOfAuthorities("USER_UPDATE", "ADMIN")) {
    // Allow if user has either USER_UPDATE or ADMIN permission
    userService.updateUser(id, dto);
}

// Check no permission
if (SecurityUtil.hasCurrentUserNoneOfAuthorities("ADMIN", "SUPER_ADMIN")) {
    // User doesn't have admin permissions
    throw new ForbiddenException("Chỉ admin mới có quyền truy cập");
}
```

### Using @PreAuthorize Annotation

```java
@PreAuthorize("hasAuthority('USER_DELETE')")
public void deleteUser(Long id) {
    userRepository.deleteById(id);
}

@PreAuthorize("hasAnyAuthority('USER_UPDATE', 'ADMIN')")
public void updateUser(Long id, ReqUserDTO dto) {
    // ...
}
```

---

## 🔄 Flow Diagram

```
┌─────────────────────────────────────────┐
│  Request arrives with JWT token         │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│  JWT Filter decodes token               │
│  Extracts "permission" claim            │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│  SecurityContext stores Authentication  │
│  with GrantedAuthorities                │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│  hasCurrentUserThisAuthority() called   │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│  Get Authentication from SecurityContext│
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│  Extract authorities (Stream<String>)   │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│  Check if required authority exists     │
└──────────────────┬──────────────────────┘
                   │
            ┌──────┴──────┐
            ▼             ▼
         Found         Not Found
      return true    return false
```

---

## 🔒 Security Notes

1. **Always check authentication != null** trước khi get authorities
2. **Permission names case-sensitive**: "USER_CREATE" ≠ "user_create"
3. **Use method security** (`@PreAuthorize`) cho declarative authorization
4. **Fail-safe**: Return false khi không có authentication
5. **Thread-safe**: SecurityContext sử dụng ThreadLocal

---

## 🚨 Edge Cases

- **No authentication**: Return false (không có user đăng nhập)
- **No authorities**: Return false (user không có permission nào)
- **Empty authority string**: Match fail (không có permission rỗng)
- **Null authority parameter**: Throw NullPointerException (nên validate trước)

---

## 🧪 Testing

```java
@Test
@WithMockUser(authorities = {"USER_READ", "USER_UPDATE"})
public void testHasAuthority() {
    // User has USER_READ
    assertTrue(SecurityUtil.hasCurrentUserThisAuthority("USER_READ"));
    
    // User doesn't have USER_DELETE
    assertFalse(SecurityUtil.hasCurrentUserThisAuthority("USER_DELETE"));
}

@Test
@WithMockUser(authorities = {"USER_READ"})
public void testHasAnyAuthority() {
    // Has one of them
    assertTrue(SecurityUtil.hasCurrentUserAnyOfAuthorities("USER_UPDATE", "USER_READ"));
    
    // Has none of them
    assertFalse(SecurityUtil.hasCurrentUserAnyOfAuthorities("ADMIN", "SUPER_ADMIN"));
}
```

---

## 📚 References

- [Spring Security Method Security](https://docs.spring.io/spring-security/reference/servlet/authorization/method-security.html)
- [SecurityContextHolder](https://docs.spring.io/spring-security/site/docs/current/api/org/springframework/security/core/context/SecurityContextHolder.html)
- [GrantedAuthority](https://docs.spring.io/spring-security/site/docs/current/api/org/springframework/security/core/GrantedAuthority.html)

---

**Version**: 1.0  
**Last Updated**: 2026-01-03
