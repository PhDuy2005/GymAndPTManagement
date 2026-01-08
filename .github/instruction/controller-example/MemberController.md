# MemberController Documentation

> **Controller**: `com.se100.GymAndPTManagement.controller.MemberController`  
> **Base URL**: `/api/v1/members`  
> **Purpose**: Quản lý thông tin hội viên (Member) của phòng gym

---

## 📋 Tổng Quan

Controller này cung cấp các endpoint để quản lý thông tin hội viên, bao gồm:
- Tạo hội viên mới
- Xem thông tin hội viên
- Cập nhật thông tin hội viên
- Xóa hội viên
- Tìm kiếm và lọc hội viên

---

## 🔗 Related Files

- **Entity**: `src/main/java/com/se100/GymAndPTManagement/domain/table/Member.java`
- **Service**: `src/main/java/com/se100/GymAndPTManagement/service/MemberService.java`
- **Repository**: `src/main/java/com/se100/GymAndPTManagement/repository/MemberRepository.java`

---

## 📝 Entity Structure

### Member Entity Fields
- `id` (Long): Primary key
- `user` (User): 1:1 relationship với User entity (được tạo tự động)
- `cccd` (String): Số CMND/CCCD (12 ký tự, unique, optional)
- `moneySpent` (BigDecimal): Tổng số tiền đã chi tiêu (default: 0)
- `moneyDebt` (BigDecimal): Số tiền nợ (default: 0)
- `joinDate` (LocalDate): Ngày tham gia (default: ngày tạo)
- Audit fields: `createdAt`, `updatedAt`, `createdBy`, `updatedBy`

### User Entity Fields (Tạo cùng Member)
- `fullname` (String): Họ và tên
- `email` (String): Email (unique, required)
- `passwordHash` (String): Mật khẩu đã hash (required)
- `phoneNumber` (String): Số điện thoại
- `avatarUrl` (String): URL ảnh đại diện
- `dob` (LocalDate): Ngày sinh
- `gender` (GenderEnum): Giới tính (MALE, FEMALE)
- `status` (UserStatusEnum): Trạng thái (ACTIVE, INACTIVE)

---

## 🚀 Endpoints

### 1. Create Member
**POST** `/api/v1/members`

**Description**: Tạo hội viên mới (đồng thời tạo User account)

**Request Body**:
```json
{
  "fullname": "Nguyễn Văn A",
  "email": "nguyenvana@example.com",
  "password": "SecurePassword123",
  "phoneNumber": "0912345678",
  "avatarUrl": "https://example.com/avatar.jpg",
  "dob": "1995-05-15",
  "gender": "MALE",
  "status": "ACTIVE",
  "cccd": "079204012345"
}
```

**Lưu ý**:
- `fullname`, `email`, `dob` là bắt buộc
- `password` là optional - nếu để trống sẽ mặc định là "12345678"
- `phoneNumber`, `avatarUrl`, `gender`, `status`, `cccd` là optional
- `moneySpent`, `moneyDebt` sẽ mặc định = 0
- `joinDate` sẽ mặc định là ngày tạo tài khoản
- User và Member được tạo trong cùng 1 transaction

**Success Response** (201 Created):
```json
{
  "statusCode": 201,
  "message": "Tạo hội viên thành công",
  "data": {
    "id": 1,
    "user": {
      "id": 1,
      "fullname": "Nguyễn Văn A",
      "email": "nguyenvana@example.com",
      "phoneNumber": "0912345678",
      "avatarUrl": "https://example.com/avatar.jpg",
      "dob": "1995-05-15",
      "gender": "MALE",
      "status": "ACTIVE"
    },
    "cccd": "079204012345",
    "moneySpent": 0.00,
    "moneyDebt": 0.00,
    "joinDate": "2026-01-08",
    "createdAt": "2026-01-08T02:35:19Z"
  }
}
```

**Error Responses**:
- **400 Bad Request**: Dữ liệu không hợp lệ
  ```json
  {
    "statusCode": 400,
    "error": "Email đã tồn tại trong hệ thống"
  }
  ```
  ```json
  {
    "statusCode": 400,
    "error": "CCCD đã tồn tại trong hệ thống"
  }
  ```
  ```json
  {
    "statusCode": 400,
    "error": "Email không hợp lệ"
  }
  ```

---

### 2. Get All Members
**GET** `/api/v1/members`

**Description**: Lấy danh sách tất cả hội viên

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách hội viên thành công",
  "data": [
    {
      "id": 1,
      "user": {
        "id": 1,
        "fullname": "Nguyễn Văn A",
        "email": "nguyenvana@example.com",
        "phoneNumber": "0912345678",
        "avatarUrl": "https://example.com/avatar.jpg",
        "dob": "1995-05-15",
        "gender": "MALE",
        "status": "ACTIVE"
      },
      "cccd": "079204012345",
      "moneySpent": 1500000.00,
      "moneyDebt": 0.00,
      "joinDate": "2026-01-07",
      "createdAt": "2026-01-07T20:03:11Z"
    }
  ]
}
```

---

### 3. Get Active Members
**GET** `/api/v1/members/active`

**Description**: Lấy danh sách hội viên đang hoạt động (status = ACTIVE)

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy danh sách hội viên đang hoạt động thành công",
  "data": [
    {
      "id": 1,
      "user": {
        "id": 1,
        "fullname": "Nguyễn Văn A",
        "email": "nguyenvana@example.com",
        "phoneNumber": "0912345678",
        "avatarUrl": "https://example.com/avatar.jpg",
        "dob": "1995-05-15",
        "gender": "MALE",
        "status": "ACTIVE"
      },
      "cccd": "079204012345",
      "moneySpent": 1500000.00,
      "moneyDebt": 0.00,
      "joinDate": "2026-01-07",
      "createdAt": "2026-01-07T20:03:11Z"
    }
  ]
}
```

---

### 4. Search Member
**GET** `/api/v1/members/search`

**Description**: Tìm kiếm hội viên theo memberId, email hoặc CCCD

**Query Parameters** (ít nhất 1 tham số):
- `memberId` (Long, optional): Member ID
- `email` (String, optional): Email của hội viên
- `cccd` (String, optional): Số CCCD của hội viên

**Priority**: memberId > email > cccd

**Example Requests**:
```
GET /api/v1/members/search?memberId=1
GET /api/v1/members/search?email=nguyenvana@example.com
GET /api/v1/members/search?cccd=079204012345
```

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Lấy hội viên theo mã hội viên, email, hoặc số CCCD",
  "data": {
    "id": 1,
    "user": {
      "id": 1,
      "fullname": "Nguyễn Văn A",
      "email": "nguyenvana@example.com",
      "phoneNumber": "0912345678",
      "avatarUrl": "https://example.com/avatar.jpg",
      "dob": "1995-05-15",
      "gender": "MALE",
      "status": "ACTIVE"
    },
    "cccd": "079204012345",
    "moneySpent": 1500000.00,
    "moneyDebt": 0.00,
    "joinDate": "2026-01-07",
    "createdAt": "2026-01-07T20:03:11Z"
  }
}
```

**Error Responses**:
- **400 Bad Request**: Không cung cấp tham số nào
  ```json
  {
    "statusCode": 400,
    "error": "Phải cung cấp ít nhất một trong các tham số: memberId, email, hoặc cccd"
  }
  ```
- **404 Not Found**:
  ```json
  {
    "statusCode": 404,
    "error": "Không tìm thấy hội viên với ID: 1"
  }
  ```

---

### 5. Update Member
**PUT** `/api/v1/members/{id}`

**Description**: Cập nhật thông tin hội viên (cả thông tin User và Member)

**Path Parameters**:
- `id` (Long): Member ID

**Request Body** (tất cả fields đều optional):
```json
{
  "fullname": "Nguyễn Văn B",
  "email": "nguyenvanb@example.com",
  "password": "NewPassword123",
  "phoneNumber": "0987654321",
  "avatarUrl": "https://example.com/new-avatar.jpg",
  "dob": "1995-06-20",
  "gender": "FEMALE",
  "cccd": "079204054321"
}
```

**Lưu ý**:
- Chỉ update các fields được gửi lên (null/empty sẽ giữ nguyên giá trị cũ)
- Email mới phải unique (không trùng với user khác)
- CCCD mới phải unique (không trùng với member khác)
- Không thể update `moneySpent`, `moneyDebt`, `joinDate` qua endpoint này
- Không thể update `hashPassword` qua endpoint này

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Cập nhật thông tin hội viên thành công",
  "data": {
    "id": 1,
    "user": {
      "id": 1,
      "fullname": "Nguyễn Văn B",
      "email": "nguyenvanb@example.com",
      "phoneNumber": "0987654321",
      "avatarUrl": "https://example.com/new-avatar.jpg",
      "dob": "1995-06-20",
      "gender": "FEMALE",
      "status": "ACTIVE"
    },
    "cccd": "079204054321",
    "moneySpent": 1500000.00,
    "moneyDebt": 0.00,
    "joinDate": "2026-01-07",
    "createdAt": "2026-01-07T20:03:11Z",
    "updatedAt": "2026-01-08T03:15:00Z"
  }
}
```

**Error Responses**:
- **404 Not Found**: Hội viên không tồn tại
  ```json
  {
    "statusCode": 404,
    "error": "Không tìm thấy hội viên với ID: 1"
  }
  ```
- **400 Bad Request**: Email hoặc CCCD đã tồn tại
  ```json
  {
    "statusCode": 400,
    "error": "Email đã tồn tại trong hệ thống"
  }
  ```
  ```json
  {
    "statusCode": 400,
    "error": "CCCD đã tồn tại trong hệ thống"
  }
  ```

---

### 6. Delete Member (Soft Delete)
**DELETE** `/api/v1/members/{id}`

**Description**: Xóa hội viên (chuyển status thành INACTIVE - không xóa record khỏi database)

**Path Parameters**:
- `id` (Long): Member ID

**Success Response** (204 No Content):
```
HTTP/1.1 204 No Content
```

**Error Response**:
- **404 Not Found**:
  ```json
  {
    "statusCode": 404,
    "error": "Không tìm thấy hội viên với ID: 1"
  }
  ```

**Lưu ý**:
- Đây là soft delete, chỉ chuyển `user.status` thành `INACTIVE`
- Dữ liệu member vẫn tồn tại trong database
- Member có status INACTIVE sẽ không xuất hiện trong `/members/active`
- Vẫn có thể tìm thấy trong `/members` và `/members/search`

---

## 🔒 Security & Authorization

- **Authentication**: Tất cả endpoints yêu cầu JWT token
- **Authorization**:
  - `GET /members`: MEMBER, ADMIN, PT
  - `GET /members/active`: MEMBER, ADMIN, PT
  - `GET /members/search`: MEMBER, ADMIN, PT
  - `POST /members`: ADMIN
  - `PUT /members/{id}`: ADMIN
  - `DELETE /members/{id}`: ADMIN

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
3. **CCCD**: 
   - Phải là 12 ký tự số (nếu có)
   - Phải unique trong hệ thống
4. **Phone Number**:
   - Phải là 10-11 chữ số
5. **Fullname**:
   - Required khi tạo mới
   - Max 150 ký tự
6. **Date of Birth**:
   - Required khi tạo mới
   - Format: YYYY-MM-DD
7. **Gender**: 
   - Chỉ nhận giá trị MALE hoặc FEMALE
8. **Status**:
   - Chỉ nhận giá trị ACTIVE hoặc INACTIVE
   - Mặc định là ACTIVE nếu không cung cấp
9. **Money Fields**:
   - `moneySpent` mặc định = 0
   - `moneyDebt` mặc định = 0
   - Không thể update trực tiếp qua PUT endpoint
10. **Join Date**:
    - Mặc định là ngày hiện tại khi tạo
    - Không thể update

### Transaction Management
- Tạo Member và User trong cùng 1 transaction (@Transactional)
- Nếu tạo User thất bại → rollback toàn bộ
- Nếu tạo Member thất bại → rollback cả User
- Update Member và User cũng trong cùng 1 transaction

### Search Logic
- Priority: memberId > email > cccd
- Nếu cung cấp memberId → tìm theo memberId (bỏ qua email và cccd)
- Nếu không có memberId nhưng có email → tìm theo email (bỏ qua cccd)
- Nếu chỉ có cccd → tìm theo cccd
- Phải cung cấp ít nhất 1 trong 3 tham số

### Automatic Calculations
- `moneySpent` được tự động cập nhật khi Member thanh toán hóa đơn
- `moneyDebt` được tự động tính khi tạo hợp đồng hoặc thanh toán
- `joinDate` được set tự động khi tạo Member (không thể thay đổi)
- Password mặc định "12345678" nếu không cung cấp khi tạo mới

---

## 📚 Related Documentation

- [DATABASE_SCHEMA.md](../DATABASE_SCHEMA.md#5-member-table)
- [API_RESPONSE_FORMAT.md](../API_RESPONSE_FORMAT.md)
- [ReqCreateMemberDTO.java](../../src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCreateMemberDTO.java)
- [ReqUpdateMemberDTO.java](../../src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqUpdateMemberDTO.java)

---

**Created**: 2026-01-07  
**Last Updated**: 2026-01-08  
**Version**: 2.0
