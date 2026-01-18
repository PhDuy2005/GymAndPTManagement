# Contract API Documentation

## Overview
Contract endpoints manage member service agreements, contract lifecycle, and contract-specific queries.

## Base URL
```
/api/v1/contracts
```

## Authentication
All endpoints require Bearer token authentication:
```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### 1. Create Contract
**POST** `/api/v1/contracts`

Creates a new service contract for a member.

**Request Body:**
```json
{
  "memberId": 3,
  "servicePackageId": 1,
  "startDate": "2026-01-20",
  "endDate": "2026-07-20",
  "notes": "New premium package"
}
```

**Response (201 Created):**
```json
{
  "statusCode": 201,
  "message": "Contract created successfully",
  "data": {
    "id": 1,
    "memberId": 3,
    "memberName": "John Doe",
    "servicePackageId": 1,
    "packageName": "Premium Annual",
    "startDate": "2026-01-20",
    "endDate": "2026-07-20",
    "status": "ACTIVE",
    "createdAt": "2026-01-17T10:30:00Z"
  }
}
```

**Error Responses:**
- **400 Bad Request** - Invalid request data
- **409 Conflict** - Member already has active contract for package

---

### 2. List All Contracts
**GET** `/api/v1/contracts`

Retrieves all contracts with optional filtering.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | Filter by status (ACTIVE, INACTIVE, EXPIRED) |
| memberId | integer | No | Filter by member |
| page | integer | No | Pagination page (default: 0) |
| size | integer | No | Page size (default: 20) |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Contracts retrieved successfully",
  "data": [
    {
      "id": 1,
      "memberId": 3,
      "memberName": "John Doe",
      "packageName": "Premium Annual",
      "startDate": "2026-01-20",
      "endDate": "2026-07-20",
      "status": "ACTIVE"
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

### 3. Get Contract Details
**GET** `/api/v1/contracts/{id}`

Retrieves detailed information about a specific contract.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Contract ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Contract retrieved successfully",
  "data": {
    "id": 1,
    "memberId": 3,
    "memberName": "John Doe",
    "memberEmail": "john@example.com",
    "memberPhone": "0123456789",
    "servicePackageId": 1,
    "packageName": "Premium Annual",
    "packagePrice": 5000000,
    "startDate": "2026-01-20",
    "endDate": "2026-07-20",
    "status": "ACTIVE",
    "sessionsIncluded": 48,
    "sessionsUsed": 12,
    "sessionsRemaining": 36,
    "createdAt": "2026-01-17T10:30:00Z",
    "notes": "Premium membership active"
  }
}
```

---

### 4. Get Member Contracts
**GET** `/api/v1/contracts/member/{memberId}`

Retrieves all contracts for a specific member.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| memberId | integer | Member ID |

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | Filter by status |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Member contracts retrieved successfully",
  "data": [
    {
      "id": 1,
      "packageName": "Premium Annual",
      "startDate": "2026-01-20",
      "endDate": "2026-07-20",
      "status": "ACTIVE",
      "sessionsRemaining": 36
    }
  ]
}
```

---

### 5. Get PT Contracts
**GET** `/api/v1/contracts/pt/{ptId}`

Retrieves contracts assigned to a specific personal trainer.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| ptId | integer | Personal Trainer ID |

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | Filter by status |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "PT contracts retrieved successfully",
  "data": [
    {
      "id": 1,
      "memberId": 3,
      "memberName": "John Doe",
      "packageName": "Premium Annual",
      "status": "ACTIVE"
    }
  ]
}
```

---

## Contract Statuses

| Status | Description |
|--------|-------------|
| ACTIVE | Contract is currently valid and active |
| INACTIVE | Contract exists but is not active |
| EXPIRED | Contract end date has passed |
| SUSPENDED | Contract temporarily suspended |

---

## Testing

**E2E Test Coverage:**
- ✅ Create new contract for member
- ✅ List all contracts with filters
- ✅ Retrieve contract details
- ✅ Get contracts for specific member
- ✅ Get contracts for specific PT

**Test Status:** 5/5 tests passing

---

---

# Invoice API Documentation

## Overview
Invoice endpoints manage billing, payment tracking, and service addition to invoices.

## Base URL
```
/api/v1/invoices
```

## Authentication
All endpoints require Bearer token authentication:
```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### 1. Get Invoice
**GET** `/api/v1/invoices/{id}`

Retrieves invoice details with line items and payment status.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Invoice ID |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Invoice retrieved successfully",
  "data": {
    "id": 1,
    "memberId": 3,
    "memberName": "John Doe",
    "invoiceDate": "2026-01-15",
    "dueDate": "2026-01-25",
    "status": "PENDING",
    "subtotal": 5000000,
    "tax": 500000,
    "total": 5500000,
    "paid": 2000000,
    "remaining": 3500000,
    "items": [
      {
        "id": 1,
        "description": "Premium Annual Package",
        "quantity": 1,
        "unitPrice": 5000000,
        "amount": 5000000
      }
    ],
    "notes": "Invoice for contract period"
  }
}
```

**Error Responses:**
- **404 Not Found** - Invoice not found
- **401 Unauthorized** - Insufficient permissions

---

### 2. Get Invoices by Member
**GET** `/api/v1/invoices/member/{memberId}`

Retrieves all invoices for a specific member.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| memberId | integer | Member ID |

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | Filter by status (PAID, PENDING, OVERDUE) |
| startDate | string | No | From date (YYYY-MM-DD) |
| endDate | string | No | To date (YYYY-MM-DD) |
| page | integer | No | Pagination page |
| size | integer | No | Page size (default: 20) |

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Member invoices retrieved successfully",
  "data": [
    {
      "id": 1,
      "invoiceDate": "2026-01-15",
      "total": 5500000,
      "paid": 2000000,
      "remaining": 3500000,
      "status": "PENDING"
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

### 3. Add Service to Invoice
**PUT** `/api/v1/invoices/{id}/add-service`

Adds additional service or charge to an existing invoice.

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Invoice ID |

**Request Body:**
```json
{
  "description": "Personal Training Session",
  "quantity": 2,
  "unitPrice": 500000
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Service added to invoice successfully",
  "data": {
    "id": 1,
    "subtotal": 6000000,
    "tax": 600000,
    "total": 6600000,
    "remaining": 4600000,
    "items": [
      {
        "id": 1,
        "description": "Premium Annual Package",
        "quantity": 1,
        "unitPrice": 5000000,
        "amount": 5000000
      },
      {
        "id": 2,
        "description": "Personal Training Session",
        "quantity": 2,
        "unitPrice": 500000,
        "amount": 1000000
      }
    ]
  }
}
```

---

### 4. Update Payment Status
**PUT** `/api/v1/invoices/{id}/payment-status`

Updates invoice payment status (full/partial payment recorded).

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Invoice ID |

**Request Body:**
```json
{
  "amountPaid": 2000000,
  "paymentMethod": "CASH",
  "paymentDate": "2026-01-17",
  "notes": "Payment received via bank transfer"
}
```

**Response (200 OK):**
```json
{
  "statusCode": 200,
  "message": "Payment recorded successfully",
  "data": {
    "id": 1,
    "total": 6600000,
    "paid": 4000000,
    "remaining": 2600000,
    "status": "PARTIAL",
    "lastPaymentDate": "2026-01-17",
    "paymentHistory": [
      {
        "date": "2026-01-17",
        "amount": 2000000,
        "method": "CASH"
      }
    ]
  }
}
```

---

## Invoice Statuses

| Status | Description |
|--------|-------------|
| DRAFT | Invoice not yet issued |
| PENDING | Invoice issued, awaiting payment |
| PARTIAL | Partial payment received |
| PAID | Invoice fully paid |
| OVERDUE | Payment due date passed |
| CANCELLED | Invoice cancelled |

---

## Error Handling

**Common Errors:**
- `Invoice not found` - Referenced invoice doesn't exist
- `Invalid amount` - Payment amount exceeds invoice total
- `Invoice cancelled` - Cannot modify cancelled invoices
- `Insufficient permissions` - User cannot access invoice

---

## Testing

**E2E Test Coverage:**
- ✅ Retrieve invoice details
- ✅ Get invoices for member
- ✅ Add service to invoice
- ✅ Record payment and update status
- ✅ Track payment history

**Integration Test Coverage:**
- ✅ Invoice creation from contracts
- ✅ Payment flow validation
- ✅ Invoice data integrity
- ✅ Payment error handling

**Test Status:** 45/45 tests passing
