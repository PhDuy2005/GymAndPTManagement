# DietDetailController Documentation

> **Controller**: `com.se100.GymAndPTManagement.controller.DietDetailController`  
> **Base URL**: `/api/v1/diet-details`  
> **Purpose**: Quản lý chi tiết thực phẩm trong thực đơn hàng ngày

---

## 📋 Tổng Quan

Controller này cung cấp các endpoint để quản lý thực phẩm trong thực đơn, bao gồm:
- Thêm thực phẩm vào thực đơn với liều lượng cụ thể
- Xem thông tin chi tiết thực phẩm (nutrition được tính theo amount)
- Cập nhật liều lượng và phương pháp chế biến
- Xóa thực phẩm khỏi thực đơn
- Tìm kiếm thực phẩm theo diet hoặc food ID

---

## 🔗 Related Files

- **Entity**: `src/main/java/com/se100/GymAndPTManagement/domain/table/DietDetail.java`
- **Composite Key**: `src/main/java/com/se100/GymAndPTManagement/domain/table/DietDetailId.java`
- **Service**: `src/main/java/com/se100/GymAndPTManagement/service/DietDetailService.java`
- **Repository**: `src/main/java/com/se100/GymAndPTManagement/repository/DietDetailRepository.java`

---

## 📝 Entity Structure

### DietDetail Entity Fields
- **Composite Primary Key** (`@IdClass(DietDetailId.class)`):
  - `dietId` (Long): Foreign key to DailyDiet (required)
  - `foodId` (Long): Foreign key to Food (required)
- `prepMethod` (String): Phương pháp chế biến (max 255, optional)
- `amount` (BigDecimal): Khối lượng thực phẩm tính bằng gram (required)
- `note` (String): Ghi chú (TEXT, optional)

### DietDetailId Composite Key
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DietDetailId implements Serializable {
    private Long dietId;
    private Long foodId;
    
    // equals() và hashCode() được generate bởi @Data
}
```

**Lưu ý**:
- Composite key ngăn chặn duplicate: **1 food chỉ xuất hiện 1 lần trong 1 diet**
- Phải implement `Serializable` và override `equals()`, `hashCode()`

### Response DTO Structure
```java
{
  "dietId": 1,
  "foodId": 5,
  "foodName": "Ức gà luộc",
  "prepMethod": "Luộc",
  "amount": 200,
  "note": "Bữa sáng",
  
  // Nutrition per 100g (from Food entity)
  "caloriesPer100g": 165.0,
  "proteinPer100g": 31.0,
  "carbsPer100g": 0.0,
  "fatPer100g": 3.6,
  
  // Total nutrition (calculated based on amount)
  "totalCalories": 330.0,
  "totalProteinG": 62.0,
  "totalCarbsG": 0.0,
  "totalFatG": 7.2
}
```

---

## 🚀 Endpoints

### 1. Add Food to Diet
**POST** `/api/v1/diet-details`

**Description**: Thêm thực phẩm vào thực đơn với liều lượng cụ thể

**Request Body**:
```json
{
  "dietId": 1,
  "foodId": 5,
  "prepMethod": "Luộc",
  "amount": 200,
  "note": "Bữa sáng"
}
```

**Lưu ý**:
- `dietId`, `foodId`, `amount` là **bắt buộc**
- `prepMethod`, `note` là optional
- Diet và Food phải tồn tại trong database
- **Không thể thêm duplicate**: 1 food chỉ xuất hiện 1 lần/diet (composite key)

**Success Response** (201 Created):
```json
{
  "statusCode": 201,
  "message": "Thêm thực phẩm vào thực đơn",
  "data": {
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
}
```

**Calculation Formula**:
```
totalCalories = (caloriesPer100g / 100) × amount
totalProteinG = (proteinPer100g / 100) × amount
totalCarbsG = (carbsPer100g / 100) × amount
totalFatG = (fatPer100g / 100) × amount
```

**Example Calculation**:
```
Ức gà: 165 kcal, 31g protein, 0g carbs, 3.6g fat (per 100g)
Amount: 200g
→ totalCalories = 165 / 100 × 200 = 330 kcal
→ totalProteinG = 31 / 100 × 200 = 62g
→ totalFatG = 3.6 / 100 × 200 = 7.2g
```

**Error Responses**:
- **400 Bad Request**: Food đã tồn tại trong diet
  ```json
  {
    "statusCode": 400,
    "error": "Thực phẩm này đã có trong thực đơn"
  }
  ```
- **404 Not Found**: Diet hoặc Food không tồn tại
  ```json
  {
    "statusCode": 404,
    "error": "Không tìm thấy thực đơn với ID: 1"
  }
  ```

---

### 2. Get Diet Detail by Composite Key
**GET** `/api/v1/diet-details/diet/{dietId}/food/{foodId}`

**Description**: Lấy thông tin chi tiết thực phẩm trong thực đơn

**Path Parameters**:
- `dietId` (Long): Daily Diet ID
- `foodId` (Long): Food ID

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy thông tin chi tiết thực phẩm trong thực đơn",
  "data": {
    "dietId": 1,
    "foodId": 5,
    "foodName": "Ức gà luộc",
    "prepMethod": "Luộc",
    "amount": 200,
    "totalCalories": 330.0,
    "totalProteinG": 62.0
  }
}
```

**Error Response**:
- **404 Not Found**: Diet detail không tồn tại

---

### 3. Get All Foods in Diet
**GET** `/api/v1/diet-details/by-diet/{dietId}`

**Description**: Lấy danh sách tất cả thực phẩm trong 1 thực đơn (no pagination)

**Path Parameters**:
- `dietId` (Long): Daily Diet ID

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thực phẩm trong thực đơn",
  "data": [
    {
      "dietId": 1,
      "foodId": 5,
      "foodName": "Ức gà luộc",
      "amount": 200,
      "totalCalories": 330.0,
      "totalProteinG": 62.0
    },
    {
      "dietId": 1,
      "foodId": 8,
      "foodName": "Cơm trắng",
      "amount": 150,
      "totalCalories": 189.0,
      "totalCarbsG": 42.3
    }
  ]
}
```

---

### 4. Get Foods in Diet with Pagination
**GET** `/api/v1/diet-details/by-diet/{dietId}/paginated`

**Description**: Lấy danh sách thực phẩm trong thực đơn với pagination

**Path Parameters**:
- `dietId` (Long): Daily Diet ID

**Query Parameters**:
- `page` (int, optional, default=0): Page number (0-indexed)
- `size` (int, optional, default=20): Page size
- `sort` (String, optional): Sort criteria (e.g., "amount,desc")

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thực phẩm trong thực đơn (phân trang)",
  "data": {
    "meta": {
      "page": 1,
      "pageSize": 20,
      "totalPages": 1,
      "totalItems": 5
    },
    "result": [...]
  }
}
```

---

### 5. Fetch Diet Details with Filter
**GET** `/api/v1/diet-details/fetch`

**Description**: Lấy danh sách diet details với filter động và pagination

**Query Parameters**:
- `filter` (String, optional): Spring-Filter expression
- `page`, `size`, `sort` (optional): Pagination parameters

**Filter Examples**:
```
# Tìm diet details với amount >= 200g
filter=amount>=200

# Tìm diet details của diet ID 1
filter=dietId:1

# Tìm diet details có phương pháp luộc/hấp
filter=prepMethod~'Luộc' or prepMethod~'Hấp'

# Tìm diet details của food ID 5
filter=foodId:5
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách diet details với filter",
  "data": {
    "meta": {...},
    "result": [...]
  }
}
```

---

### 6. Get Diets Containing Specific Food
**GET** `/api/v1/diet-details/by-food/{foodId}`

**Description**: Tìm tất cả thực đơn có chứa thực phẩm cụ thể

**Path Parameters**:
- `foodId` (Long): Food ID

**Query Parameters**:
- `page`, `size`, `sort` (optional): Pagination parameters

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách thực đơn có chứa thực phẩm",
  "data": {
    "meta": {...},
    "result": [
      {
        "dietId": 1,
        "foodId": 5,
        "foodName": "Ức gà luộc",
        "amount": 200
      },
      {
        "dietId": 3,
        "foodId": 5,
        "foodName": "Ức gà luộc",
        "amount": 150
      }
    ]
  }
}
```

**Use Case**: Xem thực phẩm này được dùng trong những thực đơn nào

---

### 7. Update Diet Detail
**PUT** `/api/v1/diet-details/diet/{dietId}/food/{foodId}`

**Description**: Cập nhật thông tin thực phẩm trong thực đơn

**Path Parameters**:
- `dietId` (Long): Daily Diet ID
- `foodId` (Long): Food ID

**Request Body** (tất cả fields optional):
```json
{
  "prepMethod": "Nướng",
  "amount": 250,
  "note": "Bữa trưa"
}
```

**Lưu ý**:
- Chỉ update các fields được gửi lên
- **Không thể thay đổi dietId hoặc foodId** (composite key)
- Để chuyển sang food khác: DELETE rồi POST mới

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Cập nhật thông tin thực phẩm trong thực đơn",
  "data": {
    "dietId": 1,
    "foodId": 5,
    "prepMethod": "Nướng",
    "amount": 250,
    "note": "Bữa trưa",
    "totalCalories": 412.5,
    "totalProteinG": 77.5
  }
}
```

**Nutrition Re-calculation**:
```
Old: 200g → 330 kcal, 62g protein
New: 250g → 412.5 kcal, 77.5g protein
```

---

### 8. Remove Food from Diet
**DELETE** `/api/v1/diet-details/diet/{dietId}/food/{foodId}`

**Description**: Xóa thực phẩm khỏi thực đơn

**Path Parameters**:
- `dietId` (Long): Daily Diet ID
- `foodId` (Long): Food ID

**Success Response** (204 No Content):
```
HTTP/1.1 204 No Content
```

**Lưu ý**:
- Hard delete - không thể khôi phục
- Chỉ xóa 1 thực phẩm cụ thể trong diet

---

### 9. Remove All Foods from Diet
**DELETE** `/api/v1/diet-details/by-diet/{dietId}`

**Description**: Xóa tất cả thực phẩm khỏi thực đơn

**Path Parameters**:
- `dietId` (Long): Daily Diet ID

**Success Response** (204 No Content):
```
HTTP/1.1 204 No Content
```

**Lưu ý**:
- Bulk delete - xóa tất cả diet details có `dietId` này
- Sử dụng khi muốn reset thực đơn hoàn toàn

---

## 🔒 Security & Authorization

- **Authentication**: Tất cả endpoints yêu cầu JWT token
- **Authorization**:
  - `GET /diet-details/*`: MEMBER, ADMIN, PERSONAL_TRAINER
  - `POST /diet-details`: ADMIN, PERSONAL_TRAINER, MEMBER (own diet)
  - `PUT /diet-details/*`: ADMIN, PERSONAL_TRAINER, MEMBER (own diet)
  - `DELETE /diet-details/*`: ADMIN, PERSONAL_TRAINER, MEMBER (own diet)

---

## 🧪 Business Logic Notes

### Composite Key Constraints
```sql
PRIMARY KEY (diet_id, food_id)
FOREIGN KEY (diet_id) REFERENCES daily_diet(diet_id)
FOREIGN KEY (food_id) REFERENCES food(food_id)
```

**Implications**:
1. **No Duplicate Food**: 1 food chỉ xuất hiện 1 lần trong 1 diet
2. **Cascade Delete**: Xóa DailyDiet → auto xóa tất cả DietDetails (nếu có CASCADE)
3. **Update Limitation**: Không thể update dietId/foodId (composite key)

### Nutrition Calculation Logic
```java
BigDecimal amount = dietDetail.getAmount() != null 
    ? dietDetail.getAmount() 
    : BigDecimal.ZERO;

BigDecimal totalCalories = food.getCalories()
    .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP)
    .multiply(amount);
```

**Properties**:
- Precision: 2 decimal places (HALF_UP rounding)
- Null-safe: amount = 0 nếu null
- Consistent: Cùng formula ở DietDetailService và DailyDietService

### Why Total* Fields in Response?
1. **Frontend Display**: Hiển thị tổng nutrition không cần tính lại
2. **Consistent Formula**: Backend đảm bảo công thức tính đúng
3. **Performance**: Calculate once, reuse many times
4. **Aggregation**: SQL có thể SUM(totalCalories) để tính tổng calo ngày

**Alternative Design**: Có thể bỏ total* fields và để frontend tự tính
```javascript
// Frontend calculation (nếu bỏ total* fields)
totalCalories = (caloriesPer100g / 100) * amount
```

---

## 📊 Use Cases

### Use Case 1: Tạo thực đơn hàng ngày đầy đủ
```
1. POST /daily-diets (member=1, date=2026-01-15)
   → dietId = 1

2. POST /diet-details (dietId=1, foodId=5, amount=200)
   → Ức gà 200g: 330 kcal, 62g protein

3. POST /diet-details (dietId=1, foodId=8, amount=150)
   → Cơm trắng 150g: 189 kcal, 42.3g carbs

4. POST /diet-details (dietId=1, foodId=12, amount=100)
   → Bông cải 100g: 34 kcal, 2.8g protein

5. GET /daily-diets/1
   → Returns diet với 3 diet details, total nutrition đã tính
```

### Use Case 2: Điều chỉnh liều lượng thực phẩm
```
PUT /diet-details/diet/1/food/5
Body: { "amount": 250 }

Old: 200g → 330 kcal, 62g protein
New: 250g → 412.5 kcal, 77.5g protein
```

### Use Case 3: Xem thực phẩm được dùng phổ biến
```
GET /diet-details/by-food/5?size=50
→ List tất cả diets có chứa Ức gà
→ Analyze frequency, average amount
```

### Use Case 4: Tính tổng nutrition của diet
```sql
-- Backend có thể query
SELECT 
    d.diet_id,
    SUM(dd.total_calories) as total_calories,
    SUM(dd.total_protein_g) as total_protein,
    SUM(dd.total_carbs_g) as total_carbs,
    SUM(dd.total_fat_g) as total_fat
FROM daily_diet d
JOIN diet_detail dd ON d.diet_id = dd.diet_id
WHERE d.member_id = 1 AND d.diet_date = '2026-01-15'
GROUP BY d.diet_id;
```

---

## 🔄 Integration with DailyDiet

### Cascade Loading
Khi fetch DailyDiet, response tự động include diet details:
```java
// DailyDietService.convertToDTO()
List<ResDietDetailDTO> dietDetails = dietDetailRepository
    .findByDietId(dailyDiet.getId())
    .stream()
    .map(this::convertDietDetailToDTO)
    .collect(Collectors.toList());

return ResDailyDietDTO.builder()
    .dietDetails(dietDetails)  // Auto-load
    .build();
```

### Workflow
```
User Request: GET /daily-diets/1
    ↓
DailyDietService.getDailyDietById(1)
    ↓
Load DailyDiet from DB
    ↓
Load DietDetails by dietId=1
    ↓
For each DietDetail:
    ↓
Load Food info
    ↓
Calculate total nutrition
    ↓
Build ResDietDetailDTO
    ↓
Return ResDailyDietDTO with dietDetails array
```

---

## 🚨 Common Errors & Solutions

### Error 1: Duplicate Food in Diet
```json
{
  "statusCode": 400,
  "error": "Thực phẩm này đã có trong thực đơn"
}
```
**Solution**: Check existing diet details trước khi POST

### Error 2: Cannot Update Composite Key
```
Lỗi: Không thể update dietId hoặc foodId
```
**Solution**: DELETE cũ → POST mới với key khác

### Error 3: Foreign Key Violation
```json
{
  "statusCode": 404,
  "error": "Không tìm thấy thực đơn với ID: 999"
}
```
**Solution**: Verify diet và food tồn tại trước khi POST

---

## 📚 Related Documentation

- [DATABASE_SCHEMA.md](../DATABASE_SCHEMA.md#18-diet-detail-table)
- [DailyDietController.md](./DailyDietController.md)
- [Composite Key Pattern](../DESIGN_PATTERNS.md#composite-key-pattern)

---

**Created**: 2026-01-15  
**Last Updated**: 2026-01-15  
**Version**: 1.0
