# 🗄️ Database Schema Definitions

> Tài liệu này định nghĩa chi tiết schema của tất cả các bảng trong database.

---

## 📋 Nguyên Tắc Chung

### Audit Fields (Bắt buộc cho mọi entity)

Tất cả entity đều phải có các audit fields sau:

```java
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
```

### Naming Conventions
- **Table names**: snake_case, số nhiều (users, roles, permissions)
- **Column names**: snake_case
- **Foreign keys**: `{table}_id` (role_id, user_id)
- **Junction tables**: `{table1}_{table2}` (role_permission)

---

## 📊 Existing Schemas

### 1. User Table

**Table name**: `users`

```java
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

    @Column(name = "name", length = 100)
    private String name;
    
    @NotBlank(message = "Không được để trống email")
    @Column(name = "email", nullable = false, unique = true, length = 150)
    private String email;
    
    @NotBlank(message = "Không được để trống mật khẩu")
    @Column(name = "password", nullable = false)
    private String password;

    // Relationship: n User -> 1 Role
    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;

    // Audit fields (bắt buộc)
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

**Columns**:
- `id`: BIGINT, Primary Key, Auto Increment
- `name`: VARCHAR(100), Nullable
- `email`: VARCHAR(150), Not Null, Unique
- `password`: VARCHAR(255), Not Null (bcrypt hashed)
- `role_id`: BIGINT, Foreign Key -> roles(id)
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

**Indexes**:
- PRIMARY KEY: `id`
- UNIQUE INDEX: `email`
- INDEX: `role_id`

---

### 2. Role Table

**Table name**: `roles`

```java
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

    @Column(name = "name", nullable = false, unique = true, length = 50)
    private String name;
    
    @Column(name = "description", length = 255)
    private String description;
    
    @Column(name = "active", nullable = false)
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

    // Audit fields (bắt buộc)
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

**Columns**:
- `id`: BIGINT, Primary Key, Auto Increment
- `name`: VARCHAR(50), Not Null, Unique
- `description`: VARCHAR(255), Nullable
- `active`: BOOLEAN, Not Null, Default: true
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

**Indexes**:
- PRIMARY KEY: `id`
- UNIQUE INDEX: `name`

---

### 3. Permission Table

**Table name**: `permissions`

```java
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
    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "api_path", length = 255)
    private String apiPath;
    
    @Column(name = "method", length = 10)
    private String method;
    
    @Column(name = "module", length = 50)
    private String module;

    // Relationship: n Permission <-> n Role
    @ManyToMany(mappedBy = "permissions")
    private Set<Role> roles;

    // Audit fields (bắt buộc)
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

**Columns**:
- `id`: BIGINT, Primary Key, Auto Increment
- `name`: VARCHAR(100), Not Null
- `api_path`: VARCHAR(255), Nullable
- `method`: VARCHAR(10), Nullable (GET, POST, PUT, DELETE, PATCH)
- `module`: VARCHAR(50), Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

**Indexes**:
- PRIMARY KEY: `id`
- UNIQUE INDEX: `(api_path, method)`

---

### 4. Role_Permission Junction Table

**Table name**: `role_permission`

```sql
CREATE TABLE role_permission (
    role_id BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);
```

**Columns**:
- `role_id`: BIGINT, Not Null, Foreign Key -> roles(id)
- `permission_id`: BIGINT, Not Null, Foreign Key -> permissions(id)

**Indexes**:
- PRIMARY KEY: `(role_id, permission_id)`
- INDEX: `role_id`
- INDEX: `permission_id`

---

## 🔄 Entity Relationships Diagram

```
┌─────────────┐
│    User     │
│  (n User)   │
└──────┬──────┘
       │ n:1
       │
       ▼
┌─────────────┐         ┌──────────────────┐         ┌──────────────┐
│    Role     │◄───────►│ role_permission  │◄───────►│  Permission  │
│  (1 Role)   │   n:n   │  (Junction)      │   n:n   │ (n Perms)    │
└─────────────┘         └──────────────────┘         └──────────────┘
```

---

## 📝 Template Cho Entity Mới

Khi tạo entity mới, sử dụng template sau:

```java
/**
 * Generated by: {MODEL_NAME}
 * Created by: {CREATOR_NAME}
 * Created at: {TIMESTAMP}
 * Purpose: {PURPOSE_DESCRIPTION}
 */
package com.se100.GymAndPTManagement.domain.table;

import java.time.Instant;
import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import com.se100.GymAndPTManagement.util.SecurityUtil;
import lombok.*;

@Entity
@Table(name = "{table_name}")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class {EntityName} {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Entity-specific fields go here
    
    // Relationships go here
    
    // Audit fields (BẮT BUỘC)
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

## 🚨 Lưu Ý Khi Tạo Schema Mới

1. **Kiểm tra file này trước**: Đảm bảo không duplicate schema đã có
2. **Audit fields**: BẮT BUỘC có cho mọi entity
3. **Indexes**: Thêm index cho các column thường xuyên query
4. **Unique constraints**: Đặt unique cho các field cần duy nhất (email, username, etc.)
5. **Relationships**: Xác định rõ owning side và inverse side
6. **Cascade**: Cẩn thận với CascadeType, đặc biệt là REMOVE
7. **Validation**: Thêm validation annotations (@NotNull, @Size, @Email, etc.)
8. **Update document**: Sau khi tạo entity mới, cập nhật vào file này

---

**Version**: 1.0  
**Last Updated**: 2026-01-03  
**Next Review**: Khi có entity mới
