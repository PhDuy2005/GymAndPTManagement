# Pagination Algorithm

**Category**: Pagination  
**Algorithm**: Spring Data JPA Pagination  
**Author**: System  
**Date**: 2026-01-03

---

## 📋 Mô Tả

Thuật toán phân trang dữ liệu để tránh load toàn bộ dataset vào memory. Sử dụng Spring Data JPA `Pageable` và `Page` để implement pagination một cách standardized.

---

## ⚙️ Configuration

| Parameter      | Default Value | Max Value | Description              |
| -------------- | ------------- | --------- | ------------------------ |
| Page Size      | 20            | 2000      | Số items mỗi trang       |
| Page Number    | 1             | -         | Trang cần lấy (1-based)  |
| Sort Field     | -             | -         | Field để sort (optional) |
| Sort Direction | ASC           | -         | ASC hoặc DESC (optional) |

**Note**: Spring Data JPA internally uses **0-based** index, nhưng API sẽ expose **1-based** để user-friendly.

---

## 💻 Implementation

### Repository Layer

```java
public interface UserRepository extends JpaRepository<User, Long> {
    // Pagination built-in từ JpaRepository
    Page<User> findAll(Pageable pageable);
    
    // Custom query với pagination
    Page<User> findByNameContaining(String name, Pageable pageable);
    
    @Query("SELECT u FROM User u WHERE u.role.name = :roleName")
    Page<User> findByRoleName(@Param("roleName") String roleName, Pageable pageable);
}
```

### Service Layer

```java
/**
 * Get paginated list
 * @param pageNumber - Trang cần lấy (bắt đầu từ 1)
 * @param pageSize - Số items mỗi trang
 * @return Page object với content và metadata
 */
public Page<User> getPaginatedList(int pageNumber, int pageSize) {
    // Validate
    if (pageNumber < 1) pageNumber = 1;
    if (pageSize < 1) pageSize = 20;
    if (pageSize > 2000) pageSize = 2000;
    
    // Convert to 0-based index for Spring Data JPA
    Pageable pageable = PageRequest.of(pageNumber - 1, pageSize);
    return userRepository.findAll(pageable);
}

/**
 * Get paginated list with sorting
 */
public Page<User> getPaginatedListWithSort(int pageNumber, int pageSize, 
                                           String sortField, String sortDirection) {
    if (pageNumber < 1) pageNumber = 1;
    if (pageSize < 1) pageSize = 20;
    if (pageSize > 2000) pageSize = 2000;
    
    Sort.Direction direction = "DESC".equalsIgnoreCase(sortDirection) 
        ? Sort.Direction.DESC 
        : Sort.Direction.ASC;
    
    Pageable pageable = PageRequest.of(pageNumber - 1, pageSize, 
                                       Sort.by(direction, sortField));
    return userRepository.findAll(pageable);
}
```

### Controller Layer

```java
@GetMapping("/users")
public ResponseEntity<RestResponse<Page<ResUserDTO>>> getUsers(
    @RequestParam(defaultValue = "1") int page,
    @RequestParam(defaultValue = "20") int size,
    @RequestParam(required = false) String sortBy,
    @RequestParam(required = false) String sortDir
) {
    Page<User> userPage;
    
    if (sortBy != null && !sortBy.isEmpty()) {
        userPage = userService.getPaginatedListWithSort(page, size, sortBy, sortDir);
    } else {
        userPage = userService.getPaginatedList(page, size);
    }
    
    // Convert to DTO
    Page<ResUserDTO> dtoPage = userPage.map(user -> convertToDTO(user));
    
    return ResponseEntity.ok(new RestResponse<>(
        HttpStatus.OK.value(),
        null,
        dtoPage
    ));
}
```

---

## 📊 Response Format

```json
{
  "statusCode": 200,
  "error": null,
  "data": {
    "content": [
      {
        "id": 1,
        "name": "User 1",
        "email": "user1@example.com"
      },
      {
        "id": 2,
        "name": "User 2",
        "email": "user2@example.com"
      }
    ],
    "pageable": {
      "sort": {
        "sorted": false,
        "unsorted": true,
        "empty": true
      },
      "pageNumber": 0,
      "pageSize": 20,
      "offset": 0,
      "paged": true,
      "unpaged": false
    },
    "totalPages": 5,
    "totalElements": 100,
    "last": false,
    "first": true,
    "size": 20,
    "number": 0,
    "sort": {
      "sorted": false,
      "unsorted": true,
      "empty": true
    },
    "numberOfElements": 20,
    "empty": false
  }
}
```

**Important Fields**:
- `content`: Array of items in current page
- `totalPages`: Total number of pages
- `totalElements`: Total number of items
- `number`: Current page number (0-based in response)
- `size`: Page size
- `first`: Is this the first page?
- `last`: Is this the last page?

---

## 📝 Usage Examples

### Request Examples

```bash
# Get first page with default size (20)
GET /api/v1/users?page=1

# Get page 2 with size 50
GET /api/v1/users?page=2&size=50

# Get page 1, sort by name ascending
GET /api/v1/users?page=1&size=20&sortBy=name&sortDir=ASC

# Get page 3, sort by createdAt descending
GET /api/v1/users?page=3&size=10&sortBy=createdAt&sortDir=DESC
```

### Client-side Pagination Logic

```javascript
// Calculate total pages
const totalPages = Math.ceil(totalElements / pageSize);

// Check if has next page
const hasNextPage = currentPage < totalPages;

// Check if has previous page
const hasPreviousPage = currentPage > 1;

// Generate page numbers for pagination UI
const pageNumbers = Array.from({length: totalPages}, (_, i) => i + 1);
```

---

## ⏱️ Performance Considerations

### Database Query

```sql
-- Spring Data JPA generates LIMIT/OFFSET query
SELECT * FROM users 
ORDER BY id 
LIMIT 20 OFFSET 0;  -- Page 1

SELECT * FROM users 
ORDER BY id 
LIMIT 20 OFFSET 20;  -- Page 2
```

### Performance Notes

- ⚠️ **Large offset problem**: OFFSET performance degrades with large values
- ✅ **Index sort fields**: Ensure sort fields are indexed
- ✅ **Limit max page size**: Prevent users from requesting too many items
- 💡 **Cursor-based pagination**: Consider for very large datasets

---

## 🚨 Edge Cases

- **Page number < 1**: Default to page 1
- **Page size < 1**: Default to 20
- **Page size > max**: Cap at 2000
- **Page number > total pages**: Return empty page
- **No data**: Return empty page with totalElements = 0
- **Invalid sort field**: Throw exception or ignore and use default sort

---

## 🧪 Testing

```java
@Test
public void testPagination_FirstPage() {
    Page<User> page = userService.getPaginatedList(1, 10);
    
    assertEquals(10, page.getSize());
    assertEquals(0, page.getNumber()); // 0-based internally
    assertTrue(page.isFirst());
    assertFalse(page.isLast());
}

@Test
public void testPagination_LastPage() {
    // Assuming 95 total users, page size 10
    Page<User> page = userService.getPaginatedList(10, 10);
    
    assertEquals(5, page.getNumberOfElements()); // Only 5 items on last page
    assertTrue(page.isLast());
    assertFalse(page.isFirst());
}

@Test
public void testPagination_EmptyResult() {
    Page<User> page = userService.getPaginatedList(100, 10);
    
    assertTrue(page.isEmpty());
    assertEquals(0, page.getNumberOfElements());
}

@Test
public void testPagination_WithSorting() {
    Page<User> page = userService.getPaginatedListWithSort(1, 10, "name", "ASC");
    
    List<User> users = page.getContent();
    for (int i = 0; i < users.size() - 1; i++) {
        assertTrue(users.get(i).getName().compareTo(users.get(i + 1).getName()) <= 0);
    }
}
```

---

## 📚 References

- [Spring Data JPA Pagination](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#repositories.query-methods.query-property-expressions)
- [Pageable Interface](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/domain/Pageable.html)
- [Page Interface](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/domain/Page.html)

---

**Version**: 1.0  
**Last Updated**: 2026-01-03
