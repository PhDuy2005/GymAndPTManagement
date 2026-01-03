# Search & Filter Algorithm

**Category**: Search & Filter  
**Algorithm**: JPA Specification & JPQL Query  
**Author**: System  
**Date**: 2026-01-03

---

## 📋 Mô Tả

Thuật toán tìm kiếm và lọc dữ liệu với nhiều criteria. Bao gồm case-insensitive search và dynamic filtering sử dụng JPA Specification pattern.

---

## 💻 Implementation

## 1️⃣ Case-insensitive Search

### Repository Method

```java
public interface UserRepository extends JpaRepository<User, Long> {
    /**
     * Search by name (case-insensitive)
     * @param name - Tên cần tìm (không phân biệt hoa thường)
     * @return List of matching entities
     */
    @Query("SELECT u FROM User u WHERE LOWER(u.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<User> searchByNameIgnoreCase(@Param("name") String name);
    
    /**
     * With pagination
     */
    @Query("SELECT u FROM User u WHERE LOWER(u.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    Page<User> searchByNameIgnoreCase(@Param("name") String name, Pageable pageable);
}
```

### Service Layer

```java
public List<User> searchUsers(String keyword) {
    if (keyword == null || keyword.trim().isEmpty()) {
        return Collections.emptyList();
    }
    
    return userRepository.searchByNameIgnoreCase(keyword);
}
```

---

## 2️⃣ Multiple Criteria Filter (AND Logic)

### Filter Criteria DTO

```java
@Data
public class UserFilterCriteria {
    private String name;
    private String email;
    private String roleName;
    private Boolean active;
    private Instant createdAfter;
    private Instant createdBefore;
}
```

### Specification Implementation

```java
public class UserSpecification {
    
    public static Specification<User> hasName(String name) {
        return (root, query, criteriaBuilder) -> {
            if (name == null || name.isEmpty()) {
                return criteriaBuilder.conjunction();
            }
            return criteriaBuilder.like(
                criteriaBuilder.lower(root.get("name")), 
                "%" + name.toLowerCase() + "%"
            );
        };
    }
    
    public static Specification<User> hasEmail(String email) {
        return (root, query, criteriaBuilder) -> {
            if (email == null || email.isEmpty()) {
                return criteriaBuilder.conjunction();
            }
            return criteriaBuilder.like(
                criteriaBuilder.lower(root.get("email")), 
                "%" + email.toLowerCase() + "%"
            );
        };
    }
    
    public static Specification<User> hasRoleName(String roleName) {
        return (root, query, criteriaBuilder) -> {
            if (roleName == null || roleName.isEmpty()) {
                return criteriaBuilder.conjunction();
            }
            return criteriaBuilder.equal(
                root.get("role").get("name"), 
                roleName
            );
        };
    }
    
    public static Specification<User> isActive(Boolean active) {
        return (root, query, criteriaBuilder) -> {
            if (active == null) {
                return criteriaBuilder.conjunction();
            }
            return criteriaBuilder.equal(root.get("active"), active);
        };
    }
    
    public static Specification<User> createdAfter(Instant date) {
        return (root, query, criteriaBuilder) -> {
            if (date == null) {
                return criteriaBuilder.conjunction();
            }
            return criteriaBuilder.greaterThanOrEqualTo(root.get("createdAt"), date);
        };
    }
    
    public static Specification<User> createdBefore(Instant date) {
        return (root, query, criteriaBuilder) -> {
            if (date == null) {
                return criteriaBuilder.conjunction();
            }
            return criteriaBuilder.lessThanOrEqualTo(root.get("createdAt"), date);
        };
    }
}
```

### Repository with Specification

```java
public interface UserRepository extends JpaRepository<User, Long>, 
                                        JpaSpecificationExecutor<User> {
    // JpaSpecificationExecutor provides findAll(Specification) method
}
```

### Service Layer

```java
/**
 * Filter with multiple criteria using Specification
 */
public Page<User> filterUsers(UserFilterCriteria criteria, Pageable pageable) {
    Specification<User> spec = Specification.where(null);
    
    spec = spec.and(UserSpecification.hasName(criteria.getName()));
    spec = spec.and(UserSpecification.hasEmail(criteria.getEmail()));
    spec = spec.and(UserSpecification.hasRoleName(criteria.getRoleName()));
    spec = spec.and(UserSpecification.isActive(criteria.getActive()));
    spec = spec.and(UserSpecification.createdAfter(criteria.getCreatedAfter()));
    spec = spec.and(UserSpecification.createdBefore(criteria.getCreatedBefore()));
    
    return userRepository.findAll(spec, pageable);
}

/**
 * Alternative: Compact version
 */
public Page<User> filterUsersCompact(UserFilterCriteria criteria, Pageable pageable) {
    Specification<User> spec = Specification.where(UserSpecification.hasName(criteria.getName()))
        .and(UserSpecification.hasEmail(criteria.getEmail()))
        .and(UserSpecification.hasRoleName(criteria.getRoleName()))
        .and(UserSpecification.isActive(criteria.getActive()))
        .and(UserSpecification.createdAfter(criteria.getCreatedAfter()))
        .and(UserSpecification.createdBefore(criteria.getCreatedBefore()));
    
    return userRepository.findAll(spec, pageable);
}
```

### Controller Layer

```java
@GetMapping("/users/filter")
public ResponseEntity<RestResponse<Page<ResUserDTO>>> filterUsers(
    @RequestParam(required = false) String name,
    @RequestParam(required = false) String email,
    @RequestParam(required = false) String roleName,
    @RequestParam(required = false) Boolean active,
    @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant createdAfter,
    @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant createdBefore,
    @RequestParam(defaultValue = "1") int page,
    @RequestParam(defaultValue = "20") int size
) {
    UserFilterCriteria criteria = new UserFilterCriteria();
    criteria.setName(name);
    criteria.setEmail(email);
    criteria.setRoleName(roleName);
    criteria.setActive(active);
    criteria.setCreatedAfter(createdAfter);
    criteria.setCreatedBefore(createdBefore);
    
    Pageable pageable = PageRequest.of(page - 1, size);
    Page<User> userPage = userService.filterUsers(criteria, pageable);
    Page<ResUserDTO> dtoPage = userPage.map(this::convertToDTO);
    
    return ResponseEntity.ok(new RestResponse<>(
        HttpStatus.OK.value(),
        null,
        dtoPage
    ));
}
```

---

## 📝 Usage Examples

### Simple Search

```bash
# Search by name
GET /api/v1/users/search?keyword=nguyen

# Case insensitive
GET /api/v1/users/search?keyword=NGUYEN
# Returns same results as lowercase
```

### Multiple Criteria Filter

```bash
# Filter by name only
GET /api/v1/users/filter?name=nguyen

# Filter by name and email
GET /api/v1/users/filter?name=nguyen&email=gmail.com

# Filter by role and active status
GET /api/v1/users/filter?roleName=ADMIN&active=true

# Filter by date range
GET /api/v1/users/filter?createdAfter=2026-01-01T00:00:00Z&createdBefore=2026-01-31T23:59:59Z

# Combine all filters with pagination
GET /api/v1/users/filter?name=nguyen&roleName=USER&active=true&page=1&size=20
```

---

## 📊 Generated SQL Examples

### Case-insensitive Search

```sql
SELECT u.* 
FROM users u 
WHERE LOWER(u.name) LIKE LOWER('%nguyen%');
```

### Multiple Criteria Filter

```sql
SELECT u.* 
FROM users u 
LEFT JOIN roles r ON u.role_id = r.id
WHERE LOWER(u.name) LIKE LOWER('%nguyen%')
  AND LOWER(u.email) LIKE LOWER('%gmail%')
  AND r.name = 'ADMIN'
  AND u.active = true
  AND u.created_at >= '2026-01-01 00:00:00'
  AND u.created_at <= '2026-01-31 23:59:59'
ORDER BY u.id
LIMIT 20 OFFSET 0;
```

---

## ⏱️ Performance Considerations

### Indexing

```sql
-- Index for name search
CREATE INDEX idx_users_name ON users(name);

-- Index for email search
CREATE INDEX idx_users_email ON users(email);

-- Index for created_at range queries
CREATE INDEX idx_users_created_at ON users(created_at);

-- Composite index for common filter combinations
CREATE INDEX idx_users_role_active ON users(role_id, active);
```

### Query Optimization

- ✅ **Use LIKE carefully**: Only add `%` at start if needed (impacts index usage)
- ✅ **Index foreign keys**: Ensure join columns (e.g., role_id) are indexed
- ✅ **Limit result size**: Always use pagination for large datasets
- ⚠️ **Avoid N+1 queries**: Use JOIN FETCH for related entities if needed

---

## 🚨 Edge Cases

- **Empty/null criteria**: Return all results (respecting pagination)
- **Invalid date range**: createdAfter > createdBefore - validate in service layer
- **Special characters in search**: Need to escape LIKE wildcards (%, _)
- **SQL injection**: Use parameterized queries (handled by JPA)
- **Unicode characters**: Ensure database collation supports unicode search

---

## 🧪 Testing

```java
@Test
public void testSearchByName_CaseInsensitive() {
    List<User> results = userRepository.searchByNameIgnoreCase("NGUYEN");
    
    assertFalse(results.isEmpty());
    results.forEach(user -> 
        assertTrue(user.getName().toLowerCase().contains("nguyen")));
}

@Test
public void testFilter_Multiplecriteria() {
    UserFilterCriteria criteria = new UserFilterCriteria();
    criteria.setName("nguyen");
    criteria.setRoleName("USER");
    criteria.setActive(true);
    
    Page<User> page = userService.filterUsers(criteria, PageRequest.of(0, 10));
    
    page.getContent().forEach(user -> {
        assertTrue(user.getName().toLowerCase().contains("nguyen"));
        assertEquals("USER", user.getRole().getName());
        assertTrue(user.getActive());
    });
}

@Test
public void testFilter_DateRange() {
    Instant start = Instant.parse("2026-01-01T00:00:00Z");
    Instant end = Instant.parse("2026-01-31T23:59:59Z");
    
    UserFilterCriteria criteria = new UserFilterCriteria();
    criteria.setCreatedAfter(start);
    criteria.setCreatedBefore(end);
    
    Page<User> page = userService.filterUsers(criteria, PageRequest.of(0, 10));
    
    page.getContent().forEach(user -> {
        assertTrue(user.getCreatedAt().isAfter(start) || user.getCreatedAt().equals(start));
        assertTrue(user.getCreatedAt().isBefore(end) || user.getCreatedAt().equals(end));
    });
}
```

---

## 📚 References

- [JPA Specification](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#specifications)
- [JPQL Query Methods](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods)
- [CriteriaBuilder API](https://docs.oracle.com/javaee/7/api/javax/persistence/criteria/CriteriaBuilder.html)

---

**Version**: 1.0  
**Last Updated**: 2026-01-03
