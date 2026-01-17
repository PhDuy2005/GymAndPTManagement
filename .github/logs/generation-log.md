# 📝 Code Generation Log

> File này ghi lại lịch sử tất cả code generations bởi AI agents/models.

---

## Log Format

```markdown
## [YYYY-MM-DD HH:mm:ss] - {PROMPT_SUMMARY}
- **Model**: {TÊN_MODEL}
- **User**: {TÊN_NGƯỜI_PROMPT}
- **Files Modified/Created**:
  - `path/to/file1.java`
  - `path/to/file2.java`
- **Description**: {MÔ_TẢ_CHI_TIẾT}
```
## [2026-01-03 15:40:00] - Format and Update ALGORITHMS.md - Business Logic Documentation

- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: Danh
- **Files Modified/Created**:
  - `.github/instruction/Thuat_toan_BM7_BM15a.md`
  - `.github/logs/generation-log.md`

- **Description**: Chỉnh lại và chuẩn hóa file ALGORITHMS.md với metadata header comment. Thêm phần Mục đích, Input, Output, Ràng buộc cho mỗi BM. Format lại heading và structure để dễ đọc. Thêm phần RÀNG BUỘC KINH DOANH (QĐ 4, 5, 6) và HẰNG SỐ HỆ THỐNG. Bao gồm 9 biểu mẫu: BM7, BM8, BM9, BM10a, BM10b, BM11, BM12, BM13, BM15a với form UI và thuật toán chi tiết.

---

## Logs

## [2026-01-03 10:00:00] - Initial Setup - Documentation Files
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: System
- **Files Modified/Created**:
  - `.github/instruction/INSTRUCTION.md`
  - `.github/instruction/API_RESPONSE_FORMAT.md`
  - `.github/instruction/DATABASE_SCHEMA.md`
  - `.github/instruction/ALGORITHMS.md`
  - `.github/logs/generation-log.md`
- **Description**: Tạo các file documentation và instruction ban đầu cho dự án, bao gồm coding conventions, API response format, database schema guidelines, và algorithms documentation.

---

<!-- New logs will be added below this line -->

## [2026-01-11 20:28:23] - Add Pagination and Specification Support to All Controllers
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResultPaginationDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/repository/AdditionalServiceRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/repository/MemberRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/repository/PersonalTrainerRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/repository/ServicePackageRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/AdditionalServiceService.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/MemberService.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/PersonalTrainerService.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/ServicePackageService.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/AdditionalServiceController.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/MemberController.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/PersonalTrainerController.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/ServicePackageController.java`
- **Description**: Thêm hỗ trợ pagination và specification filtering cho tất cả controllers. Tạo ResultPaginationDTO với Meta class (page, pageSize, totalPages, totalItems). Cập nhật tất cả Repository để extends JpaSpecificationExecutor. Thêm method handleFetch{Entity} vào tất cả Service với Specification và Pageable parameters. Thêm endpoint GET /fetch vào tất cả Controller (AdditionalServiceController, MemberController, PersonalTrainerController, ServicePackageController) với @Filter annotation và Pageable support. Logging đầy đủ cho các fetch endpoints.

---

## [2026-01-11 20:16:00] - Update AdditionalServiceController Documentation
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `.github/instruction/controller-example/AdditionalServiceController.md`
- **Description**: Cập nhật documentation cho AdditionalServiceController với tất cả 6 endpoints hiện có: POST (Create), GET (Get All), GET by ID, GET /active, PUT /activate, DELETE (Deactivate). Thêm thông tin chi tiết về isActive field, soft delete mechanism, business rules cho active/inactive status. Cập nhật logging examples, error responses, và notes về việc không có UPDATE endpoint. Version 1.1.

---

## [2026-01-11 19:57:06] - Implement GET ALL, GET by ID, GET active, PUT activate APIs for AdditionalService
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/AdditionalService.java`
  - `src/main/java/com/se100/GymAndPTManagement/repository/AdditionalServiceRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/AdditionalServiceService.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/AdditionalServiceController.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResAdditionalServiceDTO.java`
- **Description**: Thêm field isActive vào AdditionalService entity với default value true trong @PrePersist. Thêm custom query findByIsActive vào Repository. Implement 4 methods trong Service: getAllAdditionalServices, getAdditionalServiceById (với exception handling), getAllActiveAdditionalServices, activateAdditionalService. Implement 4 GET/PUT endpoints trong Controller với logging đầy đủ và @ApiMessage. Cập nhật ResAdditionalServiceDTO để include isActive field.

---

## [2026-01-11 19:51:58] - Implement POST API for AdditionalService
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCreateAdditionalServiceDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResAdditionalServiceDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/AdditionalServiceService.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/AdditionalServiceController.java`
- **Description**: Implement POST API để tạo additional service mới. Tạo ReqCreateAdditionalServiceDTO với validation (name required, costPrice và suggestSellPrice >= 0), ResAdditionalServiceDTO với static method fromEntity. Implement createAdditionalService trong Service với builder pattern. Implement POST endpoint trong Controller với @Valid, @ApiMessage, logging INFO khi tạo thành công, và return HTTP 201 Created.

---

## [2026-01-11 19:48:37] - Create AdditionalService Controller, Service, Repository & Documentation
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/repository/AdditionalServiceRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/AdditionalServiceService.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/AdditionalServiceController.java`
  - `.github/instruction/controller-example/AdditionalServiceController.md`
- **Description**: Tạo structure cho Controller-Service-Repository của AdditionalService với Dependency Injection. Controller có khai báo SLF4J Logger theo quy tắc mới. Tạo file documentation đầy đủ cho Controller bao gồm 6 endpoints: Create, Get All, Get by ID, Update, Delete, Search by Name với request/response examples, business rules, exceptions, và logging format.

---

## [2026-01-11 19:47:34] - Update INSTRUCTION.md - Add Controller Logging Requirements
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `.github/instruction/INSTRUCTION.md`
- **Description**: Bổ sung yêu cầu BẮT BUỘC về logging trong Controller vào INSTRUCTION.md. Thêm section "Logging trong Controller" với quy tắc sử dụng SLF4J Logger, format log message chuẩn (prefix >>CONTROLLER_NAME), và các ví dụ cho INFO log (request/response) và ERROR log (exception). Tham khảo implementation từ ServicePackageController.java.

---

## [2026-01-11 19:45:20] - Create and Fix AdditionalService Entity
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/AdditionalService.java`
- **Description**: Tạo entity AdditionalService theo đúng schema trong DATABASE_SCHEMA.md với các fields: additional_service_id (PK), name, costPrice, suggestSellPrice và audit fields (created_at, updated_at, created_by, updated_by). Thêm metadata header comment theo chuẩn INSTRUCTION.md.

---

## [2026-01-08 11:20:37] - Create PersonalTrainer Repository, Service, Controller & DTOs
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/repository/PersonalTrainerRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/PersonalTrainerService.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/PersonalTrainerController.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCreatePTDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqUpdatePTDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResPTDTO.java`
- **Description**: Tạo đầy đủ Repository-Service-Controller cho PersonalTrainer. PersonalTrainerRepository extends JpaRepository với findByUserId(). PersonalTrainerService implement business logic: createPT() (@Transactional tạo User+PT đồng thời, password default "12345678", validate email unique), getAllPTs(), getAllActivePTs(), getPTById(), getPTByEmail(), updatePT() (update cả User và PT fields), deletePT() (soft delete - chuyển User.status và PT.status = INACTIVE). Tạo ReqCreatePTDTO với validation đầy đủ (fullname, email, dob required; password optional min 8 chars; experienceYears >= 0). ReqUpdatePTDTO với tất cả fields optional. ResPTDTO bao gồm nested ResUserDTO. PersonalTrainerController REST endpoints: POST /api/v1/pts, GET /api/v1/pts, GET /api/v1/pts/active, GET /api/v1/pts/search (by ptId or email), PUT /api/v1/pts/{id}, DELETE /api/v1/pts/{id}.

---

## [2026-01-08 04:00:20] - Create PersonalTrainer Entity
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/PersonalTrainer.java`
  - `src/main/java/com/se100/GymAndPTManagement/util/enums/PTStatusEnum.java`
- **Description**: Tạo PersonalTrainer entity theo schema trong DATABASE_SCHEMA.md. Entity có relationship 1:1 với User (FetchType.LAZY), các trường: about (TEXT), specialization, certifications (TEXT), experience_years, rating (DECIMAL 3,2), status (enum: AVAILABLE, BUSY, INACTIVE), note (TEXT). Tạo PTStatusEnum với 3 giá trị. Thêm database indexes trên user_id, status, và rating. Default values trong @PrePersist: rating = 0, status = AVAILABLE, experienceYears = 0. Đầy đủ audit fields với @PrePersist và @PreUpdate hooks.

---

## [2026-01-08 03:33:51] - Optimize Database Performance - Add FetchType.LAZY & Indexes
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/User.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/Member.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/Role.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/Permission.java`
- **Description**: Tối ưu hóa database performance bằng cách thêm FetchType.LAZY cho tất cả relationships (tránh N+1 query problem, chỉ load data khi cần thiết). Thêm database indexes cho các trường thường query: User entity có indexes trên email, phone_number, status; Member entity có indexes trên cccd và user_id. Xác nhận bidirectional relationship giữa Role và User đã đầy đủ với @OneToMany(mappedBy = "role") trong Role và @ManyToOne trong User. Không thêm cascade operations theo yêu cầu.

---

## [2026-01-07 19:58:29] - Create Member Entity
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/Member.java`
- **Description**: Tạo entity Member theo schema đã định nghĩa trong DATABASE_SCHEMA.md. Entity bao gồm relationship 1:1 với User, các trường cccd (CMND/CCCD), money_spent, money_debt, join_date, và đầy đủ audit fields (created_at, updated_at, created_by, updated_by) với @PrePersist và @PreUpdate hooks.

---

## [2026-01-07 20:03:11] - Create Member Repository, Service, and Controller
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/repository/MemberRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/MemberService.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/MemberController.java`
  - `.github/instruction/controller-example/MemberController.md`
- **Description**: Tạo Repository, Service, và Controller cho Member entity. MemberRepository extends JpaRepository với structure cơ bản. MemberService là Service class với dependency injection của MemberRepository. MemberController là REST controller với base URL /api/v1/members và dependency injection của MemberService. Đã tạo file documentation MemberController.md với chi tiết về 5 endpoints (Create, Get by ID, Get All, Update, Delete), request/response examples, validation rules, và business logic notes.

---

## [2026-01-07 20:14:50] - Update User Schema and Entity
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `.github/instruction/DATABASE_SCHEMA.md`
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/User.java`
- **Description**: Cập nhật User schema trong DATABASE_SCHEMA.md và User.java entity để khớp với Schema.md (ERD). Thêm các trường mới: username, fullname, phone_number, status, avatar_url, dob, gender. Đổi tên trường: id -> user_id, password -> password_hash. Cập nhật đầy đủ @Column annotations với length, nullable, unique constraints. User entity giờ có đầy đủ thông tin profile người dùng theo ERD diagram.

---

## [2026-01-07 22:15:56] - Standardize Primary Keys to 'id'
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `.github/instruction/DATABASE_SCHEMA.md`
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/User.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/Member.java`
- **Description**: Chuẩn hóa tên trường primary key từ các tên cụ thể (userId, memberId, ptId, packageId, contractId, slotId, availableSlotId, bookingId, checkinId, metricId, invoiceId, detailId, dietId, foodId, deviceId, workoutId, imageId, additionalServiceId) về tên chung là 'id' cho tất cả entities. Database column names giữ nguyên (user_id, member_id, ...) nhưng Java field names đều là 'id'. Cập nhật DATABASE_SCHEMA.md cho tất cả 22 entities và các entity files đã tồn tại (User.java, Member.java).

---

## [2026-01-08 02:35:19] - Update Member Creation Flow and Remove Username
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/User.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/Member.java`
  - `.github/instruction/DATABASE_SCHEMA.md`
  - `.github/instruction/controller-example/MemberController.md`
  - `src/main/java/com/se100/GymAndPTManagement/util/enums/GenderEnum.java`
  - `src/main/java/com/se100/GymAndPTManagement/util/enums/UserStatusEnum.java`
- **Description**: Thay đổi logic tạo Member: giờ tạo Member = tạo User đồng thời trong 1 transaction. Xóa trường username khỏi User entity. Thêm enum GenderEnum (MALE, FEMALE) và UserStatusEnum (ACTIVE, INACTIVE). Cập nhật User.java sử dụng @Enumerated cho gender và status. Member.java có default values trong @PrePersist: moneySpent = 0, moneyDebt = 0, joinDate = ngày tạo. Cập nhật MemberController.md với request body mới bao gồm: fullname, email, password, phoneNumber, avatarUrl, dob, gender, status, cccd (optional).

---

## [2026-01-08 02:44:02] - Implement POST Member Endpoint
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/repository/UserRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/repository/MemberRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCreateMemberDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResMemberDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResUserDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/MemberService.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/MemberController.java`
- **Description**: Implement POST /api/v1/members endpoint để tạo Member mới. Tạo UserRepository với methods findByEmail() và existsByEmail(). Tạo ReqCreateMemberDTO với validation đầy đủ (fullname, email, password required; CCCD 12 ký tự, password min 8 chars). Tạo ResMemberDTO và ResUserDTO cho response. MemberService.createMember() thực hiện @Transactional: validate email và CCCD unique, hash password bằng BCrypt, tạo User entity, tạo Member entity linked với User, auto-set default values. MemberController POST endpoint với @Valid validation, @ApiMessage annotation, trả về 201 Created status với formatted response. MemberRepository thêm existsByCccd() method.

---

## [2026-01-03 11:46:25] - Add Timestamp Script & Update INSTRUCTION
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `.github/scripts/get_timestamp.py`
  - `.github/instruction/INSTRUCTION.md`
  - `.github/logs/generation-log.md`
- **Description**: Tạo Python script để lấy timestamp chính xác khi generate code. AI agent sẽ chạy script này trước khi ghi log để có timestamp thực tế thay vì ước lượng. Cập nhật INSTRUCTION.md để document quy trình mới.

## [2026-01-03 18:15:00] - Add Controller Documentation Requirement & Create AuthController Example
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `.github/instruction/INSTRUCTION.md`
  - `.github/instruction/controller-example/AuthController.md`
  - `.github/logs/generation-log.md`
- **Description**: Thêm yêu cầu bắt buộc: mỗi Controller phải có file .md documentation trong folder `.github/instruction/controller-example/`. Tạo file mẫu AuthController.md với đầy đủ endpoints (login, register, refresh, logout), request/response examples, DTOs, và exceptions.

## [2026-01-03 18:00:00] - Update INSTRUCTION - User Identification & Model Name Format
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `.github/instruction/INSTRUCTION.md`
  - `.github/logs/generation-log.md`
- **Description**: Cập nhật INSTRUCTION.md để yêu cầu người dùng phải thông báo tên một lần khi bắt đầu session, AI sẽ nhớ và dùng lại. Thêm format chi tiết cho model name (bao gồm engine như Claude Sonnet 4.5, GPT-4o). Cập nhật lại log entries để bao gồm engine name.

## [2026-01-03 17:30:00] - Update User Entity - Change updatedBy Default Value
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/User.java`
- **Description**: Thay đổi giá trị mặc định của trường `updatedBy` trong method `@PreUpdate` của entity User từ "system" thành "Unverify user" khi không có user trong SecurityContext.

---

## [2026-01-03 14:11:05] - Restructure ALGORITHMS.md - Create Index & Algorithm Files
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `.github/instruction/ALGORITHMS.md`
  - `.github/instruction/algo/password-hashing.md`
  - `.github/instruction/algo/jwt-token-generation.md`
  - `.github/instruction/algo/permission-check.md`
  - `.github/instruction/algo/TEMPLATE.md`
- **Description**: Restructure ALGORITHMS.md thành file index/navigation. Tạo folder `.github/instruction/algo/` và tách 3 thuật toán hiện có thành file riêng. Tạo TEMPLATE.md cho việc thêm thuật toán mới. Cập nhật quy trình: khi người dùng upload file thuật toán, AI sẽ tạo file mới theo template, cập nhật index, giữ nguyên file gốc, và có thể nêu quan ngại về thuật toán.

---

## [2026-01-03 14:26:08] - Extract Remaining Algorithms - Complete Restructure
- **Model**: GitHub Copilot (Claude Sonnet 4.5)
- **User**: PhDuy2005
- **Files Modified/Created**:
  - `.github/instruction/ALGORITHMS.md` (updated index, removed redundant content)
  - `.github/instruction/algo/password-strength-validation.md`
  - `.github/instruction/algo/audit-trail.md`
  - `.github/instruction/algo/pagination.md`
  - `.github/instruction/algo/search-filter.md`
  - `.github/logs/generation-log.md`
- **Description**: Extract 4 thuật toán còn lại từ ALGORITHMS.md vào các file riêng trong folder algo/: Password Strength Validation (Data Validation category), Audit Trail (Utilities category), Pagination (Pagination category), và Search & Filter (Search & Filter category). Cập nhật ALGORITHMS.md index với links đến các file mới. Xóa phần content dư thừa (line 164-356) khỏi ALGORITHMS.md. Hoàn tất quá trình restructure - giờ ALGORITHMS.md chỉ là file index/navigation thuần túy.

---

## [2026-01-08 14:30:00] - Tao Entity Contract
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/Contract.java`
- **Description**: Tao entity Contract theo schema trong DATABASE_SCHEMA.md. Entity co 2 relationships: n:1 voi Member (bat buoc), n:1 voi PersonalTrainer (main_pt_id, nullable). Cac truong: startDate, endDate, status, notes (TEXT), signedAt. Day du audit fields (created_at, updated_at, created_by, updated_by) voi @PrePersist va @PreUpdate hooks su dung SecurityUtil.

---

## [2026-01-08 14:50:00] - Tao Contract Repository, Service, Controller va DTOs
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/repository/ContractRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCreateContractDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResContractDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/ContractService.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/ContractController.java`
- **Description**: Tao day du Repository-Service-Controller cho Contract voi tinh nang transaction. ContractRepository co custom methods: findByMemberId(), findByMainPtId(), findByStatus(). ReqCreateContractDTO voi validation @NotNull, @NotBlank cho cac fields bat buoc. ResContractDTO chua day du thong tin contract + member name + package name/price + PT name. ContractService su dung @Transactional de dam bao ACID khi tao contract + invoice tu dong: validation kiem tra member/package/PT ton tai, startDate < endDate; tao Invoice voi totalAmount = package price, finalAmount = totalAmount, payment_status = PAID, status = COMPLETED. ContractController co 5 endpoints: POST /api/v1/contracts (tao), GET /api/v1/contracts/{id}, GET /api/v1/contracts/member/{memberId}, GET /api/v1/contracts/pt/{ptId}, GET /api/v1/contracts/status/{status}. Tat ca endpoints co @ApiMessage annotation.

---

## [2026-01-08 15:15:00] - Tạo Hệ Thống Quản Lý Trạng Thái Contract
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/util/enums/ContractStatusEnum.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/ContractStatusService.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/Contract.java` (modified)
  - `src/main/java/com/se100/GymAndPTManagement/repository/ContractRepository.java` (modified)
  - `src/main/java/com/se100/GymAndPTManagement/service/ContractService.java` (modified)
- **Description**: Tạo ContractStatusEnum với 3 trạng thái (ACTIVE, EXPIRED, CANCELLED). Contract entity sử dụng @Enumerated(EnumType.STRING) cho status. ContractStatusService cung cấp: autoExpireContracts() tự động hết hạn các contract quá end_date, getRemainingDays() tính số ngày còn lại, changeContractStatus() đổi status với validation rules (ACTIVE->EXPIRED/CANCELLED, EXPIRED->CANCELLED, CANCELLED terminal).

---

## [2026-01-11 10:30:00] - Tạo Entity Booking
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/Booking.java`
- **Description**: Tạo entity Booking với 4 mối quan hệ ManyToOne: contract (bắt buộc), member (bắt buộc), realPt (nullable), slot (bắt buộc). Trường chính: booking_date (LocalDate, bắt buộc). Đầy đủ audit fields (createdAt, updatedAt, createdBy, updatedBy) với @PrePersist và @PreUpdate hooks sử dụng SecurityUtil. Sử dụng Lombok @Data, @Builder, @NoArgsConstructor, @AllArgsConstructor.

---

## [2026-01-11 11:30:00] - Implement Booking Management System with Dynamic Filtering
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/repository/BookingRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/repository/SlotRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/repository/AvailableSlotRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/repository/ContractRepository.java` (modified)
  - `src/main/java/com/se100/GymAndPTManagement/service/BookingService.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/BookingController.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCreateBookingDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResBookingDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResAvailableSlotDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResAvailablePTDTO.java`
- **Description**: Tạo hệ thống quản lý booking hoàn chỉnh hỗ trợ 2 luồng lọc động (Dynamic Filtering):

**Luồng 1 (PT -> Slots)**: GET /api/v1/bookings/available-slots?ptId=X&date=YYYY-MM-DD
  - Truy vấn available_slots với điều kiện: pt_id = X, day_of_week = {ngày trong tuần từ date}, is_available = true
  - Loại trừ các slot đã bị đặt trong bookings với real_pt_id = X và booking_date = date
  - Trả về danh sách ResAvailableSlotDTO

**Luồng 2 (Slot -> PTs)**: GET /api/v1/bookings/available-pts?slotId=X&date=YYYY-MM-DD
  - Truy vấn available_slots với điều kiện: slot_id = X, day_of_week = {ngày trong tuần từ date}, is_available = true
  - Loại trừ các PT đã bị đặt trong bookings với slot_id = X và booking_date = date
  - Trả về danh sách ResAvailablePTDTO

**Tạo Booking**: POST /api/v1/bookings với payload ReqCreateBookingDTO (memberId, ptId, slotId, bookingDate)
  - Kiểm tra member tồn tại
  - Kiểm tra member có hợp đồng ACTIVE che phủ booking_date: startDate <= bookingDate <= endDate
  - Kiểm tra PT tồn tại
  - Kiểm tra slot tồn tại
  - Kiểm tra trùng lịch (duplicate): không tồn tại record với realPt.id = ptId, slot.id = slotId, bookingDate = date
  - Lưu booking với contract_id từ hợp đồng ACTIVE tìm được
  - Trả về ResBookingDTO

**Repository Queries**:
- BookingRepository.getAvailableSlotsForPT(): Custom @Query JPQL trả về List<Slot>
- BookingRepository.getAvailablePTsForSlot(): Custom @Query JPQL trả về List<PersonalTrainer>
- BookingRepository.findByRealPtIdAndSlotIdAndBookingDate(): Tìm booking trùng lặp
- ContractRepository.findByMemberIdAndStatusAndDateRange(): Custom @Query tìm active contract với date range

**Service Methods**:
- getAvailableSlotsForPT(ptId, date): Xác định DayOfWeek, gọi repository query, map to DTOs
- getAvailablePTsForSlot(slotId, date): Xác định DayOfWeek, gọi repository query, map to DTOs
- createBooking(@Valid ReqCreateBookingDTO): @Transactional, validation + duplicate check + save
- getBookingsByMember(memberId), getBookingsByPT(ptId), getBookingById(id), deleteBooking(id)

**Controller Endpoints** (tất cả return ResponseEntity<RestResponse<T>>):
- GET /api/v1/bookings/available-slots - Flow 1
- GET /api/v1/bookings/available-pts - Flow 2
- POST /api/v1/bookings - Tạo booking mới
- GET /api/v1/bookings/{bookingId} - Chi tiết booking
- GET /api/v1/bookings/member/{memberId} - Danh sách booking của member
- GET /api/v1/bookings/pt/{ptId} - Danh sách booking của PT
- DELETE /api/v1/bookings/{bookingId} - Xóa booking

Tất cả endpoints có @ApiMessage annotation cho Swagger documentation.

---

## [2026-01-12 09:30:00] - Implement Check-in Log Management System
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/repository/CheckinLogRepository.java`
  - `src/main/java/com/se100/GymAndPTManagement/service/CheckinLogService.java`
  - `src/main/java/com/se100/GymAndPTManagement/controller/CheckinLogController.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCheckinDTO.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResCheckinLogDTO.java`
- **Description**: Tạo hệ thống quản lý check-in log hoàn chỉnh với 3 thao tác chính:

**CheckinLogRepository** - Custom JPQL Queries:
- `findActiveCheckInByBookingId()`: Tìm active checkin (status = CHECKED_IN) mới nhất
- `findLatestByBookingId()`: Tìm checkin mới nhất bất kể status
- `hasActiveCheckin()`: Kiểm tra booking có active checkin không (status != CANCELLED)
- `findByMemberId()`, `findByBookingId()`, `findByBookingIdAndStatus()`: Queries hỗ trợ

**CheckinLogService** - 3 Business Operations:

1. **checkIn(ReqCheckinDTO)** (@Transactional):
   - Validate booking tồn tại
   - Kiểm tra booking chưa có active checkin
   - Tạo CheckinLog: booking, member (từ booking), checkinTime = LocalTime.now(), status = "CHECKED_IN", checkoutTime = null
   - Map sang ResCheckinLogDTO

2. **checkOut(bookingId)** (@Transactional):
   - Tìm active checkin log (CHECKED_IN status)
   - Update: checkoutTime = LocalTime.now(), status = "CHECKED_OUT"
   - Lưu lại
   - Map sang ResCheckinLogDTO

3. **cancelCheckin(bookingId)** (@Transactional):
   - Tìm latest checkin log (bất kể status)
   - Update: status = "CANCELLED"
   - Lưu lại
   - Map sang ResCheckinLogDTO

Plus 3 query methods: getCheckinsByMember(), getCheckinsByBooking(), getCheckinById()

**CheckinLogController** - 6 REST Endpoints:
- `POST /api/v1/checkins` - Check-in khi member đến
- `PUT /api/v1/checkins/checkout/{bookingId}` - Check-out khi member kết thúc
- `PUT /api/v1/checkins/cancel/{bookingId}` - Hủy check-in khi nhầm
- `GET /api/v1/checkins/{checkinId}` - Chi tiết checkin log
- `GET /api/v1/checkins/member/{memberId}` - Danh sách logs của member
- `GET /api/v1/checkins/booking/{bookingId}` - Danh sách logs của booking

Tất cả endpoints return `ResponseEntity<RestResponse<T>>`, có @ApiMessage annotation, error handling IllegalArgumentException.

**DTOs**:
- `ReqCheckinDTO`: bookingId (@NotNull)
- `ResCheckinLogDTO`: checkinId, bookingId, memberId, memberName, checkinTime, checkoutTime, status, createdBy

---

## [2026-01-14 21:10:00] - Create Invoice and InvoiceDetail Entity Models
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/Invoice.java`
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/InvoiceDetail.java`
- **Description**: Tạo 2 entity cho hệ thống quản lý hóa đơn và thanh toán:

**Invoice Entity**:
- Lưu thông tin hóa đơn chính cho member
- Fields chính:
  - `member_id`: BIGINT (n:1 relationship với Member)
  - `total_amount`: DECIMAL(15,2) - Tổng tiền trước chiết khấu
  - `discount_amount`: DECIMAL(15,2) - Tiền chiết khấu
  - `final_amount`: DECIMAL(15,2) - Tiền cuối cùng phải trả
  - `payment_method`: VARCHAR(50) - Phương thức thanh toán (CASH, BANK_TRANSFER, CARD, etc.)
  - `payment_status`: VARCHAR(50) - Trạng thái thanh toán (PENDING, PAID, PARTIAL, OVERDUE)
  - `status`: VARCHAR(50) - Trạng thái hóa đơn (DRAFT, ISSUED, CANCELLED)
- Đầy đủ audit fields: createdAt, updatedAt, createdBy, updatedBy
- Lifecycle management: @PrePersist, @PreUpdate với SecurityUtil

**InvoiceDetail Entity**:
- Chi tiết dòng hóa đơn (line items)
- Fields chính:
  - `invoice_id`: BIGINT (n:1 relationship với Invoice)
  - `service_id`: BIGINT - Foreign key tới ServicePackage (nullable)
  - `additional_service_id`: BIGINT - Foreign key tới AdditionalService (nullable)
  - `quantity`: INT - Số lượng dịch vụ
  - `unit_price`: DECIMAL(15,2) - Giá đơn vị
  - `total_amount`: DECIMAL(15,2) - Thành tiền = quantity * unit_price
- Hỗ trợ tính toán chi tiết các khoản phí từ service packages hoặc additional services
- Đầy đủ audit fields: createdAt, updatedAt, createdBy, updatedBy
- Lifecycle management: @PrePersist, @PreUpdate với SecurityUtil

**Design Patterns**:
- ManyToOne relationship: Invoice → Member, InvoiceDetail → Invoice
- Optional ManyToOne: InvoiceDetail có thể liên kết với ServicePackage HOẶC AdditionalService
- BigDecimal sử dụng cho tất cả monetary values (precision=15, scale=2)
- Lombok @Builder, @Data, @NoArgsConstructor, @AllArgsConstructor
- Jakarta Persistence annotations (@Entity, @Table, @Column, @JoinColumn)

---

## [2026-01-15 01:30:00] - Update Contract Service with Auto-calculated End Date
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/service/ContractService.java` (Modified)
  - `src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCreateContractDTO.java` (Modified)
  - `src/main/java/com/se100/GymAndPTManagement/controller/ContractController.java` (Modified)
- **Description**: Cập nhật hệ thống quản lý contract để tự động tính toán `end_date` dựa trên `duration_in_days` từ ServicePackage:

**ContractService.createContractWithInvoice() - Logic Changes**:
- **Auto-calculate End Date**: `endDate = startDate + duration_in_days` (từ ServicePackage)
  - Sử dụng `LocalDate.plusDays(duration)` để tính toán chính xác
- **Validation `duration_in_days`**: Kiểm tra ServicePackage có valid duration (> 0)
  - Nếu null hoặc <= 0, throw `IllegalArgumentException` với thông báo rõ ràng
- **Validation `startDate`**: Phải là ngày hiện tại hoặc tương lai
  - Ngày quá khứ không được phép
- **Validation `endDate` (nếu client gửi)**: 
  - Nếu client cung cấp endDate, kiểm tra nó PHẢI bằng calculated value
  - Nếu không trùng, throw `IllegalArgumentException` với chi tiết (expected vs provided)
  - Thông báo rõ công thức: "endDate = startDate + X days"
- **Exception Type**: Đổi từ `RuntimeException` → `IllegalArgumentException` (phù hợp hơn cho validation)

**ReqCreateContractDTO - DTO Changes**:
- **endDate field**: Từ `@NotNull` → Optional (nullable)
- **startDate validation**: Thêm `@FutureOrPresent` annotation
- **Javadoc**: Giải thích rõ endDate sẽ được tự động tính từ duration_in_days
- **Flexibility**: Client có thể:
  - Chỉ gửi startDate → hệ thống tự động tính endDate
  - Hoặc gửi cả 2 để verify, endDate PHẢI match calculated value

**ContractController - Error Handling Improvements**:
- **Phân biệt exception types**:
  - `IllegalArgumentException` (business validation) → HTTP 400
  - Generic `Exception` (server errors) → HTTP 500
- **Better context**: Thêm descriptive error messages
- **Backward compatible**: API endpoint vẫn tương tự, chỉ error handling tốt hơn

**Design Philosophy**:
- **DRY Principle**: Tránh duplication - duration được define tại ServicePackage, không lặp lại ở Contract
- **Single Source of Truth**: duration_in_days chỉ quản lý tại ServicePackage
- **Fail-fast Validation**: Kiểm tra duration trước khi tính toán
- **Clear API Contract**: Javadoc giải thích rõ behavior cho developers

**Unmodified Files** (vẫn hoạt động bình thường):
- `Contract.java` - Entity vẫn có fields startDate & endDate
- `ContractRepository.java` - Queries không cần thay đổi
- `ResContractDTO.java` - Vẫn trả về cả startDate & endDate
- `ContractStatusEnum.java` - Enum values không đổi

---

## [2026-01-15 14:45:00] - Implement Invoice and InvoiceDetail Auto-Creation on Contract Creation
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCreateContractDTO.java` (Modified)
  - `src/main/java/com/se100/GymAndPTManagement/domain/table/Invoice.java` (Modified)
  - `src/main/java/com/se100/GymAndPTManagement/repository/InvoiceRepository.java` (Created)
  - `src/main/java/com/se100/GymAndPTManagement/repository/InvoiceDetailRepository.java` (Created)
  - `src/main/java/com/se100/GymAndPTManagement/service/ContractService.java` (Modified)
- **Description**: Implement tính năng auto-tạo Invoice và InvoiceDetail khi tạo contract thành công với xử lý chiết khấu và trạng thái thanh toán:

**ReqCreateContractDTO - DTO Changes**:
- Thêm field `private BigDecimal discountAmount` - Tiền chiết khấu được nhập từ form (default 0 nếu null)
- Được sử dụng để tính `final_amount = total_amount - discount_amount`

**InvoiceRepository - Created**:
- `extends JpaRepository<Invoice, Long>`
- Query method: `findByMemberId(Long memberId)` - Tìm hóa đơn của member

**InvoiceDetailRepository - Created**:
- `extends JpaRepository<InvoiceDetail, Long>`
- Query method: `findByInvoiceId(Long invoiceId)` - Tìm chi tiết hóa đơn theo invoice

**Invoice.java - Entity Changes**:
- Import: `PaymentStatusEnum`
- Field `paymentStatus`: Đổi từ `String` → `@Enumerated(EnumType.STRING) PaymentStatusEnum paymentStatus`
- Sử dụng enum type-safe thay vì String

**ContractService.java - Auto-Creation Logic**:

**Quy trình tạo Invoice & InvoiceDetail** (khi contract tạo thành công):

1. **Lấy discount từ request**: `discountAmount = request.getDiscountAmount() ?? BigDecimal.ZERO`
   - Nếu client không cung cấp, default = 0

2. **Lấy total amount**: `totalAmount = servicePackage.getPrice()`
   - Lấy giá từ service package được chọn

3. **Validate discount**: `discountAmount <= totalAmount`
   - Nếu vượt quá total, throw `IllegalArgumentException`

4. **Tính final amount**: `finalAmount = totalAmount - discountAmount`
   - Chiết khấu được trừ trực tiếp từ tổng tiền

5. **Tạo Invoice Entity**:
   - `member`: Member được chọn
   - `totalAmount`: Giá service package (trước chiết khấu)
   - `discountAmount`: Chiết khấu từ form
   - `finalAmount`: Tiền cuối cùng = totalAmount - discountAmount
   - `paymentMethod`: Phương thức từ form
   - `paymentStatus`: **PaymentStatusEnum.UNPAID** (default)
   - `status`: **"ISSUED"** (hóa đơn được phát hành)

6. **Lưu Invoice**:
   - `invoiceRepository.save(invoice)` → Lưu và get back savedInvoice

7. **Tạo InvoiceDetail**:
   - `invoice`: Link tới Invoice vừa tạo
   - `servicePackage`: Service package từ contract (KHÔNG null)
   - `additionalService`: **null** (tạm thời bỏ qua additional services)
   - `quantity`: **1** (luôn là 1 cho service package)
   - `unitPrice`: `servicePackage.getPrice()`
   - `totalAmount`: `servicePackage.getPrice()` (quantity × unitPrice = 1 × price)

8. **Lưu InvoiceDetail**:
   - `invoiceDetailRepository.save(invoiceDetail)`

9. **Return response**: Trả về mapToResDTO(savedContract)

**Transaction Safety**:
- Tất cả operations (Contract, Invoice, InvoiceDetail) nằm trong `@Transactional` boundary
- Nếu bất kỳ bước nào fail, tất cả sẽ rollback

**Data Flow**:
- Contract + Invoice + InvoiceDetail được create cùng lúc
- Invoice luôn được tạo khi contract create (không optional)
- Mỗi contract = 1 Invoice = 1+ InvoiceDetail (hiện tại luôn 1)

**Additional Services**:
- Deferred: Additional services không được integrate vào Invoice workflow lúc này
- Để cho sau: Có thể thêm additional services vào InvoiceDetail sau

**Design Patterns**:
- **Fail-fast validation**: Check discount trước khi tính toán
- **Type-safe enums**: PaymentStatusEnum thay vì String "UNPAID"
- **Immutable default values**: PaymentStatusEnum.UNPAID, status "ISSUED" là constants
- **Builder pattern**: Sử dụng Lombok @Builder để tạo entities
- **Defensive null-check**: `discountAmount != null ? discountAmount : BigDecimal.ZERO`

---

## [2026-01-16 01:30:00] - Implement Additional Service Invoice Creation Flow
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/domain/requestDTO/ReqCreateAdditionalServiceInvoiceDTO.java` (Created)
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResInvoiceDTO.java` (Created)
  - `src/main/java/com/se100/GymAndPTManagement/domain/responseDTO/ResInvoiceDetailDTO.java` (Created)
  - `src/main/java/com/se100/GymAndPTManagement/service/InvoiceService.java` (Created)
  - `src/main/java/com/se100/GymAndPTManagement/controller/InvoiceController.java` (Created)
- **Description**: Implement complete flow để tạo invoice cho đơn đặt dịch vụ bổ sung (additional services). Flow: Additional Service list → Click "Order" → Invoice form (member dropdown, quantity input, auto-calculate amounts, discount input, payment method selection) → Submit → Create Invoice + InvoiceDetail.

**ReqCreateAdditionalServiceInvoiceDTO**:
- Fields: additionalServiceId, memberId, quantity, discountAmount (optional), paymentMethod, notes
- Validation: additionalServiceId, memberId, quantity (@Min 1), paymentMethod (@NotBlank)
- Tương tự ReqCreateContractDTO pattern

**ResInvoiceDetailDTO**:
- Fields: detailId, invoiceId, servicePackageId, servicePackageName, additionalServiceId, additionalServiceName, quantity, unitPrice, totalAmount, createdAt
- Static method `fromEntity()` để convert từ InvoiceDetail JPA entity
- Support cả service package (từ contract invoices) và additional service (từ order invoices)

**ResInvoiceDTO**:
- Fields: invoiceId, memberId, memberName, totalAmount, discountAmount, finalAmount, paymentMethod, paymentStatus (PaymentStatusEnum), status, details (List<ResInvoiceDetailDTO>), createdAt, updatedAt, createdBy
- Static method `fromEntity()` để convert từ Invoice entity với details list
- Include memberName từ Member.user.fullName

**InvoiceService - createInvoiceForAdditionalService() - 14 Steps**:

1. **Log request** - Log info với service ID, member ID, quantity
2. **Fetch member** - `memberRepository.findById(memberId)` hoặc throw IllegalArgumentException "Member not found"
3. **Fetch additional service** - `additionalServiceRepository.findById(serviceId)` hoặc throw
4. **Validate active** - Check `additionalService.getIsActive()` == true, nếu không throw "Service not active"
5. **Validate quantity** - Check quantity > 0, nếu không throw "Quantity must be > 0"
6. **Get unit price** - Lấy `additionalService.getSuggestSellPrice()`, validate != null && >= 0
7. **Calculate totalAmount** - `unitPrice × quantity`
8. **Log calculation** - Debug log: Quantity, Unit Price, Total Amount
9. **Get discount** - `request.getDiscountAmount() ?? BigDecimal.ZERO`
10. **Validate discount** - Check `discount <= totalAmount`, nếu không throw "Discount exceeds total"
11. **Calculate finalAmount** - `totalAmount - discountAmount`
12. **Create & save Invoice** - Builder pattern, paymentStatus = UNPAID, status = "ISSUED"
13. **Create & save InvoiceDetail** - additionalService được set, servicePackage = null, totalAmount = quantity × unitPrice
14. **Return ResInvoiceDTO** - Convert saved entities với static `fromEntity()` methods

**InvoiceService - Other Methods**:

- **getInvoiceById(invoiceId)** - Fetch invoice + details, return ResInvoiceDTO, throw "Invoice not found"
- **getInvoicesByMemberId(memberId)** - Fetch all invoices của member, return List<ResInvoiceDTO>, verify member exists
- **updatePaymentStatus(invoiceId, newStatus)** - Update invoice.paymentStatus, log old → new status, return ResInvoiceDTO

**InvoiceController**:

- **POST /api/v1/invoices/additional-service** - Create invoice
  - Input: @Valid ReqCreateAdditionalServiceInvoiceDTO
  - Output: HTTP 201 Created + ResInvoiceDTO
  - Error handling: 400 Bad Request (validation/business logic), 500 Internal Server Error
  - Logging: Request info, success with invoiceId, validation errors as warn, system errors as error

- **GET /api/v1/invoices/{id}** - Get invoice by ID
  - Output: HTTP 200 OK + ResInvoiceDTO
  - Error: 404 Not Found

- **GET /api/v1/invoices/member/{memberId}** - Get all invoices cho member
  - Output: HTTP 200 OK + List<ResInvoiceDTO>
  - Error: 404 Not Found (member không tồn tại)

- **PUT /api/v1/invoices/{id}/payment-status** - Update payment status
  - Input: @RequestParam PaymentStatusEnum paymentStatus
  - Output: HTTP 200 OK + ResInvoiceDTO
  - Error: 404 Not Found

**Response Format**:
- Success: Wrapped trong `RestResponse<T>` với `FormatRestResponse.success()` hoặc `RestResponse.builder()`
- Status codes: 201 Created (POST), 200 OK (GET, PUT), 400 Bad Request, 404 Not Found, 500 Server Error
- @ApiMessage annotation trên tất cả endpoints

**Frontend Form Flow**:
1. Additional Service list page → Hiển thị danh sách services, mỗi item có button "Order"
2. Click "Order" → Modal/Page mới với form:
   - Service name: Read-only (pre-filled từ selected service)
   - Member dropdown: Fetch từ GET /api/v1/members hoặc GET /api/v1/members/active
   - Quantity input: @Min(1), required
   - Total Amount: Read-only, auto-calculated display (quantity × suggestSellPrice)
   - Discount Amount: Optional input (default 0 if empty)
   - Final Amount: Read-only, auto-calculated display (totalAmount - discountAmount)
   - Payment Method: Dropdown selection (required)
   - Submit button: POST /api/v1/invoices/additional-service với ReqCreateAdditionalServiceInvoiceDTO

**Validation & Business Rules**:
- Quantity > 0: `@Min(1)` trên field
- Additional service phải active: Check `isActive == true`
- Member phải tồn tại: `memberRepository.findById()` throw if not found
- Unit price phải valid: `suggestSellPrice != null && >= 0`
- Discount <= total: `discount.compareTo(totalAmount) <= 0`
- All fields required except discountAmount (nullable with default 0)

**Transaction Safety**:
- Invoice + InvoiceDetail create cùng trong @Transactional
- Nếu fail ở bất kỳ step nào, rollback tất cả
- Khác với contract invoice (auto-create), additional service invoice là explicit user action

**Data Persistence**:
- Invoice: member_id (FK), total_amount, discount_amount, final_amount, payment_method, payment_status (UNPAID default), status ("ISSUED")
- InvoiceDetail: invoice_id (FK), additional_service_id (FK), servicePackage_id = NULL, quantity, unit_price (từ suggestSellPrice), total_amount

**Logging Strategy**:
- **INFO**: Request start, member/service not found, invoice created, payment updated
- **DEBUG**: Calculation details, fetch operations
- **WARN**: Validation failures (discount exceeds, inactive service, invalid quantity)
- **ERROR**: Unexpected exceptions with stack trace

---

## [2026-01-16 03:15:00] - Add Get All Bookings Endpoint for Booking List Page
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Modified/Created**:
  - `src/main/java/com/se100/GymAndPTManagement/controller/BookingController.java` (Modified)
  - `src/main/java/com/se100/GymAndPTManagement/service/BookingService.java` (Modified)
- **Description**: Thêm endpoint GET /api/v1/bookings để hiển thị danh sách tất cả booking trên trang booking list.

**BookingController Changes**:
- Thêm method `getAllBookings()` ở đầu controller
- Endpoint: `GET /api/v1/bookings`
- Return: `ResponseEntity<RestResponse<List<ResBookingDTO>>>`
- Message: "Lấy danh sách lịch đặt thành công"

**BookingService Changes**:
- Thêm method `getAllBookings()` trước `getBookingsByMember()`
- Logic: `bookingRepository.findAll()` → stream map to ResBookingDTO → collect
- @Transactional(readOnly = true) - Read-only transaction vì chỉ fetch data

**Frontend Flow**:
- Trang booking list: Load tất cả bookings từ GET /api/v1/bookings
- Display danh sách bookings với fields từ ResBookingDTO: id, contractId, memberId, memberName, ptId, ptName, slotId, slotStartTime, slotEndTime, bookingDate, createdBy
- Có thể filter/sort tại client-side hoặc thêm pagination sau

**Order of Endpoints** (trong BookingController):
1. GET /api/v1/bookings - Get all bookings (NEW)
2. GET /api/v1/bookings/available-slots - Available slots flow
3. GET /api/v1/bookings/available-pts - Available PTs flow
4. POST /api/v1/bookings - Create booking
5. GET /api/v1/bookings/member/{memberId} - Get by member
6. GET /api/v1/bookings/pt/{ptId} - Get by PT
7. GET /api/v1/bookings/{bookingId} - Get by ID
8. DELETE /api/v1/bookings/{bookingId} - Delete booking

---

## [2026-01-16 10:00:00] - Implement Integration Testing Infrastructure và BookingServiceIntegrationTest
- **Model**: GitHub Copilot (Claude Haiku 4.5)
- **User**: KStuv
- **Files Created**:
  - `src/test/java/com/se100/GymAndPTManagement/integration/BookingIntegrationTestBase.java`
  - `src/test/resources/application-test.properties`
  - `src/test/java/com/se100/GymAndPTManagement/integration/testdata/TestDataBuilders.java`
  - `src/test/java/com/se100/GymAndPTManagement/integration/service/BookingServiceIntegrationTest.java`
- **Description**: 

**Phần 1: Test Infrastructure Setup**

Tạo `BookingIntegrationTestBase.java` - Base class cho tất cả booking integration tests:
- Annotation: `@SpringBootTest`, `@AutoConfigureMockMvc`, `@ActiveProfiles("test")`, `@Transactional`
- Cung cấp MockMvc, ObjectMapper, và tất cả repository/service injections
- Auto-rollback transaction sau mỗi test để cách ly test data
- Helper methods: `clearAllData()`, `countAllBookings()`, `countAllContracts()`, `countAllMembers()`
- Setup/teardown: `@BeforeEach` (clear data), `@AfterEach` (transaction cleanup)

Tạo `application-test.properties` - Cấu hình H2 in-memory database:
- Database: H2 in-memory (`:mem:testdb`)
- JPA: `ddl-auto=create-drop` (recreate schema mỗi test)
- Logging: WARN by default, INFO cho application code, DEBUG cho web requests
- Security: Test user credentials cho testing

**Phần 2: Test Data Builders**

Tạo `TestDataBuilders.java` - Fluent API builders để tạo test data:
- `UserTestBuilder`: Build User entities với default test values (email, password, fullname, etc.)
- `MemberTestBuilder`: Build Member entities (cccd, user link)
- `PersonalTrainerTestBuilder`: Build PT entities (specialization, experience, status)
- `ServicePackageTestBuilder`: Build service packages (name, sessions, duration, price)
- `ContractTestBuilder`: Build contract entities (member, PT, package, dates, status, sessions)
- `SlotTestBuilder`: Build time slots (start/end times)
- `AvailableSlotTestBuilder`: Build available slots (PT, slot, day of week)
- `BookingTestBuilder`: Build booking entities (contract, member, PT, slot, date)
- `CheckinLogTestBuilder`: Build checkin logs (booking, member, times, status)

Mỗi builder sử dụng fluent method chaining pattern và cung cấp sensible defaults.

**Phần 3: BookingServiceIntegrationTest (14 Test Cases)**

Tạo `BookingServiceIntegrationTest.java` - Comprehensive service layer integration tests:

1. **Test 1: Create Booking - Happy Path**
   - Kiểm tra tạo booking thành công với tất cả dữ liệu valid
   - Xác nhận session được giảm từ contract

2. **Test 2: Create Booking - Member Không Tồn Tại**
   - Validate IllegalArgumentException khi member không tồn tại

3. **Test 3: Create Booking - Không Có Active Contract**
   - Validate IllegalArgumentException khi member không có active contract

4. **Test 4: Create Booking - Contract Đã Hết Hạn**
   - Validate IllegalArgumentException khi contract end_date đã qua

5. **Test 5: Create Booking - Không Còn Session**
   - Validate IllegalArgumentException khi remaining_sessions = 0

6. **Test 6: Create Booking - PT Không Tồn Tại**
   - Validate IllegalArgumentException khi PT không tồn tại

7. **Test 7: Create Booking - Slot Không Tồn Tại**
   - Validate IllegalArgumentException khi slot không tồn tại

8. **Test 8: Create Booking - Booking Trùng Lặp**
   - Validate IllegalArgumentException khi same PT-slot-date đã được đặt
   - Test duplicate detection logic

9. **Test 9: Get Booking by ID**
   - Kiểm tra lấy single booking thành công với tất cả fields

10. **Test 10: Get Booking by ID - Không Tìm Thấy**
    - Validate IllegalArgumentException khi booking không tồn tại

11. **Test 11: Get All Bookings for Member**
    - Tạo 3 bookings cho same member, verify tất cả được return
    - Confirm filter by member ID works correctly

12. **Test 12: Get All Bookings for PT**
    - Tạo 2 bookings cho same PT, verify tất cả được return
    - Confirm filter by PT ID works correctly

13. **Test 13: Delete Booking - Restore Sessions**
    - Kiểm tra booking bị xóa khỏi database
    - Confirm remaining_sessions được restore (+1) trên contract

14. **Test 14: Update Booking PT**
    - Test update PT trên existing booking
    - Kiểm tra realPt field được update correctly

**Test Coverage**:
- Happy path: 1 test (create booking thành công)
- Validation scenarios: 7 tests (entity không tồn tại, contract issues, duplicate)
- Query operations: 3 tests (get by ID, get by member, get by PT)
- Mutation operations: 3 tests (delete, update, create)
- Total: 14 integration test cases

**Test Data Strategy**:
- Mỗi test tạo independent entity graph (không shared state giữa tests)
- Sử dụng builder pattern để tạo readable, maintainable test data
- Minimal data setup per test (chỉ tạo necessary entities)
- Tất cả audit fields được handle bởi entity @PrePersist hooks
- Foreign key relationships được establish properly trước khi save

**Transaction Management**:
- `@Transactional` trên test class ensure rollback sau mỗi test
- Không cần manual cleanup - automatic via transaction rollback
- Isolated test execution - không data leakage giữa tests

**Assertions**:
- Verify return DTOs có correct values
- Check database state sau operations (counts, field values)
- Sử dụng Assertions từ JUnit 5 (assertNotNull, assertEquals, assertTrue, etc.)
- Throws assertions validate exception behavior

**Các bước tiếp theo**: 
- Implement BookingControllerIntegrationTest (16 endpoint tests)
- Implement BookingTransactionIntegrationTest (6 transaction atomicity tests)
- Implement AvailabilityFlowIntegrationTest (8 dynamic filtering tests)
- Implement BookingErrorHandlingTest (6 error scenario tests)

