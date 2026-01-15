# FoodController Documentation

> **Controller**: `com.se100.GymAndPTManagement.controller.FoodController`  
> **Base URL**: `/api/v1/foods`  
> **Purpose**: Quản lý cơ sở dữ liệu thực phẩm và thông tin dinh dưỡng

---

## 📋 Tổng Quan

Controller này cung cấp các endpoint để quản lý thông tin thực phẩm, bao gồm:
- Tạo thực phẩm mới với thông tin dinh dưỡng
- Xem thông tin thực phẩm
- Cập nhật thông tin thực phẩm
- Xóa thực phẩm
- Tìm kiếm và lọc thực phẩm theo nhiều tiêu chí
- Lấy danh sách thực phẩm giàu protein/carb/fat nhất

---

## 🔗 Related Files

- **Entity**: `src/main/java/com/se100/GymAndPTManagement/domain/table/Food.java`
- **Service**: `src/main/java/com/se100/GymAndPTManagement/service/FoodService.java`
- **Repository**: `src/main/java/com/se100/GymAndPTManagement/repository/FoodRepository.java`

---

## 📝 Entity Structure

### Food Entity Fields
- `id` (Long): Primary key
- `name` (String): Tên thực phẩm (unique, required, max 255 ký tự)
- `description` (String): Mô tả chi tiết (TEXT, optional)
- `calories` (BigDecimal): **Tự động tính** = protein*4 + carbs*4 + fat*9 (kcal/100g)
- `proteinG` (BigDecimal): Protein trong 100g thực phẩm (gram, required)
- `carbsG` (BigDecimal): Carbohydrate trong 100g thực phẩm (gram, required)
- `fatG` (BigDecimal): Fat trong 100g thực phẩm (gram, required)
- `note` (String): Ghi chú thêm (TEXT, optional)
- Audit fields: `createdAt`, `updatedAt`, `createdBy`, `updatedBy`

### Calculated Fields (Không lưu DB)
- `type` (String): **Tự động tính** dựa trên macro lớn nhất
  - `PROTEIN`: Nếu protein >= carbs và protein >= fat
  - `CARBOHYDRATE`: Nếu carbs >= protein và carbs >= fat
  - `FAT`: Nếu fat >= protein và fat >= carbs

---

## 🚀 Endpoints

### 1. Create Food
**POST** `/api/v1/foods`

**Description**: Tạo thực phẩm mới trong database

**Request Body**:
```json
{
  "name": "Cơm trắng",
  "description": "Cơm trắng nấu từ gạo tẻ",
  "proteinG": 2.7,
  "carbsG": 28.2,
  "fatG": 0.3,
  "note": "Thực phẩm chủ lực cung cấp năng lượng"
}
```

**Lưu ý**:
- `name`, `proteinG`, `carbsG`, `fatG` là **bắt buộc**
- `description`, `note` là optional
- `calories` và `type` sẽ **tự động tính** khi lưu
- Tên thực phẩm phải unique

**Success Response** (201 Created):
```json
{
  "statusCode": 201,
  "message": "Tạo thực phẩm mới",
  "data": {
    "id": 1,
    "name": "Cơm trắng",
    "description": "Cơm trắng nấu từ gạo tẻ",
    "calories": 125.9,
    "proteinG": 2.7,
    "carbsG": 28.2,
    "fatG": 0.3,
    "note": "Thực phẩm chủ lực cung cấp năng lượng",
    "type": "CARBOHYDRATE",
    "createdAt": "2026-01-15T14:30:00Z"
  }
}
```

**Calculation Example**:
```
calories = proteinG*4 + carbsG*4 + fatG*9
         = 2.7*4 + 28.2*4 + 0.3*9
         = 10.8 + 112.8 + 2.7
         = 125.9 kcal/100g

type = CARBOHYDRATE (vì carbsG = 28.2 là lớn nhất)
```

**Error Responses**:
- **400 Bad Request**: Dữ liệu không hợp lệ
  ```json
  {
    "statusCode": 400,
    "error": "Tên thực phẩm đã tồn tại trong hệ thống"
  }
  ```
  ```json
  {
    "statusCode": 400,
    "error": "Protein phải >= 0"
  }
  ```

---

### 2. Get Food by ID
**GET** `/api/v1/foods/{id}`

**Description**: Lấy thông tin chi tiết của 1 thực phẩm

**Path Parameters**:
- `id` (Long): Food ID

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy thông tin thực phẩm theo ID",
  "data": {
    "id": 1,
    "name": "Cơm trắng",
    "description": "Cơm trắng nấu từ gạo tẻ",
    "calories": 125.9,
    "proteinG": 2.7,
    "carbsG": 28.2,
    "fatG": 0.3,
    "note": "Thực phẩm chủ lực cung cấp năng lượng",
    "type": "CARBOHYDRATE",
    "createdAt": "2026-01-15T14:30:00Z",
    "updatedAt": "2026-01-15T15:00:00Z"
  }
}
```

**Error Response**:
- **404 Not Found**:
  ```json
  {
    "statusCode": 404,
    "error": "Không tìm thấy thực phẩm với ID: 1"
  }
  ```

---

### 3. Get All Foods
**GET** `/api/v1/foods`

**Description**: Lấy danh sách tất cả thực phẩm

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách tất cả thực phẩm",
  "data": [
    {
      "id": 1,
      "name": "Cơm trắng",
      "calories": 125.9,
      "proteinG": 2.7,
      "carbsG": 28.2,
      "fatG": 0.3,
      "type": "CARBOHYDRATE"
    },
    {
      "id": 2,
      "name": "Ức gà luộc",
      "calories": 165.0,
      "proteinG": 31.0,
      "carbsG": 0.0,
      "fatG": 3.6,
      "type": "PROTEIN"
    }
  ]
}
```

---

### 4. Fetch Foods with Filter
**GET** `/api/v1/foods/fetch`

**Description**: Lấy danh sách thực phẩm với filter động và pagination

**Query Parameters**:
- `filter` (String, optional): Spring-Filter expression
- `page` (int, optional, default=0): Page number (0-indexed)
- `size` (int, optional, default=20): Page size
- `sort` (String, optional): Sort criteria (e.g., `name,asc` hoặc `calories,desc`)

**Filter Examples**:
```
# Tìm thực phẩm có tên chứa "gà"
filter=name~'*gà*'

# Tìm thực phẩm có calories từ 100-200
filter=calories>100 and calories<200

# Tìm thực phẩm giàu protein (>20g)
filter=proteinG>20

# Kết hợp nhiều điều kiện
filter=proteinG>20 and carbsG<5 and fatG<10
```

**Example Request**:
```
GET /api/v1/foods/fetch?filter=proteinG>20&page=0&size=10&sort=proteinG,desc
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Fetch foods with filter",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 10,
      "totalPages": 3,
      "totalItems": 25
    },
    "result": [
      {
        "id": 2,
        "name": "Ức gà luộc",
        "calories": 165.0,
        "proteinG": 31.0,
        "carbsG": 0.0,
        "fatG": 3.6,
        "type": "PROTEIN"
      }
    ]
  }
}
```

---

### 5. Search Foods by Keyword
**GET** `/api/v1/foods/search`

**Description**: Tìm kiếm thực phẩm theo từ khóa (tìm trong name và note)

**Query Parameters**:
- `keyword` (String, required): Từ khóa tìm kiếm
- `page` (int, optional, default=0): Page number
- `size` (int, optional, default=20): Page size

**Example Request**:
```
GET /api/v1/foods/search?keyword=gà&page=0&size=10
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Tìm kiếm thực phẩm theo từ khóa",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 10,
      "totalPages": 1,
      "totalItems": 3
    },
    "result": [
      {
        "id": 2,
        "name": "Ức gà luộc",
        "calories": 165.0,
        "proteinG": 31.0,
        "carbsG": 0.0,
        "fatG": 3.6,
        "type": "PROTEIN"
      },
      {
        "id": 5,
        "name": "Đùi gà rán",
        "calories": 245.0,
        "proteinG": 24.0,
        "carbsG": 8.0,
        "fatG": 13.0,
        "type": "PROTEIN"
      }
    ]
  }
}
```

---

### 6. Get Foods by Type
**GET** `/api/v1/foods/by-type/{type}`

**Description**: Lấy danh sách thực phẩm theo loại (PROTEIN/CARBOHYDRATE/FAT)

**Path Parameters**:
- `type` (String): Loại thực phẩm (`PROTEIN`, `CARBOHYDRATE`, hoặc `FAT`)

**Query Parameters**:
- `page` (int, optional, default=0): Page number
- `size` (int, optional, default=20): Page size

**Example Request**:
```
GET /api/v1/foods/by-type/PROTEIN?page=0&size=10
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy thực phẩm theo loại (PROTEIN/CARBOHYDRATE/FAT)",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 10,
      "totalPages": 2,
      "totalItems": 15
    },
    "result": [
      {
        "id": 2,
        "name": "Ức gà luộc",
        "calories": 165.0,
        "proteinG": 31.0,
        "carbsG": 0.0,
        "fatG": 3.6,
        "type": "PROTEIN"
      }
    ]
  }
}
```

**Error Response**:
- **400 Bad Request**: Type không hợp lệ
  ```json
  {
    "statusCode": 400,
    "error": "Invalid food type. Must be PROTEIN, CARBOHYDRATE, or FAT."
  }
  ```

---

### 7. Get Foods by Calories Range
**GET** `/api/v1/foods/by-calories`

**Description**: Lấy danh sách thực phẩm trong khoảng calories

**Query Parameters**:
- `min` (BigDecimal, required): Calories tối thiểu
- `max` (BigDecimal, required): Calories tối đa
- `page` (int, optional, default=0): Page number
- `size` (int, optional, default=20): Page size

**Example Request**:
```
GET /api/v1/foods/by-calories?min=100&max=200&page=0&size=10
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy thực phẩm theo khoảng calories",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 10,
      "totalPages": 1,
      "totalItems": 5
    },
    "result": [
      {
        "id": 1,
        "name": "Cơm trắng",
        "calories": 125.9,
        "proteinG": 2.7,
        "carbsG": 28.2,
        "fatG": 0.3,
        "type": "CARBOHYDRATE"
      },
      {
        "id": 2,
        "name": "Ức gà luộc",
        "calories": 165.0,
        "proteinG": 31.0,
        "carbsG": 0.0,
        "fatG": 3.6,
        "type": "PROTEIN"
      }
    ]
  }
}
```

---

### 8. Get Top Protein Foods
**GET** `/api/v1/foods/top-protein`

**Description**: Lấy danh sách thực phẩm giàu protein nhất

**Query Parameters**:
- `limit` (int, optional, default=10): Số lượng kết quả

**Example Request**:
```
GET /api/v1/foods/top-protein?limit=5
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thực phẩm giàu protein nhất",
  "data": [
    {
      "id": 10,
      "name": "Whey protein isolate",
      "calories": 370.0,
      "proteinG": 90.0,
      "carbsG": 2.0,
      "fatG": 1.0,
      "type": "PROTEIN"
    },
    {
      "id": 15,
      "name": "Thịt bò nạc",
      "calories": 250.0,
      "proteinG": 36.0,
      "carbsG": 0.0,
      "fatG": 12.0,
      "type": "PROTEIN"
    },
    {
      "id": 2,
      "name": "Ức gà luộc",
      "calories": 165.0,
      "proteinG": 31.0,
      "carbsG": 0.0,
      "fatG": 3.6,
      "type": "PROTEIN"
    }
  ]
}
```

---

### 9. Get Top Carbohydrate Foods
**GET** `/api/v1/foods/top-carb`

**Description**: Lấy danh sách thực phẩm giàu carbohydrate nhất

**Query Parameters**:
- `limit` (int, optional, default=10): Số lượng kết quả

**Example Request**:
```
GET /api/v1/foods/top-carb?limit=5
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thực phẩm giàu carbohydrate nhất",
  "data": [
    {
      "id": 20,
      "name": "Yến mạch",
      "calories": 389.0,
      "proteinG": 16.9,
      "carbsG": 66.3,
      "fatG": 6.9,
      "type": "CARBOHYDRATE"
    },
    {
      "id": 25,
      "name": "Khoai lang",
      "calories": 359.0,
      "proteinG": 4.0,
      "carbsG": 85.0,
      "fatG": 0.5,
      "type": "CARBOHYDRATE"
    }
  ]
}
```

---

### 10. Get Top Fat Foods
**GET** `/api/v1/foods/top-fat`

**Description**: Lấy danh sách thực phẩm giàu fat nhất

**Query Parameters**:
- `limit` (int, optional, default=10): Số lượng kết quả

**Example Request**:
```
GET /api/v1/foods/top-fat?limit=5
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thực phẩm giàu fat nhất",
  "data": [
    {
      "id": 30,
      "name": "Bơ (Avocado)",
      "calories": 160.0,
      "proteinG": 2.0,
      "carbsG": 8.5,
      "fatG": 14.7,
      "type": "FAT"
    },
    {
      "id": 35,
      "name": "Hạnh nhân",
      "calories": 579.0,
      "proteinG": 21.2,
      "carbsG": 21.6,
      "fatG": 49.9,
      "type": "FAT"
    }
  ]
}
```

---

### 11. Update Food
**PUT** `/api/v1/foods/{id}`

**Description**: Cập nhật thông tin thực phẩm

**Path Parameters**:
- `id` (Long): Food ID

**Request Body** (tất cả fields đều optional):
```json
{
  "name": "Cơm gạo lứt",
  "description": "Cơm gạo lứt giàu chất xơ",
  "proteinG": 2.8,
  "carbsG": 23.5,
  "fatG": 0.9,
  "note": "Tốt cho người ăn kiêng"
}
```

**Lưu ý**:
- Chỉ update các fields được gửi lên (null/empty giữ nguyên)
- `calories` và `type` sẽ **tự động tính lại** khi update macro
- Tên mới phải unique (không trùng với food khác)

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Cập nhật thông tin thực phẩm",
  "data": {
    "id": 1,
    "name": "Cơm gạo lứt",
    "description": "Cơm gạo lứt giàu chất xơ",
    "calories": 114.3,
    "proteinG": 2.8,
    "carbsG": 23.5,
    "fatG": 0.9,
    "note": "Tốt cho người ăn kiêng",
    "type": "CARBOHYDRATE",
    "createdAt": "2026-01-15T14:30:00Z",
    "updatedAt": "2026-01-15T16:00:00Z"
  }
}
```

**Error Responses**:
- **404 Not Found**:
  ```json
  {
    "statusCode": 404,
    "error": "Không tìm thấy thực phẩm với ID: 1"
  }
  ```
- **400 Bad Request**:
  ```json
  {
    "statusCode": 400,
    "error": "Tên thực phẩm đã tồn tại trong hệ thống"
  }
  ```

---

### 12. Delete Food
**DELETE** `/api/v1/foods/{id}`

**Description**: Xóa thực phẩm khỏi database (hard delete)

**Path Parameters**:
- `id` (Long): Food ID

**Success Response** (204 No Content):
```
HTTP/1.1 204 No Content
```

**Error Response**:
- **404 Not Found**:
  ```json
  {
    "statusCode": 404,
    "error": "Không tìm thấy thực phẩm với ID: 1"
  }
  ```

**Lưu ý**:
- Đây là **hard delete** - thực phẩm sẽ bị xóa hoàn toàn khỏi database
- Không thể khôi phục sau khi xóa
- Nên kiểm tra xem food có đang được sử dụng trong DietDetail không trước khi xóa

---

## 🔒 Security & Authorization

- **Authentication**: Tất cả endpoints yêu cầu JWT token
- **Authorization**:
  - `GET /foods/*`: MEMBER, ADMIN, PERSONAL_TRAINER
  - `POST /foods`: ADMIN, PERSONAL_TRAINER
  - `PUT /foods/{id}`: ADMIN, PERSONAL_TRAINER
  - `DELETE /foods/{id}`: ADMIN

---

## 🧪 Business Logic Notes

### Validation Rules
1. **Name**: 
   - Required khi tạo mới
   - Phải unique trong hệ thống
   - Max 255 ký tự
2. **ProteinG, CarbsG, FatG**: 
   - Required khi tạo mới
   - Phải >= 0
   - Precision: 8, Scale: 2
3. **Description, Note**:
   - Optional
   - Kiểu TEXT (không giới hạn độ dài)

### Automatic Calculations

#### Calories Calculation
```java
calories = proteinG * 4 + carbsG * 4 + fatG * 9
```
- Protein: 4 kcal/g
- Carbohydrate: 4 kcal/g
- Fat: 9 kcal/g
- Tự động tính trong `@PrePersist` và `@PreUpdate`

#### Type Determination
```java
if (proteinG >= carbsG && proteinG >= fatG) → type = "PROTEIN"
else if (carbsG >= proteinG && carbsG >= fatG) → type = "CARBOHYDRATE"
else → type = "FAT"
```
- Type **không được lưu vào database**
- Được tính động qua getter method `getType()`
- Dựa trên macro có khối lượng lớn nhất

### Search & Filter Features
1. **Keyword Search**: Tìm trong `name` và `note` (case-insensitive)
2. **Type Filter**: Lọc theo loại thực phẩm (PROTEIN/CARBOHYDRATE/FAT)
3. **Calories Range**: Lọc theo khoảng calories
4. **Spring Filter**: Hỗ trợ filter động với nhiều điều kiện phức tạp
5. **Top Lists**: Sắp xếp theo protein/carb/fat giảm dần

### Transaction Management
- Tạo và update Food trong transaction (@Transactional)
- Validation duplicate name trước khi save
- Rollback nếu có lỗi

---

## 📊 Use Cases

### Use Case 1: Tạo kế hoạch ăn kiêng giảm cân
```
1. GET /foods/by-type/PROTEIN?size=10 → Lấy thực phẩm giàu protein
2. GET /foods/by-calories?min=50&max=150 → Lấy thực phẩm ít calories
3. Kết hợp tạo meal plan với DietDetail
```

### Use Case 2: Tìm thực phẩm thay thế
```
1. GET /foods/{id} → Lấy thông tin food hiện tại
2. GET /foods/by-type/{type}&filter=calories>{min} and calories<{max}
   → Tìm food cùng type và calories range tương tự
```

### Use Case 3: Phân tích dinh dưỡng
```
1. GET /foods/top-protein?limit=20 → Top protein sources
2. GET /foods/top-carb?limit=20 → Top carb sources
3. GET /foods/top-fat?limit=20 → Top fat sources
4. So sánh và chọn food phù hợp với mục tiêu dinh dưỡng
```

---

## 📚 Related Documentation

- [DATABASE_SCHEMA.md](../DATABASE_SCHEMA.md#18-food-table)
- [API_RESPONSE_FORMAT.md](../API_RESPONSE_FORMAT.md)
- [ReqCreateFoodDTO.java](../../src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCreateFoodDTO.java)
- [ReqUpdateFoodDTO.java](../../src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqUpdateFoodDTO.java)

---

**Created**: 2026-01-15  
**Last Updated**: 2026-01-15  
**Version**: 1.0
