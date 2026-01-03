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
