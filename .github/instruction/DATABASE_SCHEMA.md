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

## 📊 Complete Database Schema

### 5. Member Table

**Table name**: `members`

```java
@Entity
@Table(name = "members")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Member {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private Long memberId;

    // Relationship: 1:1 with User
    @OneToOne
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(name = "cccd", length = 12, unique = true)
    private String cccd;

    @Column(name = "money_spent", precision = 15, scale = 2)
    private BigDecimal moneySpent;

    @Column(name = "money_debt", precision = 15, scale = 2)
    private BigDecimal moneyDebt;

    @Column(name = "join_date")
    private LocalDate joinDate;

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
- `member_id`: BIGINT, Primary Key, Auto Increment
- `user_id`: BIGINT, Not Null, Unique, Foreign Key -> users(id)
- `cccd`: VARCHAR(12), Unique, Nullable
- `money_spent`: DECIMAL(15,2), Nullable
- `money_debt`: DECIMAL(15,2), Nullable
- `join_date`: DATE, Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 6. Personal Trainer Table

**Table name**: `personal_trainers`

```java
@Entity
@Table(name = "personal_trainers")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PersonalTrainer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "pt_id")
    private Long ptId;

    // Relationship: 1:1 with User
    @OneToOne
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(name = "about", columnDefinition = "TEXT")
    private String about;

    @Column(name = "specialization", length = 255)
    private String specialization;

    @Column(name = "certifications", columnDefinition = "TEXT")
    private String certifications;

    @Column(name = "experience_years")
    private Integer experienceYears;

    @Column(name = "rating", precision = 3, scale = 2)
    private BigDecimal rating;

    @Column(name = "status", length = 50)
    private String status;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

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
- `pt_id`: BIGINT, Primary Key, Auto Increment
- `user_id`: BIGINT, Not Null, Unique, Foreign Key -> users(id)
- `about`: TEXT, Nullable
- `specialization`: VARCHAR(255), Nullable
- `certifications`: TEXT, Nullable
- `experience_years`: INT, Nullable
- `rating`: DECIMAL(3,2), Nullable
- `status`: VARCHAR(50), Nullable
- `note`: TEXT, Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 7. Service Package Table

**Table name**: `service_packages`

```java
@Entity
@Table(name = "service_packages")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ServicePackage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "package_id")
    private Long packageId;

    @Column(name = "package_name", nullable = false, length = 255)
    private String packageName;

    @Column(name = "price", nullable = false, precision = 15, scale = 2)
    private BigDecimal price;

    @Column(name = "type", length = 50)
    private String type;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

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
        if (isActive == null) {
            isActive = true;
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
- `package_id`: BIGINT, Primary Key, Auto Increment
- `package_name`: VARCHAR(255), Not Null
- `price`: DECIMAL(15,2), Not Null
- `type`: VARCHAR(50), Nullable
- `is_active`: BOOLEAN, Not Null, Default: true
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 8. Additional Service Table

**Table name**: `additional_services`

```java
@Entity
@Table(name = "additional_services")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AdditionalService {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "additional_service_id")
    private Long additionalServiceId;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "cost_price", precision = 15, scale = 2)
    private BigDecimal costPrice;

    @Column(name = "suggest_sell_price", precision = 15, scale = 2)
    private BigDecimal suggestSellPrice;

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
- `additional_service_id`: BIGINT, Primary Key, Auto Increment
- `name`: VARCHAR(255), Not Null
- `cost_price`: DECIMAL(15,2), Nullable
- `suggest_sell_price`: DECIMAL(15,2), Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 9. Contract Table

**Table name**: `contracts`

```java
@Entity
@Table(name = "contracts")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Contract {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "contract_id")
    private Long contractId;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @ManyToOne
    @JoinColumn(name = "package_id", nullable = false)
    private ServicePackage servicePackage;

    @ManyToOne
    @JoinColumn(name = "main_pt_id")
    private PersonalTrainer mainPt;

    @Column(name = "start_date")
    private Instant startDate;

    @Column(name = "end_date")
    private Instant endDate;

    @Column(name = "status", length = 50)
    private String status;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "signed_at")
    private Instant signedAt;

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
- `contract_id`: BIGINT, Primary Key, Auto Increment
- `member_id`: BIGINT, Not Null, Foreign Key -> members(member_id)
- `package_id`: BIGINT, Not Null, Foreign Key -> service_packages(package_id)
- `main_pt_id`: BIGINT, Nullable, Foreign Key -> personal_trainers(pt_id)
- `start_date`: TIMESTAMP, Nullable
- `end_date`: TIMESTAMP, Nullable
- `status`: VARCHAR(50), Nullable
- `notes`: TEXT, Nullable
- `signed_at`: TIMESTAMP, Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 10. Slot Table

**Table name**: `slots`

```java
@Entity
@Table(name = "slots")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Slot {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "slot_id")
    private Long slotId;

    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalTime endTime;

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
- `slot_id`: BIGINT, Primary Key, Auto Increment
- `start_time`: TIME, Not Null
- `end_time`: TIME, Not Null
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 11. Available Slot Table

**Table name**: `available_slots`

```java
@Entity
@Table(name = "available_slots")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AvailableSlot {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "available_slot_id")
    private Long availableSlotId;

    @ManyToOne
    @JoinColumn(name = "pt_id", nullable = false)
    private PersonalTrainer personalTrainer;

    @ManyToOne
    @JoinColumn(name = "slot_id", nullable = false)
    private Slot slot;

    @Column(name = "day_of_week", length = 20)
    private String dayOfWeek;

    @Column(name = "is_available", nullable = false)
    private Boolean isAvailable;

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
        if (isAvailable == null) {
            isAvailable = true;
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
- `available_slot_id`: BIGINT, Primary Key, Auto Increment
- `pt_id`: BIGINT, Not Null, Foreign Key -> personal_trainers(pt_id)
- `slot_id`: BIGINT, Not Null, Foreign Key -> slots(slot_id)
- `day_of_week`: VARCHAR(20), Nullable
- `is_available`: BOOLEAN, Not Null, Default: true
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 12. Booking Table

**Table name**: `bookings`

```java
@Entity
@Table(name = "bookings")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "booking_id")
    private Long bookingId;

    @ManyToOne
    @JoinColumn(name = "contract_id", nullable = false)
    private Contract contract;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @ManyToOne
    @JoinColumn(name = "real_pt_id")
    private PersonalTrainer realPt;

    @ManyToOne
    @JoinColumn(name = "slot_id", nullable = false)
    private Slot slot;

    @Column(name = "booking_date", nullable = false)
    private LocalDate bookingDate;

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
- `booking_id`: BIGINT, Primary Key, Auto Increment
- `contract_id`: BIGINT, Not Null, Foreign Key -> contracts(contract_id)
- `member_id`: BIGINT, Not Null, Foreign Key -> members(member_id)
- `real_pt_id`: BIGINT, Nullable, Foreign Key -> personal_trainers(pt_id)
- `slot_id`: BIGINT, Not Null, Foreign Key -> slots(slot_id)
- `booking_date`: DATE, Not Null
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 13. Check-in Log Table

**Table name**: `checkin_logs`

```java
@Entity
@Table(name = "checkin_logs")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CheckinLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "checkin_id")
    private Long checkinId;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @ManyToOne
    @JoinColumn(name = "booking_id")
    private Booking booking;

    @Column(name = "checkin_time")
    private LocalTime checkinTime;

    @Column(name = "checkout_time")
    private LocalTime checkoutTime;

    @Column(name = "status", length = 50)
    private String status;

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
- `checkin_id`: BIGINT, Primary Key, Auto Increment
- `member_id`: BIGINT, Not Null, Foreign Key -> members(member_id)
- `booking_id`: BIGINT, Nullable, Foreign Key -> bookings(booking_id)
- `checkin_time`: TIME, Nullable
- `checkout_time`: TIME, Nullable
- `status`: VARCHAR(50), Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 14. Body Metrics Table

**Table name**: `body_metrics`

```java
@Entity
@Table(name = "body_metrics")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BodyMetrics {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "metric_id")
    private Long metricId;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(name = "measured_date", nullable = false)
    private LocalDate measuredDate;

    @Column(name = "weight", precision = 5, scale = 2)
    private BigDecimal weight;

    @Column(name = "height", precision = 5, scale = 2)
    private BigDecimal height;

    @Column(name = "muscle_mass", precision = 5, scale = 2)
    private BigDecimal muscleMass;

    @Column(name = "body_fat_percentage", precision = 5, scale = 2)
    private BigDecimal bodyFatPercentage;

    @Column(name = "bmi", precision = 5, scale = 2)
    private BigDecimal bmi;

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
- `metric_id`: BIGINT, Primary Key, Auto Increment
- `member_id`: BIGINT, Not Null, Foreign Key -> members(member_id)
- `measured_date`: DATE, Not Null
- `weight`: DECIMAL(5,2), Nullable
- `height`: DECIMAL(5,2), Nullable
- `muscle_mass`: DECIMAL(5,2), Nullable
- `body_fat_percentage`: DECIMAL(5,2), Nullable
- `bmi`: DECIMAL(5,2), Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 15. Invoice Table

**Table name**: `invoices`

```java
@Entity
@Table(name = "invoices")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "invoice_id")
    private Long invoiceId;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(name = "total_amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "discount_amount", precision = 15, scale = 2)
    private BigDecimal discountAmount;

    @Column(name = "final_amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal finalAmount;

    @Column(name = "payment_method", length = 50)
    private String paymentMethod;

    @Column(name = "payment_status", length = 50)
    private String paymentStatus;

    @Column(name = "status", length = 50)
    private String status;

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
- `invoice_id`: BIGINT, Primary Key, Auto Increment
- `member_id`: BIGINT, Not Null, Foreign Key -> members(member_id)
- `total_amount`: DECIMAL(15,2), Not Null
- `discount_amount`: DECIMAL(15,2), Nullable
- `final_amount`: DECIMAL(15,2), Not Null
- `payment_method`: VARCHAR(50), Nullable
- `payment_status`: VARCHAR(50), Nullable
- `status`: VARCHAR(50), Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 16. Invoice Detail Table

**Table name**: `invoice_details`

```java
@Entity
@Table(name = "invoice_details")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvoiceDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "detail_id")
    private Long detailId;

    @ManyToOne
    @JoinColumn(name = "invoice_id", nullable = false)
    private Invoice invoice;

    @ManyToOne
    @JoinColumn(name = "service_id")
    private ServicePackage servicePackage;

    @ManyToOne
    @JoinColumn(name = "additional_service_id")
    private AdditionalService additionalService;

    @Column(name = "quantity", nullable = false)
    private Integer quantity;

    @Column(name = "unit_price", nullable = false, precision = 15, scale = 2)
    private BigDecimal unitPrice;

    @Column(name = "total_amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal totalAmount;

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
- `detail_id`: BIGINT, Primary Key, Auto Increment
- `invoice_id`: BIGINT, Not Null, Foreign Key -> invoices(invoice_id)
- `service_id`: BIGINT, Nullable, Foreign Key -> service_packages(package_id)
- `additional_service_id`: BIGINT, Nullable, Foreign Key -> additional_services(additional_service_id)
- `quantity`: INT, Not Null
- `unit_price`: DECIMAL(15,2), Not Null
- `total_amount`: DECIMAL(15,2), Not Null
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 17. Daily Diet Table

**Table name**: `daily_diets`

```java
@Entity
@Table(name = "daily_diets")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DailyDiet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "diet_id")
    private Long dietId;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @ManyToOne
    @JoinColumn(name = "pt_id")
    private PersonalTrainer personalTrainer;

    @Column(name = "diet_date", nullable = false)
    private LocalDate dietDate;

    @Column(name = "water_liters", precision = 4, scale = 2)
    private BigDecimal waterLiters;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

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
- `diet_id`: BIGINT, Primary Key, Auto Increment
- `member_id`: BIGINT, Not Null, Foreign Key -> members(member_id)
- `pt_id`: BIGINT, Nullable, Foreign Key -> personal_trainers(pt_id)
- `diet_date`: DATE, Not Null
- `water_liters`: DECIMAL(4,2), Nullable
- `note`: TEXT, Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 18. Food Table

**Table name**: `foods`

```java
@Entity
@Table(name = "foods")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Food {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "food_id")
    private Long foodId;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "calories", precision = 8, scale = 2)
    private BigDecimal calories;

    @Column(name = "protein_g", precision = 8, scale = 2)
    private BigDecimal proteinG;

    @Column(name = "carbs_g", precision = 8, scale = 2)
    private BigDecimal carbsG;

    @Column(name = "fat_g", precision = 8, scale = 2)
    private BigDecimal fatG;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

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
- `food_id`: BIGINT, Primary Key, Auto Increment
- `name`: VARCHAR(255), Not Null
- `description`: TEXT, Nullable
- `calories`: DECIMAL(8,2), Nullable
- `protein_g`: DECIMAL(8,2), Nullable
- `carbs_g`: DECIMAL(8,2), Nullable
- `fat_g`: DECIMAL(8,2), Nullable
- `note`: TEXT, Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 19. Diet Detail Table

**Table name**: `diet_details`

```java
@Entity
@Table(name = "diet_details")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@IdClass(DietDetailId.class)
public class DietDetail {
    @Id
    @Column(name = "diet_id")
    private Long dietId;

    @Id
    @Column(name = "food_id")
    private Long foodId;

    @ManyToOne
    @JoinColumn(name = "diet_id", insertable = false, updatable = false)
    private DailyDiet dailyDiet;

    @ManyToOne
    @JoinColumn(name = "food_id", insertable = false, updatable = false)
    private Food food;

    @Column(name = "prep_method", length = 255)
    private String prepMethod;

    @Column(name = "amount", precision = 8, scale = 2)
    private BigDecimal amount;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

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

// Composite Primary Key Class
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DietDetailId implements Serializable {
    private Long dietId;
    private Long foodId;
}
```

**Columns**:
- `diet_id`: BIGINT, Primary Key, Foreign Key -> daily_diets(diet_id)
- `food_id`: BIGINT, Primary Key, Foreign Key -> foods(food_id)
- `prep_method`: VARCHAR(255), Nullable
- `amount`: DECIMAL(8,2), Nullable
- `note`: TEXT, Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 20. Workout Device Table

**Table name**: `workout_devices`

```java
@Entity
@Table(name = "workout_devices")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WorkoutDevice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "device_id")
    private Long deviceId;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "type", length = 100)
    private String type;

    @Column(name = "price", precision = 15, scale = 2)
    private BigDecimal price;

    @Column(name = "date_imported")
    private LocalDate dateImported;

    @Column(name = "date_maintenance")
    private LocalDate dateMaintenance;

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
- `device_id`: BIGINT, Primary Key, Auto Increment
- `name`: VARCHAR(255), Not Null
- `type`: VARCHAR(100), Nullable
- `price`: DECIMAL(15,2), Nullable
- `date_imported`: DATE, Nullable
- `date_maintenance`: DATE, Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 21. Workout Table

**Table name**: `workouts`

```java
@Entity
@Table(name = "workouts")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Workout {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "workout_id")
    private Long workoutId;

    @ManyToOne
    @JoinColumn(name = "pt_id")
    private PersonalTrainer personalTrainer;

    @ManyToOne
    @JoinColumn(name = "device_id")
    private WorkoutDevice workoutDevice;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

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
- `workout_id`: BIGINT, Primary Key, Auto Increment
- `pt_id`: BIGINT, Nullable, Foreign Key -> personal_trainers(pt_id)
- `device_id`: BIGINT, Nullable, Foreign Key -> workout_devices(device_id)
- `name`: VARCHAR(255), Not Null
- `description`: TEXT, Nullable
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

### 22. Workout Image Table

**Table name**: `workout_images`

```java
@Entity
@Table(name = "workout_images")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WorkoutImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "image_id")
    private Long imageId;

    @ManyToOne
    @JoinColumn(name = "workout_id", nullable = false)
    private Workout workout;

    @Column(name = "image_url", nullable = false, length = 500)
    private String imageUrl;

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
- `image_id`: BIGINT, Primary Key, Auto Increment
- `workout_id`: BIGINT, Not Null, Foreign Key -> workouts(workout_id)
- `image_url`: VARCHAR(500), Not Null
- `created_at`: TIMESTAMP, Not Null
- `updated_at`: TIMESTAMP, Nullable
- `created_by`: VARCHAR(100), Nullable
- `updated_by`: VARCHAR(100), Nullable

---

## 🔄 Complete Entity Relationships Diagram

```
                         ┌─────────────┐
                         │    Role     │
                         └──────┬──────┘
                                │ n:1
                                ▼
┌─────────────┐         ┌─────────────┐
│    User     │◄────────┤  Permission │
│             │  n:n    │             │
└──────┬──────┘ (role_  └─────────────┘
       │        permission)
       │ 1:1
       ├────────────────────────────┐
       │                            │
       ▼                            ▼
┌─────────────┐            ┌──────────────────┐
│   Member    │            │ Personal Trainer │
└──────┬──────┘            └────────┬─────────┘
       │                            │
       │                            │
       │                            │
       │ n:1      ┌────────┐   1:n │
       ├─────────►│Contract│◄──────┤
       │          └────┬───┘        │
       │               │            │
       │               │ 1:n        │
       │               ▼            │
       │          ┌────────┐        │
       │          │Booking │◄───────┤
       │          └────┬───┘        │
       │ 1:n           │            │
       ├──────────┐    │ 1:n        │
       │          │    ▼            │
       │    ┌─────┴────────┐        │
       │    │ Checkin Log  │        │
       │    └──────────────┘        │
       │                            │
       │ 1:n                   1:n  │
       ├──────────┐          ┌──────┴──────┐
       ▼          ▼          ▼             ▼
┌──────────┐ ┌──────────┐ ┌────────┐ ┌────────────┐
│Body      │ │ Invoice  │ │Daily   │ │Available   │
│Metrics   │ │          │ │Diet    │ │Slot        │
└──────────┘ └────┬─────┘ └────┬───┘ └────────────┘
                  │            │
                  │ 1:n   n:n  │
                  ▼            ▼
           ┌─────────────┐ ┌──────┐
           │Invoice      │ │Diet  │
           │Detail       │ │Detail│
           └─────────────┘ └──────┘
```

---

**Version**: 2.0  
**Last Updated**: 2026-01-07  
**Next Review**: Khi có entity mới
