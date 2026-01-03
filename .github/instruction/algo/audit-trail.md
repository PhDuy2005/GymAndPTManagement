# Audit Trail Algorithm

**Category**: Utilities  
**Algorithm**: Auto-populate Audit Fields  
**Author**: System  
**Date**: 2026-01-03

---

## 📋 Mô Tả

Thuật toán tự động điền các audit fields (created_at, updated_at, created_by, updated_by) vào entities khi tạo mới hoặc cập nhật. Sử dụng JPA lifecycle callbacks để trigger logic.

---

## 💻 Implementation

### Entity Audit Fields

```java
@MappedSuperclass
public abstract class AuditableEntity {
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;
    
    @Column(name = "updated_at")
    private Instant updatedAt;
    
    @Column(name = "created_by", nullable = false, updatable = false)
    private String createdBy;
    
    @Column(name = "updated_by")
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
    
    // Getters and setters
}
```

### Entity Implementation

```java
@Entity
@Table(name = "users")
public class User extends AuditableEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String email;
    
    // Other fields...
}
```

---

## 🔄 Flow Diagram

```
┌─────────────────────────────────────┐
│  Entity Save/Update Operation       │
└──────────────────┬──────────────────┘
                   │
         ┌─────────┴─────────┐
         ▼                   ▼
    @PrePersist         @PreUpdate
         │                   │
         ▼                   ▼
┌─────────────────┐  ┌─────────────────┐
│ onCreate()      │  │ onUpdate()      │
│ - Set createdAt │  │ - Set updatedAt │
│ - Set createdBy │  │ - Set updatedBy │
└────────┬────────┘  └────────┬────────┘
         │                    │
         ▼                    ▼
┌─────────────────────────────────────┐
│  SecurityUtil.getCurrentUserLogin() │
└──────────────────┬──────────────────┘
                   │
            ┌──────┴──────┐
            ▼             ▼
        Found User    No User
            │             │
      Return email   Return "system"
            │             │
            └──────┬──────┘
                   ▼
        ┌──────────────────────┐
        │  Save to Database    │
        └──────────────────────┘
```

---

## 📝 Usage

### Automatic (No Code Required)

```java
// Entity tự động được audit khi save/update
User user = new User();
user.setName("Nguyen Van A");
user.setEmail("a@example.com");

// createdAt và createdBy sẽ tự động được set
userRepository.save(user);

// updatedAt và updatedBy sẽ tự động được set
user.setName("Nguyen Van B");
userRepository.save(user);
```

### Manual Override (If Needed)

```java
@PrePersist
protected void onCreate() {
    createdAt = Instant.now();
    
    // Custom logic for specific entity
    if (this instanceof Role) {
        Role role = (Role) this;
        if (role.getActive() == null) {
            role.setActive(true);
        }
    }
    
    createdBy = SecurityUtil.getCurrentUserLogin().orElse("system");
}
```

---

## ⚙️ Configuration

### SecurityUtil Integration

```java
public class SecurityUtil {
    /**
     * Get current logged-in user's email
     * @return Optional containing user email, or empty if no authentication
     */
    public static Optional<String> getCurrentUserLogin() {
        SecurityContext securityContext = SecurityContextHolder.getContext();
        return Optional.ofNullable(extractPrincipal(securityContext.getAuthentication()));
    }
    
    private static String extractPrincipal(Authentication authentication) {
        if (authentication == null) {
            return null;
        } else if (authentication.getPrincipal() instanceof UserDetails) {
            UserDetails springSecurityUser = (UserDetails) authentication.getPrincipal();
            return springSecurityUser.getUsername();
        } else if (authentication.getPrincipal() instanceof Jwt) {
            return ((Jwt) authentication.getPrincipal()).getSubject();
        } else if (authentication.getPrincipal() instanceof String) {
            return (String) authentication.getPrincipal();
        }
        return null;
    }
}
```

### Fallback Values

| Field     | Authenticated User | Unauthenticated/System |
| --------- | ------------------ | ---------------------- |
| createdBy | User email         | "system"               |
| updatedBy | User email         | "system"               |
| createdAt | Current timestamp  | Current timestamp      |
| updatedAt | Current timestamp  | Current timestamp      |

---

## 🔒 Security Notes

1. **Immutable created fields**: `createdAt` và `createdBy` có `updatable = false`
2. **System operations**: Scheduled tasks, migrations sử dụng "system" as createdBy/updatedBy
3. **No manual override**: User không thể manual set audit fields từ API
4. **Timezone**: Sử dụng `Instant` (UTC) để tránh timezone issues

---

## 🚨 Edge Cases

- **No SecurityContext**: Fallback về "system" (scheduled tasks, migrations)
- **Anonymous user**: Fallback về "system"
- **Import data**: Có thể cần disable audit nếu muốn preserve original timestamps
- **Bulk operations**: Native queries có thể bypass lifecycle callbacks

---

## 🧪 Testing

```java
@Test
@WithMockUser(username = "test@example.com")
public void testAuditFields_OnCreate() {
    User user = new User();
    user.setName("Test User");
    user.setEmail("test@example.com");
    
    User saved = userRepository.save(user);
    
    assertNotNull(saved.getCreatedAt());
    assertNotNull(saved.getCreatedBy());
    assertEquals("test@example.com", saved.getCreatedBy());
    assertNull(saved.getUpdatedAt());
    assertNull(saved.getUpdatedBy());
}

@Test
@WithMockUser(username = "admin@example.com")
public void testAuditFields_OnUpdate() {
    User user = userRepository.findById(1L).orElseThrow();
    Instant originalCreatedAt = user.getCreatedAt();
    String originalCreatedBy = user.getCreatedBy();
    
    user.setName("Updated Name");
    User updated = userRepository.save(user);
    
    // Created fields unchanged
    assertEquals(originalCreatedAt, updated.getCreatedAt());
    assertEquals(originalCreatedBy, updated.getCreatedBy());
    
    // Updated fields changed
    assertNotNull(updated.getUpdatedAt());
    assertNotNull(updated.getUpdatedBy());
    assertEquals("admin@example.com", updated.getUpdatedBy());
}

@Test
public void testAuditFields_NoAuthentication() {
    User user = new User();
    user.setName("System User");
    user.setEmail("system@example.com");
    
    User saved = userRepository.save(user);
    
    assertEquals("system", saved.getCreatedBy());
}
```

---

## 📚 References

- [JPA Lifecycle Callbacks](https://docs.oracle.com/javaee/7/api/javax/persistence/PrePersist.html)
- [Spring Data JPA Auditing](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#auditing)
- [Spring Security Context](https://docs.spring.io/spring-security/reference/servlet/authentication/architecture.html#servlet-authentication-securitycontext)

---

**Version**: 1.0  
**Last Updated**: 2026-01-03
