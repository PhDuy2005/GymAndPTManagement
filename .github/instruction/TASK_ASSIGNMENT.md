# 📋 Phân Công Công Việc - Gym & PT Management System

> **Thời gian dự kiến**: 5 ngày (Sprint nhanh)  
> **Số thành viên**: 3 người  
> **Tổng số entities cần implement**: 19 entities (đã có User, Role, Permission)  
> **Yêu cầu**: Tất cả phải hoàn thành trong 5 ngày

---

## 📊 Tổng Quan Công Việc

### ✅ Đã Hoàn Thành (15/22)
- User
- Role  
- Permission
- Member
- PersonalTrainer
- ServicePackage
- AdditionalService
- Slot
- AvailableSlot
- BodyMetrics
- Food ✅
- DailyDiet ✅
- DietDetail ✅
- WorkoutDevice ✅
- Workout ✅

### 🔨 Cần Implement (7/22)

---

## 👥 PHÂN CÔNG CHO 3 THÀNH VIÊN

### 📌 Cách Đánh Dấu Trạng Thái Task

**Markdown Checkbox Syntax**:
- `- [ ]` : Chưa làm (Not started)
- `- [~]` : Đang làm (In progress) 
- `- [x]` : Đã hoàn thành (Completed)

**Ví dụ**:
```markdown
- [x] Entity class (`domain/table/Member.java`) ✅ Đã xong
- [~] Repository (`repository/MemberRepository.java`) 🔄 Đang làm
- [ ] Service class ⏳ Chưa làm
```

**Lưu ý**: Khi commit, nhớ cập nhật trạng thái checkbox trong file này để team biết tiến độ!

---

## 🟦 **THÀNH VIÊN 1** - User & Service Management (7 entities)

### ✅ CHECKPOINT 1 - Ngày 1
#### 1. Member Entity (Ưu tiên cao)
- [X] Entity class (`domain/table/Member.java`)
- [X] Repository (`repository/MemberRepository.java`)
- [X] Service class
- [X] Request/Response DTOs
- [X] REST Controller với CRUD operations
- [X] Validation

#### 2. Personal Trainer Entity (Ưu tiên cao)
- [X] Entity class (`domain/table/PersonalTrainer.java`)
- [X] Repository (`repository/PersonalTrainerRepository.java`)
- [X] Service class
- [X] Request/Response DTOs
- [X] REST Controller với CRUD operations
- [X] Validation

### ✅ CHECKPOINT 2 - Ngày 2
#### 3. Service Package Entity
- [X] Entity class (`domain/table/ServicePackage.java`)
- [X] Repository
- [X] Service layer
- [X] DTOs
- [X] Controller
- [X] Business logic: activate/deactivate packages

#### 4. Additional Service Entity
- [X] Entity class (`domain/table/AdditionalService.java`)
- [X] Repository (`repository/AdditionalServiceRepository.java`)
- [X] Service layer (`service/AdditionalServiceService.java`)
- [X] DTOs (ReqCreateAdditionalServiceDTO, ResAdditionalServiceDTO)
- [X] Controller (`controller/AdditionalServiceController.java`)
- [X] Price management logic
- [X] Pagination & Specification support
- [X] OpenAPI documentation (@Operation, @ApiResponses)

### ✅ CHECKPOINT 3 - Ngày 3
#### 5. Slot Entity
- [X] Entity class (`domain/table/Slot.java`)
- [X] Repository (`repository/SlotRepository.java`)
- [X] Service layer (`service/SlotService.java`)
- [X] DTOs (ReqCreateSlotDTO, ReqUpdateSlotDTO, ResSlotDTO)
- [X] Controller (`controller/SlotController.java`)
- [X] Time validation logic (startTime < endTime)
- [X] Pagination & Specification support
- [X] Active/Inactive management
- [X] OpenAPI documentation (@Operation, @ApiResponses)

#### 6. Available Slot Entity
- [X] Entity class (`domain/table/AvailableSlot.java`)
- [X] Repository
- [X] Service layer
- [X] DTOs
- [X] Controller
- [X] PT schedule management

### ✅ CHECKPOINT 4 - Ngày 4
#### 7. Body Metrics Entity
- [X] Entity class (`domain/table/BodyMetrics.java`)
- [X] Repository (`repository/BodyMetricsRepository.java`)
- [X] Service layer (`service/BodyMetricsService.java`)
- [X] DTOs (ReqCreateBodyMetricsDTO, ReqUpdateBodyMetricsDTO, ResBodyMetricsDTO)
- [X] Controller (`controller/BodyMetricsController.java`)
- [X] BMI calculation logic (auto-calculated in entity)
- [X] Pagination & Specification support
- [X] OpenAPI documentation (@Operation, @ApiResponses)
- [X] Member metrics tracking (findByMemberIdOrderByMeasuredDateDesc)

### ✅ CHECKPOINT 5 - Ngày 5 (Testing & Integration)
- [ ] Test tất cả APIs
- [ ] Fix bugs
- [ ] Integration testing
- [ ] API documentation

---

## 🟩 **THÀNH VIÊN 2** - Booking & Operations (6 entities)

### ✅ CHECKPOINT 1 - Ngày 1
#### 1. Contract Entity (Ưu tiên cao)
- [ ] Entity class (`domain/table/Contract.java`)
- [ ] Repository (`repository/ContractRepository.java`)
- [ ] Service class
- [ ] Request/Response DTOs
- [ ] REST Controller
- [ ] Contract status management (ACTIVE, EXPIRED, CANCELLED)
- [ ] Date validation (start_date < end_date)

### ✅ CHECKPOINT 2 - Ngày 2
#### 2. Booking Entity
- [ ] Entity class (`domain/table/Booking.java`)
- [ ] Repository
- [ ] Service layer
- [ ] DTOs
- [ ] Controller
- [ ] Booking validation (slot availability, contract validity)
- [ ] Conflict detection

### ✅ CHECKPOINT 3 - Ngày 3
#### 3. Checkin Log Entity
- [ ] Entity class (`domain/table/CheckinLog.java`)
- [ ] Repository
- [ ] Service layer
- [ ] DTOs
- [ ] Controller
- [ ] Auto-calculate duration
- [ ] Attendance tracking

### ✅ CHECKPOINT 4 - Ngày 4 (Billing)
#### 4. Invoice Entity
- [ ] Entity class (`domain/table/Invoice.java`)
- [ ] Repository
- [ ] Service layer
- [ ] DTOs
- [ ] Controller
- [ ] Payment status management
- [ ] Auto-calculate final_amount

#### 5. Invoice Detail Entity
- [ ] Entity class (`domain/table/InvoiceDetail.java`)
- [ ] Repository
- [ ] Service layer
- [ ] DTOs
- [ ] Controller
- [ ] Auto-calculate total_amount (quantity × unit_price)
- [ ] Link to ServicePackage OR AdditionalService

### ✅ CHECKPOINT 5 - Ngày 5 (Testing & Integration)
- [ ] Integration testing cho booking flow
- [ ] Testing payment flow
- [ ] End-to-end testing
- [ ] API documentation
- [ ] Bug fixes

---

## 🟨 **THÀNH VIÊN 3** - Diet & Workout Management (6 entities)

### ✅ CHECKPOINT 1 - Ngày 1
#### 1. Food Entity (Ưu tiên cao)
- [X] Entity class (`domain/table/Food.java`)
- [X] Repository (`repository/FoodRepository.java`)
- [X] Service class (`service/FoodService.java`)
- [X] Request/Response DTOs (ReqCreateFoodDTO, ReqUpdateFoodDTO, ResFoodDTO)
- [X] REST Controller (`controller/FoodController.java`)
- [X] Nutrition database management
- [X] Auto-calculate calories and food type
- [X] **Documentation** (`.github/instruction/controller-example/FoodController.md`)

### ✅ CHECKPOINT 2 - Ngày 2 (Diet Management)
#### 2. Daily Diet Entity
- [X] Entity class (`domain/table/DailyDiet.java`)
- [X] Repository (`repository/DailyDietRepository.java`)
- [X] Service layer (`service/DailyDietService.java`)
- [X] DTOs (ReqCreateDailyDietDTO, ReqUpdateDailyDietDTO, ResDailyDietDTO)
- [X] Controller (`controller/DailyDietController.java`)
- [X] Diet plan creation
- [X] Water intake tracking
- [X] Date range filtering
- [X] Cascade loading diet details
- [X] **Documentation** (`.github/instruction/controller-example/DailyDietController.md`)

#### 3. Diet Detail Entity (Composite Key)
- [X] Entity class (`domain/table/DietDetail.java`)
- [X] Composite key class (`domain/table/DietDetailId.java`)
- [X] Repository (`repository/DietDetailRepository.java`)
- [X] Service layer (`service/DietDetailService.java`)
- [X] DTOs (ReqCreateDietDetailDTO, ReqUpdateDietDetailDTO, ResDietDetailDTO)
- [X] Controller (`controller/DietDetailController.java`)
- [X] Handle composite primary key correctly
- [X] Nutrition calculation (total = per100g/100 × amount)
- [X] **Documentation** (`.github/instruction/controller-example/DietDetailController.md`)

### ✅ CHECKPOINT 3 - Ngày 3 (Workout)
#### 4. Workout Device Entity
- [X] Entity class (`domain/table/WorkoutDevice.java`)
- [X] Repository (`repository/WorkoutDeviceRepository.java`)
  - [X] Method `findByNameContainingIgnoreCase(String name)` - Search by keyword
- [X] Service layer (`service/WorkoutDeviceService.java`)
  - [X] Method `searchWorkoutDevicesByName(String name)` - Returns List instead of single object
- [X] DTOs (ReqCreateWorkoutDeviceDTO, ReqUpdateWorkoutDeviceDTO, ResWorkoutDeviceDTO)
- [X] Controller (`controller/WorkoutDeviceController.java`)
  - [X] Endpoint `GET /by-name?name={keyword}` - Search by name (contains, case-insensitive) → Returns `List<ResWorkoutDeviceDTO>`
- [X] Maintenance schedule tracking
- [X] Device type filtering
- [X] Import date tracking
- [X] **API Update**: Changed `/by-name` from exact match to keyword search (contains)

#### 5. Workout Entity (v2 - Redesigned)
- [X] Entity class (`domain/table/Workout.java`)
  - [X] Removed PT and Device relationships (simplified to exercise library)
  - [X] Added `duration` (Integer, minutes)
  - [X] Added `difficulty` (Enum: BEGINNER, INTERMEDIATE, ADVANCED)
  - [X] Added `type` (String, category like Cardio/Strength/Flexibility)
  - [X] Made `name` unique constraint
- [X] Enum class (`util/enums/WorkoutDifficultyEnum.java`)
- [X] Repository (`repository/WorkoutRepository.java`)
  - [X] Removed PT/Device filtering methods
  - [X] Added `findByDifficulty()`, `findByType()`, `findByTypeContainingIgnoreCase()`
  - [X] Added `countByDifficulty()`, `countByType()`
- [X] Service layer (`service/WorkoutService.java`)
  - [X] Removed PT/Device repository dependencies
  - [X] Simplified `createWorkout()` - only validates name uniqueness
  - [X] Added difficulty/type filtering methods
- [X] DTOs (ReqCreateWorkoutDTO, ReqUpdateWorkoutDTO, ResWorkoutDTO)
  - [X] Removed `ptId`, `deviceId` fields
  - [X] Added `duration`, `difficulty`, `type` fields
- [X] Controller (`controller/WorkoutController.java`)
  - [X] Removed 6 PT/Device endpoints (/by-pt, /by-device, /bodyweight, /general, /count-by-pt, /count-by-device)
  - [X] Added 5 difficulty/type endpoints
  - [X] Kept core CRUD endpoints (create, get by ID, search by name, update, delete)
- [X] Exercise library management (generic exercises, not tied to PT or equipment)
- [X] Search and filtering by difficulty/type
- [X] **Documentation** (`.github/instruction/controller-example/WorkoutController.md`)

### ✅ CHECKPOINT 4 - Ngày 4
#### 6. Workout Image Entity
- [ ] Entity class (`domain/table/WorkoutImage.java`)
- [ ] Repository
- [ ] Service layer
- [ ] DTOs
- [ ] Controller
- [ ] Image upload/storage handling

### ✅ CHECKPOINT 5 - Ngày 5 (Integration & Features)
- [ ] Nutrition calculator
- [ ] Workout plan generator
- [ ] Test all diet & workout APIs
- [ ] API documentation
- [ ] Testing & Bug fixes

---

## 📝 Chi Tiết Công Việc Cho Mỗi Entity

Với **mỗi entity**, các bạn cần làm đầy đủ các bước sau:

### 1️⃣ Entity Class
- Tạo file trong `src/main/java/com/se100/GymAndPTManagement/domain/table/`
- Sử dụng annotations: `@Entity`, `@Table`, `@Data`, `@Builder`
- **BẮT BUỘC**: Thêm Audit Fields (created_at, updated_at, created_by, updated_by)
- Cấu hình relationships đúng (`@ManyToOne`, `@OneToMany`, etc.)
- Thêm validation annotations (`@NotNull`, `@Size`, etc.)

### 2️⃣ Repository Interface
- Tạo file trong `src/main/java/com/se100/GymAndPTManagement/repository/`
- Extends `JpaRepository<Entity, Long>`
- Thêm custom query methods nếu cần:
  ```java
  List<Entity> findByStatus(String status);
  Optional<Entity> findByName(String name);
  ```

### 3️⃣ Service Class
- Tạo trong `src/main/java/com/se100/GymAndPTManagement/service/`
- Implement các methods: create, update, delete, findById, findAll
- Implement business logic
- Handle exceptions
- Use DTOs for input/output

### 4️⃣ DTOs
**Request DTOs** (`domain/requestDTO/`):
- `CreateEntityDTO.java` - cho POST requests
- `UpdateEntityDTO.java` - cho PUT/PATCH requests

**Response DTOs** (`domain/responseDTO/`):
- `ResEntityDTO.java` - cho API responses
- Convert từ Entity sang DTO trong service layer

### 5️⃣ REST Controller
- Tạo trong `src/main/java/com/se100/GymAndPTManagement/controller/`
- Implement CRUD endpoints:
  - `POST /api/v1/entities` - Create
  - `GET /api/v1/entities/{id}` - Get by ID
  - `GET /api/v1/entities` - Get all (with pagination)
  - `PUT /api/v1/entities/{id}` - Update
  - `DELETE /api/v1/entities/{id}` - Delete
- Thêm `@ApiMessage` annotation cho responses
- Thêm validation (`@Valid`)

### 6️⃣ Testing (Optional nhưng nên làm)
- Unit tests cho Service layer
- Integration tests cho Controller

---

## 🎯 Checklist Chung Cho Mỗi Entity

```markdown
- [ ] Entity class với đầy đủ annotations
- [ ] Audit fields (created_at, updated_at, created_by, updated_by)
- [ ] Relationships được cấu hình đúng
- [ ] Repository interface
- [ ] Service class
- [ ] CreateDTO và UpdateDTO
- [ ] ResponseDTO
- [ ] Controller với CRUD endpoints
- [ ] Validation annotations
- [ ] Exception handling
- [ ] Test API bằng Postman/Thunder Client
- [ ] Cập nhật DATABASE_SCHEMA.md nếu có thay đổi
```

---

## 📅 Timeline Tổng Thể (5 Ngày)

| Ngày       | Thành viên 1                       | Thành viên 2            | Thành viên 3            |
| ---------- | ---------------------------------- | ----------------------- | ----------------------- |
| **Ngày 1** | ✅ Member + PersonalTrainer         | ✅ Contract              | ✅ Food                  |
| **Ngày 2** | ServicePackage + AdditionalService | Booking                 | DailyDiet + DietDetail  |
| **Ngày 3** | Slot + AvailableSlot               | CheckinLog              | WorkoutDevice + Workout |
| **Ngày 4** | BodyMetrics                        | Invoice + InvoiceDetail | WorkoutImage            |
| **Ngày 5** | 🧪 Testing & Integration            | 🧪 Testing & Integration | 🧪 Testing & Integration |

### 🎯 Mục Tiêu Mỗi Ngày

**Ngày 1**: Hoàn thành các entities nền tảng (Member, PT, Contract, Food)  
**Ngày 2**: Services & Diet management  
**Ngày 3**: Booking system & Workout features  
**Ngày 4**: Hoàn thiện các entities còn lại  
**Ngày 5**: Testing, bug fixes, integration, documentation

---

## 🚨 Lưu Ý Quan Trọng

### ⚠️ Dependencies Between Entities
Một số entities phụ thuộc vào nhau, cần implement theo thứ tự:

1. **Member & PersonalTrainer** phải có trước Contract
2. **ServicePackage** phải có trước Contract
3. **Slot** phải có trước Booking
4. **Contract** phải có trước Booking
5. **Food** phải có trước DietDetail
6. **DailyDiet** phải có trước DietDetail
7. **Workout** phải có trước WorkoutImage

### 📋 Code Standards
- Sử dụng **Lombok** annotations: `@Data`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor`
- Naming conventions:
  - Table names: `snake_case`, số nhiều (`members`, `personal_trainers`)
  - Column names: `snake_case`
  - Entity classes: `PascalCase` (`Member`, `PersonalTrainer`)
- **LUÔN LUÔN** thêm Audit fields vào mọi entity
- Follow template trong [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)

### 🔐 Security
- Tất cả endpoints cần có authentication (trừ login/register)
- Sử dụng `SecurityUtil.getCurrentUserLogin()` để lấy current user
- Implement authorization cho các roles khác nhau

### 📝 Documentation
- Comment code cho các business logic phức tạp
- Sử dụng Swagger annotations cho API documentation
- Update DATABASE_SCHEMA.md sau khi hoàn thành mỗi entity

---

## 🤝 Collaboration Guidelines

### Git Workflow
1. Mỗi người tạo branch riêng: `feature/entity-name`
2. Commit thường xuyên với message rõ ràng
3. Pull request khi hoàn thành entity
4. Review code lẫn nhau trước khi merge

### Communication
- Daily standup: Update tiến độ hàng ngày
- Weekly review: Review code và giải quyết vấn đề
- Dùng Issues để track bugs và tasks

### Code Review Checklist
- [ ] Code follow conventions
- [ ] Có đầy đủ Audit fields
- [ ] Relationships được cấu hình đúng
- [ ] DTOs được implement đầy đủ
- [ ] Controller có validation
- [ ] No hardcoded values
- [ ] Exception handling đúng cách

---

## 📚 Tài Liệu Tham Khảo

1. **DATABASE_SCHEMA.md** - Chi tiết schema của tất cả entities
2. **Schema.md** - ERD diagram của hệ thống
3. Existing code: `User.java`, `Role.java`, `Permission.java` - Làm mẫu

---

## 🎉 Kết Luận

- **Tổng công việc**: 19 entities × 6 tasks/entity ≈ 114 tasks
- **Mỗi người**: ~38 tasks (6-7 entities)
- **Timeline**: 5 ngày (Sprint nhanh)
- **Workload**: ~7-8 tasks/người/ngày

**LƯU Ý QUAN TRỌNG**:
- ⏰ **Timeline rất gấp** - cần làm việc tập trung cao độ
- 🎯 **Ưu tiên**: Hoàn thành entities nền tảng (Ngày 1) trước
- 🤝 **Hỗ trợ lẫn nhau**: Nếu ai xong sớm, hỗ trợ người khác
- ✅ **Quality first**: Đảm bảo code đúng chuẩn, có validation đầy đủ
- 🧪 **Ngày 5 dành cho testing**: Không code thêm entity mới

---

**Created**: 2026-01-07  
**Last Updated**: 2026-01-07  
**Version**: 1.0
