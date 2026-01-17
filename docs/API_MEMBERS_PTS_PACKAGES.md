# Member API Documentation

## Overview
Member endpoints handle gym member profile management, registration, and member-specific queries.

## Base URL
```
/api/v1/members
```

## Authentication
All endpoints require Bearer token authentication:
```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### 1. Create Member
**POST** `/api/v1/members`

Creates a new gym member profile.

**Request Body:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "phone": "0123456789",
  "cccd": "123456789012",
  "dateOfBirth": "1990-05-15",
  "address": "123 Main St, City",
  "emergencyContact": "Jane Doe",
  "emergencyPhone": "0987654321"
}
```

**Response (201 Created):**
```json
{
  "statusCode": 201,
  "message": "Member created successfully",
  "data": {
    "id": 3,
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "phone": "0123456789",
    "cccd": "123456789012",
    "status": "ACTIVE",
    "createdAt": "2026-01-17T10:30:00Z"
  }
}
```

**Error Responses:**
- **400 Bad Request** - Invalid member data
- **409 Conflict** - Email or CCCD already exists

---

### 2. Get Member
**GET** `/api/v1/members/{id}`

Retrieves full member profile information.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Member ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Member retrieved successfully",
  "data": {
    "id": 3,
    "firstName": "John",
    "lastName": "Doe",
    "fullName": "John Doe",
    "email": "john@example.com",
    "phone": "0123456789",
    "cccd": "123456789012",
    "dateOfBirth": "1990-05-15",
    "address": "123 Main St, City",
    "emergencyContact": "Jane Doe",
    "emergencyPhone": "0987654321",
    "status": "ACTIVE",
    "joinDate": "2026-01-17",
    "totalBookings": 12,
    "activeContracts": 1,
    "totalInvoices": 3
  }
}
```

---

### 3. Update Member
**PUT** `/api/v1/members/{id}`

Updates member profile information.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Member ID |

**Request Body:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "phone": "0123456789",
  "address": "456 New Ave, City",
  "emergencyContact": "Jane Smith",
  "emergencyPhone": "0987654322"
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Member updated successfully",
  "data": {
    "id": 3,
    "firstName": "John",
    "lastName": "Doe",
    "phone": "0123456789",
    "address": "456 New Ave, City",
    "updatedAt": "2026-01-17T11:00:00Z"
  }
}
```

---

### 4. Delete Member
**DELETE** `/api/v1/members/{id}`

Deactivates a member account (soft delete).

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Member ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Member deleted successfully",
  "data": null
}
```

---

### 5. Search Members
**GET** `/api/v1/members/search`

Searches members by name, email, or phone.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| query | string | Yes | Search term (name, email, or phone) |
| status | string | No | Filter by status (ACTIVE, INACTIVE) |
| page | integer | No | Pagination page (default: 0) |
| size | integer | No | Page size (default: 20) |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Members found successfully",
  "data": [
    {
      "id": 3,
      "fullName": "John Doe",
      "email": "john@example.com",
      "phone": "0123456789",
      "status": "ACTIVE",
      "activeContracts": 1
    }
  ],
  "pagination": {
    "currentPage": 0,
    "pageSize": 20,
    "totalElements": 5
  }
}
```

---

### 6. List Active Members
**GET** `/api/v1/members/active`

Retrieves all active members.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| page | integer | No | Pagination page (default: 0) |
| size | integer | No | Page size (default: 20) |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Active members retrieved successfully",
  "data": [
    {
      "id": 3,
      "fullName": "John Doe",
      "email": "john@example.com",
      "status": "ACTIVE",
      "totalBookings": 12
    }
  ],
  "pagination": {
    "currentPage": 0,
    "pageSize": 20,
    "totalElements": 45
  }
}
```

---

## Member Statuses

| Status | Description |
|--------|-------------|
| ACTIVE | Member is active and can book sessions |
| INACTIVE | Member is inactive (suspended) |
| SUSPENDED | Membership temporarily suspended |
| DELETED | Member account deactivated |

---

## Testing

**E2E Test Coverage:**
- ✅ Create new member
- ✅ Retrieve member details
- ✅ Update member information
- ✅ Delete/deactivate member
- ✅ Search members
- ✅ List active members

**Test Status:** 6/6 tests passing

---

---

# Personal Trainer API Documentation

## Overview
Personal Trainer (PT) endpoints manage PT profile, availability, specializations, and PT-specific information.

## Base URL
```
/api/v1/pts
```

## Authentication
All endpoints require Bearer token authentication:
```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### 1. Create PT
**POST** `/api/v1/pts`

Creates a new personal trainer account.

**Request Body:**
```json
{
  "firstName": "Jane",
  "lastName": "Smith",
  "email": "jane@example.com",
  "phone": "0123456789",
  "specialization": "Yoga & Pilates",
  "experience": "5 years",
  "certification": "ISSA Certified",
  "bio": "Experienced yoga instructor"
}
```

**Response (201 Created):**
```json
{
  "statusCode": 201,
  "message": "PT created successfully",
  "data": {
    "id": 1,
    "firstName": "Jane",
    "lastName": "Smith",
    "email": "jane@example.com",
    "specialization": "Yoga & Pilates",
    "status": "ACTIVE",
    "createdAt": "2026-01-17T10:30:00Z"
  }
}
```

---

### 2. Get PT
**GET** `/api/v1/pts/{id}`

Retrieves personal trainer profile and details.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | PT ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "PT retrieved successfully",
  "data": {
    "id": 1,
    "firstName": "Jane",
    "lastName": "Smith",
    "fullName": "Jane Smith",
    "email": "jane@example.com",
    "phone": "0123456789",
    "specialization": "Yoga & Pilates",
    "experience": "5 years",
    "certification": "ISSA Certified",
    "bio": "Experienced yoga instructor",
    "status": "ACTIVE",
    "totalClasses": 48,
    "totalMembers": 25,
    "averageRating": 4.8
  }
}
```

---

### 3. Update PT
**PUT** `/api/v1/pts/{id}`

Updates personal trainer information.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | PT ID |

**Request Body:**
```json
{
  "firstName": "Jane",
  "lastName": "Smith",
  "phone": "0123456789",
  "specialization": "Yoga, Pilates & CrossFit",
  "bio": "Expert in multiple fitness domains"
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "PT updated successfully",
  "data": {
    "id": 1,
    "fullName": "Jane Smith",
    "specialization": "Yoga, Pilates & CrossFit",
    "updatedAt": "2026-01-17T11:00:00Z"
  }
}
```

---

### 4. Delete PT
**DELETE** `/api/v1/pts/{id}`

Deactivates a personal trainer account.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | PT ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "PT deleted successfully",
  "data": null
}
```

---

### 5. Search PTs
**GET** `/api/v1/pts/search`

Searches personal trainers by name, specialization, or email.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| query | string | Yes | Search term |
| specialization | string | No | Filter by specialization |
| status | string | No | Filter by status |
| page | integer | No | Pagination page |
| size | integer | No | Page size (default: 20) |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "PTs found successfully",
  "data": [
    {
      "id": 1,
      "fullName": "Jane Smith",
      "specialization": "Yoga & Pilates",
      "status": "ACTIVE",
      "totalMembers": 25
    }
  ]
}
```

---

### 6. Get PT Availability
**GET** `/api/v1/pts/{id}/availability`

Retrieves PT availability schedule.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | PT ID |

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| startDate | string | No | From date (YYYY-MM-DD) |
| endDate | string | No | To date (YYYY-MM-DD) |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "PT availability retrieved successfully",
  "data": {
    "id": 1,
    "fullName": "Jane Smith",
    "availability": [
      {
        "date": "2026-01-20",
        "slots": [
          {
            "startTime": "08:00",
            "endTime": "09:00",
            "available": true
          },
          {
            "startTime": "09:00",
            "endTime": "10:00",
            "available": false
          }
        ]
      }
    ]
  }
}
```

---

### 7. Update PT Status
**PUT** `/api/v1/pts/{id}/status`

Updates PT working status (ACTIVE, INACTIVE, ON_LEAVE).

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | PT ID |

**Request Body:**
```json
{
  "status": "ON_LEAVE",
  "reason": "Annual vacation",
  "fromDate": "2026-02-01",
  "toDate": "2026-02-15"
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "PT status updated successfully",
  "data": {
    "id": 1,
    "status": "ON_LEAVE",
    "fromDate": "2026-02-01",
    "toDate": "2026-02-15"
  }
}
```

---

## PT Statuses

| Status | Description |
|--------|-------------|
| ACTIVE | PT is working and available |
| INACTIVE | PT is inactive |
| ON_LEAVE | PT is temporarily away |
| SUSPENDED | PT account suspended |

---

## Testing

**Test Status:** 9/9 tests passing

---

---

# Service Package API Documentation

## Overview
Service Package endpoints manage gym membership packages, pricing, and package-specific services.

## Base URL
```
/api/v1/service-packages
```

## Authentication
All endpoints require Bearer token authentication:
```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### 1. Create Package
**POST** `/api/v1/service-packages`

Creates a new service package offering.

**Request Body:**
```json
{
  "packageName": "Premium Annual",
  "description": "Full access annual membership",
  "price": 5000000,
  "duration": 365,
  "sessionsIncluded": 48,
  "type": "ANNUAL",
  "features": ["Unlimited classes", "PT assistance", "Sauna access"]
}
```

**Response (201 Created):**
```json
{
  "statusCode": 201,
  "message": "Package created successfully",
  "data": {
    "id": 1,
    "packageName": "Premium Annual",
    "price": 5000000,
    "duration": 365,
    "sessionsIncluded": 48,
    "type": "ANNUAL",
    "status": "ACTIVE",
    "createdAt": "2026-01-17T10:30:00Z"
  }
}
```

---

### 2. Get Package
**GET** `/api/v1/service-packages/{id}`

Retrieves service package details.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Package ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Package retrieved successfully",
  "data": {
    "id": 1,
    "packageName": "Premium Annual",
    "description": "Full access annual membership",
    "price": 5000000,
    "duration": 365,
    "sessionsIncluded": 48,
    "type": "ANNUAL",
    "status": "ACTIVE",
    "features": ["Unlimited classes", "PT assistance", "Sauna access"],
    "totalSales": 150
  }
}
```

---

### 3. Update Package
**PUT** `/api/v1/service-packages/{id}`

Updates service package information.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Package ID |

**Request Body:**
```json
{
  "packageName": "Premium Plus Annual",
  "price": 6000000,
  "sessionsIncluded": 60,
  "features": ["Unlimited classes", "PT assistance", "Sauna access", "Nutrition consulting"]
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Package updated successfully",
  "data": {
    "id": 1,
    "packageName": "Premium Plus Annual",
    "price": 6000000,
    "sessionsIncluded": 60,
    "updatedAt": "2026-01-17T11:00:00Z"
  }
}
```

---

### 4. Delete Package
**DELETE** `/api/v1/service-packages/{id}`

Deactivates a service package (soft delete).

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Package ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Package deleted successfully",
  "data": null
}
```

---

### 5. Activate Package
**PUT** `/api/v1/service-packages/{id}/activate`

Activates a previously deactivated package.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Package ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Package activated successfully",
  "data": {
    "id": 1,
    "status": "ACTIVE",
    "activatedAt": "2026-01-17T11:05:00Z"
  }
}
```

---

### 6. Deactivate Package
**PUT** `/api/v1/service-packages/{id}/deactivate`

Deactivates a service package.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Package ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Package deactivated successfully",
  "data": {
    "id": 1,
    "status": "INACTIVE",
    "deactivatedAt": "2026-01-17T11:05:00Z"
  }
}
```

---

### 7. Get Packages by Type
**GET** `/api/v1/service-packages/by-type/{type}`

Retrieves all packages of a specific type.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| type | string | Package type (MONTHLY, QUARTERLY, ANNUAL) |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Packages retrieved successfully",
  "data": [
    {
      "id": 1,
      "packageName": "Premium Annual",
      "price": 5000000,
      "duration": 365,
      "sessionsIncluded": 48,
      "status": "ACTIVE"
    }
  ]
}
```

---

## Package Types

| Type | Duration | Common Use |
|------|----------|-----------|
| MONTHLY | 30 days | Short-term commitment |
| QUARTERLY | 90 days | Medium-term membership |
| ANNUAL | 365 days | Full year commitment |
| CUSTOM | Variable | Special packages |

---

## Testing

**Test Status:** 6/6 tests passing
