# PersonalTrainerController Documentation

> **Controller**: `com.se100.GymAndPTManagement.controller.PersonalTrainerController`  
> **Base URL**: `/api/v1/pts`  
> **Purpose**: Quản lý thông tin Personal Trainer (PT) của phòng gym

---

## 📋 Tổng Quan

Controller này cung cấp các endpoint để quản lý thông tin Personal Trainer, bao gồm:
- Tạo PT mới
- Xem thông tin PT
- Cập nhật thông tin PT
- Xóa PT (soft delete)
- Tìm kiếm và lọc PT
- Quản lý trạng thái PT (Available/Busy)

---

## 🔗 Related Files

- **Entity**: `src/main/java/com/se100/GymAndPTManagement/domain/table/PersonalTrainer.java`
- **Service**: `src/main/java/com/se100/GymAndPTManagement/service/PersonalTrainerService.java`
- **Repository**: `src/main/java/com/se100/GymAndPTManagement/repository/PersonalTrainerRepository.java`

---

## 📝 Entity Structure

### PersonalTrainer Entity Fields
- `id` (Long): Primary key (pt_id trong database)
- `user` (User): 1:1 relationship với User entity (được tạo tự động)
- `about` (String): Giới thiệu về PT (TEXT)
- `specialization` (String): Chuyên môn (255 ký tự)
- `certifications` (String): Chứng chỉ (TEXT)
- `experienceYears` (Integer): Số năm kinh nghiệm (default: 0)
- `rating` (BigDecimal): Đánh giá (3,2) (default: 0.00)
- `status` (PTStatusEnum): Trạng thái PT (AVAILABLE, BUSY, INACTIVE)
- `note` (String): Ghi chú (TEXT)
- Audit fields: `createdAt`, `updatedAt`, `createdBy`, `updatedBy`

### User Entity Fields (Tạo cùng PT)
- `fullname` (String): Họ và tên
- `email` (String): Email (unique, required)
- `passwordHash` (String): Mật khẩu đã hash
- `phoneNumber` (String): Số điện thoại
- `avatarUrl` (String): URL ảnh đại diện
- `dob` (LocalDate): Ngày sinh
- `gender` (GenderEnum): Giới tính (MALE, FEMALE)
- `status` (UserStatusEnum): Trạng thái (ACTIVE, INACTIVE)

---

## 🚀 Endpoints

### 1. Create Personal Trainer
**POST** `/api/v1/pts`

**Description**: Tạo Personal Trainer mới (đồng thời tạo User account)

**Request Body**:
```json
{
  "fullname": "Nguyễn Văn PT",
  "email": "pt@example.com",
  "password": "SecurePassword123",
  "phoneNumber": "0912345678",
  "avatarUrl": "https://example.com/avatar.jpg",
  "dob": "1990-05-15",
  "gender": "MALE",
  "status": "ACTIVE",
  "about": "Chuyên gia tập gym với 10 năm kinh nghiệm",
  "specialization": "Bodybuilding, Weight Loss",
  "certifications": "ACE CPT, NASM-CPT",
  "experienceYears": 10,
  "note": "Có thể dạy cả tiếng Anh"
}
```

**Lưu ý**:
- `fullname`, `email`, `dob` là bắt buộc
- `password` là optional - nếu để trống sẽ mặc định là "12345678"
- `phoneNumber`, `avatarUrl`, `gender`, `status` là optional
- `about`, `specialization`, `certifications`, `experienceYears`, `note` là optional
- Default values: rating = 0.00, status = AVAILABLE, experienceYears = 0
- User và PT được tạo trong cùng 1 transaction

**Success Response** (201 Created):
```json
{
  "statusCode": 201,
  "message": "Tạo Personal Trainer mới",
  "data": {
    "id": 1,
    "user": {
      "id": 10,
      "fullname": "Nguyễn Văn PT",
      "email": "pt@example.com",
      "phoneNumber": "0912345678",
      "avatarUrl": "https://example.com/avatar.jpg",
      "dob": "1990-05-15",
      "gender": "MALE",
      "status": "ACTIVE"
    },
    "about": "Chuyên gia tập gym với 10 năm kinh nghiệm",
    "specialization": "Bodybuilding, Weight Loss",
    "certifications": "ACE CPT, NASM-CPT",
    "experienceYears": 10,
    "rating": 0.00,
    "status": "AVAILABLE",
    "note": "Có thể dạy cả tiếng Anh",
    "createdAt": "2026-01-08T11:20:37Z"
  }
}
```

**Error Responses**:
- **400 Bad Request**: Email đã tồn tại
  ```json
  {
    "statusCode": 400,
    "error": "Email đã tồn tại trong hệ thống"
  }
  ```

---

### 2. Get All Personal Trainers
**GET** `/api/v1/pts`

**Description**: Lấy danh sách tất cả Personal Trainer

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách các Personal Trainer",
  "data": [
    {
      "id": 1,
      "user": {
        "id": 10,
        "fullname": "Nguyễn Văn PT",
        "email": "pt@example.com",
        "phoneNumber": "0912345678",
        "avatarUrl": "https://example.com/avatar.jpg",
        "dob": "1990-05-15",
        "gender": "MALE",
        "status": "ACTIVE"
      },
      "about": "Chuyên gia tập gym với 10 năm kinh nghiệm",
      "specialization": "Bodybuilding, Weight Loss",
      "certifications": "ACE CPT, NASM-CPT",
      "experienceYears": 10,
      "rating": 4.85,
      "status": "AVAILABLE",
      "note": "Có thể dạy cả tiếng Anh",
      "createdAt": "2026-01-08T11:20:37Z",
      "updatedAt": "2026-01-08T14:30:00Z"
    }
  ]
}
```

---

### 3. Get Active Personal Trainers
**GET** `/api/v1/pts/active`

**Description**: Lấy danh sách Personal Trainer đang hoạt động (User status = ACTIVE)

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách các Personal Trainer đang hoạt động",
  "data": [
    {
      "id": 1,
      "user": {
        "id": 10,
        "fullname": "Nguyễn Văn PT",
        "email": "pt@example.com",
        "status": "ACTIVE"
      },
      "specialization": "Bodybuilding, Weight Loss",
      "rating": 4.85,
      "status": "AVAILABLE"
    }
  ]
}
```

---

### 4. Search Personal Trainer
**GET** `/api/v1/pts/search`

**Description**: Tìm kiếm Personal Trainer theo ID hoặc email

**Query Parameters** (ít nhất 1 tham số):
- `ptId` (Long, optional): PT ID
- `email` (String, optional): Email của PT

**Priority**: ptId > email

**Example Requests**:
```
GET /api/v1/pts/search?ptId=1
GET /api/v1/pts/search?email=pt@example.com
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy Personal Trainer theo ID hoặc email",
  "data": {
    "id": 1,
    "user": {
      "id": 10,
      "fullname": "Nguyễn Văn PT",
      "email": "pt@example.com",
      "phoneNumber": "0912345678",
      "avatarUrl": "https://example.com/avatar.jpg",
      "dob": "1990-05-15",
      "gender": "MALE",
      "status": "ACTIVE"
    },
    "about": "Chuyên gia tập gym với 10 năm kinh nghiệm",
    "specialization": "Bodybuilding, Weight Loss",
    "certifications": "ACE CPT, NASM-CPT",
    "experienceYears": 10,
    "rating": 4.85,
    "status": "AVAILABLE",
    "note": "Có thể dạy cả tiếng Anh",
    "createdAt": "2026-01-08T11:20:37Z"
  }
}
```

**Error Responses**:
- **400 Bad Request**: Không cung cấp tham số
  ```json
  {
    "statusCode": 400,
    "error": "Phải cung cấp ít nhất một trong các tham số: ptId hoặc email"
  }
  ```
- **404 Not Found**:
  ```json
  {
    "statusCode": 404,
    "error": "Không tìm thấy PT với ID: 1"
  }
  ```

---

### 5. Update Personal Trainer
**PUT** `/api/v1/pts/{id}`

**Description**: Cập nhật thông tin Personal Trainer (cả thông tin User và PT)

**Path Parameters**:
- `id` (Long): PT ID

**Request Body** (tất cả fields đều optional):
```json
{
  "fullname": "Nguyễn Văn PT Updated",
  "email": "pt-new@example.com",
  "password": "NewPassword123",
  "phoneNumber": "0987654321",
  "avatarUrl": "https://example.com/new-avatar.jpg",
  "dob": "1990-06-20",
  "gender": "MALE",
  "about": "Updated bio",
  "specialization": "CrossFit, HIIT",
  "certifications": "ACE CPT, NASM-CPT, CrossFit Level 1",
  "experienceYears": 12,
  "note": "Bilingual PT"
}
```

**Lưu ý**:
- Chỉ update các fields được gửi lên (null/empty sẽ giữ nguyên giá trị cũ)
- Email mới phải unique (không trùng với user khác)
- Password mới sẽ được hash trước khi lưu
- Không thể update `rating`, `status` qua endpoint này

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Cập nhật thông tin Personal Trainer",
  "data": {
    "id": 1,
    "user": {
      "id": 10,
      "fullname": "Nguyễn Văn PT Updated",
      "email": "pt-new@example.com",
      "phoneNumber": "0987654321",
      "avatarUrl": "https://example.com/new-avatar.jpg",
      "dob": "1990-06-20",
      "gender": "MALE",
      "status": "ACTIVE"
    },
    "about": "Updated bio",
    "specialization": "CrossFit, HIIT",
    "certifications": "ACE CPT, NASM-CPT, CrossFit Level 1",
    "experienceYears": 12,
    "rating": 4.85,
    "status": "AVAILABLE",
    "note": "Bilingual PT",
    "createdAt": "2026-01-08T11:20:37Z",
    "updatedAt": "2026-01-08T15:30:00Z"
  }
}
```

**Error Responses**:
- **404 Not Found**: PT không tồn tại
- **400 Bad Request**: Email đã tồn tại

---

### 6. Delete Personal Trainer (Soft Delete)
**DELETE** `/api/v1/pts/{id}`

**Description**: Xóa Personal Trainer (chuyển User.status và PT.status thành INACTIVE)

**Path Parameters**:
- `id` (Long): PT ID

**Success Response** (204 No Content):
```
HTTP/1.1 204 No Content
```

**Error Response**:
- **404 Not Found**:
  ```json
  {
    "statusCode": 404,
    "error": "Không tìm thấy PT với ID: 1"
  }
  ```

**Lưu ý**:
- Đây là soft delete, chỉ chuyển status thành INACTIVE
- Dữ liệu PT vẫn tồn tại trong database
- PT có status INACTIVE sẽ không xuất hiện trong `/pts/active`

---

### 7. Set PT as Available
**PUT** `/api/v1/pts/{id}/go-available`

**Description**: Kích hoạt lại Personal Trainer (chuyển PT.status thành AVAILABLE)

**Path Parameters**:
- `id` (Long): PT ID

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Kích hoạt lại Personal Trainer (chuyển trạng thái thành AVAILABLE)",
  "data": {
    "id": 1,
    "user": {
      "id": 10,
      "fullname": "Nguyễn Văn PT",
      "status": "ACTIVE"
    },
    "status": "AVAILABLE",
    "rating": 4.85
  }
}
```

**Error Responses**:
- **404 Not Found**: PT không tồn tại
- **400 Bad Request**: 
  - "Personal Trainer is not active" - User không ACTIVE
  - "Personal Trainer is already available" - Đã ở trạng thái AVAILABLE

---

### 8. Set PT as Busy
**PUT** `/api/v1/pts/{id}/go-busy`

**Description**: Đặt trạng thái Personal Trainer thành BUSY

**Path Parameters**:
- `id` (Long): PT ID

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Đặt trạng thái Personal Trainer thành BUSY",
  "data": {
    "id": 1,
    "user": {
      "id": 10,
      "fullname": "Nguyễn Văn PT",
      "status": "ACTIVE"
    },
    "status": "BUSY",
    "rating": 4.85
  }
}
```

**Error Responses**:
- **404 Not Found**: PT không tồn tại
- **400 Bad Request**:
  - "Personal Trainer is not active" - User không ACTIVE
  - "Personal Trainer is already busy" - Đã ở trạng thái BUSY

---

### 9. Get Available PTs by Slot and Date
**GET** `/api/v1/pts/available-by-slot`

**Description**: Lấy danh sách tất cả PT rảnh theo slot và ngày cụ thể

**Query Parameters**:
- `slotId` (required, Long): ID của slot cần tìm PT
- `date` (required, LocalDate): Ngày cần kiểm tra (format: yyyy-MM-dd)

**Request Examples**:
```
GET /api/v1/pts/available-by-slot?slotId=2&date=2026-01-20
GET /api/v1/pts/available-by-slot?slotId=1&date=2026-02-15
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách PT rảnh theo slot và ngày",
  "data": [
    {
      "id": 5,
      "user": {
        "id": 15,
        "fullname": "Nguyễn Văn A",
        "email": "pta@gym.com",
        "phoneNumber": "0912345678",
        "avatarUrl": "https://example.com/avatar1.jpg",
        "dob": "1990-05-15",
        "gender": "MALE",
        "status": "ACTIVE"
      },
      "about": "PT chuyên về Yoga và Pilates",
      "specialization": "Yoga, Pilates",
      "certifications": "ACE-CPT, NASM-CPT",
      "experienceYears": 5,
      "rating": 4.8,
      "status": "AVAILABLE",
      "note": null,
      "createdAt": "2025-12-01T08:00:00Z",
      "updatedAt": "2026-01-10T10:30:00Z"
    },
    {
      "id": 7,
      "user": {
        "id": 20,
        "fullname": "Trần Thị B",
        "email": "ptb@gym.com",
        "phoneNumber": "0923456789",
        "avatarUrl": "https://example.com/avatar2.jpg",
        "dob": "1992-08-20",
        "gender": "FEMALE",
        "status": "ACTIVE"
      },
      "about": "PT chuyên về Cardio và giảm cân",
      "specialization": "Cardio, Weight Loss",
      "certifications": "ISSA-CFT",
      "experienceYears": 3,
      "rating": 4.5,
      "status": "AVAILABLE",
      "note": null,
      "createdAt": "2025-11-15T09:00:00Z",
      "updatedAt": "2026-01-12T14:20:00Z"
    }
  ]
}
```

**Empty Result** (200 OK - không có PT rảnh):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách PT rảnh theo slot và ngày",
  "data": []
}
```

**Error Responses**:
- **404 Not Found**: 
  ```json
  {
    "statusCode": 404,
    "message": "Slot not found with id: 999",
    "error": "Id Invalid Exception"
  }
  ```
- **400 Bad Request** (invalid date format):
  ```json
  {
    "statusCode": 400,
    "message": "Failed to convert value of type 'java.lang.String' to required type 'java.time.LocalDate'",
    "error": "Bad Request"
  }
  ```

**Business Logic**:
1. Validate slot tồn tại trong database
2. Chuyển đổi date sang day of week (MONDAY, TUESDAY, etc.)
3. Tìm tất cả AvailableSlot với:
   - `slotId` = slotId truyền vào
   - `dayOfWeek` = day of week từ date
   - `isAvailable` = true
4. Lọc chỉ những PT có:
   - User.status = ACTIVE
   - PT.status = AVAILABLE
5. Trả về danh sách PT thỏa mãn

**Use Cases**:
- Member muốn tìm PT rảnh vào thứ 2, slot sáng sớm (06:00-08:00)
- Admin muốn xem có bao nhiêu PT available cho slot cụ thể trong ngày
- Hệ thống booking tự động suggest PT khi member chọn slot và ngày

**Notes**:
- Ngày trong tuần được tự động tính từ `date` (không cần truyền dayOfWeek)
- Chỉ trả về PT đang ACTIVE và AVAILABLE
- Nếu slot không tồn tại → 404
- Nếu không có PT nào rảnh → trả về array rỗng []
- Date format phải là yyyy-MM-dd (ví dụ: 2026-01-20)

---

## 🔒 Security & Authorization

- **Authentication**: Tất cả endpoints yêu cầu JWT token
- **Authorization**:
  - `GET /pts`: MEMBER, ADMIN, PT
  - `GET /pts/active`: MEMBER, ADMIN, PT
  - `GET /pts/search`: MEMBER, ADMIN, PT
  - `GET /pts/available-by-slot`: MEMBER, ADMIN, PT
  - `POST /pts`: ADMIN
  - `PUT /pts/{id}`: ADMIN, PT (chỉ update chính mình)
  - `DELETE /pts/{id}`: ADMIN
  - `PUT /pts/{id}/go-available`: ADMIN, PT (chỉ update chính mình)
  - `PUT /pts/{id}/go-busy`: ADMIN, PT (chỉ update chính mình)

---

## 🧪 Business Logic Notes

### Validation Rules
1. **Email**: 
   - Phải hợp lệ (format email)
   - Phải unique trong hệ thống
   - Max 150 ký tự
2. **Password**:
   - Optional khi tạo mới - mặc định "12345678" nếu để trống
   - Tối thiểu 8 ký tự khi tự nhập
   - Sẽ được hash bằng BCrypt trước khi lưu
3. **Phone Number**:
   - Phải là 10-11 chữ số
4. **Fullname**:
   - Required khi tạo mới
   - Max 150 ký tự
5. **Date of Birth**:
   - Required khi tạo mới
   - Format: YYYY-MM-DD
6. **Gender**: 
   - Chỉ nhận giá trị MALE hoặc FEMALE
7. **User Status**:
   - Chỉ nhận giá trị ACTIVE hoặc INACTIVE
   - Mặc định là ACTIVE nếu không cung cấp
8. **PT Status**:
   - AVAILABLE, BUSY, INACTIVE
   - Mặc định là AVAILABLE khi tạo mới
9. **Experience Years**:
   - Phải >= 0
   - Mặc định = 0
10. **Rating**:
    - DECIMAL(3,2) - từ 0.00 đến 9.99
    - Mặc định = 0.00
    - Không thể update trực tiếp (tính từ feedback)

### Transaction Management
- Tạo PT và User trong cùng 1 transaction (@Transactional)
- Nếu tạo User thất bại → rollback toàn bộ
- Nếu tạo PT thất bại → rollback cả User
- Update PT và User cũng trong cùng 1 transaction

### Search Logic
- Priority: ptId > email
- Nếu cung cấp ptId → tìm theo ptId (bỏ qua email)
- Nếu không có ptId nhưng có email → tìm theo email
- Phải cung cấp ít nhất 1 trong 2 tham số

### Status Management
- **AVAILABLE**: PT sẵn sàng nhận học viên mới
- **BUSY**: PT đang bận, không nhận thêm học viên
- **INACTIVE**: PT không còn làm việc (soft delete)
- Chỉ PT có User.status = ACTIVE mới có thể chuyển giữa AVAILABLE/BUSY
- PT bị INACTIVE không thể chuyển về AVAILABLE/BUSY trực tiếp

### Automatic Calculations
- `rating` được tự động cập nhật khi có feedback từ members
- `experienceYears` default = 0 khi tạo mới
- Password mặc định "12345678" nếu không cung cấp khi tạo mới

---

## 📚 Related Documentation

- [DATABASE_SCHEMA.md](../DATABASE_SCHEMA.md#6-personal-trainer-table)
- [API_RESPONSE_FORMAT.md](../API_RESPONSE_FORMAT.md)
- [ReqCreatePTDTO.java](../../src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCreatePTDTO.java)
- [ReqUpdatePTDTO.java](../../src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqUpdatePTDTO.java)
- [PTStatusEnum.java](../../src/main/java/com/se100/GymAndPTManagement/util/enums/PTStatusEnum.java)

---

**Created**: 2026-01-08  
**Last Updated**: 2026-01-14  
**Version**: 1.1
