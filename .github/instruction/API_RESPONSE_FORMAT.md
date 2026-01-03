# 🌐 API Response Format

> Tài liệu này định nghĩa format chuẩn cho tất cả API responses trong dự án.

---

## 📋 Format Chung

Tất cả API response phải tuân theo format JSON chuẩn sau:

### Success Response

```json
{
  "statusCode": 200,
  "message": "Mô tả kết quả thành công",
  "data": {
    // Dữ liệu trả về (object hoặc array)
  }
}
```

### Error Response

```json
{
  "statusCode": 400,
  "error": "Mô tả lỗi chi tiết",
  "message": "Thông báo lỗi người dùng có thể đọc được"
}
```

---

## 🎯 Chi Tiết Response Formats

### 1. Success Response - Single Object

**Status Code**: `200 OK`, `201 Created`

```json
{
  "statusCode": 200,
  "message": "Lấy thông tin user thành công",
  "data": {
    "id": 1,
    "name": "Nguyen Van A",
    "email": "nguyenvana@example.com",
    "role": {
      "id": 1,
      "name": "USER",
      "description": "Standard user role"
    },
    "createdAt": "2026-01-03T10:30:00Z",
    "updatedAt": "2026-01-03T15:45:00Z"
  }
}
```

### 2. Success Response - Array/List

**Status Code**: `200 OK`

```json
{
  "statusCode": 200,
  "message": "Lấy danh sách users thành công",
  "data": [
    {
      "id": 1,
      "name": "Nguyen Van A",
      "email": "nguyenvana@example.com"
    },
    {
      "id": 2,
      "name": "Tran Thi B",
      "email": "tranthib@example.com"
    }
  ]
}
```

### 3. Success Response - Pagination

**Status Code**: `200 OK`

```json
{
  "statusCode": 200,
  "message": "Lấy danh sách users thành công",
  "data": {
    "content": [
      {
        "id": 1,
        "name": "Nguyen Van A",
        "email": "nguyenvana@example.com"
      },
      {
        "id": 2,
        "name": "Tran Thi B",
        "email": "tranthib@example.com"
      }
    ],
    "pageNumber": 1,
    "pageSize": 20,
    "totalElements": 100,
    "totalPages": 5,
    "first": true,
    "last": false
  }
}
```

### 4. Success Response - No Content

**Status Code**: `200 OK` hoặc `204 No Content`

```json
{
  "statusCode": 200,
  "message": "Xóa user thành công",
  "data": null
}
```

### 5. Error Response - Validation Error

**Status Code**: `400 Bad Request`

```json
{
  "statusCode": 400,
  "error": "Validation failed",
  "message": "Dữ liệu đầu vào không hợp lệ",
  "errors": [
    {
      "field": "email",
      "message": "Email không được để trống"
    },
    {
      "field": "password",
      "message": "Mật khẩu phải có ít nhất 8 ký tự"
    }
  ]
}
```

### 6. Error Response - Not Found

**Status Code**: `404 Not Found`

```json
{
  "statusCode": 404,
  "error": "Resource not found",
  "message": "Không tìm thấy user với ID: 999"
}
```

### 7. Error Response - Unauthorized

**Status Code**: `401 Unauthorized`

```json
{
  "statusCode": 401,
  "error": "Unauthorized",
  "message": "Vui lòng đăng nhập để tiếp tục"
}
```

### 8. Error Response - Forbidden

**Status Code**: `403 Forbidden`

```json
{
  "statusCode": 403,
  "error": "Forbidden",
  "message": "Bạn không có quyền truy cập tài nguyên này"
}
```

### 9. Error Response - Internal Server Error

**Status Code**: `500 Internal Server Error`

```json
{
  "statusCode": 500,
  "error": "Internal server error",
  "message": "Đã xảy ra lỗi hệ thống, vui lòng thử lại sau"
}
```

---

## 🛠️ Implementation

### FormatRestResponse Utility Class

```java
package com.se100.GymAndPTManagement.util;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

public class FormatRestResponse {
    
    /**
     * Success response with data
     */
    public static <T> ResponseEntity<ApiResponse<T>> success(String message, T data) {
        ApiResponse<T> response = new ApiResponse<>();
        response.setStatusCode(HttpStatus.OK.value());
        response.setMessage(message);
        response.setData(data);
        return ResponseEntity.ok(response);
    }
    
    /**
     * Success response without data
     */
    public static ResponseEntity<ApiResponse<Object>> success(String message) {
        return success(message, null);
    }
    
    /**
     * Created response (201)
     */
    public static <T> ResponseEntity<ApiResponse<T>> created(String message, T data) {
        ApiResponse<T> response = new ApiResponse<>();
        response.setStatusCode(HttpStatus.CREATED.value());
        response.setMessage(message);
        response.setData(data);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
    
    /**
     * Error response
     */
    public static ResponseEntity<ApiResponse<Object>> error(HttpStatus status, String error, String message) {
        ApiResponse<Object> response = new ApiResponse<>();
        response.setStatusCode(status.value());
        response.setError(error);
        response.setMessage(message);
        return ResponseEntity.status(status).body(response);
    }
    
    /**
     * Bad request error (400)
     */
    public static ResponseEntity<ApiResponse<Object>> badRequest(String message) {
        return error(HttpStatus.BAD_REQUEST, "Bad Request", message);
    }
    
    /**
     * Not found error (404)
     */
    public static ResponseEntity<ApiResponse<Object>> notFound(String message) {
        return error(HttpStatus.NOT_FOUND, "Not Found", message);
    }
    
    /**
     * Unauthorized error (401)
     */
    public static ResponseEntity<ApiResponse<Object>> unauthorized(String message) {
        return error(HttpStatus.UNAUTHORIZED, "Unauthorized", message);
    }
    
    /**
     * Forbidden error (403)
     */
    public static ResponseEntity<ApiResponse<Object>> forbidden(String message) {
        return error(HttpStatus.FORBIDDEN, "Forbidden", message);
    }
    
    /**
     * Internal server error (500)
     */
    public static ResponseEntity<ApiResponse<Object>> serverError(String message) {
        return error(HttpStatus.INTERNAL_SERVER_ERROR, "Internal Server Error", message);
    }
}
```

### ApiResponse DTO

```java
package com.se100.GymAndPTManagement.util;

import lombok.Data;
import java.util.List;

@Data
public class ApiResponse<T> {
    private int statusCode;
    private String message;
    private String error;
    private T data;
    private List<ValidationError> errors;
    
    @Data
    public static class ValidationError {
        private String field;
        private String message;
        
        public ValidationError(String field, String message) {
            this.field = field;
            this.message = message;
        }
    }
}
```

---

## 📝 Usage Examples

### Controller Example

```java
/**
 * Generated by: GitHub Copilot
 * Created by: Developer Name
 * Created at: 2026-01-03 10:00:00
 * Purpose: User management endpoints
 */
@RestController
@RequestMapping("/api/v1/users")
public class UserController {
    
    private final UserService userService;
    
    public UserController(UserService userService) {
        this.userService = userService;
    }
    
    @GetMapping("/{id}")
    @ApiMessage("Lấy thông tin user theo ID")
    public ResponseEntity<ApiResponse<ResUserDTO>> getUserById(@PathVariable Long id) {
        ResUserDTO user = userService.getUserById(id);
        return FormatRestResponse.success("Lấy thông tin user thành công", user);
    }
    
    @PostMapping
    @ApiMessage("Tạo user mới")
    public ResponseEntity<ApiResponse<ResUserDTO>> createUser(@Valid @RequestBody ReqUserDTO dto) {
        ResUserDTO user = userService.createUser(dto);
        return FormatRestResponse.created("Tạo user thành công", user);
    }
    
    @DeleteMapping("/{id}")
    @ApiMessage("Xóa user")
    public ResponseEntity<ApiResponse<Object>> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return FormatRestResponse.success("Xóa user thành công");
    }
}
```

---

## 🚨 Lưu Ý Quan Trọng

1. **@ApiMessage Annotation**: BẮT BUỘC cho mọi endpoint
2. **Consistent Status Codes**: Sử dụng đúng HTTP status code
3. **Clear Messages**: Message phải rõ ràng, dễ hiểu cho người dùng
4. **No Sensitive Data**: Không trả về password, secret keys trong response
5. **Null Handling**: Trả về `null` hoặc empty array thay vì throw exception khi không có data
6. **Error Details**: Cung cấp đủ thông tin lỗi để debug nhưng không expose internal details

---

## 📊 HTTP Status Codes Reference

| Status Code | Meaning               | Usage                                     |
| ----------- | --------------------- | ----------------------------------------- |
| 200         | OK                    | Successful GET, PUT, PATCH, DELETE        |
| 201         | Created               | Successful POST (resource created)        |
| 204         | No Content            | Successful request with no response body  |
| 400         | Bad Request           | Invalid request data/validation error     |
| 401         | Unauthorized          | Authentication required                   |
| 403         | Forbidden             | No permission to access                   |
| 404         | Not Found             | Resource not found                        |
| 409         | Conflict              | Resource conflict (e.g., duplicate email) |
| 500         | Internal Server Error | Server-side error                         |

---

**Version**: 1.0  
**Last Updated**: 2026-01-03
