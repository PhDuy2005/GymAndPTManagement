# ⚙️ Algorithms & Business Logic - Index

> File này là danh mục tổng hợp tất cả các thuật toán và business logic trong dự án. Mỗi thuật toán có file riêng trong folder `algo/`.

---

## 📋 Nguyên Tắc

### Quy Tắc Chung
1. **Kiểm tra trước khi implement**: Luôn kiểm tra danh mục này trước khi viết thuật toán mới
2. **Tái sử dụng**: Nếu đã có thuật toán tương tự, sử dụng lại thay vì viết mới
3. **Document sau khi implement**: Mọi thuật toán mới phải được document vào file riêng
4. **Clear naming**: Đặt tên file thuật toán rõ ràng, dễ tìm kiếm (kebab-case)

### Quy Trình Khi Upload Thuật Toán Mới

⚠️ **Khi người dùng upload file thuật toán**, AI agent được phép:

1. **Tạo file mới theo template**: Sử dụng [TEMPLATE.md](./algo/TEMPLATE.md)
2. **Cập nhật file index này**: Thêm link vào danh mục phù hợp
3. **Giữ nguyên file gốc**: KHÔNG chỉnh sửa file người dùng upload
4. **Review và feedback**: Nêu quan ngại về thuật toán nếu có:
   - Security issues
   - Performance problems
   - Best practice violations
   - Compatibility issues

**Format feedback**:
```markdown
## ⚠️ Review Notes - {Algorithm Name}

**Reviewer**: {AI Model Name}
**Date**: {Date}

### Concerns:
- ⚠️ {Concern 1}
- ⚠️ {Concern 2}

### Suggestions:
- 💡 {Suggestion 1}
- 💡 {Suggestion 2}

### Approval Status:
- [ ] Approved without changes
- [x] Approved with suggestions
- [ ] Needs revision
```

---

## 📚 Danh Mục Thuật Toán

### 🔐 Authentication & Authorization

| #   | Algorithm            | File                                                      | Description                                  | Author | Date       |
| --- | -------------------- | --------------------------------------------------------- | -------------------------------------------- | ------ | ---------- |
| 1   | Password Hashing     | [password-hashing.md](./algo/password-hashing.md)         | BCrypt password hashing and verification     | System | 2026-01-03 |
| 2   | JWT Token Generation | [jwt-token-generation.md](./algo/jwt-token-generation.md) | Generate access & refresh tokens using HS256 | System | 2026-01-03 |
| 3   | Permission Check     | [permission-check.md](./algo/permission-check.md)         | Check user permissions from SecurityContext  | System | 2026-01-03 |

### 📊 Data Validation

| #   | Algorithm | File | Description                             | Author | Date |
| --- | --------- | ---- | --------------------------------------- | ------ | ---- |
| -   | -         | -    | *Chưa có thuật toán trong category này* | -      | -    |

### 🔍 Search & Filter

| #   | Algorithm | File | Description                             | Author | Date |
| --- | --------- | ---- | --------------------------------------- | ------ | ---- |
| -   | -         | -    | *Chưa có thuật toán trong category này* | -      | -    |

### 📄 Pagination

| #   | Algorithm | File | Description                             | Author | Date |
| --- | --------- | ---- | --------------------------------------- | ------ | ---- |
| -   | -         | -    | *Chưa có thuật toán trong category này* | -      | -    |

### 🔄 Business Logic

| #   | Algorithm | File | Description                             | Author | Date |
| --- | --------- | ---- | --------------------------------------- | ------ | ---- |
| -   | -         | -    | *Chưa có thuật toán trong category này* | -      | -    |

### 🧮 Calculations

| #   | Algorithm | File | Description                             | Author | Date |
| --- | --------- | ---- | --------------------------------------- | ------ | ---- |
| -   | -         | -    | *Chưa có thuật toán trong category này* | -      | -    |

### 🛠️ Utilities

| #   | Algorithm | File | Description                             | Author | Date |
| --- | --------- | ---- | --------------------------------------- | ------ | ---- |
| -   | -         | -    | *Chưa có thuật toán trong category này* | -      | -    |

### 📦 Other

| #   | Algorithm | File | Description                             | Author | Date |
| --- | --------- | ---- | --------------------------------------- | ------ | ---- |
| -   | -         | -    | *Chưa có thuật toán trong category này* | -      | -    |

---

## ➕ Thêm Thuật Toán Mới

### Quy Trình

1. **Kiểm tra duplicate**: Tìm trong danh mục xem đã có thuật toán tương tự chưa
2. **Chọn category**: Xác định thuật toán thuộc category nào
3. **Tạo file mới**: 
   - Copy [TEMPLATE.md](./algo/TEMPLATE.md)
   - Đặt tên file: `{algorithm-name}.md` (kebab-case)
   - Điền đầy đủ thông tin theo template
4. **Cập nhật index**: Thêm entry vào bảng category tương ứng trong file này
5. **Ghi log**: Ghi vào [generation-log.md](../logs/generation-log.md)

### Naming Convention

**File name**: `{algorithm-name}.md`
- Sử dụng kebab-case
- Mô tả rõ ràng, ngắn gọn
- Ví dụ: `password-hashing.md`, `jwt-token-generation.md`, `email-validation.md`

---

## 🔍 Tìm Kiếm Thuật Toán

### Theo Category
- Xem bảng category tương ứng ở trên

### Theo Keyword
- Sử dụng Ctrl+F trong file này
- Hoặc search trong folder `algo/`

### Theo Use Case
- Xem mô tả (Description column) trong các bảng category

---

## 📖 Template & Guidelines

- **Template**: [algo/TEMPLATE.md](./algo/TEMPLATE.md)
- **Coding Standards**: [INSTRUCTION.md](./INSTRUCTION.md)
- **API Format**: [API_RESPONSE_FORMAT.md](./API_RESPONSE_FORMAT.md)
- **Database Schema**: [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md)

---

## 🚨 Lưu Ý Quan Trọng

1. **Không duplicate**: Kiểm tra kỹ trước khi tạo thuật toán mới
2. **Document đầy đủ**: Theo đúng template, bao gồm examples và tests
3. **Security first**: Luôn xem xét security implications
4. **Performance**: Document complexity và performance notes
5. **Maintainability**: Code phải dễ hiểu, dễ maintain
6. **Testing**: Luôn có test cases và edge cases

---

**Version**: 2.0 (Refactored)  
**Last Updated**: 2026-01-03 14:11:05  
**Maintained by**: Development Team
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
