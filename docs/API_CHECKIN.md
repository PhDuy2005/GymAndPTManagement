# Check-in API Documentation

## Overview
Check-in endpoints manage gym member attendance tracking, session check-in/checkout, and attendance records for contracted services.

## Base URL
```
/api/v1/checkins
```

## Authentication
All endpoints require Bearer token authentication:
```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### 1. Check-in Member
**POST** `/api/v1/checkins`

Records member check-in for a booked session.

**Request Body:**
```json
{
  "bookingId": 5,
  "notes": "Optional check-in notes"
}
```

**Response (201 Created):**
```json
{
  "statusCode": 201,
  "message": "Check-in recorded successfully",
  "data": {
    "id": 1,
    "bookingId": 5,
    "memberId": 3,
    "checkInTime": "2026-01-20T08:05:00Z",
    "status": "CHECKED_IN",
    "notes": "Optional check-in notes"
  }
}
```

**Error Responses:**
- **400 Bad Request** - Invalid booking or already checked in
- **404 Not Found** - Booking not found
- **409 Conflict** - Check-in not allowed (past session or cancelled booking)

---

### 2. Check-out Member
**PUT** `/api/v1/checkins/checkout/{id}`

Records member check-out and session end time.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Check-in record ID |

**Request Body:**
```json
{
  "notes": "Optional checkout notes"
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Check-out recorded successfully",
  "data": {
    "id": 1,
    "bookingId": 5,
    "memberId": 3,
    "checkInTime": "2026-01-20T08:05:00Z",
    "checkOutTime": "2026-01-20T09:00:00Z",
    "duration": 55,
    "status": "CHECKED_OUT"
  }
}
```

---

### 3. Cancel Check-in
**PUT** `/api/v1/checkins/cancel/{id}`

Cancels an active check-in session.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Check-in record ID |

**Request Body:**
```json
{
  "reason": "Member requested cancellation",
  "notes": "Optional notes"
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Check-in cancelled successfully",
  "data": {
    "id": 1,
    "bookingId": 5,
    "status": "CANCELLED",
    "cancelledAt": "2026-01-20T08:30:00Z",
    "reason": "Member requested cancellation"
  }
}
```

---

### 4. Get Attendance Record
**GET** `/api/v1/checkins/{id}`

Retrieves details of a specific check-in record.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Check-in record ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Attendance record retrieved successfully",
  "data": {
    "id": 1,
    "bookingId": 5,
    "memberId": 3,
    "memberName": "John Doe",
    "slotName": "Morning Yoga",
    "ptName": "Jane Smith",
    "date": "2026-01-20",
    "checkInTime": "2026-01-20T08:05:00Z",
    "checkOutTime": "2026-01-20T09:00:00Z",
    "duration": 55,
    "status": "CHECKED_OUT",
    "notes": "Optional notes"
  }
}
```

---

### 5. Get Member Attendance
**GET** `/api/v1/checkins/attendance/{memberId}`

Retrieves attendance history for a specific member.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| memberId | integer | Member ID |

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| startDate | string | No | From date (YYYY-MM-DD) |
| endDate | string | No | To date (YYYY-MM-DD) |
| status | string | No | Filter by status |
| page | integer | No | Pagination page |
| size | integer | No | Page size (default: 20) |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Attendance records retrieved successfully",
  "data": [
    {
      "id": 1,
      "date": "2026-01-20",
      "slotName": "Morning Yoga",
      "ptName": "Jane Smith",
      "checkInTime": "08:05",
      "checkOutTime": "09:00",
      "duration": 55,
      "status": "CHECKED_OUT"
    },
    {
      "id": 2,
      "date": "2026-01-18",
      "slotName": "Evening Fitness",
      "ptName": "John Smith",
      "checkInTime": "18:00",
      "checkOutTime": "18:45",
      "duration": 45,
      "status": "CHECKED_OUT"
    }
  ],
  "pagination": {
    "currentPage": 0,
    "pageSize": 20,
    "totalElements": 25
  }
}
```

---

### 6. Get Check-in by Booking
**GET** `/api/v1/checkins/booking/{bookingId}`

Retrieves check-in record associated with a specific booking.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| bookingId | integer | Booking ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Check-in record retrieved successfully",
  "data": {
    "id": 1,
    "bookingId": 5,
    "memberId": 3,
    "checkInTime": "2026-01-20T08:05:00Z",
    "checkOutTime": "2026-01-20T09:00:00Z",
    "duration": 55,
    "status": "CHECKED_OUT"
  }
}
```

---

## Check-in Statuses

| Status | Description |
|--------|-------------|
| CHECKED_IN | Member has checked in, session active |
| CHECKED_OUT | Member has checked out, session completed |
| CANCELLED | Check-in was cancelled |
| NO_SHOW | Member didn't show up for booked session |

---

## Attendance Tracking

**Key Metrics:**
- Session duration (checkout time - checkin time)
- Attendance rate per member
- Per-PT session attendance
- Slot utilization rate

**Use Cases:**
- Contract fulfillment tracking (sessions used vs. available)
- Attendance reporting for gyms
- Member engagement analytics
- PT performance metrics

---

## Error Handling

**Common Errors:**
- `Booking not found` - Referenced booking doesn't exist
- `Already checked in` - Member already checked in to this booking
- `Already checked out` - Session already completed
- `Invalid check-out` - Check-out time before check-in
- `Session expired` - Cannot check in to past session

---

## Testing

**E2E Test Coverage:**
- ✅ Member check-in to booked session
- ✅ Member check-out completion
- ✅ Cancel active check-in
- ✅ Retrieve attendance records
- ✅ Get member attendance history
- ✅ Check-in by booking ID

**Test Status:** 5/5 tests passing
