# Slot API Documentation

## Overview
Slot endpoints manage gym class schedules, time slots, and session scheduling for different types of classes and trainers.

## Base URL
```
/api/v1/slots
```

## Authentication
All endpoints require Bearer token authentication:
```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### 1. Create Slot
**POST** `/api/v1/slots`

Creates a new gym class slot/session.

**Request Body:**
```json
{
  "slotName": "Morning Yoga",
  "description": "Relaxing yoga session for beginners",
  "date": "2026-01-20",
  "startTime": "08:00",
  "endTime": "09:00",
  "ptId": 1,
  "totalSeats": 10,
  "type": "CLASS",
  "notes": "Bring your yoga mat"
}
```

**Response (201 Created):**
```json
{
  "statusCode": 201,
  "message": "Slot created successfully",
  "data": {
    "id": 1,
    "slotName": "Morning Yoga",
    "date": "2026-01-20",
    "startTime": "08:00",
    "endTime": "09:00",
    "totalSeats": 10,
    "availableSeats": 10,
    "ptName": "Jane Smith",
    "status": "ACTIVE",
    "createdAt": "2026-01-17T10:30:00Z"
  }
}
```

**Error Responses:**
- **400 Bad Request** - Invalid slot data
- **409 Conflict** - PT not available at specified time

---

### 2. Get Slot
**GET** `/api/v1/slots/{id}`

Retrieves details of a specific gym class slot.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Slot ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Slot retrieved successfully",
  "data": {
    "id": 1,
    "slotName": "Morning Yoga",
    "description": "Relaxing yoga session for beginners",
    "date": "2026-01-20",
    "startTime": "08:00",
    "endTime": "09:00",
    "duration": 60,
    "ptId": 1,
    "ptName": "Jane Smith",
    "totalSeats": 10,
    "bookedSeats": 3,
    "availableSeats": 7,
    "type": "CLASS",
    "status": "ACTIVE",
    "occupancyRate": 30,
    "notes": "Bring your yoga mat"
  }
}
```

---

### 3. Update Slot
**PUT** `/api/v1/slots/{id}`

Updates slot information.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Slot ID |

**Request Body:**
```json
{
  "slotName": "Advanced Morning Yoga",
  "description": "Advanced yoga for experienced practitioners",
  "totalSeats": 12,
  "notes": "Please notify before booking"
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Slot updated successfully",
  "data": {
    "id": 1,
    "slotName": "Advanced Morning Yoga",
    "totalSeats": 12,
    "updatedAt": "2026-01-17T11:00:00Z"
  }
}
```

---

### 4. Delete Slot
**DELETE** `/api/v1/slots/{id}`

Deletes a gym class slot.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Slot ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Slot deleted successfully",
  "data": null
}
```

---

### 5. Activate Slot
**PUT** `/api/v1/slots/{id}/activate`

Activates a slot for bookings.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Slot ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Slot activated successfully",
  "data": {
    "id": 1,
    "status": "ACTIVE",
    "activatedAt": "2026-01-17T11:05:00Z"
  }
}
```

---

### 6. List Active Slots Only
**GET** `/api/v1/slots/active`

Retrieves all active slots available for booking.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| startDate | string | No | From date (YYYY-MM-DD) |
| endDate | string | No | To date (YYYY-MM-DD) |
| ptId | integer | No | Filter by PT |
| type | string | No | Filter by type (CLASS, PERSONAL, GROUP) |
| page | integer | No | Pagination page (default: 0) |
| size | integer | No | Page size (default: 20) |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Active slots retrieved successfully",
  "data": [
    {
      "id": 1,
      "slotName": "Morning Yoga",
      "date": "2026-01-20",
      "startTime": "08:00",
      "endTime": "09:00",
      "ptName": "Jane Smith",
      "availableSeats": 7,
      "totalSeats": 10,
      "status": "ACTIVE"
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

## Slot Types

| Type | Description |
|------|-------------|
| CLASS | Group fitness class |
| PERSONAL | One-on-one personal training |
| GROUP | Small group training (4-6 people) |
| WORKSHOP | Special workshop or training session |

---

## Slot Statuses

| Status | Description |
|--------|-------------|
| ACTIVE | Available for booking |
| INACTIVE | Not available for booking |
| FULL | No available seats |
| CANCELLED | Session cancelled |
| COMPLETED | Session has ended |

---

## Testing

**Test Status:** 6/6 tests passing

---

---

# Role & Permission API Documentation

## Overview
Role and Permission endpoints manage user access control, role definitions, and permission assignments for system features.

## Base URL
```
/api/v1/roles
/api/v1/permissions
```

## Authentication
All endpoints require Bearer token authentication with ADMIN role:
```
Authorization: Bearer <admin_jwt_token>
```

---

## Endpoints

### 1. Create Role
**POST** `/api/v1/roles`

Creates a new user role.

**Request Body:**
```json
{
  "roleName": "STAFF",
  "description": "Gym staff member with limited admin access",
  "permissions": [1, 2, 3, 4]
}
```

**Response (201 Created):**
```json
{
  "statusCode": 201,
  "message": "Role created successfully",
  "data": {
    "id": 4,
    "roleName": "STAFF",
    "description": "Gym staff member with limited admin access",
    "createdAt": "2026-01-17T10:30:00Z"
  }
}
```

---

### 2. Get Role
**GET** `/api/v1/roles/{id}`

Retrieves role details and assigned permissions.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Role ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Role retrieved successfully",
  "data": {
    "id": 1,
    "roleName": "MEMBER",
    "description": "Gym member with basic access",
    "permissions": [
      {
        "id": 1,
        "permissionName": "BOOKING_VIEW",
        "description": "View bookings"
      },
      {
        "id": 2,
        "permissionName": "BOOKING_CREATE",
        "description": "Create bookings"
      }
    ],
    "totalPermissions": 8
  }
}
```

---

### 3. Update Role
**PUT** `/api/v1/roles/{id}`

Updates role information.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Role ID |

**Request Body:**
```json
{
  "description": "Updated staff member description",
  "permissions": [1, 2, 3, 4, 5]
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Role updated successfully",
  "data": {
    "id": 4,
    "roleName": "STAFF",
    "description": "Updated staff member description",
    "updatedAt": "2026-01-17T11:00:00Z"
  }
}
```

---

### 4. Delete Role
**DELETE** `/api/v1/roles/{id}`

Deletes a user role (if not assigned to any users).

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Role ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Role deleted successfully",
  "data": null
}
```

**Error Responses:**
- **409 Conflict** - Role is assigned to active users

---

### 5. List All Roles
**GET** `/api/v1/roles`

Retrieves all roles in the system.

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Roles retrieved successfully",
  "data": [
    {
      "id": 1,
      "roleName": "ADMIN",
      "description": "System administrator",
      "totalPermissions": 15
    },
    {
      "id": 2,
      "roleName": "MEMBER",
      "description": "Gym member",
      "totalPermissions": 8
    },
    {
      "id": 3,
      "roleName": "PT",
      "description": "Personal trainer",
      "totalPermissions": 10
    }
  ]
}
```

---

### 6. Create Permission
**POST** `/api/v1/permissions`

Creates a new system permission.

**Request Body:**
```json
{
  "permissionName": "INVOICE_EDIT",
  "description": "Edit member invoices",
  "category": "INVOICE"
}
```

**Response (201 Created):**
```json
{
  "statusCode": 201,
  "message": "Permission created successfully",
  "data": {
    "id": 15,
    "permissionName": "INVOICE_EDIT",
    "description": "Edit member invoices",
    "category": "INVOICE"
  }
}
```

---

### 7. Get Permission
**GET** `/api/v1/permissions/{id}`

Retrieves permission details.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Permission ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Permission retrieved successfully",
  "data": {
    "id": 1,
    "permissionName": "BOOKING_VIEW",
    "description": "View member bookings",
    "category": "BOOKING"
  }
}
```

---

### 8. List All Permissions
**GET** `/api/v1/permissions`

Retrieves all permissions in the system.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| category | string | No | Filter by category |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Permissions retrieved successfully",
  "data": [
    {
      "id": 1,
      "permissionName": "BOOKING_VIEW",
      "description": "View member bookings",
      "category": "BOOKING"
    },
    {
      "id": 2,
      "permissionName": "BOOKING_CREATE",
      "description": "Create new bookings",
      "category": "BOOKING"
    }
  ]
}
```

---

## Default Roles

| Role | Description | Use Case |
|------|-------------|----------|
| ADMIN | Full system access | System administrators |
| MEMBER | Member access | Gym members |
| PT | Personal trainer access | Trainers and instructors |
| STAFF | Limited admin access | Gym staff members |

---

## Permission Categories

| Category | Description |
|----------|-------------|
| BOOKING | Booking management |
| MEMBER | Member profile management |
| PT | Personal trainer management |
| INVOICE | Invoice and payment management |
| CONTRACT | Contract management |
| SLOT | Class schedule management |
| CHECKIN | Check-in/attendance tracking |
| ROLE | Role and permission management |

---

## Error Handling

**Common Errors:**
- `Role not found` - Referenced role doesn't exist
- `Permission not found` - Referenced permission doesn't exist
- `Role in use` - Cannot delete role assigned to users
- `Invalid permission assignment` - Cannot assign restricted permissions
- `Insufficient permissions` - User lacks required permissions

---

## Testing

**Test Status:** 5/5 tests passing
