# ServicePackageController Documentation

> **Controller**: `com.se100.GymAndPTManagement.controller.ServicePackageController`  
> **Base URL**: `/api/v1/service-packages`  
> **Purpose**: Quản lý các gói dịch vụ (Service Package) của phòng gym

---

## 📋 Tổng Quan

Controller này cung cấp các endpoint để quản lý thông tin gói dịch vụ, bao gồm:
- Tạo gói dịch vụ mới
- Xem thông tin gói dịch vụ
- Cập nhật thông tin gói dịch vụ
- Xóa gói dịch vụ (soft delete)
- Tìm kiếm và lọc gói dịch vụ
- Quản lý trạng thái gói dịch vụ (Active/Inactive)

---

## 🔗 Related Files

- **Entity**: `src/main/java/com/se100/GymAndPTManagement/domain/table/ServicePackage.java`
- **Service**: `src/main/java/com/se100/GymAndPTManagement/service/ServicePackageService.java`
- **Repository**: `src/main/java/com/se100/GymAndPTManagement/repository/ServicePackageRepository.java`

---

## 📝 Entity Structure

### ServicePackage Entity Fields
- `id` (Long): Primary key (package_id trong database)
- `packageName` (String): Tên gói dịch vụ (255 ký tự, unique, required)
- `price` (BigDecimal): Giá gói (15,2) (required, >= 0, default: 0)
- `type` (PackageTypeEnum): Loại gói (PT_INCLUDED, NO_PT) (required)
- `isActive` (Boolean): Trạng thái hoạt động (required, default: true)
- Audit fields: `createdAt`, `updatedAt`, `createdBy`, `updatedBy`

### PackageTypeEnum
- `PT_INCLUDED`: Gói bao gồm Personal Trainer
- `NO_PT`: Gói không bao gồm Personal Trainer

---

## 📍 API Endpoints

### 1. Tạo Gói Dịch Vụ Mới

**POST** `/api/v1/service-packages`

#### Request Body
```json
{
  "packageName": "VIP 12 tháng",
  "price": 15000000,
  "type": "PT_INCLUDED",
  "isActive": true
}
```

#### Request Fields
| Field       | Type            | Required | Validation                   | Description                  |
| ----------- | --------------- | -------- | ---------------------------- | ---------------------------- |
| packageName | String          | Yes      | @NotBlank                    | Tên gói dịch vụ              |
| price       | BigDecimal      | Yes      | @NotNull, @DecimalMin("0.0") | Giá gói (>= 0)               |
| type        | PackageTypeEnum | Yes      | @NotNull                     | Loại gói (PT_INCLUDED/NO_PT) |
| isActive    | Boolean         | No       | -                            | Trạng thái (default: true)   |

#### Response (201 Created)
```json
{
  "id": 1,
  "packageName": "VIP 12 tháng",
  "price": 15000000.00,
  "type": "PT_INCLUDED",
  "isActive": true,
  "createdAt": "2026-01-11T09:30:43Z",
  "updatedAt": null,
  "createdBy": "admin",
  "updatedBy": null
}
```

#### Business Logic
- Package name phải unique trong hệ thống
- Nếu isActive không được cung cấp, mặc định là `true`
- Nếu price không được cung cấp, mặc định là `0`
- Tự động ghi nhận `createdAt` và `createdBy`

#### Error Cases
- **400**: Package name đã tồn tại
- **400**: Validation errors (missing required fields, invalid price)

---

### 2. Lấy Tất Cả Gói Dịch Vụ

**GET** `/api/v1/service-packages`

#### Response (200 OK)
```json
[
  {
    "id": 1,
    "packageName": "VIP 12 tháng",
    "price": 15000000.00,
    "type": "PT_INCLUDED",
    "isActive": true,
    "createdAt": "2026-01-11T09:30:43Z",
    "updatedAt": null,
    "createdBy": "admin",
    "updatedBy": null
  },
  {
    "id": 2,
    "packageName": "Basic 6 tháng",
    "price": 5000000.00,
    "type": "NO_PT",
    "isActive": false,
    "createdAt": "2026-01-10T08:20:15Z",
    "updatedAt": "2026-01-11T10:00:00Z",
    "createdBy": "admin",
    "updatedBy": "admin"
  }
]
```

#### Business Logic
- Trả về tất cả gói dịch vụ (bao gồm cả inactive)
- Kết quả không phân trang (có thể thêm pagination sau)

---

### 3. Lấy Tất Cả Gói Dịch Vụ Đang Hoạt Động

**GET** `/api/v1/service-packages/active`

#### Response (200 OK)
```json
[
  {
    "id": 1,
    "packageName": "VIP 12 tháng",
    "price": 15000000.00,
    "type": "PT_INCLUDED",
    "isActive": true,
    "createdAt": "2026-01-11T09:30:43Z",
    "updatedAt": null,
    "createdBy": "admin",
    "updatedBy": null
  }
]
```

#### Business Logic
- Chỉ trả về các gói có `isActive = true`
- Hữu ích cho việc hiển thị gói cho khách hàng

---

### 4. Lấy Gói Dịch Vụ Theo Loại

**GET** `/api/v1/service-packages/type/{type}`

#### URL Parameters
| Parameter | Type            | Required | Description                       |
| --------- | --------------- | -------- | --------------------------------- |
| type      | PackageTypeEnum | Yes      | Loại gói (PT_INCLUDED hoặc NO_PT) |

#### Query Parameters
| Parameter  | Type    | Required | Default | Description                |
| ---------- | ------- | -------- | ------- | -------------------------- |
| activeOnly | boolean | No       | false   | Chỉ lấy gói đang hoạt động |

#### Examples
```http
GET /api/v1/service-packages/type/PT_INCLUDED
GET /api/v1/service-packages/type/PT_INCLUDED?activeOnly=true
GET /api/v1/service-packages/type/NO_PT?activeOnly=false
```

#### Response (200 OK)
```json
[
  {
    "id": 1,
    "packageName": "VIP 12 tháng",
    "price": 15000000.00,
    "type": "PT_INCLUDED",
    "isActive": true,
    "createdAt": "2026-01-11T09:30:43Z",
    "updatedAt": null,
    "createdBy": "admin",
    "updatedBy": null
  }
]
```

#### Business Logic
- Nếu `activeOnly=true`: Chỉ trả về gói có `isActive=true`
- Nếu `activeOnly=false`: Trả về tất cả gói của loại đó

---

### 5. Lấy Gói Dịch Vụ Theo ID

**GET** `/api/v1/service-packages/{id}`

#### URL Parameters
| Parameter | Type | Required | Description        |
| --------- | ---- | -------- | ------------------ |
| id        | Long | Yes      | ID của gói dịch vụ |

#### Example
```http
GET /api/v1/service-packages/1
```

#### Response (200 OK)
```json
{
  "id": 1,
  "packageName": "VIP 12 tháng",
  "price": 15000000.00,
  "type": "PT_INCLUDED",
  "isActive": true,
  "createdAt": "2026-01-11T09:30:43Z",
  "updatedAt": null,
  "createdBy": "admin",
  "updatedBy": null
}
```

#### Error Cases
- **400**: Service package not found with ID: {id}

---

### 6. Tìm Kiếm Gói Dịch Vụ Theo Tên

**GET** `/api/v1/service-packages/search`

#### Query Parameters
| Parameter   | Type   | Required | Description                           |
| ----------- | ------ | -------- | ------------------------------------- |
| packageName | String | Yes      | Tên gói dịch vụ cần tìm (exact match) |

#### Example
```http
GET /api/v1/service-packages/search?packageName=VIP%2012%20tháng
```

#### Response (200 OK)
```json
{
  "id": 1,
  "packageName": "VIP 12 tháng",
  "price": 15000000.00,
  "type": "PT_INCLUDED",
  "isActive": true,
  "createdAt": "2026-01-11T09:30:43Z",
  "updatedAt": null,
  "createdBy": "admin",
  "updatedBy": null
}
```

#### Business Logic
- Tìm kiếm exact match (không phải partial search)
- packageName là required parameter

#### Error Cases
- **400**: Package name is required
- **400**: Service package not found with name: {packageName}

---

### 7. Cập Nhật Gói Dịch Vụ

**PUT** `/api/v1/service-packages/{id}`

#### URL Parameters
| Parameter | Type | Required | Description        |
| --------- | ---- | -------- | ------------------ |
| id        | Long | Yes      | ID của gói dịch vụ |

#### Request Body (Tất cả fields đều optional)
```json
{
  "packageName": "VIP Plus 12 tháng",
  "price": 18000000,
  "type": "PT_INCLUDED",
  "isActive": true
}
```

#### Request Fields
| Field       | Type            | Required | Validation         | Description    |
| ----------- | --------------- | -------- | ------------------ | -------------- |
| packageName | String          | No       | -                  | Tên gói mới    |
| price       | BigDecimal      | No       | @DecimalMin("0.0") | Giá mới (>= 0) |
| type        | PackageTypeEnum | No       | -                  | Loại gói mới   |
| isActive    | Boolean         | No       | -                  | Trạng thái mới |

#### Response (200 OK)
```json
{
  "id": 1,
  "packageName": "VIP Plus 12 tháng",
  "price": 18000000.00,
  "type": "PT_INCLUDED",
  "isActive": true,
  "createdAt": "2026-01-11T09:30:43Z",
  "updatedAt": "2026-01-11T10:15:20Z",
  "createdBy": "admin",
  "updatedBy": "admin"
}
```

#### Business Logic
- Chỉ update các fields được cung cấp
- Nếu packageName thay đổi, kiểm tra uniqueness (không được trùng với gói khác)
- Tự động update `updatedAt` và `updatedBy`

#### Error Cases
- **400**: Service package not found with ID: {id}
- **400**: Package name already exists: {packageName} (khi đổi tên trùng)
- **400**: Validation errors (invalid price)

---

### 8. Xóa Gói Dịch Vụ

**DELETE** `/api/v1/service-packages/{id}`

#### URL Parameters
| Parameter | Type | Required | Description        |
| --------- | ---- | -------- | ------------------ |
| id        | Long | Yes      | ID của gói dịch vụ |

#### Example
```http
DELETE /api/v1/service-packages/1
```

#### Response (204 No Content)
```
(No body)
```

#### Business Logic
- **Soft delete**: Chỉ set `isActive = false`, không xóa khỏi database
- Tự động update `updatedAt` và `updatedBy`

#### Error Cases
- **400**: Service package not found with ID: {id}

---

### 9. Kích Hoạt Gói Dịch Vụ

**PUT** `/api/v1/service-packages/{id}/activate`

#### URL Parameters
| Parameter | Type | Required | Description        |
| --------- | ---- | -------- | ------------------ |
| id        | Long | Yes      | ID của gói dịch vụ |

#### Example
```http
PUT /api/v1/service-packages/1/activate
```

#### Response (200 OK)
```json
{
  "id": 1,
  "packageName": "VIP 12 tháng",
  "price": 15000000.00,
  "type": "PT_INCLUDED",
  "isActive": true,
  "createdAt": "2026-01-11T09:30:43Z",
  "updatedAt": "2026-01-11T10:20:00Z",
  "createdBy": "admin",
  "updatedBy": "admin"
}
```

#### Business Logic
- Set `isActive = true`
- Tự động update `updatedAt` và `updatedBy`
- Có thể dùng để phục hồi gói đã bị deactivate

#### Error Cases
- **400**: Service package not found with ID: {id}

---

### 10. Vô Hiệu Hóa Gói Dịch Vụ

**PUT** `/api/v1/service-packages/{id}/deactivate`

#### URL Parameters
| Parameter | Type | Required | Description        |
| --------- | ---- | -------- | ------------------ |
| id        | Long | Yes      | ID của gói dịch vụ |

#### Example
```http
PUT /api/v1/service-packages/1/deactivate
```

#### Response (200 OK)
```json
{
  "id": 1,
  "packageName": "VIP 12 tháng",
  "price": 15000000.00,
  "type": "PT_INCLUDED",
  "isActive": false,
  "createdAt": "2026-01-11T09:30:43Z",
  "updatedAt": "2026-01-11T10:25:00Z",
  "createdBy": "admin",
  "updatedBy": "admin"
}
```

#### Business Logic
- Set `isActive = false`
- Tự động update `updatedAt` và `updatedBy`
- Khác với DELETE, endpoint này trả về entity đã update

#### Error Cases
- **400**: Service package not found with ID: {id}

---

## 🔐 Security & Authorization

**Note**: Tài liệu này chưa bao gồm phần authorization. Cần implement sau:
- Chỉ ADMIN/MANAGER mới được tạo/sửa/xóa gói dịch vụ
- Member có thể xem danh sách gói active
- PT có thể xem danh sách gói để tư vấn

---

## 📊 Business Rules

### Package Name Uniqueness
- Mỗi gói dịch vụ phải có tên unique
- Khi tạo mới: Kiểm tra tên không trùng
- Khi update: Kiểm tra tên mới không trùng với gói khác (trừ chính nó)

### Pricing Rules
- Giá gói phải >= 0
- Default price là 0 nếu không cung cấp
- Sử dụng BigDecimal để tránh lỗi làm tròn

### Activation/Deactivation
- Gói inactive không hiển thị cho khách hàng
- Có thể activate lại gói đã deactivate
- DELETE endpoint thực chất là deactivate (soft delete)

### Package Type
- `PT_INCLUDED`: Gói bao gồm PT, có thể booking PT sessions
- `NO_PT`: Gói không bao gồm PT, chỉ sử dụng thiết bị và cơ sở vật chất

---

## 🧪 Testing Checklist

### Create Package Tests
- ✅ Tạo package với tất cả fields hợp lệ
- ✅ Tạo package với isActive = null (test default true)
- ✅ Tạo package với price = null (test default 0)
- ❌ Tạo package với packageName trùng (expect error)
- ❌ Tạo package với packageName empty (expect validation error)
- ❌ Tạo package với price < 0 (expect validation error)
- ❌ Tạo package với type = null (expect validation error)

### Get Packages Tests
- ✅ Get all packages (active + inactive)
- ✅ Get active packages only
- ✅ Get packages by type PT_INCLUDED
- ✅ Get packages by type NO_PT
- ✅ Get packages by type with activeOnly=true
- ✅ Get package by ID (exists)
- ❌ Get package by ID (not exists)
- ✅ Search by packageName (exists)
- ❌ Search by packageName (not exists)
- ❌ Search without packageName parameter

### Update Package Tests
- ✅ Update packageName
- ✅ Update price
- ✅ Update type
- ✅ Update isActive
- ✅ Update một số fields (partial update)
- ❌ Update packageName trùng với gói khác
- ❌ Update với ID không tồn tại

### Delete & Activation Tests
- ✅ Delete package (soft delete, check isActive = false)
- ✅ Activate package (check isActive = true)
- ✅ Deactivate package (check isActive = false)
- ❌ Delete/Activate/Deactivate với ID không tồn tại

---

## 📝 Notes for Developers

### Default Values
- `isActive`: true (set in @PrePersist)
- `price`: 0 (set in @PrePersist)

### Soft Delete Pattern
- DELETE endpoint chỉ set `isActive = false`
- Không xóa record khỏi database
- Có thể phục hồi bằng activate endpoint

### Enum Handling
- PackageTypeEnum được lưu dưới dạng STRING trong database
- Frontend cần pass exact enum values: "PT_INCLUDED" hoặc "NO_PT"

### Audit Fields
- `createdAt`, `createdBy`: Set tự động khi tạo (@PrePersist)
- `updatedAt`, `updatedBy`: Set tự động khi update (@PreUpdate)
- SecurityUtil.getCurrentUserLogin() được dùng để lấy user hiện tại

---

## 🔄 Version History

| Version | Date       | Author    | Changes               |
| ------- | ---------- | --------- | --------------------- |
| 1.0     | 2026-01-11 | PhDuy2005 | Initial documentation |

---

**Generated by**: GitHub Copilot (Claude Sonnet 4.5)  
**Last Updated**: 2026-01-11 09:30:43
