# Booking API Documentation

## Overview
Booking endpoints manage gym class reservations and session bookings. Handles availability checking, booking creation/modification, and booking lifecycle management.

## Base URL
```
/api/v1/bookings
```

## Authentication
All endpoints require Bearer token authentication:
```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### 1. Get Available Slots
**GET** `/api/v1/bookings/available-slots`

Retrieves available gym class slots for booking.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| date | string | No | Filter by date (YYYY-MM-DD) |
| servicePackageId | integer | No | Filter by service package |
| ptId | integer | No | Filter by personal trainer |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Available slots retrieved successfully",
  "data": [
    {
      "id": 1,
      "slotName": "Morning Yoga",
      "startTime": "08:00",
      "endTime": "09:00",
      "date": "2026-01-20",
      "availableSeats": 5,
      "totalSeats": 10,
      "pt": {
        "id": 1,
        "name": "Jane Smith"
      },
      "servicePackage": {
        "id": 1,
        "name": "Basic Membership"
      }
    }
  ]
}
```

---

### 2. Get Available PTs
**GET** `/api/v1/bookings/available-pts`

Retrieves list of available personal trainers.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| servicePackageId | integer | No | Filter by service package |
| date | string | No | Filter by available date |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Available PTs retrieved successfully",
  "data": [
    {
      "id": 1,
      "name": "Jane Smith",
      "specialization": "Yoga & Pilates",
      "status": "ACTIVE",
      "availableSlots": 8,
      "experience": "5 years"
    }
  ]
}
```

---

### 3. Create Booking
**POST** `/api/v1/bookings`

Creates a new booking for a gym class or session.

**Request Body:**
```json
{
  "slotId": 1,
  "ptId": 1,
  "contractId": 1,
  "notes": "Optional notes for the booking"
}
```

**Response (201 Created):**
```json
{
  "statusCode": 201,
  "message": "Booking created successfully",
  "data": {
    "id": 5,
    "slotId": 1,
    "ptId": 1,
    "contractId": 1,
    "status": "CONFIRMED",
    "createdAt": "2026-01-17T10:30:00Z",
    "slot": {
      "id": 1,
      "slotName": "Morning Yoga",
      "startTime": "08:00",
      "date": "2026-01-20"
    }
  }
}
```

**Error Responses:**
- **400 Bad Request** - Invalid request data
- **409 Conflict** - Slot already fully booked
- **401 Unauthorized** - Invalid authentication

---

### 4. Get Booking
**GET** `/api/v1/bookings/{id}`

Retrieves details of a specific booking.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Booking ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Booking retrieved successfully",
  "data": {
    "id": 5,
    "slotId": 1,
    "ptId": 1,
    "contractId": 1,
    "status": "CONFIRMED",
    "notes": "Optional notes",
    "createdAt": "2026-01-17T10:30:00Z",
    "updatedAt": "2026-01-17T10:30:00Z",
    "slot": {
      "id": 1,
      "slotName": "Morning Yoga",
      "startTime": "08:00",
      "endTime": "09:00",
      "date": "2026-01-20"
    },
    "pt": {
      "id": 1,
      "name": "Jane Smith"
    }
  }
}
```

---

### 5. Update Booking PT
**PUT** `/api/v1/bookings/{id}/pt`

Updates the assigned personal trainer for a booking.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Booking ID |

**Request Body:**
```json
{
  "ptId": 2
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Booking updated successfully",
  "data": {
    "id": 5,
    "ptId": 2,
    "status": "CONFIRMED",
    "updatedAt": "2026-01-17T10:35:00Z"
  }
}
```

---

### 6. Delete Booking
**DELETE** `/api/v1/bookings/{id}`

Cancels a booking and releases the reserved slot.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Booking ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Booking deleted successfully",
  "data": null
}
```

**Error Responses:**
- **404 Not Found** - Booking not found
- **400 Bad Request** - Cannot delete past bookings

---

### 7. List Bookings
**GET** `/api/v1/bookings`

Retrieves all bookings for the current user.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | Filter by status (CONFIRMED, CANCELLED) |
| startDate | string | No | Filter from date (YYYY-MM-DD) |
| endDate | string | No | Filter to date (YYYY-MM-DD) |
| page | integer | No | Pagination page (default: 0) |
| size | integer | No | Page size (default: 20) |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Bookings retrieved successfully",
  "data": [
    {
      "id": 5,
      "slotName": "Morning Yoga",
      "date": "2026-01-20",
      "startTime": "08:00",
      "ptName": "Jane Smith",
      "status": "CONFIRMED"
    }
  ],
  "pagination": {
    "currentPage": 0,
    "pageSize": 20,
    "totalElements": 15
  }
}
```

---

## Booking Statuses

| Status | Description |
|--------|-------------|
| CONFIRMED | Booking is confirmed and active |
| CANCELLED | Booking has been cancelled |
| COMPLETED | Session has been completed |
| NO_SHOW | Member didn't attend booked session |

---

## Error Handling

**Common Errors:**
- `Slot not available` - Selected slot has no available seats
- `Invalid contract` - Associated contract is inactive
- `Booking conflict` - Member already booked same slot
- `PT not available` - Trainer not available for selected time
- `Past booking` - Cannot modify bookings in the past

---

## Testing

**E2E Test Coverage:**
- ✅ Get available slots with various filters
- ✅ Get list of available PTs
- ✅ Create booking successfully
- ✅ Retrieve booking details
- ✅ Update booking PT assignment
- ✅ Delete/cancel booking

**Integration Test Coverage:**
- ✅ Database constraint validation
- ✅ Available seat calculation
- ✅ Concurrent booking handling
- ✅ Booking lifecycle management

**Test Status:** 26/26 tests passing
