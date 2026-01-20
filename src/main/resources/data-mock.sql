-- ============================================
-- MOCK DATA FOR GYM & PT MANAGEMENT SYSTEM
-- Generated: 2026-01-18
-- Purpose: Test data for development and testing
-- Database: MySQL/MariaDB
-- Schema: Matches Hibernate-generated tables
-- ============================================

-- Disable foreign key checks for data insertion
SET FOREIGN_KEY_CHECKS=0;

-- Clear existing data (reverse order of FK dependencies)
DELETE FROM diet_details WHERE 1=1;
DELETE FROM checkin_logs WHERE 1=1;
DELETE FROM daily_diets WHERE 1=1;
DELETE FROM invoice_details WHERE 1=1;
DELETE FROM invoices WHERE 1=1;
DELETE FROM bookings WHERE 1=1;
DELETE FROM contracts WHERE 1=1;
DELETE FROM body_metrics WHERE 1=1;
DELETE FROM available_slots WHERE 1=1;
DELETE FROM foods WHERE 1=1;
DELETE FROM workouts WHERE 1=1;
DELETE FROM workout_devices WHERE 1=1;
DELETE FROM additional_services WHERE 1=1;
DELETE FROM slots WHERE 1=1;
DELETE FROM members WHERE 1=1;
DELETE FROM personal_trainers WHERE 1=1;
DELETE FROM service_packages WHERE 1=1;
DELETE FROM role_permission WHERE 1=1;
DELETE FROM users WHERE 1=1;
DELETE FROM permissions WHERE 1=1;
DELETE FROM roles WHERE 1=1;

-- ============================================
-- 1. ROLES
-- ============================================
INSERT INTO roles (id, name, description, active, created_at, created_by, updated_at, updated_by) VALUES
(1, 'ADMIN', 'Quản trị viên hệ thống', 1, NOW(), 'system', NOW(), 'system'),
(2, 'MEMBER', 'Khách hàng', 1, NOW(), 'system', NOW(), 'system'),
(3, 'PT', 'Huấn luyện viên cá nhân', 1, NOW(), 'system', NOW(), 'system');

-- ============================================
-- 2. PERMISSIONS
-- ============================================
INSERT INTO permissions (id, name, api_path, method, module, created_at, created_by, updated_at, updated_by) VALUES
-- User Management
(1, 'VIEW_USERS', '/api/v1/users', 'GET', 'USER_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(2, 'CREATE_USER', '/api/v1/users', 'POST', 'USER_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(3, 'UPDATE_USER', '/api/v1/users/*', 'PUT', 'USER_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(4, 'DELETE_USER', '/api/v1/users/*', 'DELETE', 'USER_MANAGEMENT', NOW(), 'system', NOW(), 'system'),

-- Member Management
(5, 'VIEW_MEMBERS', '/api/v1/members', 'GET', 'MEMBER_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(6, 'CREATE_MEMBER', '/api/v1/members', 'POST', 'MEMBER_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(7, 'UPDATE_MEMBER', '/api/v1/members/*', 'PUT', 'MEMBER_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(8, 'DELETE_MEMBER', '/api/v1/members/*', 'DELETE', 'MEMBER_MANAGEMENT', NOW(), 'system', NOW(), 'system'),

-- PT Management
(9, 'VIEW_PT', '/api/v1/personal-trainers', 'GET', 'PT_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(10, 'CREATE_PT', '/api/v1/personal-trainers', 'POST', 'PT_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(11, 'UPDATE_PT', '/api/v1/personal-trainers/*', 'PUT', 'PT_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(12, 'DELETE_PT', '/api/v1/personal-trainers/*', 'DELETE', 'PT_MANAGEMENT', NOW(), 'system', NOW(), 'system'),

-- Service Package Management
(13, 'VIEW_PACKAGES', '/api/v1/service-packages', 'GET', 'PACKAGE_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(14, 'CREATE_PACKAGE', '/api/v1/service-packages', 'POST', 'PACKAGE_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(15, 'UPDATE_PACKAGE', '/api/v1/service-packages/*', 'PUT', 'PACKAGE_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(16, 'DELETE_PACKAGE', '/api/v1/service-packages/*', 'DELETE', 'PACKAGE_MANAGEMENT', NOW(), 'system', NOW(), 'system'),

-- Workout Management
(17, 'VIEW_WORKOUTS', '/api/v1/workouts', 'GET', 'WORKOUT_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(18, 'CREATE_WORKOUT', '/api/v1/workouts', 'POST', 'WORKOUT_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(19, 'UPDATE_WORKOUT', '/api/v1/workouts/*', 'PUT', 'WORKOUT_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(20, 'DELETE_WORKOUT', '/api/v1/workouts/*', 'DELETE', 'WORKOUT_MANAGEMENT', NOW(), 'system', NOW(), 'system'),

-- Food Management
(21, 'VIEW_FOODS', '/api/v1/foods', 'GET', 'FOOD_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(22, 'CREATE_FOOD', '/api/v1/foods', 'POST', 'FOOD_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(23, 'UPDATE_FOOD', '/api/v1/foods/*', 'PUT', 'FOOD_MANAGEMENT', NOW(), 'system', NOW(), 'system'),
(24, 'DELETE_FOOD', '/api/v1/foods/*', 'DELETE', 'FOOD_MANAGEMENT', NOW(), 'system', NOW(), 'system');

-- ============================================
-- 3. ROLE-PERMISSION MAPPINGS
-- ============================================
-- Admin: All permissions
INSERT INTO role_permission (role_id, permission_id) 
SELECT 1, id FROM permissions;

-- PT: View and manage workouts, foods, own profile
INSERT INTO role_permission (role_id, permission_id) VALUES
(3, 1), (3, 5), (3, 9), (3, 17), (3, 18), (3, 19), (3, 21), (3, 22), (3, 23);

-- Member: View only
INSERT INTO role_permission (role_id, permission_id) VALUES
(2, 1), (2, 5), (2, 9), (2, 13), (2, 17), (2, 21);

-- ============================================
-- 4. USERS (password: "123456" - BCrypt hashed)
-- BCrypt hash generated with strength 10
-- ============================================
INSERT INTO users (user_id, password_hash, fullname, email, phone_number, status, gender, dob, role_id, created_at, created_by, updated_at, updated_by) VALUES
-- Admins
(1, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Admin User', 'admin@gym.com', '0901000001', 'ACTIVE', 'MALE', '1985-01-15', 1, NOW(), 'system', NOW(), 'system'),

-- Personal Trainers
(2, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Trần Minh PT', 'pt1@gym.com', '0903000001', 'ACTIVE', 'MALE', '1990-05-12', 3, NOW(), 'system', NOW(), 'system'),
(3, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Lê Thị PT', 'pt2@gym.com', '0903000002', 'ACTIVE', 'FEMALE', '1992-08-25', 3, NOW(), 'system', NOW(), 'system'),
(4, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Phạm Văn PT', 'pt3@gym.com', '0903000003', 'ACTIVE', 'MALE', '1991-11-30', 3, NOW(), 'system', NOW(), 'system'),

-- Members
(5, '$2a$10$rDkPvvAFV8kqwvKJzwlHEOmR.uqxVl6b4U9FGkWxPaZz6v3CJA.Ii', 'Nguyễn Văn A', 'member1@gmail.com', '0904000001', 'ACTIVE', 'MALE', '1995-02-14', 2, NOW(), 'system', NOW(), 'system'),
(6, '$2a$10$rDkPvvAFV8kqwvKJzwlHEOmR.uqxVl6b4U9FGkWxPaZz6v3CJA.Ii', 'Trần Thị B', 'member2@gmail.com', '0904000002', 'ACTIVE', 'FEMALE', '1997-06-20', 2, NOW(), 'system', NOW(), 'system'),
(7, '$2a$10$rDkPvvAFV8kqwvKJzwlHEOmR.uqxVl6b4U9FGkWxPaZz6v3CJA.Ii', 'Lê Văn C', 'member3@gmail.com', '0904000003', 'ACTIVE', 'MALE', '1996-09-10', 2, NOW(), 'system', NOW(), 'system'),
(8, '$2a$10$rDkPvvAFV8kqwvKJzwlHEOmR.uqxVl6b4U9FGkWxPaZz6v3CJA.Ii', 'Phạm Thị D', 'member4@gmail.com', '0904000004', 'ACTIVE', 'FEMALE', '1998-12-05', 2, NOW(), 'system', NOW(), 'system'),
(9, '$2a$10$rDkPvvAFV8kqwvKJzwlHEOmR.uqxVl6b4U9FGkWxPaZz6v3CJA.Ii', 'Hoàng Văn E', 'member5@gmail.com', '0904000005', 'ACTIVE', 'MALE', '1994-03-18', 2, NOW(), 'system', NOW(), 'system'),
(10, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Võ Thị F', 'member6@gmail.com', '0904000006', 'ACTIVE', 'FEMALE', '1999-04-22', 2, NOW(), 'system', NOW(), 'system'),
(11, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Đặng Văn G', 'member7@gmail.com', '0904000007', 'ACTIVE', 'MALE', '1993-11-08', 2, NOW(), 'system', NOW(), 'system'),
(12, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Bùi Thị H', 'member8@gmail.com', '0904000008', 'INACTIVE', 'FEMALE', '1996-07-15', 2, NOW(), 'system', NOW(), 'system'),
(13, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Mai Văn I', 'member9@gmail.com', '0904000009', 'ACTIVE', 'MALE', '1992-01-30', 2, NOW(), 'system', NOW(), 'system'),
(14, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Hồ Thị K', 'member10@gmail.com', '0904000010', 'ACTIVE', 'FEMALE', '2000-05-12', 2, NOW(), 'system', NOW(), 'system'),
(15, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Dương Văn L', 'member11@gmail.com', '0904000011', 'ACTIVE', 'MALE', '1991-08-25', 2, NOW(), 'system', NOW(), 'system'),
(16, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Ngô Thị M', 'member12@gmail.com', '0904000012', 'ACTIVE', 'FEMALE', '1998-03-19', 2, NOW(), 'system', NOW(), 'system'),
(17, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Lý Văn N', 'member13@gmail.com', '0904000013', 'INACTIVE', 'MALE', '1995-12-07', 2, NOW(), 'system', NOW(), 'system'),
(18, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Phan Thị O', 'member14@gmail.com', '0904000014', 'ACTIVE', 'FEMALE', '1997-09-14', 2, NOW(), 'system', NOW(), 'system'),
(19, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Tô Văn P', 'member15@gmail.com', '0904000015', 'ACTIVE', 'MALE', '1994-06-28', 2, NOW(), 'system', NOW(), 'system'),
(20, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Vũ Thị Q', 'member16@gmail.com', '0904000016', 'ACTIVE', 'FEMALE', '1999-02-11', 2, NOW(), 'system', NOW(), 'system'),
(21, '$2a$10$Fx.PAIC1U/fOk5n2upd.QObUzcnu0zNr8TTD2mCLtbdhWZJGEpX32', 'Đinh Văn R', 'member17@gmail.com', '0904000017', 'ACTIVE', 'MALE', '1993-10-03', 2, NOW(), 'system', NOW(), 'system');

-- ============================================
-- 5. SERVICE PACKAGES
-- ============================================
INSERT INTO service_packages (package_id, package_name, description, duration_in_days, number_of_sessions, price, is_active, type, created_at, created_by, updated_at, updated_by) VALUES
(1, 'Gói 1 Tháng Cơ Bản', 'Truy cập phòng gym cơ bản, không bao gồm PT', 30, 0, 500000, 1, 'NO_PT', NOW(), 'system', NOW(), 'system'),
(2, 'Gói 3 Tháng Tiêu Chuẩn', 'Truy cập phòng gym + 12 buổi PT (4 buổi/tháng)', 90, 12, 1300000, 1, 'PT_INCLUDED', NOW(), 'system', NOW(), 'system'),
(3, 'Gói 6 Tháng Nâng Cao', 'Truy cập phòng gym + 48 buổi PT (8 buổi/tháng) + Nutrition plan', 180, 48, 2300000, 1, 'PT_INCLUDED', NOW(), 'system', NOW(), 'system'),
(4, 'Gói VIP 12 Tháng', 'Full access + Unlimited PT + Nutrition + Supplements', 365, 120, 4200000, 1, 'PT_INCLUDED', NOW(), 'system', NOW(), 'system'),
(5, 'Gói Học Sinh - Sinh Viên', 'Gói đặc biệt cho HSSV (yêu cầu thẻ)', 30, 0, 350000, 1, 'NO_PT', NOW(), 'system', NOW(), 'system');

-- ============================================
-- 6. ADDITIONAL SERVICES
-- ============================================
INSERT INTO additional_services (additional_service_id, name, description, cost_price, suggest_sell_price, is_active, created_at, created_by, updated_at, updated_by) VALUES
(1, 'Khóa Tủ Cá Nhân', 'Cho thuê khóa tủ cá nhân theo tháng', 30000, 50000, 1, NOW(), 'system', NOW(), 'system'),
(2, 'Khăn Tắm', 'Dịch vụ khăn tắm sạch mỗi buổi tập', 15000, 30000, 1, NOW(), 'system', NOW(), 'system'),
(3, 'Nước Uống Miễn Phí', 'Nước khoáng/nước lọc không giới hạn', 0, 0, 1, NOW(), 'system', NOW(), 'system'),
(4, 'Phân Tích Body Composition', 'Đo và phân tích thành phần cơ thể (InBody)', 50000, 100000, 1, NOW(), 'system', NOW(), 'system'),
(5, 'Tư Vấn Dinh Dưỡng', 'Buổi tư vấn dinh dưỡng 1-1 với chuyên gia', 100000, 200000, 1, NOW(), 'system', NOW(), 'system'),
(6, 'Massage Phục Hồi', 'Massage thể thao 30 phút', 80000, 150000, 1, NOW(), 'system', NOW(), 'system'),
(7, 'Sauna/Steam Room', 'Truy cập phòng xông hơi', 40000, 80000, 1, NOW(), 'system', NOW(), 'system');

-- ============================================
-- 7. PERSONAL TRAINERS
-- ============================================
INSERT INTO personal_trainers (pt_id, user_id, specialization, experience_years, about, certifications, rating, status, note, created_at, created_by, updated_at, updated_by) VALUES
(1, 2, 'Bodybuilding & Strength Training', 5, 'Chuyên về tăng cơ và sức mạnh, từng thi đấu Bodybuilding cấp quốc gia', 'ISSA Certified Personal Trainer, CrossFit Level 1', 4.80, 'AVAILABLE', NULL, NOW(), 'system', NOW(), 'system'),
(2, 3, 'Weight Loss & Cardio', 3, 'Chuyên giảm cân và cardio, giúp hơn 100 học viên đạt mục tiêu', 'ACE Certified, Nutrition Specialist', 4.90, 'AVAILABLE', NULL, NOW(), 'system', NOW(), 'system'),
(3, 4, 'Functional Training & CrossFit', 4, 'Huấn luyện viên CrossFit Level 2, chuyên functional fitness', 'CrossFit Level 2, NASM-CPT', 4.70, 'AVAILABLE', NULL, NOW(), 'system', NOW(), 'system');

-- ============================================
-- 8. MEMBERS
-- ============================================
INSERT INTO members (member_id, user_id, cccd, join_date, money_spent, money_debt, created_at, created_by, updated_at, updated_by) VALUES
(1, 5, '001095000001', '2026-01-01', 1300000, 0, NOW(), 'system', NOW(), 'system'),
(2, 6, '001097000002', '2026-01-05', 500000, 0, NOW(), 'system', NOW(), 'system'),
(3, 7, '001096000003', '2025-12-15', 2300000, 0, NOW(), 'system', NOW(), 'system'),
(4, 8, '001098000004', '2026-01-10', 500000, 0, NOW(), 'system', NOW(), 'system'),
(5, 9, '001094000005', '2025-10-01', 4200000, 0, NOW(), 'system', NOW(), 'system'),
(6, 10, '001099000006', '2025-11-20', 1800000, 0, NOW(), 'system', NOW(), 'system'),
(7, 11, '001093000007', '2025-09-15', 3500000, 200000, NOW(), 'system', NOW(), 'system'),
(8, 12, '001098000008', '2024-12-01', 500000, 500000, NOW(), 'system', NOW(), 'system'),
(9, 13, '001092000009', '2025-08-10', 2600000, 0, NOW(), 'system', NOW(), 'system'),
(10, 14, '002000000010', '2026-01-12', 350000, 0, NOW(), 'system', NOW(), 'system'),
(11, 15, '001091000011', '2025-07-05', 4500000, 0, NOW(), 'system', NOW(), 'system'),
(12, 16, '001098000012', '2025-12-20', 1300000, 0, NOW(), 'system', NOW(), 'system'),
(13, 17, '001095000013', '2025-06-01', 1000000, 1000000, NOW(), 'system', NOW(), 'system'),
(14, 18, '001097000014', '2025-11-10', 500000, 0, NOW(), 'system', NOW(), 'system'),
(15, 19, '001094000015', '2025-10-15', 2300000, 0, NOW(), 'system', NOW(), 'system'),
(16, 20, '001999000016', '2026-01-08', 350000, 0, NOW(), 'system', NOW(), 'system'),
(17, 21, '001093000017', '2025-09-25', 3000000, 0, NOW(), 'system', NOW(), 'system');

-- ============================================
-- 9. SLOTS (Training Time Slots)
-- ============================================
INSERT INTO slots (slot_id, slot_name, start_time, end_time, is_active, created_at, created_by, updated_at, updated_by) VALUES
(1, 'Slot 06:00-07:00', '06:00:00', '07:00:00', 1, NOW(), 'system', NOW(), 'system'),
(2, 'Slot 07:00-08:00', '07:00:00', '08:00:00', 1, NOW(), 'system', NOW(), 'system'),
(3, 'Slot 08:00-09:00', '08:00:00', '09:00:00', 1, NOW(), 'system', NOW(), 'system'),
(4, 'Slot 09:00-10:00', '09:00:00', '10:00:00', 1, NOW(), 'system', NOW(), 'system'),
(5, 'Slot 10:00-11:00', '10:00:00', '11:00:00', 1, NOW(), 'system', NOW(), 'system'),
(6, 'Slot 14:00-15:00', '14:00:00', '15:00:00', 1, NOW(), 'system', NOW(), 'system'),
(7, 'Slot 15:00-16:00', '15:00:00', '16:00:00', 1, NOW(), 'system', NOW(), 'system'),
(8, 'Slot 16:00-17:00', '16:00:00', '17:00:00', 1, NOW(), 'system', NOW(), 'system'),
(9, 'Slot 17:00-18:00', '17:00:00', '18:00:00', 1, NOW(), 'system', NOW(), 'system'),
(10, 'Slot 18:00-19:00', '18:00:00', '19:00:00', 1, NOW(), 'system', NOW(), 'system'),
(11, 'Slot 19:00-20:00', '19:00:00', '20:00:00', 1, NOW(), 'system', NOW(), 'system'),
(12, 'Slot 20:00-21:00', '20:00:00', '21:00:00', 1, NOW(), 'system', NOW(), 'system');

-- ============================================
-- 10. AVAILABLE SLOTS (PT Availability)
-- ============================================
-- PT 1 (Trần Minh PT - user_id: 2) - Available morning slots
INSERT INTO available_slots (available_slot_id, pt_id, user_id, slot_id, day_of_week, is_available, created_at, created_by, updated_at, updated_by) VALUES
(1, 1, 2, 1, 'MONDAY', 1, NOW(), 'system', NOW(), 'system'),
(2, 1, 2, 2, 'MONDAY', 1, NOW(), 'system', NOW(), 'system'),
(3, 1, 2, 3, 'MONDAY', 1, NOW(), 'system', NOW(), 'system'),
(4, 1, 2, 1, 'WEDNESDAY', 1, NOW(), 'system', NOW(), 'system'),
(5, 1, 2, 2, 'WEDNESDAY', 1, NOW(), 'system', NOW(), 'system'),
(6, 1, 2, 1, 'FRIDAY', 1, NOW(), 'system', NOW(), 'system'),

-- PT 2 (Lê Thị PT - user_id: 3) - Available afternoon slots
(7, 2, 3, 6, 'TUESDAY', 1, NOW(), 'system', NOW(), 'system'),
(8, 2, 3, 7, 'TUESDAY', 1, NOW(), 'system', NOW(), 'system'),
(9, 2, 3, 8, 'TUESDAY', 1, NOW(), 'system', NOW(), 'system'),
(10, 2, 3, 6, 'THURSDAY', 1, NOW(), 'system', NOW(), 'system'),
(11, 2, 3, 7, 'THURSDAY', 1, NOW(), 'system', NOW(), 'system'),
(12, 2, 3, 6, 'SATURDAY', 1, NOW(), 'system', NOW(), 'system'),

-- PT 3 (Phạm Văn PT - user_id: 4) - Available evening slots
(13, 3, 4, 9, 'MONDAY', 1, NOW(), 'system', NOW(), 'system'),
(14, 3, 4, 10, 'MONDAY', 1, NOW(), 'system', NOW(), 'system'),
(15, 3, 4, 11, 'MONDAY', 1, NOW(), 'system', NOW(), 'system'),
(16, 3, 4, 9, 'WEDNESDAY', 1, NOW(), 'system', NOW(), 'system'),
(17, 3, 4, 10, 'WEDNESDAY', 1, NOW(), 'system', NOW(), 'system'),
(18, 3, 4, 9, 'FRIDAY', 1, NOW(), 'system', NOW(), 'system');

-- ============================================
-- 11. BODY METRICS (Member Health Tracking)
-- ============================================
INSERT INTO body_metrics (metric_id, member_id, measured_date, weight, height, body_fat_percentage, muscle_mass, bmi, measured_by, created_at, created_by, updated_at, updated_by) VALUES
-- Member 1 progress
(1, 1, '2026-01-01', 75.5, 175, 22.5, 55.2, 24.65, 2, NOW(), 'system', NOW(), 'system'),
(2, 1, '2026-01-08', 74.8, 175, 21.8, 55.8, 24.44, 2, NOW(), 'system', NOW(), 'system'),
(3, 1, '2026-01-15', 74.2, 175, 21.2, 56.3, 24.24, 2, NOW(), 'system', NOW(), 'system'),

-- Member 2 progress
(4, 2, '2026-01-05', 68.0, 165, 28.5, 45.2, 24.98, 3, NOW(), 'system', NOW(), 'system'),
(5, 2, '2026-01-12', 67.3, 165, 27.8, 45.6, 24.72, 3, NOW(), 'system', NOW(), 'system'),

-- Member 3 progress
(6, 3, '2025-12-15', 82.0, 180, 18.5, 63.5, 25.31, 4, NOW(), 'system', NOW(), 'system'),
(7, 3, '2026-01-01', 83.2, 180, 17.8, 65.1, 25.68, 4, NOW(), 'system', NOW(), 'system'),
(8, 3, '2026-01-15', 84.0, 180, 17.5, 66.0, 25.93, 4, NOW(), 'system', NOW(), 'system'),

-- Member 5 (VIP)
(9, 5, '2025-10-01', 90.0, 178, 25.0, 62.5, 28.41, 3, NOW(), 'system', NOW(), 'system'),
(10, 5, '2025-11-01', 87.5, 178, 22.5, 64.2, 27.61, 3, NOW(), 'system', NOW(), 'system'),
(11, 5, '2025-12-01', 85.0, 178, 20.0, 65.8, 26.83, 3, NOW(), 'system', NOW(), 'system'),
(12, 5, '2026-01-01', 83.2, 178, 18.5, 66.5, 26.27, 3, NOW(), 'system', NOW(), 'system');

-- ============================================
-- 12. FOOD (Nutrition Database)
-- ============================================
INSERT INTO foods (food_id, name, description, calories, protein, carbohydrate, fat, type, status, notes, food_photo, created_at, created_by, updated_at, updated_by) VALUES
-- Proteins
(1, 'Ức gà luộc', 'Thịt ức gà luộc không da, nguồn protein chất lượng cao', 165, 31.0, 0.0, 3.6, 'PROTEIN', 'ACTIVE', 'Tốt cho tăng cơ, ít calo', NULL, NOW(), 'system', NOW(), 'system'),
(2, 'Trứng gà luộc', 'Trứng gà luộc chín (whole egg)', 155, 13.0, 1.1, 11.0, 'PROTEIN', 'ACTIVE', 'Protein hoàn chỉnh, nhiều vitamin', NULL, NOW(), 'system', NOW(), 'system'),
(3, 'Cá hồi nướng', 'Cá hồi Nauy nướng', 208, 25.0, 0.0, 13.0, 'PROTEIN', 'ACTIVE', 'Giàu Omega-3, tốt cho tim mạch', NULL, NOW(), 'system', NOW(), 'system'),
(4, 'Thịt bò nạc', 'Thịt bò nạc, ít mỡ', 250, 26.0, 0.0, 8.0, 'PROTEIN', 'ACTIVE', 'Nhiều sắt và kẽm', NULL, NOW(), 'system', NOW(), 'system'),

-- Carbs
(5, 'Cơm gạo lứt', 'Gạo lứt nấu chín', 111, 2.6, 23.0, 0.9, 'CARB', 'ACTIVE', 'Carb phức hợp, nhiều chất xơ', NULL, NOW(), 'system', NOW(), 'system'),
(6, 'Khoai lang', 'Khoai lang luộc/hấp', 86, 1.6, 20.1, 0.1, 'CARB', 'ACTIVE', 'Carb lành mạnh, nhiều vitamin A', NULL, NOW(), 'system', NOW(), 'system'),
(7, 'Yến mạch', 'Yến mạch nguyên hạt', 389, 13.0, 67.0, 7.0, 'CARB', 'ACTIVE', 'Giàu chất xơ hòa tan', NULL, NOW(), 'system', NOW(), 'system'),
(8, 'Bánh mì nguyên cám', 'Bánh mì whole wheat', 247, 9.0, 41.0, 3.5, 'CARB', 'ACTIVE', 'Carb phức, nhiều chất xơ', NULL, NOW(), 'system', NOW(), 'system'),

-- Vegetables
(9, 'Bông cải xanh', 'Broccoli hấp', 55, 2.8, 7.0, 0.4, 'VEGETABLE', 'ACTIVE', 'Rất nhiều vitamin C và K', NULL, NOW(), 'system', NOW(), 'system'),
(10, 'Rau chân vịt', 'Spinach luộc', 23, 2.9, 3.6, 0.4, 'VEGETABLE', 'ACTIVE', 'Giàu sắt và canxi', NULL, NOW(), 'system', NOW(), 'system'),
(11, 'Cà chua', 'Cà chua tươi', 18, 0.9, 3.9, 0.2, 'VEGETABLE', 'ACTIVE', 'Nhiều lycopene, chống oxy hóa', NULL, NOW(), 'system', NOW(), 'system'),

-- Fruits
(12, 'Chuối', 'Chuối tiêu chín', 89, 1.1, 23.0, 0.3, 'FRUIT', 'ACTIVE', 'Nhiều kali, tốt sau tập', NULL, NOW(), 'system', NOW(), 'system'),
(13, 'Táo', 'Táo tươi có vỏ', 52, 0.3, 14.0, 0.2, 'FRUIT', 'ACTIVE', 'Nhiều chất xơ', NULL, NOW(), 'system', NOW(), 'system'),
(14, 'Cam', 'Cam tươi', 47, 0.9, 12.0, 0.1, 'FRUIT', 'ACTIVE', 'Rất nhiều vitamin C', NULL, NOW(), 'system', NOW(), 'system'),

-- Healthy Fats
(15, 'Quả bơ', 'Avocado', 160, 2.0, 9.0, 15.0, 'FAT', 'ACTIVE', 'Chất béo lành mạnh', NULL, NOW(), 'system', NOW(), 'system'),
(16, 'Hạt hạnh nhân', 'Almond rang', 579, 21.0, 22.0, 50.0, 'FAT', 'ACTIVE', 'Protein thực vật, vitamin E', NULL, NOW(), 'system', NOW(), 'system'),
(17, 'Dầu ô liu', 'Extra virgin olive oil', 884, 0.0, 0.0, 99.0, 'FAT', 'ACTIVE', 'Chất béo không bão hòa đơn', NULL, NOW(), 'system', NOW(), 'system'),

-- Dairy
(18, 'Sữa tươi không đường', 'Low-fat milk', 42, 3.4, 5.0, 1.0, 'DAIRY', 'ACTIVE', 'Canxi, protein', NULL, NOW(), 'system', NOW(), 'system'),
(19, 'Sữa chua Hy Lạp', 'Greek yogurt plain', 59, 10.0, 3.6, 0.4, 'DAIRY', 'ACTIVE', 'Probiotic, protein cao', NULL, NOW(), 'system', NOW(), 'system'),
(20, 'Phô mai cottage', 'Cottage cheese', 98, 11.0, 3.4, 4.3, 'DAIRY', 'ACTIVE', 'Protein casein tốt trước ngủ', NULL, NOW(), 'system', NOW(), 'system'),

-- Additional Proteins
(21, 'Tôm luộc', 'Boiled shrimp', 99, 24.0, 0.2, 0.3, 'PROTEIN', 'ACTIVE', 'Ít calo, nhiều protein', NULL, NOW(), 'system', NOW(), 'system'),
(22, 'Thịt lợn nạc', 'Lean pork', 143, 27.0, 0.0, 3.5, 'PROTEIN', 'ACTIVE', 'Nguồn protein tốt', NULL, NOW(), 'system', NOW(), 'system'),
(23, 'Đậu phụ', 'Tofu', 76, 8.0, 1.9, 4.8, 'PROTEIN', 'ACTIVE', 'Protein thực vật hoàn chỉnh', NULL, NOW(), 'system', NOW(), 'system'),
(24, 'Cá ngừ đóng hộp', 'Canned tuna', 132, 28.0, 0.0, 1.3, 'PROTEIN', 'ACTIVE', 'Tiện lợi, nhiều protein', NULL, NOW(), 'system', NOW(), 'system'),
(25, 'Whey protein isolate', 'Whey protein powder', 360, 90.0, 2.0, 0.5, 'PROTEIN', 'ACTIVE', 'Bổ sung protein sau tập', NULL, NOW(), 'system', NOW(), 'system'),

-- More Carbs
(26, 'Chuối xanh', 'Green banana', 89, 1.1, 22.8, 0.3, 'CARB', 'ACTIVE', 'Tinh bột kháng, tốt cho đường huyết', NULL, NOW(), 'system', NOW(), 'system'),
(27, 'Khoai tây', 'Potato', 77, 2.0, 17.5, 0.1, 'CARB', 'ACTIVE', 'Carb bổ dưỡng', NULL, NOW(), 'system', NOW(), 'system'),
(28, 'Mì Ý nguyên cám', 'Whole wheat pasta', 124, 5.3, 26.0, 0.5, 'CARB', 'ACTIVE', 'Carb phức cho endurance', NULL, NOW(), 'system', NOW(), 'system'),
(29, 'Ngô luộc', 'Boiled corn', 96, 3.4, 21.0, 1.5, 'CARB', 'ACTIVE', 'Nhiều chất xơ', NULL, NOW(), 'system', NOW(), 'system'),
(30, 'Đậu đỏ', 'Red beans', 127, 8.7, 22.8, 0.5, 'CARB', 'ACTIVE', 'Protein và carb thực vật', NULL, NOW(), 'system', NOW(), 'system'),

-- More Vegetables
(31, 'Cà rốt', 'Carrot', 41, 0.9, 10.0, 0.2, 'VEGETABLE', 'ACTIVE', 'Nhiều beta-carotene', NULL, NOW(), 'system', NOW(), 'system'),
(32, 'Dưa chuột', 'Cucumber', 15, 0.7, 3.6, 0.1, 'VEGETABLE', 'ACTIVE', 'Ít calo, nhiều nước', NULL, NOW(), 'system', NOW(), 'system'),
(33, 'Súp lơ trắng', 'Cauliflower', 25, 1.9, 5.0, 0.3, 'VEGETABLE', 'ACTIVE', 'Low-carb, nhiều vitamin', NULL, NOW(), 'system', NOW(), 'system'),
(34, 'Măng tây', 'Asparagus', 20, 2.2, 3.9, 0.1, 'VEGETABLE', 'ACTIVE', 'Nhiều folate', NULL, NOW(), 'system', NOW(), 'system'),
(35, 'Ớt chuông', 'Bell pepper', 31, 1.0, 6.0, 0.3, 'VEGETABLE', 'ACTIVE', 'Nhiều vitamin C', NULL, NOW(), 'system', NOW(), 'system'),
(36, 'Cải bó xôi', 'Kale', 49, 4.3, 8.8, 0.9, 'VEGETABLE', 'ACTIVE', 'Siêu thực phẩm, nhiều dưỡng chất', NULL, NOW(), 'system', NOW(), 'system'),
(37, 'Hành tây', 'Onion', 40, 1.1, 9.3, 0.1, 'VEGETABLE', 'ACTIVE', 'Chống viêm', NULL, NOW(), 'system', NOW(), 'system'),
(38, 'Tỏi', 'Garlic', 149, 6.4, 33.1, 0.5, 'VEGETABLE', 'ACTIVE', 'Tăng miễn dịch', NULL, NOW(), 'system', NOW(), 'system'),

-- More Fruits
(39, 'Dâu tây', 'Strawberry', 32, 0.7, 7.7, 0.3, 'FRUIT', 'ACTIVE', 'Ít đường, nhiều vitamin C', NULL, NOW(), 'system', NOW(), 'system'),
(40, 'Việt quất', 'Blueberry', 57, 0.7, 14.5, 0.3, 'FRUIT', 'ACTIVE', 'Chống oxy hóa mạnh', NULL, NOW(), 'system', NOW(), 'system'),
(41, 'Dưa hấu', 'Watermelon', 30, 0.6, 7.6, 0.2, 'FRUIT', 'ACTIVE', 'Nhiều nước, ít calo', NULL, NOW(), 'system', NOW(), 'system'),
(42, 'Nho đen', 'Black grapes', 69, 0.7, 18.1, 0.2, 'FRUIT', 'ACTIVE', 'Resveratrol tốt cho tim', NULL, NOW(), 'system', NOW(), 'system'),
(43, 'Xoài', 'Mango', 60, 0.8, 15.0, 0.4, 'FRUIT', 'ACTIVE', 'Nhiều vitamin A', NULL, NOW(), 'system', NOW(), 'system'),
(44, 'Dứa', 'Pineapple', 50, 0.5, 13.1, 0.1, 'FRUIT', 'ACTIVE', 'Enzyme bromelain', NULL, NOW(), 'system', NOW(), 'system'),
(45, 'Đu đủ', 'Papaya', 43, 0.5, 11.0, 0.3, 'FRUIT', 'ACTIVE', 'Enzyme papain hỗ trợ tiêu hóa', NULL, NOW(), 'system', NOW(), 'system'),
(46, 'Lê', 'Pear', 57, 0.4, 15.2, 0.1, 'FRUIT', 'ACTIVE', 'Nhiều chất xơ', NULL, NOW(), 'system', NOW(), 'system'),

-- More Healthy Fats
(47, 'Hạt óc chó', 'Walnut', 654, 15.2, 13.7, 65.2, 'FAT', 'ACTIVE', 'Omega-3 thực vật', NULL, NOW(), 'system', NOW(), 'system'),
(48, 'Hạt điều', 'Cashew', 553, 18.2, 30.2, 43.9, 'FAT', 'ACTIVE', 'Khoáng chất tốt', NULL, NOW(), 'system', NOW(), 'system'),
(49, 'Hạt chia', 'Chia seeds', 486, 16.5, 42.1, 30.7, 'FAT', 'ACTIVE', 'Omega-3, chất xơ cao', NULL, NOW(), 'system', NOW(), 'system'),
(50, 'Hạt lanh', 'Flax seeds', 534, 18.3, 28.9, 42.2, 'FAT', 'ACTIVE', 'ALA omega-3, lignans', NULL, NOW(), 'system', NOW(), 'system'),
(51, 'Bơ đậu phộng', 'Peanut butter', 588, 25.8, 20.0, 50.0, 'FAT', 'ACTIVE', 'Protein và chất béo lành mạnh', NULL, NOW(), 'system', NOW(), 'system'),
(52, 'Dầu dừa', 'Coconut oil', 862, 0.0, 0.0, 99.1, 'FAT', 'ACTIVE', 'MCT tốt cho năng lượng', NULL, NOW(), 'system', NOW(), 'system'),

-- Beverages & Others
(53, 'Cà phê đen', 'Black coffee', 2, 0.3, 0.0, 0.0, 'BEVERAGE', 'ACTIVE', 'Caffeine tăng năng lượng', NULL, NOW(), 'system', NOW(), 'system'),
(54, 'Trà xanh', 'Green tea', 1, 0.0, 0.0, 0.0, 'BEVERAGE', 'ACTIVE', 'Chống oxy hóa, hỗ trợ giảm cân', NULL, NOW(), 'system', NOW(), 'system'),
(55, 'Nước ép cần tây', 'Celery juice', 14, 0.7, 3.0, 0.2, 'BEVERAGE', 'ACTIVE', 'Detox, ít calo', NULL, NOW(), 'system', NOW(), 'system'),
(56, 'Sữa đậu nành', 'Soy milk', 54, 3.3, 6.0, 1.8, 'DAIRY', 'ACTIVE', 'Thay thế sữa bò', NULL, NOW(), 'system', NOW(), 'system'),
(57, 'Sữa hạnh nhân', 'Almond milk', 17, 0.6, 1.5, 1.1, 'DAIRY', 'ACTIVE', 'Ít calo, không lactose', NULL, NOW(), 'system', NOW(), 'system'),
(58, 'Mật ong', 'Honey', 304, 0.3, 82.4, 0.0, 'CARB', 'ACTIVE', 'Đường tự nhiên', NULL, NOW(), 'system', NOW(), 'system'),
(59, 'Gừng', 'Ginger', 80, 1.8, 17.8, 0.8, 'VEGETABLE', 'ACTIVE', 'Chống viêm, hỗ trợ tiêu hóa', NULL, NOW(), 'system', NOW(), 'system'),
(60, 'Bí xanh', 'Zucchini', 17, 1.2, 3.1, 0.3, 'VEGETABLE', 'ACTIVE', 'Low-carb, nhiều nước', NULL, NOW(), 'system', NOW(), 'system');

-- ============================================
-- 13. WORKOUT DEVICES
-- ============================================
INSERT INTO workout_devices (device_id, name, type, price, date_imported, date_maintenance, image_url, created_at, created_by, updated_at, updated_by) VALUES
-- Cardio Equipment
(1, 'Treadmill Pro X1', 'Cardio', 35000000, '2025-06-15', '2026-06-15', 'https://example.com/treadmill-x1.jpg', NOW(), 'system', NOW(), 'system'),
(2, 'Treadmill Basic T2', 'Cardio', 18000000, '2025-08-20', '2026-08-20', 'https://example.com/treadmill-t2.jpg', NOW(), 'system', NOW(), 'system'),
(3, 'Rowing Machine R3', 'Cardio', 12000000, '2025-09-10', '2026-03-10', 'https://example.com/rowing-r3.jpg', NOW(), 'system', NOW(), 'system'),
(4, 'Exercise Bike B5', 'Cardio', 8500000, '2025-10-05', '2026-04-05', 'https://example.com/bike-b5.jpg', NOW(), 'system', NOW(), 'system'),
(5, 'Elliptical Trainer E4', 'Cardio', 22000000, '2025-07-12', '2026-07-12', 'https://example.com/elliptical.jpg', NOW(), 'system', NOW(), 'system'),

-- Strength Equipment
(6, 'Smith Machine Pro', 'Strength', 45000000, '2025-05-20', '2026-05-20', 'https://example.com/smith-machine.jpg', NOW(), 'system', NOW(), 'system'),
(7, 'Power Rack Heavy Duty', 'Strength', 38000000, '2025-06-01', '2026-06-01', 'https://example.com/power-rack.jpg', NOW(), 'system', NOW(), 'system'),
(8, 'Bench Press Station', 'Strength', 15000000, '2025-07-15', '2026-07-15', 'https://example.com/bench-press.jpg', NOW(), 'system', NOW(), 'system'),
(9, 'Cable Crossover Machine', 'Strength', 52000000, '2025-08-10', '2026-08-10', 'https://example.com/cable-crossover.jpg', NOW(), 'system', NOW(), 'system'),
(10, 'Leg Press Machine', 'Strength', 28000000, '2025-09-05', '2026-09-05', 'https://example.com/leg-press.jpg', NOW(), 'system', NOW(), 'system'),

-- Free Weights
(11, 'Dumbbells Set 2.5-50kg', 'Free Weights', 25000000, '2025-05-01', NULL, 'https://example.com/dumbbells.jpg', NOW(), 'system', NOW(), 'system'),
(12, 'Barbell Olympic Set', 'Free Weights', 18000000, '2025-05-01', NULL, 'https://example.com/barbell.jpg', NOW(), 'system', NOW(), 'system'),
(13, 'Kettlebell Set 4-32kg', 'Free Weights', 8000000, '2025-06-10', NULL, 'https://example.com/kettlebells.jpg', NOW(), 'system', NOW(), 'system'),

-- Functional Training
(14, 'TRX Suspension Trainer', 'Functional', 3500000, '2025-07-01', '2026-01-01', 'https://example.com/trx.jpg', NOW(), 'system', NOW(), 'system'),
(15, 'Battle Rope 15m', 'Functional', 1500000, '2025-08-01', NULL, 'https://example.com/battle-rope.jpg', NOW(), 'system', NOW(), 'system'),
(16, 'Plyo Box Set', 'Functional', 4000000, '2025-07-20', NULL, 'https://example.com/plyo-box.jpg', NOW(), 'system', NOW(), 'system');

-- ============================================
-- 14. WORKOUTS (Exercise Library)
-- ============================================
INSERT INTO workouts (workout_id, name, description, duration, difficulty, type, created_at, created_by, updated_at, updated_by) VALUES
-- Bodyweight - Beginner
(1, 'Push-ups', 'Nằm sấp, tay chống đất ngang vai, đẩy người lên xuống', 10, 'BEGINNER', 'Strength', NOW(), 'system', NOW(), 'system'),
(2, 'Squats', 'Đứng thẳng, hạ người xuống như ngồi ghế, đứng lên', 12, 'BEGINNER', 'Strength', NOW(), 'system', NOW(), 'system'),
(3, 'Plank', 'Chống tay/cánh tay, giữ thân thẳng', 5, 'BEGINNER', 'Core', NOW(), 'system', NOW(), 'system'),
(4, 'Jumping Jacks', 'Nhảy tại chỗ, tay chân mở rộng', 10, 'BEGINNER', 'Cardio', NOW(), 'system', NOW(), 'system'),
(5, 'Lunges', 'Bước chân ra trước, hạ người xuống', 10, 'BEGINNER', 'Strength', NOW(), 'system', NOW(), 'system'),

-- Intermediate
(6, 'Burpees', 'Squat, chống tay, push-up, nhảy lên', 15, 'INTERMEDIATE', 'HIIT', NOW(), 'system', NOW(), 'system'),
(7, 'Mountain Climbers', 'Tư thế plank, đưa chân lên xuống nhanh', 12, 'INTERMEDIATE', 'Cardio', NOW(), 'system', NOW(), 'system'),
(8, 'Diamond Push-ups', 'Push-up với tay tạo hình kim cương', 10, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(9, 'Jump Squats', 'Squat kết hợp nhảy bật cao', 12, 'INTERMEDIATE', 'HIIT', NOW(), 'system', NOW(), 'system'),
(10, 'Side Plank', 'Plank nghiêng một bên', 8, 'INTERMEDIATE', 'Core', NOW(), 'system', NOW(), 'system'),

-- Advanced
(11, 'Pistol Squats', 'Squat một chân, chân còn lại thẳng ra trước', 10, 'ADVANCED', 'Strength', NOW(), 'system', NOW(), 'system'),
(12, 'Handstand Push-ups', 'Chống tay ngược, đẩy người lên xuống', 8, 'ADVANCED', 'Strength', NOW(), 'system', NOW(), 'system'),
(13, 'Muscle-ups', 'Từ xà đơn lên trên xà song', 6, 'ADVANCED', 'Strength', NOW(), 'system', NOW(), 'system'),
(14, 'Box Jumps', 'Nhảy lên box/bục cao', 15, 'ADVANCED', 'HIIT', NOW(), 'system', NOW(), 'system'),
(15, 'Dragon Flag', 'Nâng toàn thân từ vai, core siêu mạnh', 5, 'ADVANCED', 'Core', NOW(), 'system', NOW(), 'system'),

-- Cardio
(16, 'Running 5K', 'Chạy bộ 5km với tốc độ trung bình', 30, 'INTERMEDIATE', 'Cardio', NOW(), 'system', NOW(), 'system'),
(17, 'HIIT Sprint Intervals', '30s sprint, 30s rest, lặp lại', 20, 'INTERMEDIATE', 'HIIT', NOW(), 'system', NOW(), 'system'),
(18, 'Cycling', 'Đạp xe cardio tốc độ đều', 45, 'BEGINNER', 'Cardio', NOW(), 'system', NOW(), 'system'),
(19, 'Rowing 2000m', 'Rowing machine 2000m', 10, 'INTERMEDIATE', 'Cardio', NOW(), 'system', NOW(), 'system'),

-- Flexibility
(20, 'Yoga Flow', 'Chuỗi động tác yoga cơ bản', 30, 'BEGINNER', 'Flexibility', NOW(), 'system', NOW(), 'system'),
(21, 'Static Stretching', 'Giãn cơ tĩnh sau tập', 15, 'BEGINNER', 'Flexibility', NOW(), 'system', NOW(), 'system'),
(22, 'Dynamic Warm-up', 'Khởi động động học trước tập', 10, 'BEGINNER', 'Flexibility', NOW(), 'system', NOW(), 'system'),

-- Strength Training (with equipment)
(23, 'Barbell Bench Press', 'Nằm đẩy tạ đòn trên ghế', 15, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(24, 'Barbell Deadlift', 'Nâng tạ đòn từ sàn lên', 12, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(25, 'Barbell Squat', 'Squat với tạ đòn trên vai', 15, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(26, 'Pull-ups', 'Kéo xà đơn', 10, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(27, 'Dumbbell Shoulder Press', 'Đẩy tạ đơn lên trên vai', 12, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(28, 'Cable Rows', 'Kéo cable về phía ngực', 15, 'BEGINNER', 'Strength', NOW(), 'system', NOW(), 'system'),
(29, 'Leg Press', 'Đẩy chân trên máy leg press', 15, 'BEGINNER', 'Strength', NOW(), 'system', NOW(), 'system'),
(30, 'Lat Pulldown', 'Kéo lat bar xuống trước ngực', 12, 'BEGINNER', 'Strength', NOW(), 'system', NOW(), 'system'),

-- Additional Advanced Exercises
(31, 'Romanian Deadlift', 'Deadlift chạm gót, tập hamstring', 12, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(32, 'Front Squat', 'Squat với tạ đòn trước ngực', 12, 'ADVANCED', 'Strength', NOW(), 'system', NOW(), 'system'),
(33, 'Overhead Press', 'Đẩy tạ đòn lên cao trên đầu', 10, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(34, 'Dumbbell Lunges', 'Lunge với tạ đơn hai tay', 12, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(35, 'Incline Bench Press', 'Bench press trên ghế nghiêng', 12, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(36, 'T-Bar Row', 'Kéo T-bar về phía ngực', 12, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(37, 'Face Pulls', 'Kéo cable về phía mặt', 15, 'BEGINNER', 'Strength', NOW(), 'system', NOW(), 'system'),
(38, 'Farmers Walk', 'Đi bộ mang tạ nặng hai tay', 10, 'INTERMEDIATE', 'Strength', NOW(), 'system', NOW(), 'system'),
(39, 'Kettlebell Swings', 'Đung kettlebell từ dưới lên', 15, 'INTERMEDIATE', 'HIIT', NOW(), 'system', NOW(), 'system'),
(40, 'Turkish Get-Up', 'Động tác phức hợp từ nằm đứng lên', 8, 'ADVANCED', 'Functional', NOW(), 'system', NOW(), 'system'),

-- Core & Abs
(41, 'Russian Twists', 'Xoay người tập bụng chéo', 15, 'INTERMEDIATE', 'Core', NOW(), 'system', NOW(), 'system'),
(42, 'Leg Raises', 'Nâng chân tập bụng dưới', 12, 'INTERMEDIATE', 'Core', NOW(), 'system', NOW(), 'system'),
(43, 'Ab Wheel Rollout', 'Lăn bánh xe tập bụng', 10, 'ADVANCED', 'Core', NOW(), 'system', NOW(), 'system'),
(44, 'Bicycle Crunches', 'Gập bụng đạp xe', 20, 'BEGINNER', 'Core', NOW(), 'system', NOW(), 'system'),
(45, 'Hanging Knee Raises', 'Nâng đầu gối treo xà', 12, 'INTERMEDIATE', 'Core', NOW(), 'system', NOW(), 'system'),

-- More Cardio
(46, 'Stair Climbing', 'Leo cầu thang', 20, 'INTERMEDIATE', 'Cardio', NOW(), 'system', NOW(), 'system'),
(47, 'Jump Rope', 'Nhảy dây', 15, 'INTERMEDIATE', 'Cardio', NOW(), 'system', NOW(), 'system'),
(48, 'Swimming', 'Bơi lội', 45, 'INTERMEDIATE', 'Cardio', NOW(), 'system', NOW(), 'system'),
(49, 'Boxing', 'Đấm bốc', 30, 'INTERMEDIATE', 'HIIT', NOW(), 'system', NOW(), 'system'),
(50, 'Battle Ropes', 'Đánh dây battle rope', 10, 'ADVANCED', 'HIIT', NOW(), 'system', NOW(), 'system');

-- ============================================
-- 14.1 CONTRACTS (Membership Contracts)
-- Package 1 (Gói 1 Tháng Cơ Bản): NO_PT, 0 sessions
-- Package 2 (Gói 3 Tháng Tiêu Chuẩn): PT_INCLUDED, 12 sessions
-- Package 3 (Gói 6 Tháng Nâng Cao): PT_INCLUDED, 48 sessions
-- Package 4 (Gói VIP 12 Tháng): PT_INCLUDED, 120 sessions
-- Package 5 (Gói Học Sinh - Sinh Viên): NO_PT, 0 sessions
-- ============================================
INSERT INTO contracts (contract_id, member_id, package_id, main_pt_id, start_date, end_date, total_sessions, remaining_sessions, signed_at, status, created_at, created_by, updated_at, updated_by) VALUES
-- Active contracts with PT
(1, 1, 2, 1, '2026-01-01', '2026-03-31', 12, 9, '2025-12-28 10:30:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(2, 3, 3, 3, '2025-12-15', '2026-06-12', 48, 45, '2025-12-10 14:00:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(3, 5, 4, 2, '2025-10-01', '2026-09-30', 120, 78, '2025-09-25 09:15:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(4, 6, 2, 2, '2025-11-20', '2026-02-17', 12, 10, '2025-11-18 16:20:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(5, 7, 3, 1, '2025-09-15', '2026-03-14', 48, 32, '2025-09-10 11:45:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(6, 11, 4, 3, '2025-07-05', '2026-07-04', 120, 45, '2025-07-01 13:30:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(7, 12, 2, 1, '2025-12-20', '2026-03-19', 12, 11, '2025-12-18 15:00:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(8, 15, 3, 2, '2025-10-15', '2026-04-13', 48, 28, '2025-10-10 10:00:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(9, 17, 3, 3, '2025-09-25', '2026-03-23', 48, 30, '2025-09-20 14:30:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),

-- Active contracts without PT (basic packages)
(10, 2, 1, NULL, '2026-01-05', '2026-02-04', 0, 0, '2026-01-03 12:00:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(11, 4, 1, NULL, '2026-01-10', '2026-02-09', 0, 0, '2026-01-08 09:30:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(12, 10, 5, NULL, '2026-01-12', '2026-02-11', 0, 0, '2026-01-10 16:45:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(13, 16, 5, NULL, '2026-01-08', '2026-02-07', 0, 0, '2026-01-06 11:15:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),
(14, 14, 1, NULL, '2025-11-10', '2025-12-10', 0, 0, '2025-11-08 13:20:00', 'ACTIVE', NOW(), 'system', NOW(), 'system'),

-- Expired contracts
(15, 8, 1, NULL, '2024-12-01', '2024-12-31', 0, 0, '2024-11-28 10:00:00', 'EXPIRED', NOW(), 'system', NOW(), 'system'),
(16, 9, 2, 2, '2025-08-10', '2025-11-08', 12, 0, '2025-08-05 14:30:00', 'EXPIRED', NOW(), 'system', NOW(), 'system'),
(17, 13, 1, NULL, '2025-06-01', '2025-06-30', 0, 0, '2025-05-28 09:00:00', 'EXPIRED', NOW(), 'system', NOW(), 'system');

-- ============================================
-- 14.2 BOOKINGS (PT Session Bookings)
-- ============================================
INSERT INTO bookings (booking_id, member_id, contract_id, slot_id, real_pt_id, booking_date, created_at, created_by, updated_at, updated_by) VALUES
-- Member 1 bookings (with PT 1)
(1, 1, 1, 1, 1, '2026-01-20', NOW(), 'system', NOW(), 'system'),
(2, 1, 1, 2, 1, '2026-01-22', NOW(), 'system', NOW(), 'system'),
(3, 1, 1, 3, 1, '2026-01-24', NOW(), 'system', NOW(), 'system'),

-- Member 2 bookings (with PT 2)
(4, 2, 2, 6, 2, '2026-01-21', NOW(), 'system', NOW(), 'system'),
(5, 2, 2, 7, 2, '2026-01-23', NOW(), 'system', NOW(), 'system'),

-- Member 3 bookings (with PT 3)
(6, 3, 3, 9, 3, '2026-01-20', NOW(), 'system', NOW(), 'system'),
(7, 3, 3, 10, 3, '2026-01-22', NOW(), 'system', NOW(), 'system'),
(8, 3, 3, 11, 3, '2026-01-24', NOW(), 'system', NOW(), 'system'),

-- Member 4 bookings (with PT 1)
(9, 4, 4, 1, 1, '2026-01-21', NOW(), 'system', NOW(), 'system'),
(10, 4, 4, 2, 1, '2026-01-23', NOW(), 'system', NOW(), 'system'),

-- Member 5 VIP bookings (with PT 2)
(11, 5, 5, 6, 2, '2026-01-20', NOW(), 'system', NOW(), 'system'),
(12, 5, 5, 8, 2, '2026-01-22', NOW(), 'system', NOW(), 'system'),
(13, 5, 5, 7, 2, '2026-01-25', NOW(), 'system', NOW(), 'system'),
(14, 5, 5, 9, 3, '2026-01-26', NOW(), 'system', NOW(), 'system'),

-- Member 6 bookings (with PT 1)
(15, 6, 6, 1, 1, '2026-01-15', NOW(), 'system', NOW(), 'system'),
(16, 6, 6, 2, 1, '2026-01-17', NOW(), 'system', NOW(), 'system'),
(17, 6, 6, 3, 1, '2026-01-19', NOW(), 'system', NOW(), 'system'),

-- Member 7 bookings (with PT 2)
(18, 7, 7, 6, 2, '2026-01-14', NOW(), 'system', NOW(), 'system'),
(19, 7, 7, 7, 2, '2026-01-16', NOW(), 'system', NOW(), 'system'),
(20, 7, 7, 8, 2, '2026-01-18', NOW(), 'system', NOW(), 'system'),

-- Member 11 VIP bookings (with PT 3)
(21, 11, 11, 9, 3, '2026-01-15', NOW(), 'system', NOW(), 'system'),
(22, 11, 11, 10, 3, '2026-01-17', NOW(), 'system', NOW(), 'system'),
(23, 11, 11, 11, 3, '2026-01-19', NOW(), 'system', NOW(), 'system'),

-- Member 12 bookings (with PT 1)
(24, 12, 12, 1, 1, '2026-01-14', NOW(), 'system', NOW(), 'system'),
(25, 12, 12, 2, 1, '2026-01-16', NOW(), 'system', NOW(), 'system'),

-- Member 15 bookings (with PT 2)
(26, 15, 15, 6, 2, '2026-01-13', NOW(), 'system', NOW(), 'system'),
(27, 15, 15, 7, 2, '2026-01-15', NOW(), 'system', NOW(), 'system'),
(28, 15, 15, 8, 2, '2026-01-17', NOW(), 'system', NOW(), 'system'),

-- Member 17 bookings (with PT 3)
(29, 17, 17, 9, 3, '2026-01-14', NOW(), 'system', NOW(), 'system'),
(30, 17, 17, 10, 3, '2026-01-16', NOW(), 'system', NOW(), 'system');

-- ============================================
-- 15. DAILY DIETS (Diet Plans for Members)
-- ============================================
INSERT INTO daily_diets (diet_id, member_id, pt_id, diet_date, water_liters, note, created_at, created_by, updated_at, updated_by) VALUES
-- Member 1 diet plans (cutting phase)
(1, 1, 1, '2026-01-15', 2.5, 'Ngày 1 - Cutting diet', NOW(), 'system', NOW(), 'system'),
(2, 1, 1, '2026-01-16', 2.5, 'Ngày 2 - Cutting diet', NOW(), 'system', NOW(), 'system'),

-- Member 3 diet plans (bulking phase)
(3, 3, 3, '2026-01-15', 3.0, 'Ngày 1 - Bulking phase', NOW(), 'system', NOW(), 'system'),
(4, 3, 3, '2026-01-16', 3.0, 'Ngày 2 - Bulking phase', NOW(), 'system', NOW(), 'system'),

-- Member 5 VIP custom plan
(5, 5, 2, '2026-01-15', 2.8, 'VIP nutrition plan - Day 1', NOW(), 'system', NOW(), 'system');

-- ============================================
-- 16. DIET DETAILS (Meals in Diet Plans)
-- Note: diet_details uses composite key (diet_id, food_id)
-- ============================================
-- Member 1 - Day 1 (Cutting - 1800 kcal target)
INSERT INTO diet_details (diet_id, food_id, amount, prep_method, note, created_at, created_by, updated_at, updated_by) VALUES
-- Breakfast foods for diet 1
(1, 2, 150, 'Luộc', 'Bữa sáng - 3 trứng', NOW(), 'system', NOW(), 'system'),
(1, 7, 50, 'Nấu cháo', 'Bữa sáng - Yến mạch', NOW(), 'system', NOW(), 'system'),
(1, 12, 100, 'Tươi', 'Bữa sáng - Chuối', NOW(), 'system', NOW(), 'system'),

-- Lunch foods for diet 1
(1, 1, 150, 'Luộc', 'Bữa trưa - Ức gà', NOW(), 'system', NOW(), 'system'),
(1, 5, 150, 'Nấu chín', 'Bữa trưa - Cơm gạo lứt', NOW(), 'system', NOW(), 'system'),
(1, 9, 200, 'Hấp', 'Bữa trưa - Bông cải xanh', NOW(), 'system', NOW(), 'system'),

-- Dinner foods for diet 1
(1, 3, 150, 'Nướng', 'Bữa tối - Cá hồi', NOW(), 'system', NOW(), 'system'),
(1, 6, 200, 'Luộc', 'Bữa tối - Khoai lang', NOW(), 'system', NOW(), 'system'),
(1, 10, 150, 'Luộc', 'Bữa tối - Rau chân vịt', NOW(), 'system', NOW(), 'system'),

-- Snack for diet 1
(1, 13, 150, 'Tươi', 'Bữa phụ - Táo', NOW(), 'system', NOW(), 'system'),
(1, 16, 30, 'Rang', 'Bữa phụ - Hạnh nhân', NOW(), 'system', NOW(), 'system');

-- Member 1 - Day 2
INSERT INTO diet_details (diet_id, food_id, amount, prep_method, note, created_at, created_by, updated_at, updated_by) VALUES
(2, 2, 150, 'Luộc', 'Bữa sáng - Trứng', NOW(), 'system', NOW(), 'system'),
(2, 8, 80, 'Nướng', 'Bữa sáng - Bánh mì', NOW(), 'system', NOW(), 'system'),
(2, 15, 80, 'Tươi', 'Bữa sáng - Bơ', NOW(), 'system', NOW(), 'system'),

(2, 4, 150, 'Xào', 'Bữa trưa - Thịt bò', NOW(), 'system', NOW(), 'system'),
(2, 6, 200, 'Luộc', 'Bữa trưa - Khoai lang', NOW(), 'system', NOW(), 'system'),
(2, 11, 150, 'Tươi', 'Bữa trưa - Cà chua', NOW(), 'system', NOW(), 'system'),

(2, 1, 180, 'Luộc', 'Bữa tối - Ức gà', NOW(), 'system', NOW(), 'system'),
(2, 5, 120, 'Nấu chín', 'Bữa tối - Cơm gạo lứt', NOW(), 'system', NOW(), 'system'),
(2, 9, 200, 'Hấp', 'Bữa tối - Bông cải xanh', NOW(), 'system', NOW(), 'system'),

(2, 19, 200, 'Tươi', 'Bữa phụ - Sữa chua', NOW(), 'system', NOW(), 'system'),
(2, 14, 150, 'Tươi', 'Bữa phụ - Cam', NOW(), 'system', NOW(), 'system');

-- Member 3 - Day 1 (Bulking - 3000 kcal target)
INSERT INTO diet_details (diet_id, food_id, amount, prep_method, note, created_at, created_by, updated_at, updated_by) VALUES
(3, 2, 200, 'Luộc', 'Bữa sáng - 4 trứng', NOW(), 'system', NOW(), 'system'),
(3, 7, 100, 'Nấu cháo', 'Bữa sáng - Yến mạch', NOW(), 'system', NOW(), 'system'),
(3, 12, 150, 'Tươi', 'Bữa sáng - Chuối', NOW(), 'system', NOW(), 'system'),
(3, 18, 250, 'Tươi', 'Bữa sáng - Sữa', NOW(), 'system', NOW(), 'system'),

(3, 1, 250, 'Luộc', 'Bữa trưa - Ức gà nhiều', NOW(), 'system', NOW(), 'system'),
(3, 5, 250, 'Nấu chín', 'Bữa trưa - Cơm nhiều', NOW(), 'system', NOW(), 'system'),
(3, 9, 200, 'Hấp', 'Bữa trưa - Bông cải xanh', NOW(), 'system', NOW(), 'system'),
(3, 15, 50, 'Tươi', 'Bữa trưa - Bơ', NOW(), 'system', NOW(), 'system'),

(3, 4, 200, 'Nướng', 'Bữa tối - Thịt bò', NOW(), 'system', NOW(), 'system'),
(3, 6, 300, 'Luộc', 'Bữa tối - Khoai lang nhiều', NOW(), 'system', NOW(), 'system'),
(3, 10, 200, 'Luộc', 'Bữa tối - Rau chân vịt', NOW(), 'system', NOW(), 'system'),

(3, 16, 50, 'Rang', 'Bữa phụ - Hạnh nhân', NOW(), 'system', NOW(), 'system'),
(3, 20, 150, 'Tươi', 'Bữa phụ - Phô mai cottage', NOW(), 'system', NOW(), 'system');

-- Member 5 VIP - Day 1
INSERT INTO diet_details (diet_id, food_id, amount, prep_method, note, created_at, created_by, updated_at, updated_by) VALUES
(5, 2, 180, 'Luộc', 'Bữa sáng VIP - Trứng', NOW(), 'system', NOW(), 'system'),
(5, 7, 80, 'Nấu cháo', 'Bữa sáng VIP - Yến mạch', NOW(), 'system', NOW(), 'system'),
(5, 14, 150, 'Vắt tươi', 'Bữa sáng VIP - Cam', NOW(), 'system', NOW(), 'system'),
(5, 19, 150, 'Tươi', 'Bữa sáng VIP - Sữa chua Hy Lạp', NOW(), 'system', NOW(), 'system'),

(5, 3, 200, 'Nướng', 'Bữa trưa VIP - Cá hồi', NOW(), 'system', NOW(), 'system'),
(5, 5, 200, 'Nấu chín', 'Bữa trưa VIP - Cơm gạo lứt', NOW(), 'system', NOW(), 'system'),
(5, 9, 200, 'Hấp', 'Bữa trưa VIP - Bông cải xanh', NOW(), 'system', NOW(), 'system'),
(5, 15, 60, 'Tươi', 'Bữa trưa VIP - Bơ', NOW(), 'system', NOW(), 'system'),

(5, 1, 200, 'Luộc', 'Bữa tối VIP - Ức gà', NOW(), 'system', NOW(), 'system'),
(5, 6, 250, 'Luộc', 'Bữa tối VIP - Khoai lang', NOW(), 'system', NOW(), 'system'),
(5, 10, 150, 'Luộc', 'Bữa tối VIP - Rau chân vịt', NOW(), 'system', NOW(), 'system'),

(5, 16, 40, 'Rang', 'Bữa phụ VIP - Hạnh nhân', NOW(), 'system', NOW(), 'system'),
(5, 13, 150, 'Tươi', 'Bữa phụ VIP - Táo', NOW(), 'system', NOW(), 'system');

-- ============================================
-- 17. INVOICES (Payment Records)
-- ============================================
INSERT INTO invoices (invoice_id, member_id, total_amount, discount_amount, final_amount, payment_method, payment_status, status, created_at, created_by, updated_at, updated_by) VALUES
-- PAID invoices
(1, 1, 1300000, 0, 1300000, 'CREDIT_CARD', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(2, 2, 500000, 0, 500000, 'CASH', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(3, 3, 2300000, 0, 2300000, 'BANK_TRANSFER', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(4, 4, 500000, 0, 500000, 'CASH', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(5, 5, 4200000, 0, 4200000, 'CREDIT_CARD', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(6, 6, 1300000, 0, 1300000, 'BANK_TRANSFER', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(7, 7, 2300000, 0, 2300000, 'CREDIT_CARD', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(8, 9, 1300000, 0, 1300000, 'CASH', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(9, 10, 350000, 0, 350000, 'CASH', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(10, 11, 4200000, 0, 4200000, 'BANK_TRANSFER', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(11, 12, 1300000, 0, 1300000, 'CREDIT_CARD', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(12, 15, 2300000, 0, 2300000, 'BANK_TRANSFER', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(13, 16, 350000, 0, 350000, 'CASH', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),
(14, 17, 2300000, 0, 2300000, 'CREDIT_CARD', 'PAID', 'COMPLETED', NOW(), 'system', NOW(), 'system'),

-- UNPAID invoices (with debt)
(15, 8, 500000, 0, 500000, NULL, 'UNPAID', 'PENDING', NOW(), 'system', NOW(), 'system'),
(16, 13, 1000000, 0, 1000000, NULL, 'UNPAID', 'PENDING', NOW(), 'system', NOW(), 'system'),
(17, 14, 500000, 0, 500000, NULL, 'UNPAID', 'PENDING', NOW(), 'system', NOW(), 'system'),

-- Partially paid (using UNPAID status with partial amount)
(18, 7, 200000, 0, 200000, 'CASH', 'UNPAID', 'PENDING', NOW(), 'system', NOW(), 'system');

-- ============================================
-- 18. CHECK-IN LOGS
-- ============================================
INSERT INTO checkin_logs (checkin_id, member_id, checkin_time, created_at, created_by, updated_at, updated_by) VALUES
-- Recent check-ins for active members
(1, 1, '2026-01-19 08:30:00', NOW(), 'system', NOW(), 'system'),
(2, 1, '2026-01-18 09:15:00', NOW(), 'system', NOW(), 'system'),
(3, 1, '2026-01-17 08:45:00', NOW(), 'system', NOW(), 'system'),
(4, 2, '2026-01-19 18:00:00', NOW(), 'system', NOW(), 'system'),
(5, 2, '2026-01-18 17:30:00', NOW(), 'system', NOW(), 'system'),
(6, 3, '2026-01-19 07:00:00', NOW(), 'system', NOW(), 'system'),
(7, 3, '2026-01-18 07:15:00', NOW(), 'system', NOW(), 'system'),
(8, 3, '2026-01-17 07:00:00', NOW(), 'system', NOW(), 'system'),
(9, 3, '2026-01-16 07:30:00', NOW(), 'system', NOW(), 'system'),
(10, 4, '2026-01-19 19:00:00', NOW(), 'system', NOW(), 'system'),
(11, 5, '2026-01-19 06:30:00', NOW(), 'system', NOW(), 'system'),
(12, 5, '2026-01-18 06:45:00', NOW(), 'system', NOW(), 'system'),
(13, 5, '2026-01-17 06:30:00', NOW(), 'system', NOW(), 'system'),
(14, 5, '2026-01-16 06:50:00', NOW(), 'system', NOW(), 'system'),
(15, 5, '2026-01-15 06:30:00', NOW(), 'system', NOW(), 'system'),
(16, 6, '2026-01-19 16:00:00', NOW(), 'system', NOW(), 'system'),
(17, 6, '2026-01-18 15:45:00', NOW(), 'system', NOW(), 'system'),
(18, 7, '2026-01-19 10:30:00', NOW(), 'system', NOW(), 'system'),
(19, 7, '2026-01-18 10:15:00', NOW(), 'system', NOW(), 'system'),
(20, 7, '2026-01-17 10:45:00', NOW(), 'system', NOW(), 'system'),
(21, 9, '2026-01-19 14:00:00', NOW(), 'system', NOW(), 'system'),
(22, 9, '2026-01-18 13:45:00', NOW(), 'system', NOW(), 'system'),
(23, 10, '2026-01-19 17:00:00', NOW(), 'system', NOW(), 'system'),
(24, 11, '2026-01-19 20:00:00', NOW(), 'system', NOW(), 'system'),
(25, 11, '2026-01-18 19:45:00', NOW(), 'system', NOW(), 'system'),
(26, 11, '2026-01-17 20:15:00', NOW(), 'system', NOW(), 'system'),
(27, 12, '2026-01-19 11:30:00', NOW(), 'system', NOW(), 'system'),
(28, 12, '2026-01-18 11:00:00', NOW(), 'system', NOW(), 'system'),
(29, 14, '2026-01-19 15:30:00', NOW(), 'system', NOW(), 'system'),
(30, 15, '2026-01-19 09:00:00', NOW(), 'system', NOW(), 'system'),
(31, 15, '2026-01-18 08:45:00', NOW(), 'system', NOW(), 'system'),
(32, 15, '2026-01-17 09:15:00', NOW(), 'system', NOW(), 'system'),
(33, 16, '2026-01-19 18:30:00', NOW(), 'system', NOW(), 'system'),
(34, 17, '2026-01-19 12:00:00', NOW(), 'system', NOW(), 'system'),
(35, 17, '2026-01-18 12:15:00', NOW(), 'system', NOW(), 'system'),
(36, 17, '2026-01-17 11:45:00', NOW(), 'system', NOW(), 'system');

-- ============================================
-- 19. ADDITIONAL BODY METRICS
-- ============================================
INSERT INTO body_metrics (metric_id, member_id, measured_date, weight, height, body_fat_percentage, muscle_mass, bmi, measured_by, created_at, created_by, updated_at, updated_by) VALUES
-- Existing metrics (1-12 already in file)

-- Member 2 additional progress
(13, 2, '2026-01-19', 66.8, 165, 27.2, 46.0, 24.54, 3, NOW(), 'system', NOW(), 'system'),

-- Member 4 progress
(14, 4, '2026-01-10', 72.0, 168, 24.5, 52.0, 25.51, 2, NOW(), 'system', NOW(), 'system'),
(15, 4, '2026-01-17', 71.3, 168, 23.8, 52.6, 25.26, 2, NOW(), 'system', NOW(), 'system'),

-- Member 6 progress
(16, 6, '2025-11-20', 58.5, 162, 26.0, 42.5, 22.30, 3, NOW(), 'system', NOW(), 'system'),
(17, 6, '2025-12-20', 57.8, 162, 25.2, 42.9, 22.03, 3, NOW(), 'system', NOW(), 'system'),
(18, 6, '2026-01-19', 57.2, 162, 24.5, 43.3, 21.80, 3, NOW(), 'system', NOW(), 'system'),

-- Member 7 progress
(19, 7, '2025-09-15', 95.0, 182, 28.0, 65.0, 28.68, 4, NOW(), 'system', NOW(), 'system'),
(20, 7, '2025-10-15', 92.5, 182, 26.5, 66.2, 27.92, 4, NOW(), 'system', NOW(), 'system'),
(21, 7, '2025-11-15', 90.2, 182, 25.0, 67.0, 27.23, 4, NOW(), 'system', NOW(), 'system'),
(22, 7, '2025-12-15', 88.5, 182, 23.8, 67.5, 26.72, 4, NOW(), 'system', NOW(), 'system'),
(23, 7, '2026-01-15', 87.0, 182, 22.5, 67.8, 26.26, 4, NOW(), 'system', NOW(), 'system'),

-- Member 9 progress
(24, 9, '2025-08-10', 78.0, 175, 19.5, 60.5, 25.47, 2, NOW(), 'system', NOW(), 'system'),
(25, 9, '2025-09-10', 79.5, 175, 18.8, 62.0, 25.96, 2, NOW(), 'system', NOW(), 'system'),
(26, 9, '2025-10-10', 81.0, 175, 18.2, 63.5, 26.45, 2, NOW(), 'system', NOW(), 'system'),

-- Member 10 progress
(27, 10, '2026-01-12', 52.0, 158, 22.0, 40.0, 20.83, 3, NOW(), 'system', NOW(), 'system'),

-- Member 11 progress
(28, 11, '2025-07-05', 88.0, 180, 20.0, 68.0, 27.16, 4, NOW(), 'system', NOW(), 'system'),
(29, 11, '2025-08-05', 89.5, 180, 19.5, 69.5, 27.62, 4, NOW(), 'system', NOW(), 'system'),
(30, 11, '2025-09-05', 91.0, 180, 19.0, 71.0, 28.09, 4, NOW(), 'system', NOW(), 'system'),
(31, 11, '2025-10-05', 92.2, 180, 18.5, 72.2, 28.46, 4, NOW(), 'system', NOW(), 'system'),
(32, 11, '2025-11-05', 93.5, 180, 18.0, 73.5, 28.86, 4, NOW(), 'system', NOW(), 'system'),
(33, 11, '2025-12-05', 94.8, 180, 17.8, 74.5, 29.26, 4, NOW(), 'system', NOW(), 'system'),
(34, 11, '2026-01-05', 96.0, 180, 17.5, 75.5, 29.63, 4, NOW(), 'system', NOW(), 'system'),

-- Member 12 progress
(35, 12, '2025-12-20', 61.0, 170, 28.0, 43.0, 21.11, 2, NOW(), 'system', NOW(), 'system'),
(36, 12, '2026-01-19', 60.2, 170, 27.2, 43.5, 20.83, 2, NOW(), 'system', NOW(), 'system'),

-- Member 14 progress
(37, 14, '2025-11-10', 65.0, 163, 30.0, 44.0, 24.46, 3, NOW(), 'system', NOW(), 'system'),
(38, 14, '2025-12-10', 64.0, 163, 29.2, 44.5, 24.09, 3, NOW(), 'system', NOW(), 'system'),

-- Member 15 progress
(39, 15, '2025-10-15', 70.0, 172, 23.0, 52.0, 23.66, 2, NOW(), 'system', NOW(), 'system'),
(40, 15, '2025-11-15', 71.5, 172, 22.0, 54.0, 24.17, 2, NOW(), 'system', NOW(), 'system'),
(41, 15, '2025-12-15', 73.0, 172, 21.0, 56.0, 24.68, 2, NOW(), 'system', NOW(), 'system'),
(42, 15, '2026-01-15', 74.2, 172, 20.5, 57.2, 25.09, 2, NOW(), 'system', NOW(), 'system'),

-- Member 16 progress
(43, 16, '2026-01-08', 48.0, 155, 24.0, 36.0, 19.98, 3, NOW(), 'system', NOW(), 'system'),

-- Member 17 progress
(44, 17, '2025-09-25', 85.0, 178, 22.0, 64.0, 26.83, 4, NOW(), 'system', NOW(), 'system'),
(45, 17, '2025-10-25', 86.5, 178, 21.5, 65.5, 27.31, 4, NOW(), 'system', NOW(), 'system'),
(46, 17, '2025-11-25', 88.0, 178, 21.0, 67.0, 27.78, 4, NOW(), 'system', NOW(), 'system'),
(47, 17, '2025-12-25', 89.2, 178, 20.5, 68.2, 28.16, 4, NOW(), 'system', NOW(), 'system'),
(48, 17, '2026-01-19', 90.5, 178, 20.0, 69.5, 28.57, 4, NOW(), 'system', NOW(), 'system');

-- ============================================
-- END OF MOCK DATA
-- ============================================

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS=1;

-- Summary
SELECT 
    'Mock data inserted successfully!' as message,
    (SELECT COUNT(*) FROM roles) as roles,
    (SELECT COUNT(*) FROM permissions) as permissions,
    (SELECT COUNT(*) FROM users) as users,
    (SELECT COUNT(*) FROM service_packages) as packages,
    (SELECT COUNT(*) FROM additional_services) as services,
    (SELECT COUNT(*) FROM personal_trainers) as pts,
    (SELECT COUNT(*) FROM members) as members,
    (SELECT COUNT(*) FROM slots) as slots,
    (SELECT COUNT(*) FROM available_slots) as available_slots,
    (SELECT COUNT(*) FROM body_metrics) as body_metrics,
    (SELECT COUNT(*) FROM foods) as foods,
    (SELECT COUNT(*) FROM workout_devices) as devices,
    (SELECT COUNT(*) FROM workouts) as workouts,
    (SELECT COUNT(*) FROM contracts) as contracts,
    (SELECT COUNT(*) FROM bookings) as bookings,
    (SELECT COUNT(*) FROM invoices) as invoices,
    (SELECT COUNT(*) FROM checkin_logs) as checkin_logs,
    (SELECT COUNT(*) FROM daily_diets) as diets,
    (SELECT COUNT(*) FROM diet_details) as diet_details;
