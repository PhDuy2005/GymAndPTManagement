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

| #   | Algorithm                    | File                                                                      | Description                               | Author | Date       |
| --- | ---------------------------- | ------------------------------------------------------------------------- | ----------------------------------------- | ------ | ---------- |
| 1   | Password Strength Validation | [password-strength-validation.md](./algo/password-strength-validation.md) | Validate password complexity and strength | System | 2026-01-03 |

### 🔍 Search & Filter

| #   | Algorithm       | File                                        | Description                                                          | Author | Date       |
| --- | --------------- | ------------------------------------------- | -------------------------------------------------------------------- | ------ | ---------- |
| 1   | Search & Filter | [search-filter.md](./algo/search-filter.md) | Case-insensitive search and dynamic filtering with JPA Specification | System | 2026-01-03 |

### 📄 Pagination

| #   | Algorithm  | File                                  | Description                              | Author | Date       |
| --- | ---------- | ------------------------------------- | ---------------------------------------- | ------ | ---------- |
| 1   | Pagination | [pagination.md](./algo/pagination.md) | Standard pagination with Spring Data JPA | System | 2026-01-03 |

### 🔄 Business Logic

| #   | Algorithm | File | Description                             | Author | Date |
| --- | --------- | ---- | --------------------------------------- | ------ | ---- |
| -   | -         | -    | *Chưa có thuật toán trong category này* | -      | -    |

### 🧮 Calculations

| #   | Algorithm | File | Description                             | Author | Date |
| --- | --------- | ---- | --------------------------------------- | ------ | ---- |
| -   | -         | -    | *Chưa có thuật toán trong category này* | -      | -    |

### 🛠️ Utilities

| #   | Algorithm   | File                                    | Description                                              | Author | Date       |
| --- | ----------- | --------------------------------------- | -------------------------------------------------------- | ------ | ---------- |
| 1   | Audit Trail | [audit-trail.md](./algo/audit-trail.md) | Auto-populate audit fields using JPA lifecycle callbacks | System | 2026-01-03 |

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
**Last Updated**: 2026-01-03 14:26:08  
**Maintained by**: Development Team
