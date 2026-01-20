# Database Initializer - Hướng dẫn sử dụng

## 📋 Tổng quan

File `DatabaseInitializer.java` là một **Spring Boot CommandLineRunner** tự động khởi tạo dữ liệu mock cho database khi ứng dụng khởi động.

## ✨ Điểm đặc biệt

### 🎯 Sử dụng Service Layer cho User/Member/PT

Thay vì thực thi SQL trực tiếp cho Users, Members và Personal Trainers, chúng tôi **gọi thẳng vào Service layer**:

```java
// ❌ KHÔNG làm thế này (SQL trực tiếp)
jdbcTemplate.execute("INSERT INTO users ... VALUES ...");

// ✅ LÀM thế này (qua Service)
memberService.createMember(memberDTO);
personalTrainerService.createPT(ptDTO);
```

### 🔥 Lợi ích

1. **Business Logic được đảm bảo**
   - Validation tự động (email không trùng, CCCD hợp lệ, etc.)
   - Password được mã hóa BCrypt đúng cách
   - Default values được set tự động (@PrePersist)

2. **Nhất quán với API**
   - Dữ liệu mock tạo ra giống y như khi gọi API
   - Không bị lệch logic giữa test data và production

3. **Dễ bảo trì**
   - Khi thay đổi logic tạo user, chỉ cần sửa 1 chỗ (Service)
   - Không cần update cả SQL script

## 📊 Cấu trúc khởi tạo

```
1. Roles & Permissions       → SQL (bảng cơ bản)
2. Service Packages           → SQL (không có logic phức tạp)
3. Users/Members/PTs          → SERVICE (có validation & business logic)
4. Slots & Available Slots    → SQL
5. Foods, Workouts, Devices   → SQL
6. Contracts & Bookings       → SQL (tạm bỏ qua - cần điều chỉnh ID)
7. Metrics & Logs             → SQL (tạm bỏ qua - cần điều chỉnh ID)
```

## 🚀 Cách hoạt động

### Khi ứng dụng khởi động:

1. **Kiểm tra dữ liệu**
   ```java
   if (isDataAlreadyInitialized()) {
       return; // Bỏ qua nếu đã có data
   }
   ```

2. **Khởi tạo Roles & Permissions** (SQL)
   ```sql
   INSERT INTO roles ...
   INSERT INTO permissions ...
   ```

3. **Tạo Admin User** (SQL - vì không có AdminService)
   ```sql
   INSERT INTO users (role_id=1) ...
   ```

4. **Tạo Personal Trainers** (qua Service)
   ```java
   ReqCreatePTDTO pt1 = new ReqCreatePTDTO();
   pt1.setFullname("Trần Minh PT");
   pt1.setEmail("pt1@gym.com");
   // ... set các fields khác
   personalTrainerService.createPT(pt1);
   ```

5. **Tạo Members** (qua Service)
   ```java
   ReqCreateMemberDTO member1 = new ReqCreateMemberDTO();
   member1.setFullname("Nguyễn Văn A");
   member1.setEmail("member1@gmail.com");
   // ... set các fields khác
   memberService.createMember(member1);
   ```

## 📝 Dữ liệu được tạo

### Users
- **1 Admin**: admin@gym.com (password: 123456)
- **3 PTs**: pt1@gym.com, pt2@gym.com, pt3@gym.com
- **17 Members**: member1@gmail.com → member17@gmail.com

### Khác
- 3 Roles (ADMIN, MEMBER, PT)
- 24 Permissions
- 5 Service Packages
- 7 Additional Services
- 12 Time Slots
- 5 Foods (mẫu)
- 5 Workouts (mẫu)
- 3 Workout Devices (mẫu)

## ⚙️ Cấu hình

### Tắt auto-init (nếu cần)

Có 2 cách:

**Cách 1**: Comment annotation
```java
// @Component  // Bỏ comment này
public class DatabaseInitializer implements CommandLineRunner {
```

**Cách 2**: Thêm condition trong `run()`
```java
@Override
public void run(String... args) throws Exception {
    if (!"dev".equals(environment)) {
        return; // Chỉ chạy trên môi trường dev
    }
    // ... code khởi tạo
}
```

## 🔍 Logging

```
🚀 Bắt đầu khởi tạo database với dữ liệu mock...
📝 Bước 1: Khởi tạo Roles & Permissions...
✓ Roles & Permissions khởi tạo xong!
📦 Bước 2: Khởi tạo Service Packages & Additional Services...
✓ Service Packages & Additional Services khởi tạo xong!
👥 Bước 3: Khởi tạo Users, Members & Personal Trainers qua Service...
✓ Admin user created via SQL
✓ Personal Trainers created via Service
✓ Members created via Service
...
✓ ✓ ✓ Khởi tạo database hoàn tất thành công!
```

## ⚠️ Lưu ý quan trọng

### 1. Contracts & Bookings tạm bỏ qua

Do Users/Members/PTs được tạo qua Service, các ID có thể khác với SQL file gốc. Cần điều chỉnh logic tạo Contracts/Bookings để lấy ID động từ database.

### 2. Password mặc định

Tất cả users có password: **123456** (đã được BCrypt hash trong Service)

### 3. Chạy 1 lần duy nhất

`isDataAlreadyInitialized()` kiểm tra xem đã có dữ liệu chưa (bằng cách đếm roles). Nếu có rồi thì bỏ qua.

### 4. Dependencies cần có

```java
@RequiredArgsConstructor
private final JdbcTemplate jdbcTemplate;
private final MemberService memberService;
private final PersonalTrainerService personalTrainerService;
```

Đảm bảo các Service đã được inject đúng.

## 🛠️ Tùy chỉnh

### Thêm dữ liệu mới

```java
private void createAdditionalMembers() {
    String[][] memberData = {
        {"Tên", "email", "phone", "GENDER", "dob", "STATUS", "cccd"},
        // Thêm dòng mới ở đây
    };
    
    for (String[] data : memberData) {
        ReqCreateMemberDTO member = new ReqCreateMemberDTO();
        // ... set fields
        memberService.createMember(member);
    }
}
```

### Thay đổi password mặc định

Tìm và sửa:
```java
pt1.setPassword("123456"); // Đổi thành password khác
```

## 📚 Tài liệu tham khảo

- [MemberService.java](../service/MemberService.java) - Business logic tạo Member
- [PersonalTrainerService.java](../service/PersonalTrainerService.java) - Business logic tạo PT
- [data-mock.sql](../../resources/data-mock.sql) - SQL script gốc

## 👨‍💻 Tác giả

- SE100 Team
- Version: 2.0
- Updated: 2026-01-20

---

**Happy Coding! 🎉**
