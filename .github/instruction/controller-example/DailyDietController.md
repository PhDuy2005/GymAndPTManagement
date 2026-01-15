# DailyDietController Documentation

> **Controller**: `com.se100.GymAndPTManagement.controller.DailyDietController`  
> **Base URL**: `/api/v1/daily-diets`  
> **Purpose**: Quản lý kế hoạch dinh dưỡng hàng ngày cho member

---

## 📋 Tổng Quan

Controller này cung cấp các endpoint để quản lý thực đơn hàng ngày, bao gồm:
- Tạo thực đơn cho member (có thể do PT lập)
- Xem thông tin thực đơn kèm chi tiết thực phẩm
- Cập nhật thực đơn (PT, water intake, note)
- Xóa thực đơn
- Tìm kiếm và lọc thực đơn theo member, PT, ngày

---

## 🔗 Related Files

- **Entity**: `src/main/java/com/se100/GymAndPTManagement/domain/table/DailyDiet.java`
- **Service**: `src/main/java/com/se100/GymAndPTManagement/service/DailyDietService.java`
- **Repository**: `src/main/java/com/se100/GymAndPTManagement/repository/DailyDietRepository.java`

---

## 📝 Entity Structure

### DailyDiet Entity Fields
- `id` (Long): Primary key (diet_id)
- `member` (Member): Member sử dụng thực đơn (required, FK)
- `personalTrainer` (PersonalTrainer): PT lập thực đơn (optional, FK)
- `dietDate` (LocalDate): Ngày áp dụng thực đơn (required)
- `waterLiters` (BigDecimal): Lượng nước uống (liters, optional)
- `note` (String): Ghi chú thêm (TEXT, optional)
- Audit fields: `createdAt`, `updatedAt`, `createdBy`, `updatedBy`

### Response DTO Includes
- **dietDetails** (List<ResDietDetailDTO>): Danh sách thực phẩm trong thực đơn
  - Mỗi detail chứa: foodName, amount, prepMethod, nutrition info (total calories, protein, carbs, fat)

---

## 🚀 Endpoints

### 1. Create Daily Diet
**POST** `/api/v1/daily-diets`

**Description**: Tạo thực đơn hàng ngày mới cho member

**Request Body**:
```json
{
  "memberId": 1,
  "ptId": 2,
  "dietDate": "2026-01-15",
  "waterLiters": 2.5,
  "note": "Thực đơn tăng cơ"
}
```

**Lưu ý**:
- `memberId`, `dietDate` là **bắt buộc**
- `ptId`, `waterLiters`, `note` là optional
- 1 member chỉ có **1 thực đơn/ngày** (unique constraint)
- Member và PT phải tồn tại trong hệ thống

**Success Response** (201 Created):
```json
{
  "statusCode": 201,
  "message": "Tạo thực đơn hàng ngày mới",
  "data": {
    "id": 1,
    "memberId": 1,
    "memberName": "Nguyễn Văn A",
    "ptId": 2,
    "ptName": "Trần Văn B",
    "dietDate": "2026-01-15",
    "waterLiters": 2.5,
    "note": "Thực đơn tăng cơ",
    "dietDetails": [],
    "createdAt": "2026-01-15T14:30:00Z"
  }
}
```

**Error Responses**:
- **400 Bad Request**: Thực đơn cho ngày này đã tồn tại
  ```json
  {
    "statusCode": 400,
    "error": "Thực đơn cho ngày này đã tồn tại"
  }
  ```
- **404 Not Found**: Member hoặc PT không tồn tại
  ```json
  {
    "statusCode": 404,
    "error": "Không tìm thấy member với ID: 1"
  }
  ```

---

### 2. Get Daily Diet by ID
**GET** `/api/v1/daily-diets/{id}`

**Description**: Lấy thông tin chi tiết thực đơn kèm danh sách thực phẩm

**Path Parameters**:
- `id` (Long): Daily Diet ID

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy thông tin thực đơn theo ID",
  "data": {
    "id": 1,
    "memberId": 1,
    "memberName": "Nguyễn Văn A",
    "ptId": 2,
    "ptName": "Trần Văn B",
    "dietDate": "2026-01-15",
    "waterLiters": 2.5,
    "note": "Thực đơn tăng cơ",
    "dietDetails": [
      {
        "dietId": 1,
        "foodId": 5,
        "foodName": "Ức gà luộc",
        "prepMethod": "Luộc",
        "amount": 200,
        "note": "Bữa sáng",
        "caloriesPer100g": 165.0,
        "proteinPer100g": 31.0,
        "carbsPer100g": 0.0,
        "fatPer100g": 3.6,
        "totalCalories": 330.0,
        "totalProteinG": 62.0,
        "totalCarbsG": 0.0,
        "totalFatG": 7.2
      }
    ],
    "createdAt": "2026-01-15T14:30:00Z",
    "updatedAt": "2026-01-15T15:00:00Z"
  }
}
```

**Calculation Example**:
```
Food: Ức gà (per 100g) = 165 kcal, 31g protein, 3.6g fat
Amount: 200g
→ totalCalories = 165 / 100 × 200 = 330 kcal
→ totalProteinG = 31 / 100 × 200 = 62g
→ totalFatG = 3.6 / 100 × 200 = 7.2g
```

---

### 3. Fetch Daily Diets with Filter
**GET** `/api/v1/daily-diets/fetch`

**Description**: Lấy danh sách thực đơn với filter động và pagination

**Query Parameters**:
- `filter` (String, optional): Spring-Filter expression
- `page` (int, optional, default=0): Page number (0-indexed)
- `size` (int, optional, default=20): Page size
- `sort` (String, optional): Sort criteria

**Filter Examples**:
```
# Tìm thực đơn có lượng nước >= 2 lít
filter=waterLiters>=2

# Tìm thực đơn trong tháng 1/2026
filter=dietDate>='2026-01-01' and dietDate<='2026-01-31'

# Tìm thực đơn của member ID 1
filter=member.id:1
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thực đơn với filter và pagination",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 20,
      "totalPages": 3,
      "totalItems": 45
    },
    "result": [...]
  }
}
```

---

### 4. Get Daily Diets by Member
**GET** `/api/v1/daily-diets/by-member/{memberId}`

**Description**: Lấy danh sách thực đơn của 1 member cụ thể

**Path Parameters**:
- `memberId` (Long): Member ID

**Query Parameters**:
- `page`, `size`, `sort` (optional): Pagination parameters

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thực đơn theo member",
  "data": {
    "meta": {...},
    "result": [...]
  }
}
```

---

### 5. Get Daily Diets by PT
**GET** `/api/v1/daily-diets/by-pt/{ptId}`

**Description**: Lấy danh sách thực đơn do PT lập

**Path Parameters**:
- `ptId` (Long): Personal Trainer ID

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thực đơn do PT tạo",
  "data": {
    "meta": {...},
    "result": [...]
  }
}
```

---

### 6. Get Daily Diets by Date Range
**GET** `/api/v1/daily-diets/by-date-range`

**Description**: Lấy danh sách thực đơn trong khoảng thời gian

**Query Parameters**:
- `startDate` (LocalDate, required): Ngày bắt đầu (format: YYYY-MM-DD)
- `endDate` (LocalDate, required): Ngày kết thúc (format: YYYY-MM-DD)
- `page`, `size`, `sort` (optional): Pagination parameters

**Example Request**:
```
GET /api/v1/daily-diets/by-date-range?startDate=2026-01-01&endDate=2026-01-31
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thực đơn theo khoảng thời gian",
  "data": {
    "meta": {...},
    "result": [...]
  }
}
```

---

### 7. Get Daily Diet by Member and Date Range
**GET** `/api/v1/daily-diets/by-member/{memberId}/date-range`

**Description**: Lấy thực đơn của member trong khoảng ngày

**Path Parameters**:
- `memberId` (Long): Member ID

**Query Parameters**:
- `startDate` (LocalDate, required): Ngày bắt đầu
- `endDate` (LocalDate, required): Ngày kết thúc
- `page`, `size`, `sort` (optional): Pagination

**Example Request**:
```
GET /api/v1/daily-diets/by-member/1/date-range?startDate=2026-01-01&endDate=2026-01-07
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy thực đơn của member theo khoảng ngày",
  "data": {
    "meta": {...},
    "result": [...]
  }
}
```

---

### 8. Get Daily Diet by Member and Specific Date
**GET** `/api/v1/daily-diets/by-member/{memberId}/date/{date}`

**Description**: Lấy thực đơn của member trong ngày cụ thể

**Path Parameters**:
- `memberId` (Long): Member ID
- `date` (LocalDate): Ngày cụ thể (format: YYYY-MM-DD)

**Example Request**:
```
GET /api/v1/daily-diets/by-member/1/date/2026-01-15
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy thực đơn của member theo ngày cụ thể",
  "data": {
    "id": 1,
    "memberId": 1,
    "dietDate": "2026-01-15",
    "dietDetails": [...]
  }
}
```

---

### 9. Update Daily Diet
**PUT** `/api/v1/daily-diets/{id}`

**Description**: Cập nhật thông tin thực đơn (không update dietDetails)

**Path Parameters**:
- `id` (Long): Daily Diet ID

**Request Body** (tất cả fields optional):
```json
{
  "ptId": 3,
  "dietDate": "2026-01-16",
  "waterLiters": 3.0,
  "note": "Tăng lượng nước"
}
```

**Lưu ý**:
- Chỉ update các fields được gửi lên
- Nếu đổi `dietDate`, phải check không trùng với diet khác của member
- Để update `dietDetails`, dùng endpoints của DietDetailController

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Cập nhật thông tin thực đơn",
  "data": {
    "id": 1,
    "ptId": 3,
    "ptName": "Lê Văn C",
    "dietDate": "2026-01-16",
    "waterLiters": 3.0,
    "updatedAt": "2026-01-15T16:00:00Z"
  }
}
```

---

### 10. Delete Daily Diet
**DELETE** `/api/v1/daily-diets/{id}`

**Description**: Xóa thực đơn (hard delete)

**Path Parameters**:
- `id` (Long): Daily Diet ID

**Success Response** (204 No Content):
```
HTTP/1.1 204 No Content
```

**Lưu ý**:
- Hard delete - không thể khôi phục
- Cần xóa hết DietDetails trước (hoặc dùng CASCADE)

---

## 🔒 Security & Authorization

- **Authentication**: Tất cả endpoints yêu cầu JWT token
- **Authorization**:
  - `GET /daily-diets/*`: MEMBER, ADMIN, PERSONAL_TRAINER
  - `POST /daily-diets`: ADMIN, PERSONAL_TRAINER, MEMBER (tự tạo)
  - `PUT /daily-diets/{id}`: ADMIN, PERSONAL_TRAINER, MEMBER (owner)
  - `DELETE /daily-diets/{id}`: ADMIN, MEMBER (owner)

---

## 🧪 Business Logic Notes

### Validation Rules
1. **memberId**: Required, phải tồn tại trong bảng members
2. **ptId**: Optional, nếu có phải tồn tại trong bảng personal_trainers
3. **dietDate**: Required, unique per member (1 member = 1 diet/ngày)
4. **waterLiters**: Optional, phải >= 0

### Unique Constraint
```sql
UNIQUE (member_id, diet_date)
```
- Prevent duplicate: 1 member không thể có 2 diets cùng ngày
- Khi update dietDate, check conflict với diet khác

### Diet Details Loading
- Response **luôn bao gồm** `dietDetails` array
- Tự động load từ `diet_details` table qua `diet_id`
- Mỗi detail tính toán nutrition dựa trên amount:
  ```
  totalCalories = caloriesPer100g / 100 × amount
  totalProteinG = proteinPer100g / 100 × amount
  totalCarbsG = carbsPer100g / 100 × amount
  totalFatG = fatPer100g / 100 × amount
  ```

### Cascade Behavior
- Delete DailyDiet → Recommend delete all DietDetails first
- Update member/PT → không ảnh hưởng existing diets

---

## 📊 Use Cases

### Use Case 1: PT tạo thực đơn cho member
```
1. POST /daily-diets (ptId=2, memberId=1, dietDate=2026-01-15)
2. POST /diet-details (add Ức gà 200g)
3. POST /diet-details (add Cơm trắng 150g)
4. POST /diet-details (add Bông cải 100g)
5. GET /daily-diets/by-member/1/date/2026-01-15 → View full diet with nutrition
```

### Use Case 2: Member xem thực đơn tuần
```
GET /daily-diets/by-member/1/date-range?startDate=2026-01-15&endDate=2026-01-21
→ Returns 7 diets với chi tiết thực phẩm và tổng nutrition
```

### Use Case 3: Thống kê lượng nước uống
```
GET /daily-diets/fetch?filter=member.id:1 and dietDate>='2026-01-01'&sort=dietDate,asc
→ Analyze water intake trend
```

---

## 📚 Related Documentation

- [DATABASE_SCHEMA.md](../DATABASE_SCHEMA.md#17-daily-diet-table)
- [DietDetailController.md](./DietDetailController.md)
- [API_RESPONSE_FORMAT.md](../API_RESPONSE_FORMAT.md)

---

**Created**: 2026-01-15  
**Last Updated**: 2026-01-15  
**Version**: 1.0
