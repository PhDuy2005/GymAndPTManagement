<p align="center">
  <a href="https://www.uit.edu.vn/" title="Trường Đại học Công nghệ Thông tin" style="border: 5;">
    <img src="https://i.imgur.com/WmMnSRt.png" alt="Trường Đại học Công nghệ Thông tin | University of Information Technology">
  </a>
</p>

<!-- Title -->
<h1 align="center"><b>SE100 - PHƯƠNG PHÁP PHÁT TRIỂN PHẦN MỀM HƯỚNG ĐỐI TƯỢNG</b></h1>

## GIỚI THIỆU MÔN HỌC
<a name="gioithieumonhoc"></a>
* **Tên môn học**: Phương pháp Phát triển phần mềm hướng đối tượng - Object-oriented software development methodology
* **Mã môn học**: SE100
* **Năm học**: 2025-2026

## GIẢNG VIÊN HƯỚNG DẪN
<a name="giangvien"></a>
* ThS. **Huỳnh Hồ Thị Mộng Trinh**

## THÀNH VIÊN NHÓM
<a name="thanhvien"></a>
| STT |   MSSV   |            Họ và Tên |                                                        Github |                  Email |
| --- | :------: | -------------------: | ------------------------------------------------------------: | ---------------------: |
| 1   | 23520540 |      Tăng Minh Hoàng |                       [Hoangfff](https://github.com/Hoangfff) | 23520540@gm.uit.edu.vn |
| 2   | 23520689 |      Lê Nguyên Khang |                             [KStuv](https://github.com/KStuv) | 23520689@gm.uit.edu.vn |
| 3   | 23520243 |    Nguyễn Thành Danh | [NguyenThanhDanh1678](https://github.com/NguyenThanhDanh1678) | 23520243@gm.uit.edu.vn |
| 4   | 23520384 |  Phạm Trần Khánh Duy |                     [PhDuy2005](https://github.com/PhDuy2005) | 23520384@gm.uit.edu.vn |
| 5   | 22520072 | Phan Nguyễn Tuấn Anh |     [PhanNguyenTuanAnh](https://github.com/PhanNguyenTuanAnh) | 22520072@gm.uit.edu.vn |

## PROJECT LIÊN QUAN
<a name="projectlienquan"></a>
* **Frontend Repository**: [Gym Management Web](https://github.com/Hoangfff/gym-management-web) - Giao diện người dùng được xây dựng với React

---

# 🏋️ Gym & PT Management System

Hệ thống quản lý phòng gym và huấn luyện viên cá nhân (Personal Trainer) được xây dựng bằng Spring Boot.

---

## 📋 Mục lục

- [Yêu cầu hệ thống](#-yêu cầu-hệ-thống)
- [Cài đặt môi trường](#-cài-đặt-môi-trường)
  - [1. Cài đặt Java JDK 17](#1-cài-đặt-java-jdk-17)
  - [2. Cài đặt VS Code Extensions](#2-cài-đặt-vs-code-extensions)
  - [3. Cài đặt MySQL](#3-cài-đặt-mysql)
- [Cài đặt project](#-cài-đặt-project)
- [Chạy ứng dụng](#-chạy-ứng-dụng)
- [Cấu trúc dự án](#-cấu-trúc-dự-án)
- [API Documentation](#-api-documentation)
- [Dữ liệu mẫu](#-dữ-liệu-mẫu)

---

## 🔧 Yêu cầu hệ thống

### Phần mềm bắt buộc:

- **Java JDK**: Version 17 trở lên
- **Gradle**: 8.x (được bao gồm trong wrapper)
- **MySQL**: 8.0 trở lên
- **VS Code**: Phiên bản mới nhất

### Extensions VS Code bắt buộc:

- Extension Pack for Java
- Spring Boot Extension Pack

---

## 🚀 Cài đặt môi trường

### 1. Cài đặt Java JDK 17

#### Kiểm tra Java hiện tại

Mở **Terminal** (PowerShell/Command Prompt) và chạy:

```bash
java -version
```

**Kết quả mong đợi:**
```
java version "17.0.x" 2023-xx-xx LTS
Java(TM) SE Runtime Environment (build 17.0.x+xx-LTS-xxx)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.x+xx-LTS-xxx, mixed mode, sharing)
```

Nếu version < 17 hoặc không tìm thấy Java, hãy tiến hành cài đặt.

---

#### Cài đặt Java JDK 17

**Cách 1: Tải từ Oracle (Khuyến nghị)**

1. Truy cập: [Oracle JDK 17 Downloads](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)

2. Chọn file phù hợp với hệ điều hành:
   - **Windows**: `jdk-17_windows-x64_bin.exe`
   - **macOS**: `jdk-17_macos-x64_bin.dmg` (Intel) hoặc `jdk-17_macos-aarch64_bin.dmg` (M1/M2)
   - **Linux**: `jdk-17_linux-x64_bin.tar.gz`

3. Chạy file cài đặt và làm theo hướng dẫn

4. **Thiết lập biến môi trường** (Windows):
   
   - Mở **System Properties** → **Environment Variables**
   - Thêm biến mới:
     - **Variable name**: `JAVA_HOME`
     - **Variable value**: `C:\Program Files\Java\jdk-17` (đường dẫn cài đặt JDK)
   
   - Thêm vào **Path**:
     - Thêm dòng mới: `%JAVA_HOME%\bin`

5. **Kiểm tra cài đặt**:

   Mở Terminal mới và chạy:
   ```bash
   java -version
   javac -version
   ```

---

**Cách 2: Sử dụng Chocolatey (Windows)**

```powershell
# Cài đặt Chocolatey (nếu chưa có)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Cài đặt JDK 17
choco install openjdk17 -y

# Kiểm tra
java -version
```

---

**Cách 3: Sử dụng SDKMAN (Linux/macOS)**

```bash
# Cài đặt SDKMAN
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Cài đặt JDK 17
sdk install java 17.0.9-tem

# Kiểm tra
java -version
```

---

### 2. Cài đặt VS Code Extensions

#### A. Extension Pack for Java

**Cách 1: Cài đặt từ VS Code Marketplace**

1. Mở **VS Code**
2. Nhấn `Ctrl+Shift+X` (Windows/Linux) hoặc `Cmd+Shift+X` (macOS)
3. Tìm kiếm: `Extension Pack for Java`
4. Nhấn **Install** trên extension của **Microsoft**

**Hoặc**

Nhấn `Ctrl+P` và chạy:
```
ext install vscjava.vscode-java-pack
```

**Extension Pack bao gồm:**
- Language Support for Java™ by Red Hat
- Debugger for Java
- Test Runner for Java
- Maven for Java
- Project Manager for Java
- Visual Studio IntelliCode

---

#### B. Spring Boot Extension Pack

**Cách 1: Cài đặt từ VS Code Marketplace**

1. Mở **VS Code**
2. Nhấn `Ctrl+Shift+X` (Windows/Linux) hoặc `Cmd+Shift+X` (macOS)
3. Tìm kiếm: `Spring Boot Extension Pack`
4. Nhấn **Install** trên extension của **VMware**

**Hoặc**

Nhấn `Ctrl+P` và chạy:
```
ext install vmware.vscode-boot-dev-pack
```

**Extension Pack bao gồm:**
- Spring Boot Tools
- Spring Initializr Java Support
- Spring Boot Dashboard

---

#### Kiểm tra Extensions đã cài đặt

Nhấn `Ctrl+Shift+X` và kiểm tra các extension sau đã được cài:

✅ Extension Pack for Java  
✅ Spring Boot Extension Pack  

---

### 3. Cài đặt MySQL

#### Tải và cài đặt MySQL Server 8.0+

1. Truy cập: [MySQL Downloads](https://dev.mysql.com/downloads/mysql/)
2. Chọn version phù hợp với hệ điều hành
3. Cài đặt theo hướng dẫn
4. **Lưu lại** root password

#### Tạo Database

Mở **MySQL Workbench** hoặc **MySQL Command Line** và chạy:

```sql
CREATE DATABASE gym_management;
```

#### Tạo User (khuyến nghị)

```sql
CREATE USER 'gym_user'@'localhost' IDENTIFIED BY 'gym_password_123';
GRANT ALL PRIVILEGES ON gym_management.* TO 'gym_user'@'localhost';
FLUSH PRIVILEGES;
```

---

## 📦 Cài đặt project

### 1. Clone repository

```bash
git clone <repository-url>
cd GymAndPTManagement
```

### 2. Cấu hình Database

Mở file `src/main/resources/application.properties` và cập nhật:

```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/gym_management
spring.datasource.username=gym_user
spring.datasource.password=gym_password_123

# Nếu dùng root user
# spring.datasource.username=root
# spring.datasource.password=your_root_password
```

### 3. Build project

```bash
# Windows
.\gradlew clean build

# Linux/macOS
./gradlew clean build
```

---

## ▶️ Chạy ứng dụng

### Cách 1: Sử dụng Gradle

```bash
# Windows
.\gradlew bootRun

# Linux/macOS
./gradlew bootRun
```

### Cách 2: Chạy từ VS Code

1. Mở file `GymAndPtManagementApplication.java`
2. Nhấn **F5** hoặc click **Run** trên Spring Boot Dashboard
3. Hoặc nhấn **Ctrl+F5** để chạy không debug

### Cách 3: Chạy JAR file

```bash
# Build JAR
.\gradlew bootJar

# Chạy
java -jar build/libs/GymAndPTManagement-0.0.1-SNAPSHOT.jar
```

---

## 🔍 Kiểm tra ứng dụng

Khi ứng dụng chạy thành công, bạn sẽ thấy:

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.x.x)

🚀 Bắt đầu khởi tạo database với dữ liệu mock...
✓ Roles & Permissions khởi tạo xong!
✓ Service Packages & Additional Services khởi tạo xong!
✓ Admin user created via UserService
✓ Personal Trainers created via Service
✓ Members created via Service
...
✓ ✓ ✓ Khởi tạo database hoàn tất thành công!

Started GymAndPtManagementApplication in X.XXX seconds
```

### Truy cập ứng dụng

- **API Base URL**: http://localhost:8080
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **API Docs**: http://localhost:8080/api-docs

---

## 📁 Cấu trúc dự án

```
GymAndPTManagement/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/se100/GymAndPTManagement/
│   │   │       ├── config/          # Cấu hình (Security, OpenAPI, DatabaseInit)
│   │   │       ├── controller/      # REST API Controllers
│   │   │       ├── domain/
│   │   │       │   ├── requestDTO/  # Request DTOs
│   │   │       │   ├── responseDTO/ # Response DTOs
│   │   │       │   └── table/       # JPA Entities
│   │   │       ├── repository/      # JPA Repositories
│   │   │       ├── service/         # Business Logic
│   │   │       └── util/            # Utilities
│   │   └── resources/
│   │       ├── application.properties
│   │       └── data-mock.sql       # Dữ liệu mẫu
│   └── test/                        # Unit Tests
├── docs/                            # Tài liệu API
├── build.gradle.kts
└── README.md
```

---

## 📚 API Documentation

Xem chi tiết tại thư mục [docs/](docs/):

- [API Overview](docs/API_OVERVIEW.md)
- [Authentication API](docs/API_AUTHENTICATION.md)
- [Members & PTs API](docs/API_MEMBERS_PTS_PACKAGES.md)
- [Booking API](docs/API_BOOKING.md)
- [Check-in API](docs/API_CHECKIN.md)
- [Contracts & Invoices](docs/API_CONTRACTS_AND_INVOICES.md)

---

## 🎯 Dữ liệu mẫu

Ứng dụng tự động khởi tạo dữ liệu mẫu khi chạy lần đầu:

### Users (Password: `123456` cho tất cả)

| Role   | Email             | Fullname         |
| ------ | ----------------- | ---------------- |
| Admin  | admin@gym.com     | Admin User       |
| PT     | pt1@gym.com       | Trần Minh PT     |
| PT     | pt2@gym.com       | Lê Thị PT        |
| PT     | pt3@gym.com       | Phạm Văn PT      |
| Member | member1@gmail.com | Nguyễn Văn A     |
| Member | member2@gmail.com | Trần Thị B       |
| ...    | ...               | ... (17 members) |

### Packages

1. **Gói 1 Tháng Cơ Bản** - 500,000 VNĐ
2. **Gói 3 Tháng Tiêu Chuẩn** - 1,300,000 VNĐ (12 buổi PT)
3. **Gói 6 Tháng Nâng Cao** - 2,300,000 VNĐ (48 buổi PT)
4. **Gói VIP 12 Tháng** - 4,200,000 VNĐ (120 buổi PT)
5. **Gói Học Sinh - Sinh Viên** - 350,000 VNĐ

---

## 🐛 Xử lý sự cố

### Lỗi: "java: invalid source release: 17"

**Nguyên nhân**: JDK version không đúng

**Giải pháp**:
1. Kiểm tra JAVA_HOME đang trỏ đến JDK 17+
2. Trong VS Code, mở Command Palette (`Ctrl+Shift+P`)
3. Chạy: `Java: Configure Java Runtime`
4. Chọn JDK 17 cho project

---

### Lỗi: "Access denied for user..."

**Nguyên nhân**: Sai username/password MySQL

**Giải pháp**:
1. Kiểm tra lại `application.properties`
2. Đảm bảo user đã được tạo và có quyền truy cập database

---

### Lỗi: Port 8080 đã được sử dụng

**Giải pháp**:

Thêm vào `application.properties`:
```properties
server.port=8081
```

---

## 👥 Đóng góp

1. Fork repository
2. Tạo branch mới (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

---

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

---

## 📞 Liên hệ

SE100 Team - [GitHub](https://github.com/yourusername/GymAndPTManagement)

Project Link: [https://github.com/yourusername/GymAndPTManagement](https://github.com/yourusername/GymAndPTManagement)

---

## 🙏 Acknowledgments

- [Spring Boot](https://spring.io/projects/spring-boot)
- [Spring Security](https://spring.io/projects/spring-security)
- [MySQL](https://www.mysql.com/)
- [Swagger/OpenAPI](https://swagger.io/)

---

**Happy Coding! 🎉**
