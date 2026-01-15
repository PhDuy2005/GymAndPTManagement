# FileController Documentation

> **Controller**: `com.se100.GymAndPTManagement.controller.FileController`  
> **Base URL**: `/api/v1`  
> **Purpose**: Quản lý upload và download file (tài liệu, hình ảnh) trên server

---

## 📋 Tổng Quan

Controller này cung cấp các endpoint để:
- **Upload** file (hình ảnh, tài liệu) lên server với validation
- **Download** file từ server về máy client
- Quản lý folder lưu trữ file theo danh mục
- Validate MIME type và extension

---

## 🔗 Related Files

- **Service**: `src/main/java/com/se100/GymAndPTManagement/service/FileService.java`
- **Response DTO**: `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResUploadFileDTO.java`
- **Configuration**: `application.properties` (property: `se100.upload-file.base-uri`)

---

## 📝 Configuration

### Upload Directory Configuration
```properties
# application.properties
se100.upload-file.base-uri=file:///uploads/
```

**Directory Structure**:
```
/uploads/
├── member-documents/      # Tài liệu của member
├── workout-images/        # Hình ảnh bài tập
├── before-after/          # Ảnh before/after
├── receipts/              # Hóa đơn/biên lai
└── temp/                  # File tạm
```

---

## 🚀 Endpoints

### 1. Upload File
**POST** `/api/v1/files`

**Description**: Upload file lên server với validation

**Request Parameters** (multipart/form-data):
- `file` (MultipartFile, required): File cần upload
- `folder` (String, required): Thư mục lưu trữ (e.g., `member-documents`, `workout-images`)

**Allowed File Types**:
- **Extensions**: `png`, `jpg`, `jpeg`, `gif`, `pdf`, `doc`, `docx`
- **MIME Types**:
  - `image/png` (PNG)
  - `image/jpeg` (JPG, JPEG)
  - `image/gif` (GIF)
  - `application/pdf` (PDF)
  - `application/msword` (DOC)
  - `application/vnd.openxmlformats-officedocument.wordprocessingml.document` (DOCX)

**Max File Size**: 
- Mặc định: 10MB (có thể cấu hình trong `application.properties`)

**Success Response** (200 OK):
```json
{
  "statusCode": 200,
  "message": "Upload single file to server",
  "data": {
    "fileName": "1673891234567-resume.pdf",
    "uploadedAt": "2026-01-15T14:30:00Z"
  }
}
```

**Response Fields**:
- `fileName` (String): Tên file sau khi lưu (timestamp prefix + original name)
- `uploadedAt` (Instant): Thời gian upload

**Error Responses**:
- **400 Bad Request**: File empty hoặc extension không hợp lệ
  ```json
  {
    "statusCode": 400,
    "error": "File is required"
  }
  ```
  ```json
  {
    "statusCode": 400,
    "error": "File type is not allowed. Only allow: png, jpg, jpeg, gif, pdf, doc, docx"
  }
  ```
  
- **400 Bad Request**: MIME type không hợp lệ
  ```json
  {
    "statusCode": 400,
    "error": "Invalid file type based on MIME type."
  }
  ```

### Example Usage (cURL)
```bash
curl -X POST "http://localhost:8080/api/v1/files" \
  -F "file=@/path/to/document.pdf" \
  -F "folder=member-documents"
```

### Example Usage (JavaScript/Fetch)
```javascript
const formData = new FormData();
formData.append('file', fileInput.files[0]);
formData.append('folder', 'member-documents');

const response = await fetch('/api/v1/files', {
  method: 'POST',
  body: formData,
  headers: {
    'Authorization': `Bearer ${token}`
  }
});

const data = await response.json();
console.log(data.data.fileName); // Lưu fileName để download sau
```

---

### 2. Download File
**GET** `/api/v1/files`

**Description**: Download file từ server

**Query Parameters**:
- `fileName` (String, required): Tên file đã upload (từ endpoint upload)
- `folder` (String, required): Thư mục chứa file

**Success Response** (200 OK):
- Binary file data (application/octet-stream)
- Header: `Content-Disposition: attachment; filename="<fileName>"`

**Example Download**:
```javascript
// Sau khi upload, lưu được fileName = "1673891234567-resume.pdf"
const response = await fetch(
  '/api/v1/files?fileName=1673891234567-resume.pdf&folder=member-documents',
  {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  }
);

const blob = await response.blob();
const url = window.URL.createObjectURL(blob);
const a = document.createElement('a');
a.href = url;
a.download = 'resume.pdf';
a.click();
```

**Error Responses**:
- **400 Bad Request**: Thiếu fileName
  ```json
  {
    "statusCode": 400,
    "error": "File name is required"
  }
  ```

- **404 Not Found**: File không tồn tại
  ```json
  {
    "statusCode": 404,
    "error": "File not found"
  }
  ```

---

## 🔒 Security & Best Practices

### Authentication
- **Yêu cầu**: JWT token trong header
- Upload/Download cần authentication (trừ công khai URL)

### Authorization
- **Upload**: Member, PersonalTrainer, Admin
- **Download**: Ai có URL + token hợp lệ

### File Validation
1. **Extension Check**: Whitelist extensions
   ```java
   allowedExtensions = ["png", "jpg", "jpeg", "gif", "pdf", "doc", "docx"]
   ```

2. **MIME Type Check**: Validate content type
   ```java
   allowedMimeTypes = [
     "application/pdf",
     "image/jpeg",
     "image/png",
     "application/msword",
     "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
   ]
   ```

3. **Filename Sanitization**: Timestamp prefix tránh collision
   ```java
   finalName = System.currentTimeMillis() + "-" + file.getOriginalFilename()
   // Ví dụ: 1673891234567-resume.pdf
   ```

### Storage Security
- ❌ **KHÔNG** lưu file trong web root (tránh direct access)
- ✅ **Lưu ngoài** web root (e.g., `/uploads/` ngoài public folder)
- ✅ **Sử dụng** FileService để access file (kiểm soát quyền hạn)

---

## 📊 Use Cases

### Use Case 1: Member upload hồ sơ
```
1. User chọn file từ máy tính
2. POST /api/v1/files
   - file: "resume.pdf"
   - folder: "member-documents"
3. Server response: fileName = "1673891234567-resume.pdf"
4. Frontend lưu fileName trong database
5. Lần sau member muốn tải file:
6. GET /api/v1/files?fileName=1673891234567-resume.pdf&folder=member-documents
```

### Use Case 2: Admin quản lý tài liệu
```
Upload hình ảnh bài tập:
- POST /api/v1/files
  - file: "push-up.jpg"
  - folder: "workout-images"
  
Download hình ảnh:
- GET /api/v1/files?fileName=1673891234567-push-up.jpg&folder=workout-images
```

### Use Case 3: Member upload ảnh before/after
```
1. Member chụp ảnh hiện tại
2. POST /api/v1/files
   - file: "after-photo.jpg"
   - folder: "before-after"
3. Lưu fileName vào table BodyMetrics hoặc Progress tracking
4. Có thể download/view lại ảnh để compare
```

### Use Case 4: Invoices/Receipts
```
Upload hóa đơn:
- POST /api/v1/files
  - file: "invoice-2026-01.pdf"
  - folder: "receipts"
  
Download hóa đơn:
- GET /api/v1/files?fileName=1673891234567-invoice-2026-01.pdf&folder=receipts
```

---

## 🔧 Implementation Details

### FileService Logic

#### 1. createUploadFolder()
```java
// Tạo thư mục nếu chưa tồn tại
// Input: folder path (e.g., "file:///uploads/member-documents")
// Output: void
Path path = Paths.get(new URI(folder));
if (!tmpDir.isDirectory()) {
    Files.createDirectory(tmpDir.toPath());
}
```

**Lưu ý**:
- Sử dụng `java.nio.file` API
- Convert URI → Path → File
- Create parent directories nếu cần

#### 2. store()
```java
// Lưu file với timestamp prefix
String finalName = System.currentTimeMillis() + "-" + file.getOriginalFilename();
// Ví dụ: "1673891234567-resume.pdf"

Path path = Paths.get(new URI(baseURI + folder + "/" + finalName));
Files.copy(inputStream, path, StandardCopyOption.REPLACE_EXISTING);
return finalName;
```

**Lợi ích**:
- Tránh conflict: Nhiều file cùng tên được lưu riêng
- Theo dõi thời gian: Timestamp cho biết khi nào upload
- Deterministic: Có thể tái tạo path từ fileName + folder

#### 3. getFileLength()
```java
// Lấy kích thước file (để set Content-Length header)
File file = new File(path.toString());
if (!file.exists() || file.isDirectory()) {
    return 0L;
}
return file.length(); // Byte
```

#### 4. getResource()
```java
// Trả về InputStreamResource để download
FileInputStream inputStream = new FileInputStream(file);
return new InputStreamResource(inputStream);
```

---

## 📋 Configuration (application.properties)

```properties
# File Upload Configuration
se100.upload-file.base-uri=file:///uploads/

# File Size Limit (default 10MB)
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB

# Temporary Storage Path
spring.servlet.multipart.location=/tmp/uploads
```

---

## 🧪 Testing

### Test Upload (Postman)
```
POST /api/v1/files
Content-Type: multipart/form-data

Form Data:
- Key: "file" (type: File) → Select any .pdf, .jpg, .png
- Key: "folder" (type: Text) → "member-documents"

Expected: 200 OK with ResUploadFileDTO
```

### Test Download (Browser)
```
GET /api/v1/files?fileName=1673891234567-resume.pdf&folder=member-documents

Expected: File download
```

---

## 🚨 Common Issues & Solutions

### Issue 1: "File type is not allowed"
**Cause**: Extension không được whitelist  
**Solution**: Sửa file extension hoặc thêm vào whitelist
```java
allowedExtensions = List.of("png", "jpg", "jpeg", "gif", "pdf", "doc", "docx");
```

### Issue 2: "Invalid file type based on MIME type"
**Cause**: File extension hợp lệ nhưng MIME type sai  
**Solution**: Upload file đúng format (không đổi extension của file khác)

**Example**:
```
❌ Sai: Đổi "video.mp4" → "video.pdf" (MIME type vẫn là video/mp4)
✅ Đúng: Upload file PDF thực sự
```

### Issue 3: "File not found"
**Cause**: fileName hoặc folder sai  
**Solution**: Kiểm tra fileName từ response upload, folder phải match

### Issue 4: Directory không được tạo
**Cause**: Permissions không đủ trên file system  
**Solution**: 
- Check folder permissions (`chmod 755`)
- Verify `se100.upload-file.base-uri` tồn tại
- Run application với user có write permission

---

## 💾 Data Storage Pattern

### Storing File Reference in Database

**Example 1: Member Documents**
```java
@Entity
public class MemberDocument {
    @Id private Long id;
    
    @ManyToOne
    private Member member;
    
    private String fileName;     // e.g., "1673891234567-resume.pdf"
    private String folder;       // e.g., "member-documents"
    private String displayName;  // e.g., "Resume"
    private LocalDateTime uploadedAt;
    
    // Helper method to reconstruct download URL
    public String getDownloadUrl() {
        return "/api/v1/files?fileName=" + fileName + "&folder=" + folder;
    }
}
```

**Example 2: Workout Images**
```java
@Entity
public class WorkoutImage {
    @Id private Long id;
    
    @ManyToOne
    private Workout workout;
    
    private String fileName;     // e.g., "1673891234567-push-up.jpg"
    private String folder;       // "workout-images"
    private String description;
    
    public String getDownloadUrl() {
        return "/api/v1/files?fileName=" + fileName + "&folder=" + folder;
    }
}
```

---

## 📚 Related Documentation

- [DATABASE_SCHEMA.md](../DATABASE_SCHEMA.md)
- [API_RESPONSE_FORMAT.md](../API_RESPONSE_FORMAT.md)
- Spring MultipartFile: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/multipart/MultipartFile.html

---

## 🎯 MAYDAY Feature Notes

**MAYDAY** = Member's Attached Documents & Information Vault  

This FileController provides the backbone for:
- ✅ Storing member documents (contracts, health forms, ID copies)
- ✅ Hosting exercise images/videos (reference material)
- ✅ Progress tracking images (before/after photos)
- ✅ Invoice/receipt management
- ✅ Workout routine documents

**File Organization**:
```
/uploads/
├── member-documents/    → Contracts, health forms, IDs
├── workout-images/      → Exercise demonstrations
├── before-after/        → Progress photos
├── receipts/            → Invoices, payment proofs
└── personal-docs/       → Member's personal files
```

---

**Created**: 2026-01-15  
**Last Updated**: 2026-01-15  
**Version**: 1.0  
**Feature**: MAYDAY (Member's Attached Documents & Information Vault)
