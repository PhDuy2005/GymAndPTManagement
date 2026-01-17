# WorkoutDeviceController Documentation

> **Controller**: `com.se100.GymAndPTManagement.controller.WorkoutDeviceController`  
> **Base URL**: `/api/v1/workout-devices`  
> **Purpose**: Quản lý thiết bị tập luyện trong phòng gym

---

## 📋 Tổng Quan

Controller này cung cấp các endpoint để quản lý thiết bị tập luyện (workout devices/equipment), bao gồm:
- Tạo thiết bị mới
- Xem thông tin thiết bị
- Cập nhật thông tin thiết bị
- Xóa thiết bị
- Tìm kiếm thiết bị theo tên (keyword search)
- Lọc thiết bị theo loại
- Theo dõi lịch bảo trì
- Quản lý ngày nhập khẩu và giá

---

## 🔗 Related Files

- **Entity**: `src/main/java/com/se100/GymAndPTManagement/domain/table/WorkoutDevice.java`
- **Service**: `src/main/java/com/se100/GymAndPTManagement/service/WorkoutDeviceService.java`
- **Repository**: `src/main/java/com/se100/GymAndPTManagement/repository/WorkoutDeviceRepository.java`

---

## 📝 Entity Structure

### WorkoutDevice Entity Fields
- `id` (Long): Primary key
- `name` (String): Tên thiết bị (unique, required, max 255 ký tự)
- `type` (String): Loại thiết bị (max 100 ký tự, e.g., "Cardio", "Strength", "Free Weights")
- `price` (BigDecimal): Giá thiết bị (VND)
- `dateImported` (LocalDate): Ngày nhập khẩu (default = ngày hiện tại)
- `dateMaintenance` (LocalDate): Ngày bảo trì tiếp theo
- `imageUrl` (String): URL hình ảnh thiết bị (max 500 ký tự)
- Audit fields: `createdAt`, `updatedAt`, `createdBy`, `updatedBy`

### Constraints
- `name` phải unique
- `price` phải >= 0
- `dateMaintenance` có thể null (thiết bị mới chưa cần bảo trì)

---

## 🚀 Endpoints

### 1. Create Workout Device
**POST** `/api/v1/workout-devices`

**Description**: Tạo thiết bị tập luyện mới

**Request Body**:
```json
{
  "name": "Treadmill Pro X1",
  "type": "Cardio",
  "price": 35000000,
  "dateImported": "2026-01-15",
  "dateMaintenance": "2026-04-15",
  "imageUrl": "https://example.com/images/treadmill-pro-x1.jpg"
}
```

**Lưu ý**:
- `name` là **bắt buộc** và phải unique
- `dateImported` nếu không cung cấp sẽ mặc định là ngày hiện tại
- Các trường khác là optional

**Success Response** (201 Created):
```json
{
  "statusCode": 201,
  "message": "Tạo thiết bị tập luyện mới",
  "data": {
    "id": 1,
    "name": "Treadmill Pro X1",
    "type": "Cardio",
    "price": 35000000,
    "dateImported": "2026-01-15",
    "dateMaintenance": "2026-04-15",
    "imageUrl": "https://example.com/images/treadmill-pro-x1.jpg",
    "createdAt": "2026-01-17T10:30:00Z"
  }
}
```

**Error Response** (400 Bad Request):
```json
{
  "statusCode": 400,
  "message": "Thiết bị với tên này đã tồn tại"
}
```

---

### 2. Get Workout Device by ID
**GET** `/api/v1/workout-devices/{id}`

**Description**: Lấy thông tin chi tiết thiết bị theo ID

**Path Parameters**:
- `id` (Long): ID của thiết bị

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy thông tin thiết bị theo ID",
  "data": {
    "id": 1,
    "name": "Treadmill Pro X1",
    "type": "Cardio",
    "price": 35000000,
    "dateImported": "2026-01-15",
    "dateMaintenance": "2026-04-15",
    "imageUrl": "https://example.com/images/treadmill-pro-x1.jpg",
    "createdAt": "2026-01-17T10:30:00Z"
  }
}
```

**Error Response** (404 Not Found):
```json
{
  "statusCode": 404,
  "message": "Không tìm thấy thiết bị với ID: 999"
}
```

---

### 3. Search Workout Devices by Name (Keyword Search) ⭐
**GET** `/api/v1/workout-devices/by-name?name={keyword}`

**Description**: Tìm kiếm thiết bị theo tên (chứa từ khóa, không phân biệt hoa thường)

**Query Parameters**:
- `name` (String): Từ khóa tìm kiếm (case-insensitive, contains search)

**Lưu ý**:
- **Thay đổi từ phiên bản cũ**: Endpoint này đã được cập nhật từ exact match sang keyword search
- Trả về **List** thay vì single object
- Sử dụng `findByNameContainingIgnoreCase()` trong repository

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Tìm kiếm thiết bị theo tên",
  "data": [
    {
      "id": 1,
      "name": "Treadmill Pro X1",
      "type": "Cardio",
      "price": 35000000,
      "dateImported": "2026-01-15",
      "dateMaintenance": "2026-04-15",
      "imageUrl": "https://example.com/images/treadmill-pro-x1.jpg"
    },
    {
      "id": 2,
      "name": "Treadmill Basic T2",
      "type": "Cardio",
      "price": 18000000,
      "dateImported": "2026-01-10",
      "dateMaintenance": "2026-03-10",
      "imageUrl": "https://example.com/images/treadmill-basic.jpg"
    }
  ]
}
```

**Example Requests**:
- `GET /api/v1/workout-devices/by-name?name=treadmill` → Returns all devices with "treadmill" in name
- `GET /api/v1/workout-devices/by-name?name=pro` → Returns devices with "pro" in name
- `GET /api/v1/workout-devices/by-name?name=` → Returns all devices (empty search)

**Empty Result** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Tìm kiếm thiết bị theo tên",
  "data": []
}
```

---

### 4. Get Devices by Type
**GET** `/api/v1/workout-devices/by-type?type={type}&page={page}&size={size}`

**Description**: Lấy danh sách thiết bị theo loại với pagination

**Query Parameters**:
- `type` (String, required): Loại thiết bị (e.g., "Cardio", "Strength")
- `page` (Integer, optional): Số trang (default: 0)
- `size` (Integer, optional): Kích thước trang (default: 10)

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thiết bị theo loại",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 10,
      "totalPages": 2,
      "totalItems": 15
    },
    "result": [
      {
        "id": 1,
        "name": "Treadmill Pro X1",
        "type": "Cardio",
        "price": 35000000
      }
    ]
  }
}
```

---

### 5. Get Devices Requiring Maintenance
**GET** `/api/v1/workout-devices/maintenance-required?date={date}&page={page}&size={size}`

**Description**: Lấy danh sách thiết bị cần bảo trì trước hoặc vào ngày chỉ định

**Query Parameters**:
- `date` (LocalDate, optional): Ngày kiểm tra (format: yyyy-MM-dd, default: today)
- `page` (Integer, optional): Số trang
- `size` (Integer, optional): Kích thước trang

**Example**: `GET /api/v1/workout-devices/maintenance-required?date=2026-04-01`

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thiết bị cần bảo trì",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 10,
      "totalPages": 1,
      "totalItems": 3
    },
    "result": [
      {
        "id": 5,
        "name": "Rowing Machine R3",
        "type": "Cardio",
        "dateMaintenance": "2026-03-15",
        "price": 12000000
      }
    ]
  }
}
```

---

### 6. Get Devices Imported After Date
**GET** `/api/v1/workout-devices/imported-after?date={date}&page={page}&size={size}`

**Description**: Lấy danh sách thiết bị được nhập sau ngày chỉ định

**Query Parameters**:
- `date` (LocalDate, required): Ngày kiểm tra (format: yyyy-MM-dd)
- `page` (Integer, optional): Số trang
- `size` (Integer, optional): Kích thước trang

**Example**: `GET /api/v1/workout-devices/imported-after?date=2026-01-01`

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thiết bị nhập sau ngày chỉ định",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 10,
      "totalPages": 1,
      "totalItems": 8
    },
    "result": [
      {
        "id": 1,
        "name": "Treadmill Pro X1",
        "dateImported": "2026-01-15"
      }
    ]
  }
}
```

---

### 7. Count Devices by Type
**GET** `/api/v1/workout-devices/count-by-type?type={type}`

**Description**: Đếm số lượng thiết bị theo loại

**Query Parameters**:
- `type` (String, required): Loại thiết bị

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Đếm số lượng thiết bị theo loại",
  "data": 15
}
```

---

### 8. Update Workout Device
**PUT** `/api/v1/workout-devices/{id}`

**Description**: Cập nhật thông tin thiết bị

**Path Parameters**:
- `id` (Long): ID của thiết bị

**Request Body** (tất cả fields đều optional):
```json
{
  "name": "Treadmill Pro X1 Updated",
  "type": "Cardio Advanced",
  "price": 38000000,
  "dateMaintenance": "2026-05-15",
  "imageUrl": "https://example.com/images/new-image.jpg"
}
```

**Lưu ý**:
- Chỉ cập nhật các field không null
- `name` mới phải unique (nếu thay đổi)
- `dateImported` không được cập nhật (chỉ set khi tạo)

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Cập nhật thông tin thiết bị",
  "data": {
    "id": 1,
    "name": "Treadmill Pro X1 Updated",
    "type": "Cardio Advanced",
    "price": 38000000,
    "dateMaintenance": "2026-05-15",
    "updatedAt": "2026-01-17T14:00:00Z"
  }
}
```

---

### 9. Delete Workout Device
**DELETE** `/api/v1/workout-devices/{id}`

**Description**: Xóa thiết bị khỏi hệ thống

**Path Parameters**:
- `id` (Long): ID của thiết bị

**Success Response** (204 No Content):
```
(No response body)
```

**Error Response** (404 Not Found):
```json
{
  "statusCode": 404,
  "message": "Không tìm thấy thiết bị với ID: 999"
}
```

---

## 🔍 Repository Methods

### Standard JPA Methods
```java
// Search by name (keyword, case-insensitive) - NEW ⭐
List<WorkoutDevice> findByNameContainingIgnoreCase(String name);

// Find by name (exact match) - For uniqueness check
Optional<WorkoutDevice> findByName(String name);

// Check existence
boolean existsByName(String name);

// Filter by type
Page<WorkoutDevice> findByType(String type, Pageable pageable);

// Maintenance tracking
Page<WorkoutDevice> findByDateMaintenanceLessThanEqual(LocalDate date, Pageable pageable);

// Import tracking
Page<WorkoutDevice> findByDateImportedAfter(LocalDate date, Pageable pageable);

// Count by type
long countByType(String type);
```

---

## 📊 Business Logic

### Service Layer Features
1. **Create Validation**:
   - Check name uniqueness
   - Set default dateImported if not provided

2. **Update Validation**:
   - Check name conflicts when renaming
   - Preserve dateImported (immutable)

3. **Search Enhancement**:
   - Keyword search using `findByNameContainingIgnoreCase()`
   - Returns List for flexible results

4. **Maintenance Tracking**:
   - Filter devices needing maintenance before specified date
   - Useful for scheduling preventive maintenance

---

## 📝 DTOs Structure

### ReqCreateWorkoutDeviceDTO
```java
{
  "name": String (required, max 255),
  "type": String (optional, max 100),
  "price": BigDecimal (optional, >= 0),
  "dateImported": LocalDate (optional, default = today),
  "dateMaintenance": LocalDate (optional),
  "imageUrl": String (optional, max 500)
}
```

### ReqUpdateWorkoutDeviceDTO
```java
{
  "name": String (optional, max 255),
  "type": String (optional, max 100),
  "price": BigDecimal (optional, >= 0),
  "dateMaintenance": LocalDate (optional),
  "imageUrl": String (optional, max 500)
}
```

### ResWorkoutDeviceDTO
```java
{
  "id": Long,
  "name": String,
  "type": String,
  "price": BigDecimal,
  "dateImported": LocalDate,
  "dateMaintenance": LocalDate,
  "imageUrl": String,
  "createdAt": Instant,
  "updatedAt": Instant,
  "createdBy": String,
  "updatedBy": String
}
```

---

## 🎯 Usage Examples

### Frontend Integration

**Search devices by keyword**:
```javascript
// Search for all treadmills
fetch('/api/v1/workout-devices/by-name?name=treadmill')
  .then(res => res.json())
  .then(data => {
    // data.data is an array of matching devices
    console.log(`Found ${data.data.length} devices`);
  });
```

**Get devices needing maintenance**:
```javascript
// Get devices needing maintenance in next 30 days
const targetDate = new Date();
targetDate.setDate(targetDate.getDate() + 30);

fetch(`/api/v1/workout-devices/maintenance-required?date=${targetDate.toISOString().split('T')[0]}`)
  .then(res => res.json())
  .then(data => {
    console.log('Devices needing maintenance:', data.data.result);
  });
```

---

## ⚠️ Important Notes

1. **API Change - `/by-name` endpoint** ⭐:
   - **Old behavior**: Exact match, returns single object or 404
   - **New behavior**: Keyword search (contains), returns List (can be empty)
   - **Migration guide**: Update frontend to handle array response

2. **Name Uniqueness**:
   - Device names must be unique across the system
   - Case-sensitive uniqueness check

3. **Date Handling**:
   - `dateImported` defaults to current date if not provided
   - `dateImported` is immutable after creation
   - `dateMaintenance` can be updated via PUT request

4. **Image URL**:
   - Max 500 characters
   - Store URL only, not actual file

---

## 🔄 Changelog

### Version 2.0 (2026-01-17)
- **BREAKING CHANGE**: Changed `GET /by-name` endpoint behavior
  - Now performs keyword search instead of exact match
  - Returns `List<ResWorkoutDeviceDTO>` instead of single `ResWorkoutDeviceDTO`
  - Added `findByNameContainingIgnoreCase()` repository method
  - Renamed service method to `searchWorkoutDevicesByName()`

### Version 1.0 (2026-01-15)
- Initial implementation
- CRUD operations
- Maintenance tracking
- Type filtering
