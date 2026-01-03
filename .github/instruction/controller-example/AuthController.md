# AuthController - Authentication API Documentation

> Controller xử lý các API liên quan đến xác thực người dùng (đăng nhập, đăng ký, refresh token).

---

## 📋 Thông Tin Chung

- **Controller**: `AuthController`
- **Base Path**: `/api/v1/auth`
- **Package**: `com.se100.GymAndPTManagement.controller`
- **Authentication**: Không cần authentication (public endpoints)

---

## 🔐 Endpoints

### 1. Đăng Nhập (Login)

**Endpoint**: `POST /api/v1/auth/login`  
**Authentication**: Không cần  
**Description**: Đăng nhập bằng email và password, trả về access token và refresh token

#### Request

**Headers**:
```
Content-Type: application/json
```

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Request DTO** (`ReqLoginDTO.java`):
```java
public class ReqLoginDTO {
    @NotBlank(message = "Email không được để trống")
    @Email(message = "Email không đúng định dạng")
    private String email;
    
    @NotBlank(message = "Password không được để trống")
    private String password;
}
```

#### Success Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "Đăng nhập thành công",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "email": "user@example.com",
      "name": "Nguyen Van A",
      "role": {
        "id": 2,
        "name": "USER",
        "description": "Standard user role"
      }
    }
  }
}
```

**Response DTO** (`ResLoginDTO.java`):
```java
public class ResLoginDTO {
    private String accessToken;
    private String refreshToken;
    private UserLogin user;
    
    @Data
    public static class UserLogin {
        private Long id;
        private String email;
        private String name;
        private RoleLogin role;
    }
    
    @Data
    public static class RoleLogin {
        private Long id;
        private String name;
        private String description;
    }
}
```

#### Error Responses

**401 Unauthorized** - Sai email hoặc password:
```json
{
  "statusCode": 401,
  "error": "Unauthorized",
  "message": "Email hoặc mật khẩu không chính xác"
}
```

**400 Bad Request** - Validation error:
```json
{
  "statusCode": 400,
  "error": "Validation failed",
  "message": "Dữ liệu đầu vào không hợp lệ",
  "errors": [
    {
      "field": "email",
      "message": "Email không được để trống"
    }
  ]
}
```

#### Exceptions

- `BadCredentialsException`: Email hoặc password không đúng
- `MethodArgumentNotValidException`: Validation error (email/password trống hoặc sai format)

---

### 2. Đăng Ký (Register)

**Endpoint**: `POST /api/v1/auth/register`  
**Authentication**: Không cần  
**Description**: Đăng ký tài khoản mới

#### Request

**Headers**:
```
Content-Type: application/json
```

**Request Body**:
```json
{
  "email": "newuser@example.com",
  "password": "password123",
  "name": "Nguyen Van B"
}
```

**Request DTO** (`ReqRegisterDTO.java`):
```java
public class ReqRegisterDTO {
    @NotBlank(message = "Email không được để trống")
    @Email(message = "Email không đúng định dạng")
    private String email;
    
    @NotBlank(message = "Password không được để trống")
    @Size(min = 8, message = "Password phải có ít nhất 8 ký tự")
    private String password;
    
    @NotBlank(message = "Tên không được để trống")
    private String name;
}
```

#### Success Response (201 Created)

```json
{
  "statusCode": 201,
  "message": "Đăng ký tài khoản thành công",
  "data": {
    "id": 10,
    "email": "newuser@example.com",
    "name": "Nguyen Van B",
    "role": {
      "id": 2,
      "name": "USER",
      "description": "Standard user role"
    }
  }
}
```

**Response DTO** (`ResUserDTO.java`):
```java
public class ResUserDTO {
    private Long id;
    private String email;
    private String name;
    private RoleDTO role;
    private Instant createdAt;
    
    @Data
    public static class RoleDTO {
        private Long id;
        private String name;
        private String description;
    }
}
```

#### Error Responses

**409 Conflict** - Email đã tồn tại:
```json
{
  "statusCode": 409,
  "error": "Conflict",
  "message": "Email này đã được đăng ký"
}
```

**400 Bad Request** - Validation error:
```json
{
  "statusCode": 400,
  "error": "Validation failed",
  "message": "Dữ liệu đầu vào không hợp lệ",
  "errors": [
    {
      "field": "password",
      "message": "Password phải có ít nhất 8 ký tự"
    }
  ]
}
```

#### Exceptions

- `DuplicateEmailException`: Email đã tồn tại trong hệ thống
- `MethodArgumentNotValidException`: Validation error

---

### 3. Refresh Token

**Endpoint**: `POST /api/v1/auth/refresh`  
**Authentication**: Không cần (nhưng cần refresh token)  
**Description**: Lấy access token mới bằng refresh token

#### Request

**Headers**:
```
Content-Type: application/json
```

**Request Body**:
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Request DTO** (`ReqRefreshTokenDTO.java`):
```java
public class ReqRefreshTokenDTO {
    @NotBlank(message = "Refresh token không được để trống")
    private String refreshToken;
}
```

#### Success Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "Refresh token thành công",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "email": "user@example.com",
      "name": "Nguyen Van A"
    }
  }
}
```

**Response DTO**: `ResLoginDTO` (same as login)

#### Error Responses

**401 Unauthorized** - Refresh token không hợp lệ hoặc hết hạn:
```json
{
  "statusCode": 401,
  "error": "Unauthorized",
  "message": "Refresh token không hợp lệ hoặc đã hết hạn"
}
```

#### Exceptions

- `JwtException`: Token không hợp lệ (sai format, signature, hoặc expired)
- `MethodArgumentNotValidException`: Refresh token trống

---

### 4. Đăng Xuất (Logout)

**Endpoint**: `POST /api/v1/auth/logout`  
**Authentication**: Cần access token  
**Description**: Đăng xuất người dùng (invalidate token nếu có blacklist)

#### Request

**Headers**:
```
Authorization: Bearer {access_token}
Content-Type: application/json
```

**Request Body**: Không cần

#### Success Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "Đăng xuất thành công",
  "data": null
}
```

#### Error Responses

**401 Unauthorized** - Không có token hoặc token không hợp lệ:
```json
{
  "statusCode": 401,
  "error": "Unauthorized",
  "message": "Vui lòng đăng nhập để tiếp tục"
}
```

#### Exceptions

- `JwtException`: Token không hợp lệ

---

## 📝 Notes

### Security Considerations

1. **Password Hashing**: Sử dụng BCrypt để hash password trước khi lưu vào database
2. **JWT Expiration**: 
   - Access token: 10 days (có thể điều chỉnh ngắn hơn trong production)
   - Refresh token: 10 days
3. **Token Storage**: 
   - Client nên lưu access token trong memory hoặc secure storage
   - Refresh token nên lưu trong httpOnly cookie (nếu web) hoặc secure storage (nếu mobile)

### Validation Rules

- **Email**: Phải đúng format email (RFC 5322)
- **Password**: Tối thiểu 8 ký tự (có thể thêm yêu cầu complexity sau)
- **Name**: Không được để trống

### Default Role

- Khi đăng ký, user sẽ được gán role mặc định là "USER"
- Admin role chỉ được tạo thủ công hoặc qua endpoint riêng (yêu cầu admin permission)

---

## 🔗 Related Files

- **Controller**: `src/main/java/com/se100/GymAndPTManagement/controller/AuthController.java`
- **Service**: `src/main/java/com/se100/GymAndPTManagement/service/AuthService.java`
- **DTOs**: `src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/`, `responseDTO/`
- **Entity**: [User.java](../DATABASE_SCHEMA.md#1-user-table)

---

**Version**: 1.0  
**Last Updated**: 2026-01-03  
**Author**: PhDuy2005
