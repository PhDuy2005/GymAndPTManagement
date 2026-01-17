# Authentication API Documentation

## Overview
Authentication endpoints handle user login, token management, and account information retrieval. Uses JWT (JSON Web Tokens) with HS256 algorithm and 10-day expiration.

## Base URL
```
/api/v1/auth
```

## Authentication
All requests (except login) require Bearer token in Authorization header:
```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### 1. Login
**POST** `/api/v1/auth/login`

Authenticates user with username and password, returns JWT token.

**Request Body:**
```json
{
  "username": "user@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 864000,
    "user": {
      "id": 1,
      "username": "user@example.com",
      "role": "MEMBER"
    }
  }
}
```

**Error Responses:**
- **400 Bad Request** - Invalid credentials
- **401 Unauthorized** - User not found or password incorrect

---

### 2. Get Account Info
**GET** `/api/v1/auth/account`

Retrieves current authenticated user's account information.

**Headers:**
```
Authorization: Bearer <jwt_token>
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Account retrieved successfully",
  "data": {
    "id": 1,
    "username": "user@example.com",
    "email": "user@example.com",
    "fullName": "John Doe",
    "role": "MEMBER",
    "status": "ACTIVE"
  }
}
```

**Error Responses:**
- **401 Unauthorized** - Invalid or missing token
- **404 Not Found** - User not found

---

### 3. Refresh Token
**GET** `/api/v1/auth/refresh`

Refreshes JWT token before expiration. Returns new token with extended expiration.

**Headers:**
```
Authorization: Bearer <jwt_token>
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Token refreshed successfully",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 864000
  }
}
```

**Error Responses:**
- **401 Unauthorized** - Token expired or invalid

---

### 4. Logout
**POST** `/api/v1/auth/logout`

Invalidates current user session and token.

**Headers:**
```
Authorization: Bearer <jwt_token>
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Logout successful",
  "data": null
}
```

**Error Responses:**
- **401 Unauthorized** - Invalid or missing token

---

## Token Details

**JWT Structure:**
- **Algorithm:** HS256
- **Expiration:** 10 days (864000 seconds)
- **Payload includes:** user ID, role, username, issued time

**Token Example:**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwicm9sZSI6Ik1FTUJFUiIsImlhdCI6MTY3MzAwMDAwMH0.signature
```

---

## User Roles

| Role | Description |
|------|-------------|
| ADMIN | System administrator with full access |
| MEMBER | Gym member with booking and booking access |
| PT | Personal trainer with class and schedule management |

---

## Error Handling

All authentication errors follow standard response format:

```json
{
  "statusCode": 400,
  "message": "Invalid credentials",
  "data": null
}
```

**Common Errors:**
- `Invalid credentials` - Username/password mismatch
- `User not found` - Account doesn't exist
- `Token expired` - JWT token has expired
- `Invalid token` - Malformed or tampered token
- `Unauthorized` - Missing or invalid authentication header

---

## Testing

**E2E Test Coverage:**
- ✅ Login with valid credentials
- ✅ Login with invalid credentials
- ✅ Get account information
- ✅ Refresh token before expiration
- ✅ Access protected resource with valid token
- ✅ Access protected resource with invalid token
- ✅ Logout and invalidate session

**Test Status:** 6/6 tests passing
