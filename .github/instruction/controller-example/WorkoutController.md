# WorkoutController Documentation

> **Controller**: `com.se100.GymAndPTManagement.controller.WorkoutController`  
> **Base URL**: `/api/v1/workouts`  
> **Purpose**: Quản lý thư viện bài tập (exercise library) cho phòng gym

---

## 📋 Tổng Quan

Controller này cung cấp các endpoint để quản lý thư viện bài tập tổng quát, bao gồm:
- Tạo bài tập mới
- Xem thông tin bài tập
- Cập nhật thông tin bài tập
- Xóa bài tập
- Tìm kiếm bài tập theo tên
- Lọc bài tập theo độ khó (difficulty)
- Lọc bài tập theo loại (type)
- Đếm số lượng bài tập theo difficulty/type

**Design Philosophy**: Workout v2 là thư viện bài tập chung, không gắn với PT cụ thể hay thiết bị cụ thể. Mọi người đều có thể sử dụng các bài tập này.

---

## 🔗 Related Files

- **Entity**: `src/main/java/com/se100/GymAndPTManagement/domain/table/Workout.java`
- **Enum**: `src/main/java/com/se100/GymAndPTManagement/util/enums/WorkoutDifficultyEnum.java`
- **Service**: `src/main/java/com/se100/GymAndPTManagement/service/WorkoutService.java`
- **Repository**: `src/main/java/com/se100/GymAndPTManagement/repository/WorkoutRepository.java`

---

## 📝 Entity Structure (Version 2)

### Workout Entity Fields
- `id` (Long): Primary key
- `name` (String): Tên bài tập (unique, required, max 255 ký tự)
- `description` (String): Mô tả chi tiết cách thực hiện (TEXT, optional)
- `duration` (Integer): Thời lượng bài tập (phút, optional)
- `difficulty` (WorkoutDifficultyEnum): Độ khó (BEGINNER, INTERMEDIATE, ADVANCED, optional)
- `type` (String): Loại bài tập (max 100 ký tự, e.g., "Cardio", "Strength", "Flexibility", "HIIT", optional)
- Audit fields: `createdAt`, `updatedAt`, `createdBy`, `updatedBy`

### WorkoutDifficultyEnum
```java
public enum WorkoutDifficultyEnum {
    BEGINNER,       // Người mới bắt đầu
    INTERMEDIATE,   // Trung cấp
    ADVANCED        // Nâng cao
}
```

### Design Changes from v1 ⚠️
**Removed fields** (không còn trong v2):
- ❌ `personalTrainer` (ManyToOne) - Bài tập không còn thuộc về PT cụ thể
- ❌ `workoutDevice` (ManyToOne) - Bài tập không còn yêu cầu thiết bị cụ thể

**New fields** (mới trong v2):
- ✅ `duration` - Thời lượng tập
- ✅ `difficulty` - Độ khó chuẩn hóa
- ✅ `type` - Phân loại linh hoạt

**Rationale**: Đơn giản hóa Workout thành exercise library tổng quát, không ràng buộc với PT hay thiết bị cụ thể.

---

## 🚀 Endpoints

### 1. Create Workout
**POST** `/api/v1/workouts`

**Description**: Tạo bài tập mới trong thư viện

**Request Body**:
```json
{
  "name": "Push-ups",
  "description": "Nằm sấp, tay chống đất ngang vai, đẩy người lên xuống",
  "duration": 10,
  "difficulty": "BEGINNER",
  "type": "Strength"
}
```

**Validation Rules**:
- `name` là **bắt buộc** và phải unique
- `description`, `duration`, `difficulty`, `type` là optional
- `duration` nếu có phải >= 1 (phút)

**Success Response** (201 Created):
```json
{
  "statusCode": 201,
  "message": "Tạo bài tập mới",
  "data": {
    "id": 1,
    "name": "Push-ups",
    "description": "Nằm sấp, tay chống đất ngang vai, đẩy người lên xuống",
    "duration": 10,
    "difficulty": "BEGINNER",
    "type": "Strength",
    "createdAt": "2026-01-17T10:30:00Z"
  }
}
```

**Error Response** (400 Bad Request):
```json
{
  "statusCode": 400,
  "message": "Bài tập với tên này đã tồn tại"
}
```

---

### 2. Get Workout by ID
**GET** `/api/v1/workouts/{id}`

**Description**: Lấy thông tin chi tiết bài tập theo ID

**Path Parameters**:
- `id` (Long): ID của bài tập

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy thông tin bài tập theo ID",
  "data": {
    "id": 1,
    "name": "Push-ups",
    "description": "Nằm sấp, tay chống đất ngang vai, đẩy người lên xuống",
    "duration": 10,
    "difficulty": "BEGINNER",
    "type": "Strength",
    "createdAt": "2026-01-17T10:30:00Z",
    "updatedAt": "2026-01-17T10:30:00Z"
  }
}
```

**Error Response** (404 Not Found):
```json
{
  "statusCode": 404,
  "message": "Không tìm thấy bài tập với ID: 999"
}
```

---

### 3. Get Workout by Name (Exact Match)
**GET** `/api/v1/workouts/by-name?name={name}`

**Description**: Lấy bài tập theo tên chính xác (exact match)

**Query Parameters**:
- `name` (String, required): Tên bài tập (case-sensitive)

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy thông tin bài tập theo tên",
  "data": {
    "id": 1,
    "name": "Push-ups",
    "difficulty": "BEGINNER",
    "type": "Strength"
  }
}
```

**Error Response** (404 Not Found):
```json
{
  "statusCode": 404,
  "message": "Không tìm thấy bài tập với tên: InvalidName"
}
```

---

### 4. Search Workouts by Name (Keyword Search)
**GET** `/api/v1/workouts/search?name={keyword}&page={page}&size={size}`

**Description**: Tìm kiếm bài tập theo tên (chứa từ khóa, không phân biệt hoa thường)

**Query Parameters**:
- `name` (String, required): Từ khóa tìm kiếm
- `page` (Integer, optional): Số trang (default: 0)
- `size` (Integer, optional): Kích thước trang (default: 10)

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Tìm kiếm bài tập theo tên",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 10,
      "totalPages": 1,
      "totalItems": 3
    },
    "result": [
      {
        "id": 1,
        "name": "Push-ups",
        "difficulty": "BEGINNER",
        "type": "Strength",
        "duration": 10
      },
      {
        "id": 5,
        "name": "Diamond Push-ups",
        "difficulty": "ADVANCED",
        "type": "Strength",
        "duration": 8
      }
    ]
  }
}
```

**Example Requests**:
- `GET /api/v1/workouts/search?name=push` → Tìm tất cả bài tập có "push" trong tên
- `GET /api/v1/workouts/search?name=squat&size=5` → Tìm bài tập squat, 5 kết quả/trang

---

### 5. Get Workouts by Difficulty
**GET** `/api/v1/workouts/by-difficulty/{difficulty}?page={page}&size={size}`

**Description**: Lấy danh sách bài tập theo độ khó

**Path Parameters**:
- `difficulty` (WorkoutDifficultyEnum, required): BEGINNER, INTERMEDIATE, hoặc ADVANCED

**Query Parameters**:
- `page` (Integer, optional): Số trang
- `size` (Integer, optional): Kích thước trang

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách bài tập theo độ khó",
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
        "name": "Push-ups",
        "difficulty": "BEGINNER",
        "type": "Strength",
        "duration": 10
      },
      {
        "id": 2,
        "name": "Jumping Jacks",
        "difficulty": "BEGINNER",
        "type": "Cardio",
        "duration": 15
      }
    ]
  }
}
```

**Example Requests**:
- `GET /api/v1/workouts/by-difficulty/BEGINNER` → Tất cả bài tập cho người mới
- `GET /api/v1/workouts/by-difficulty/ADVANCED?size=20` → Bài tập nâng cao, 20/trang

---

### 6. Get Workouts by Type (Exact Match)
**GET** `/api/v1/workouts/by-type?type={type}&page={page}&size={size}`

**Description**: Lấy danh sách bài tập theo loại (exact match)

**Query Parameters**:
- `type` (String, required): Loại bài tập (e.g., "Cardio", "Strength", "Flexibility")
- `page` (Integer, optional): Số trang
- `size` (Integer, optional): Kích thước trang

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách bài tập theo loại",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 10,
      "totalPages": 1,
      "totalItems": 8
    },
    "result": [
      {
        "id": 3,
        "name": "Running",
        "difficulty": "INTERMEDIATE",
        "type": "Cardio",
        "duration": 30
      }
    ]
  }
}
```

**Common Type Values**:
- `Cardio` - Bài tập tim mạch
- `Strength` - Bài tập sức mạnh
- `Flexibility` - Bài tập dẻo dai
- `HIIT` - High-Intensity Interval Training
- `Yoga` - Yoga exercises
- `Pilates` - Pilates exercises

---

### 7. Search Workouts by Type (Keyword Search)
**GET** `/api/v1/workouts/search-type?type={keyword}&page={page}&size={size}`

**Description**: Tìm kiếm bài tập theo loại (chứa từ khóa, không phân biệt hoa thường)

**Query Parameters**:
- `type` (String, required): Từ khóa tìm kiếm trong type
- `page` (Integer, optional): Số trang
- `size` (Integer, optional): Kích thước trang

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Tìm kiếm bài tập theo loại",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 10,
      "totalPages": 1,
      "totalItems": 5
    },
    "result": [
      {
        "id": 10,
        "name": "Circuit Training",
        "difficulty": "INTERMEDIATE",
        "type": "HIIT Cardio",
        "duration": 25
      }
    ]
  }
}
```

**Example**: `GET /api/v1/workouts/search-type?type=cardio` → Tìm tất cả type có "cardio" (HIIT Cardio, Cardio, etc.)

---

### 8. Count Workouts by Difficulty
**GET** `/api/v1/workouts/count-by-difficulty/{difficulty}`

**Description**: Đếm số lượng bài tập theo độ khó

**Path Parameters**:
- `difficulty` (WorkoutDifficultyEnum, required): BEGINNER, INTERMEDIATE, hoặc ADVANCED

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Đếm số lượng bài tập theo độ khó",
  "data": 15
}
```

**Example**: `GET /api/v1/workouts/count-by-difficulty/BEGINNER` → Returns 15

---

### 9. Count Workouts by Type
**GET** `/api/v1/workouts/count-by-type?type={type}`

**Description**: Đếm số lượng bài tập theo loại

**Query Parameters**:
- `type` (String, required): Loại bài tập

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Đếm số lượng bài tập theo loại",
  "data": 8
}
```

**Example**: `GET /api/v1/workouts/count-by-type?type=Cardio` → Returns 8

---

### 10. Update Workout
**PUT** `/api/v1/workouts/{id}`

**Description**: Cập nhật thông tin bài tập

**Path Parameters**:
- `id` (Long): ID của bài tập

**Request Body** (tất cả fields đều optional):
```json
{
  "name": "Advanced Push-ups",
  "description": "Updated description with proper form details",
  "duration": 12,
  "difficulty": "INTERMEDIATE",
  "type": "Strength Training"
}
```

**Lưu ý**:
- Chỉ cập nhật các field không null
- `name` mới phải unique (nếu thay đổi)

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Cập nhật thông tin bài tập",
  "data": {
    "id": 1,
    "name": "Advanced Push-ups",
    "description": "Updated description with proper form details",
    "duration": 12,
    "difficulty": "INTERMEDIATE",
    "type": "Strength Training",
    "updatedAt": "2026-01-17T14:00:00Z"
  }
}
```

**Error Responses**:
- **404 Not Found**: Workout not found
- **400 Bad Request**: Name conflict or invalid data

---

### 11. Delete Workout
**DELETE** `/api/v1/workouts/{id}`

**Description**: Xóa bài tập khỏi thư viện

**Path Parameters**:
- `id` (Long): ID của bài tập

**Success Response** (204 No Content):
```
(No response body)
```

**Error Response** (404 Not Found):
```json
{
  "statusCode": 404,
  "message": "Không tìm thấy bài tập với ID: 999"
}
```

---

## 🔍 Repository Methods

### Standard JPA Methods
```java
// Find by name (exact match)
Optional<Workout> findByName(String name);

// Search by name (keyword, case-insensitive)
Page<Workout> findByNameContainingIgnoreCase(String name, Pageable pageable);

// Check existence
boolean existsByName(String name);

// Filter by difficulty
Page<Workout> findByDifficulty(WorkoutDifficultyEnum difficulty, Pageable pageable);

// Filter by type (exact)
Page<Workout> findByType(String type, Pageable pageable);

// Search by type (contains)
Page<Workout> findByTypeContainingIgnoreCase(String type, Pageable pageable);

// Count methods
long countByDifficulty(WorkoutDifficultyEnum difficulty);
long countByType(String type);
```

### Removed from v1 (không còn trong v2)
```java
// ❌ findByPersonalTrainerId()
// ❌ findByWorkoutDeviceId()
// ❌ findByPersonalTrainerIsNull()
// ❌ findByWorkoutDeviceIsNull()
// ❌ countByPersonalTrainerId()
// ❌ countByWorkoutDeviceId()
```

---

## 📊 Business Logic

### Service Layer Features

1. **Create Validation**:
   - Check name uniqueness
   - All fields optional except name
   - No PT/Device validation (removed from v2)

2. **Update Validation**:
   - Check name conflicts when renaming
   - Partial updates (only update non-null fields)

3. **Search & Filter**:
   - Name search: keyword-based (contains, case-insensitive)
   - Difficulty filter: standardized enum values
   - Type filter: flexible string categories

4. **Simplified Design**:
   - No PT repository dependency
   - No Device repository dependency
   - Focus on exercise catalog, not ownership

---

## 📝 DTOs Structure

### ReqCreateWorkoutDTO
```java
{
  "name": String (required, max 255),
  "description": String (optional, TEXT),
  "duration": Integer (optional, min 1, minutes),
  "difficulty": WorkoutDifficultyEnum (optional: BEGINNER/INTERMEDIATE/ADVANCED),
  "type": String (optional, max 100)
}
```

### ReqUpdateWorkoutDTO
```java
{
  "name": String (optional, max 255),
  "description": String (optional, TEXT),
  "duration": Integer (optional, min 1, minutes),
  "difficulty": WorkoutDifficultyEnum (optional),
  "type": String (optional, max 100)
}
```

### ResWorkoutDTO
```java
{
  "id": Long,
  "name": String,
  "description": String,
  "duration": Integer,
  "difficulty": WorkoutDifficultyEnum,
  "type": String,
  "createdAt": Instant,
  "updatedAt": Instant,
  "createdBy": String,
  "updatedBy": String
}
```

**Removed from v1 DTO**:
- ❌ `ptId`, `ptName` - No longer associated with PT
- ❌ `deviceId`, `deviceName` - No longer associated with device

---

## 🎯 Usage Examples

### Frontend Integration

**Create a workout**:
```javascript
fetch('/api/v1/workouts', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    name: 'Burpees',
    description: 'Full body exercise combining squat, push-up, and jump',
    duration: 15,
    difficulty: 'INTERMEDIATE',
    type: 'HIIT'
  })
})
.then(res => res.json())
.then(data => console.log('Created:', data.data));
```

**Filter by difficulty**:
```javascript
// Get beginner workouts for new members
fetch('/api/v1/workouts/by-difficulty/BEGINNER?size=20')
  .then(res => res.json())
  .then(data => {
    const beginnerWorkouts = data.data.result;
    console.log(`Found ${beginnerWorkouts.length} beginner workouts`);
  });
```

**Search by type**:
```javascript
// Find all cardio exercises
fetch('/api/v1/workouts/search-type?type=cardio')
  .then(res => res.json())
  .then(data => {
    // Will find "Cardio", "HIIT Cardio", "Cardio Training", etc.
    console.log('Cardio workouts:', data.data.result);
  });
```

**Get workout statistics**:
```javascript
// Dashboard: Count workouts by difficulty
Promise.all([
  fetch('/api/v1/workouts/count-by-difficulty/BEGINNER').then(r => r.json()),
  fetch('/api/v1/workouts/count-by-difficulty/INTERMEDIATE').then(r => r.json()),
  fetch('/api/v1/workouts/count-by-difficulty/ADVANCED').then(r => r.json())
])
.then(([beginner, intermediate, advanced]) => {
  console.log('Workout Distribution:');
  console.log(`Beginner: ${beginner.data}`);
  console.log(`Intermediate: ${intermediate.data}`);
  console.log(`Advanced: ${advanced.data}`);
});
```

---

## ⚠️ Important Notes

1. **Version 2 Design Philosophy** ⭐:
   - Workout là **exercise library tổng quát**
   - Không gắn với PT cụ thể (mọi PT đều có thể sử dụng)
   - Không gắn với thiết bị cụ thể (bài tập có thể dùng hoặc không dùng thiết bị)
   - Phân loại theo `difficulty` (chuẩn hóa) và `type` (linh hoạt)

2. **Name Uniqueness**:
   - Workout names must be unique across the system
   - Case-sensitive uniqueness check
   - Use for preventing duplicate exercises

3. **Difficulty Enum**:
   - Only 3 values: BEGINNER, INTERMEDIATE, ADVANCED
   - Frontend should use dropdown/select for input
   - Cannot use arbitrary values

4. **Type Field**:
   - Free-form String (max 100 chars)
   - Recommended values: Cardio, Strength, Flexibility, HIIT, Yoga, Pilates
   - Can be customized per gym's needs

5. **Duration Field**:
   - In minutes
   - Optional (some exercises may not have fixed duration)
   - Minimum 1 minute if provided

---

## 🔄 Migration Guide (v1 → v2)

### Breaking Changes

**Removed Endpoints**:
```
❌ GET /api/v1/workouts/by-pt/{ptId}
❌ GET /api/v1/workouts/by-device/{deviceId}
❌ GET /api/v1/workouts/bodyweight
❌ GET /api/v1/workouts/general
❌ GET /api/v1/workouts/count-by-pt/{ptId}
❌ GET /api/v1/workouts/count-by-device/{deviceId}
❌ GET /api/v1/workouts/fetch (SpringFilter endpoint)
```

**New Endpoints**:
```
✅ GET /api/v1/workouts/by-difficulty/{difficulty}
✅ GET /api/v1/workouts/by-type?type={type}
✅ GET /api/v1/workouts/search-type?type={keyword}
✅ GET /api/v1/workouts/count-by-difficulty/{difficulty}
✅ GET /api/v1/workouts/count-by-type?type={type}
```

**DTO Changes**:
```javascript
// v1 Request DTO (OLD)
{
  name: "Push-ups",
  description: "...",
  ptId: 5,          // ❌ REMOVED
  deviceId: 10      // ❌ REMOVED
}

// v2 Request DTO (NEW)
{
  name: "Push-ups",
  description: "...",
  duration: 10,     // ✅ NEW
  difficulty: "BEGINNER",  // ✅ NEW
  type: "Strength"  // ✅ NEW
}
```

**Frontend Migration Steps**:
1. Remove PT/Device selection from Workout creation form
2. Add Duration input (number, minutes)
3. Add Difficulty dropdown (BEGINNER/INTERMEDIATE/ADVANCED)
4. Add Type input (text or dropdown with suggestions)
5. Update search/filter UI to use difficulty/type instead of PT/device
6. Remove /fetch endpoint calls (SpringFilter removed)

---

## 🔄 Changelog

### Version 2.0 (2026-01-17) - MAJOR REDESIGN ⚠️
- **BREAKING CHANGES**:
  - Removed all PT and Device relationships from entity
  - Removed 6 PT/Device related endpoints
  - Removed `ptId`, `deviceId` from DTOs
  - Removed PT/Device repository dependencies from service
  
- **NEW FEATURES**:
  - Added `duration` field (Integer, minutes)
  - Added `difficulty` field (Enum: BEGINNER/INTERMEDIATE/ADVANCED)
  - Added `type` field (String, flexible categorization)
  - Added WorkoutDifficultyEnum
  - Added 5 new difficulty/type filtering endpoints
  - Made `name` unique constraint
  
- **DESIGN RATIONALE**:
  - Simplified to generic exercise library
  - Not tied to specific PT or equipment
  - Focus on categorization (difficulty + type)
  - Easier for frontend to use and maintain

### Version 1.0 (2026-01-15) - DEPRECATED
- Initial implementation with PT/Device relationships
- Complex design with ownership model
- Required PT/Device validation

---

## 📚 Related Documentation

- [WorkoutDifficultyEnum](../DATABASE_SCHEMA.md#workoutdifficulty-enum)
- [Database Schema - Workout v2](../DATABASE_SCHEMA.md#workout-table)
- [API Response Format](../API_RESPONSE_FORMAT.md)
