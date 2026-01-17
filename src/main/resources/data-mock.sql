-- ============================================
-- MOCK DATA FOR GYM & PT MANAGEMENT SYSTEM
-- Generated: 2026-01-17
-- Purpose: Test data for development and testing
-- Database: PostgreSQL
-- Note: For MySQL version, use data-mock-mysql.sql
-- ============================================

-- Clear existing data (reverse order of FK dependencies)
DELETE FROM diet_detail;

DELETE FROM daily_diet;

DELETE FROM food;

DELETE FROM body_metrics;

DELETE FROM available_slot;

DELETE FROM slot;

DELETE FROM member;

DELETE FROM personal_trainer;

DELETE FROM workout;

DELETE FROM workout_device;

DELETE FROM additional_service;

DELETE FROM service_package;

DELETE FROM role_permission;

DELETE FROM users;

DELETE FROM permission;

DELETE FROM role;

-- ============================================
-- 1. ROLES
-- ============================================
INSERT INTO
    role (
        role_id,
        name,
        description,
        active,
        created_at,
        created_by
    )
VALUES (
        1,
        'ADMIN',
        'System Administrator - Full access',
        true,
        NOW(),
        'system'
    ),
    (
        2,
        'MANAGER',
        'Gym Manager - Manage staff and operations',
        true,
        NOW(),
        'system'
    ),
    (
        3,
        'PERSONAL_TRAINER',
        'Personal Trainer - Manage training sessions',
        true,
        NOW(),
        'system'
    ),
    (
        4,
        'MEMBER',
        'Gym Member - Basic access',
        true,
        NOW(),
        'system'
    ),
    (
        5,
        'RECEPTIONIST',
        'Receptionist - Handle check-ins',
        true,
        NOW(),
        'system'
    );

-- ============================================
-- 2. PERMISSIONS
-- ============================================
INSERT INTO
    permission (
        permission_id,
        name,
        api_path,
        method,
        module,
        created_at,
        created_by
    )
VALUES
    -- User Management
    (
        1,
        'VIEW_USERS',
        '/api/v1/users',
        'GET',
        'USER_MANAGEMENT',
        NOW(),
        'system'
    ),
    (
        2,
        'CREATE_USER',
        '/api/v1/users',
        'POST',
        'USER_MANAGEMENT',
        NOW(),
        'system'
    ),
    (
        3,
        'UPDATE_USER',
        '/api/v1/users/*',
        'PUT',
        'USER_MANAGEMENT',
        NOW(),
        'system'
    ),
    (
        4,
        'DELETE_USER',
        '/api/v1/users/*',
        'DELETE',
        'USER_MANAGEMENT',
        NOW(),
        'system'
    ),

-- Member Management
(
    5,
    'VIEW_MEMBERS',
    '/api/v1/members',
    'GET',
    'MEMBER_MANAGEMENT',
    NOW(),
    'system'
),
(
    6,
    'CREATE_MEMBER',
    '/api/v1/members',
    'POST',
    'MEMBER_MANAGEMENT',
    NOW(),
    'system'
),
(
    7,
    'UPDATE_MEMBER',
    '/api/v1/members/*',
    'PUT',
    'MEMBER_MANAGEMENT',
    NOW(),
    'system'
),
(
    8,
    'DELETE_MEMBER',
    '/api/v1/members/*',
    'DELETE',
    'MEMBER_MANAGEMENT',
    NOW(),
    'system'
),

-- PT Management
(
    9,
    'VIEW_PT',
    '/api/v1/personal-trainers',
    'GET',
    'PT_MANAGEMENT',
    NOW(),
    'system'
),
(
    10,
    'CREATE_PT',
    '/api/v1/personal-trainers',
    'POST',
    'PT_MANAGEMENT',
    NOW(),
    'system'
),
(
    11,
    'UPDATE_PT',
    '/api/v1/personal-trainers/*',
    'PUT',
    'PT_MANAGEMENT',
    NOW(),
    'system'
),
(
    12,
    'DELETE_PT',
    '/api/v1/personal-trainers/*',
    'DELETE',
    'PT_MANAGEMENT',
    NOW(),
    'system'
),

-- Service Package Management
(
    13,
    'VIEW_PACKAGES',
    '/api/v1/service-packages',
    'GET',
    'PACKAGE_MANAGEMENT',
    NOW(),
    'system'
),
(
    14,
    'CREATE_PACKAGE',
    '/api/v1/service-packages',
    'POST',
    'PACKAGE_MANAGEMENT',
    NOW(),
    'system'
),
(
    15,
    'UPDATE_PACKAGE',
    '/api/v1/service-packages/*',
    'PUT',
    'PACKAGE_MANAGEMENT',
    NOW(),
    'system'
),
(
    16,
    'DELETE_PACKAGE',
    '/api/v1/service-packages/*',
    'DELETE',
    'PACKAGE_MANAGEMENT',
    NOW(),
    'system'
),

-- Workout Management
(
    17,
    'VIEW_WORKOUTS',
    '/api/v1/workouts',
    'GET',
    'WORKOUT_MANAGEMENT',
    NOW(),
    'system'
),
(
    18,
    'CREATE_WORKOUT',
    '/api/v1/workouts',
    'POST',
    'WORKOUT_MANAGEMENT',
    NOW(),
    'system'
),
(
    19,
    'UPDATE_WORKOUT',
    '/api/v1/workouts/*',
    'PUT',
    'WORKOUT_MANAGEMENT',
    NOW(),
    'system'
),
(
    20,
    'DELETE_WORKOUT',
    '/api/v1/workouts/*',
    'DELETE',
    'WORKOUT_MANAGEMENT',
    NOW(),
    'system'
),

-- Food Management
(
    21,
    'VIEW_FOODS',
    '/api/v1/foods',
    'GET',
    'FOOD_MANAGEMENT',
    NOW(),
    'system'
),
(
    22,
    'CREATE_FOOD',
    '/api/v1/foods',
    'POST',
    'FOOD_MANAGEMENT',
    NOW(),
    'system'
),
(
    23,
    'UPDATE_FOOD',
    '/api/v1/foods/*',
    'PUT',
    'FOOD_MANAGEMENT',
    NOW(),
    'system'
),
(
    24,
    'DELETE_FOOD',
    '/api/v1/foods/*',
    'DELETE',
    'FOOD_MANAGEMENT',
    NOW(),
    'system'
);

-- ============================================
-- 3. ROLE-PERMISSION MAPPINGS
-- ============================================
-- Admin: All permissions
INSERT INTO
    role_permission (role_id, permission_id)
SELECT 1, permission_id
FROM permission;

-- Manager: Most permissions except user deletion
INSERT INTO
    role_permission (role_id, permission_id)
VALUES (2, 1),
    (2, 2),
    (2, 3),
    (2, 5),
    (2, 6),
    (2, 7),
    (2, 8),
    (2, 9),
    (2, 10),
    (2, 11),
    (2, 13),
    (2, 14),
    (2, 15),
    (2, 16),
    (2, 17),
    (2, 18),
    (2, 19),
    (2, 21),
    (2, 22),
    (2, 23);

-- PT: View and manage workouts, foods, own profile
INSERT INTO
    role_permission (role_id, permission_id)
VALUES (3, 1),
    (3, 5),
    (3, 9),
    (3, 17),
    (3, 18),
    (3, 19),
    (3, 21),
    (3, 22),
    (3, 23);

-- Member: View only
INSERT INTO
    role_permission (role_id, permission_id)
VALUES (4, 1),
    (4, 5),
    (4, 9),
    (4, 13),
    (4, 17),
    (4, 21);

-- Receptionist: Member and basic management
INSERT INTO
    role_permission (role_id, permission_id)
VALUES (5, 1),
    (5, 5),
    (5, 6),
    (5, 7),
    (5, 9),
    (5, 13);

-- ============================================
-- 4. USERS (password: "123456" - BCrypt hashed)
-- ============================================
INSERT INTO
    users (
        user_id,
        password_hash,
        fullname,
        email,
        phone_number,
        status,
        gender,
        dob,
        role_id,
        created_at,
        created_by
    )
VALUES
    -- Admins
    (
        1,
        '$2a$10$DK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qY',
        'Admin User',
        'admin@gym.com',
        '0901000001',
        'ACTIVE',
        'MALE',
        '1985-01-15',
        1,
        NOW(),
        'system'
    ),

-- Managers
(
    2,
    '$2a$10$DK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qY',
    'Nguyễn Văn Quản Lý',
    'manager@gym.com',
    '0902000001',
    'ACTIVE',
    'MALE',
    '1988-03-20',
    2,
    NOW(),
    'system'
),

-- Personal Trainers
(
    3,
    '$2a$10$DK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qY',
    'Trần Minh PT',
    'pt1@gym.com',
    '0903000001',
    'ACTIVE',
    'MALE',
    '1990-05-12',
    3,
    NOW(),
    'system'
),
(
    4,
    '$2a$10$DK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qY',
    'Lê Thị PT',
    'pt2@gym.com',
    '0903000002',
    'ACTIVE',
    'FEMALE',
    '1992-08-25',
    3,
    NOW(),
    'system'
),
(
    5,
    '$2a$10$DK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qY',
    'Phạm Văn PT',
    'pt3@gym.com',
    '0903000003',
    'ACTIVE',
    'MALE',
    '1991-11-30',
    3,
    NOW(),
    'system'
),

-- Members
(
    6,
    '$2a$10$DK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qY',
    'Nguyễn Văn A',
    'member1@gmail.com',
    '0904000001',
    'ACTIVE',
    'MALE',
    '1995-02-14',
    4,
    NOW(),
    'system'
),
(
    7,
    '$2a$10$DK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qY',
    'Trần Thị B',
    'member2@gmail.com',
    '0904000002',
    'ACTIVE',
    'FEMALE',
    '1997-06-20',
    4,
    NOW(),
    'system'
),
(
    8,
    '$2a$10$DK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qY',
    'Lê Văn C',
    'member3@gmail.com',
    '0904000003',
    'ACTIVE',
    'MALE',
    '1996-09-10',
    4,
    NOW(),
    'system'
),
(
    9,
    '$2a$10$DK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qY',
    'Phạm Thị D',
    'member4@gmail.com',
    '0904000004',
    'ACTIVE',
    'FEMALE',
    '1998-12-05',
    4,
    NOW(),
    'system'
),
(
    10,
    '$2a$10$DK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qY',
    'Hoàng Văn E',
    'member5@gmail.com',
    '0904000005',
    'ACTIVE',
    'MALE',
    '1994-03-18',
    4,
    NOW(),
    'system'
),

-- Receptionists
(
    11,
    '$2a$10$DK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qYx5F5Y0F5YOK8P8xN5V3qY',
    'Vũ Thị Lễ Tân',
    'reception@gym.com',
    '0905000001',
    'ACTIVE',
    'FEMALE',
    '1999-07-22',
    5,
    NOW(),
    'system'
);

-- ============================================
-- 5. SERVICE PACKAGES
-- ============================================
INSERT INTO
    service_package (
        package_id,
        name,
        description,
        duration_days,
        price,
        discount,
        final_price,
        active,
        package_type,
        created_at,
        created_by
    )
VALUES (
        1,
        'Gói 1 Tháng Cơ Bản',
        'Truy cập phòng gym cơ bản, không bao gồm PT',
        30,
        500000,
        0,
        500000,
        true,
        'BASIC',
        NOW(),
        'system'
    ),
    (
        2,
        'Gói 3 Tháng Tiêu Chuẩn',
        'Truy cập phòng gym + 4 buổi PT/tháng',
        90,
        1400000,
        100000,
        1300000,
        true,
        'STANDARD',
        NOW(),
        'system'
    ),
    (
        3,
        'Gói 6 Tháng Nâng Cao',
        'Truy cập phòng gym + 8 buổi PT/tháng + Nutrition plan',
        180,
        2600000,
        300000,
        2300000,
        true,
        'PREMIUM',
        NOW(),
        'system'
    ),
    (
        4,
        'Gói VIP 12 Tháng',
        'Full access + Unlimited PT + Nutrition + Supplements',
        365,
        5000000,
        800000,
        4200000,
        true,
        'VIP',
        NOW(),
        'system'
    ),
    (
        5,
        'Gói Học Sinh - Sinh Viên',
        'Gói đặc biệt cho HSSV (yêu cầu thẻ)',
        30,
        350000,
        0,
        350000,
        true,
        'STUDENT',
        NOW(),
        'system'
    );

-- ============================================
-- 6. ADDITIONAL SERVICES
-- ============================================
INSERT INTO
    additional_service (
        service_id,
        name,
        description,
        price,
        active,
        created_at,
        created_by
    )
VALUES (
        1,
        'Khóa Tủ Cá Nhân',
        'Cho thuê khóa tủ cá nhân theo tháng',
        50000,
        true,
        NOW(),
        'system'
    ),
    (
        2,
        'Khăn Tắm',
        'Dịch vụ khăn tắm sạch mỗi buổi tập',
        30000,
        true,
        NOW(),
        'system'
    ),
    (
        3,
        'Nước Uống Miễn Phí',
        'Nước khoáng/nước lọc không giới hạn',
        0,
        true,
        NOW(),
        'system'
    ),
    (
        4,
        'Phân Tích Body Composition',
        'Đo và phân tích thành phần cơ thể (InBody)',
        100000,
        true,
        NOW(),
        'system'
    ),
    (
        5,
        'Tư Vấn Dinh Dưỡng',
        'Buổi tư vấn dinh dưỡng 1-1 với chuyên gia',
        200000,
        true,
        NOW(),
        'system'
    ),
    (
        6,
        'Massage Phục Hồi',
        'Massage thể thao 30 phút',
        150000,
        true,
        NOW(),
        'system'
    ),
    (
        7,
        'Sauna/Steam Room',
        'Truy cập phòng xông hơi',
        80000,
        true,
        NOW(),
        'system'
    );

-- ============================================
-- 7. PERSONAL TRAINERS
-- ============================================
INSERT INTO
    personal_trainer (
        pt_id,
        user_id,
        specialization,
        experience_years,
        hourly_rate,
        bio,
        rating,
        total_reviews,
        status,
        created_at,
        created_by
    )
VALUES (
        1,
        3,
        'Bodybuilding & Strength Training',
        5,
        200000,
        'Chuyên về tăng cơ và sức mạnh, từng thi đấu Bodybuilding cấp quốc gia',
        4.8,
        120,
        'ACTIVE',
        NOW(),
        'system'
    ),
    (
        2,
        4,
        'Weight Loss & Cardio',
        3,
        180000,
        'Chuyên giảm cân và cardio, giúp hơn 100 học viên đạt mục tiêu',
        4.9,
        95,
        'ACTIVE',
        NOW(),
        'system'
    ),
    (
        3,
        5,
        'Functional Training & CrossFit',
        4,
        190000,
        'Huấn luyện viên CrossFit Level 2, chuyên functional fitness',
        4.7,
        78,
        'ACTIVE',
        NOW(),
        'system'
    );

-- ============================================
-- 8. MEMBERS
-- ============================================
INSERT INTO
    member (
        member_id,
        user_id,
        membership_start,
        membership_end,
        package_id,
        emergency_contact,
        health_notes,
        status,
        total_spent,
        created_at,
        created_by
    )
VALUES (
        1,
        6,
        '2026-01-01',
        '2026-04-01',
        2,
        '0987654321',
        'Không có vấn đề sức khỏe đặc biệt',
        'ACTIVE',
        1300000,
        NOW(),
        'system'
    ),
    (
        2,
        7,
        '2026-01-05',
        '2026-02-05',
        1,
        '0987654322',
        'Huyết áp cao nhẹ, tránh tập quá nặng',
        'ACTIVE',
        500000,
        NOW(),
        'system'
    ),
    (
        3,
        8,
        '2025-12-15',
        '2026-06-15',
        3,
        '0987654323',
        NULL,
        'ACTIVE',
        2300000,
        NOW(),
        'system'
    ),
    (
        4,
        9,
        '2026-01-10',
        '2026-02-10',
        1,
        '0987654324',
        'Đau lưng nhẹ',
        'ACTIVE',
        500000,
        NOW(),
        'system'
    ),
    (
        5,
        10,
        '2025-10-01',
        '2026-10-01',
        4,
        '0987654325',
        'VIP member, có private locker',
        'ACTIVE',
        4200000,
        NOW(),
        'system'
    );

-- ============================================
-- 9. SLOTS (Training Time Slots)
-- ============================================
INSERT INTO
    slot (
        slot_id,
        start_time,
        end_time,
        active,
        created_at,
        created_by
    )
VALUES (
        1,
        '06:00:00',
        '07:00:00',
        true,
        NOW(),
        'system'
    ),
    (
        2,
        '07:00:00',
        '08:00:00',
        true,
        NOW(),
        'system'
    ),
    (
        3,
        '08:00:00',
        '09:00:00',
        true,
        NOW(),
        'system'
    ),
    (
        4,
        '09:00:00',
        '10:00:00',
        true,
        NOW(),
        'system'
    ),
    (
        5,
        '10:00:00',
        '11:00:00',
        true,
        NOW(),
        'system'
    ),
    (
        6,
        '14:00:00',
        '15:00:00',
        true,
        NOW(),
        'system'
    ),
    (
        7,
        '15:00:00',
        '16:00:00',
        true,
        NOW(),
        'system'
    ),
    (
        8,
        '16:00:00',
        '17:00:00',
        true,
        NOW(),
        'system'
    ),
    (
        9,
        '17:00:00',
        '18:00:00',
        true,
        NOW(),
        'system'
    ),
    (
        10,
        '18:00:00',
        '19:00:00',
        true,
        NOW(),
        'system'
    ),
    (
        11,
        '19:00:00',
        '20:00:00',
        true,
        NOW(),
        'system'
    ),
    (
        12,
        '20:00:00',
        '21:00:00',
        true,
        NOW(),
        'system'
    );

-- ============================================
-- 10. AVAILABLE SLOTS (PT Availability)
-- ============================================
-- PT 1 (Trần Minh) - Available morning slots
INSERT INTO
    available_slot (
        available_slot_id,
        pt_id,
        slot_id,
        day_of_week,
        status,
        created_at,
        created_by
    )
VALUES (
        1,
        1,
        1,
        'MONDAY',
        'AVAILABLE',
        NOW(),
        'system'
    ),
    (
        2,
        1,
        2,
        'MONDAY',
        'AVAILABLE',
        NOW(),
        'system'
    ),
    (
        3,
        1,
        3,
        'MONDAY',
        'AVAILABLE',
        NOW(),
        'system'
    ),
    (
        4,
        1,
        1,
        'WEDNESDAY',
        'AVAILABLE',
        NOW(),
        'system'
    ),
    (
        5,
        1,
        2,
        'WEDNESDAY',
        'AVAILABLE',
        NOW(),
        'system'
    ),
    (
        6,
        1,
        1,
        'FRIDAY',
        'AVAILABLE',
        NOW(),
        'system'
    ),

-- PT 2 (Lê Thị) - Available afternoon slots
(
    7,
    2,
    6,
    'TUESDAY',
    'AVAILABLE',
    NOW(),
    'system'
),
(
    8,
    2,
    7,
    'TUESDAY',
    'AVAILABLE',
    NOW(),
    'system'
),
(
    9,
    2,
    8,
    'TUESDAY',
    'AVAILABLE',
    NOW(),
    'system'
),
(
    10,
    2,
    6,
    'THURSDAY',
    'AVAILABLE',
    NOW(),
    'system'
),
(
    11,
    2,
    7,
    'THURSDAY',
    'AVAILABLE',
    NOW(),
    'system'
),
(
    12,
    2,
    6,
    'SATURDAY',
    'AVAILABLE',
    NOW(),
    'system'
),

-- PT 3 (Phạm Văn) - Available evening slots
(
    13,
    3,
    9,
    'MONDAY',
    'AVAILABLE',
    NOW(),
    'system'
),
(
    14,
    3,
    10,
    'MONDAY',
    'AVAILABLE',
    NOW(),
    'system'
),
(
    15,
    3,
    11,
    'MONDAY',
    'AVAILABLE',
    NOW(),
    'system'
),
(
    16,
    3,
    9,
    'WEDNESDAY',
    'AVAILABLE',
    NOW(),
    'system'
),
(
    17,
    3,
    10,
    'WEDNESDAY',
    'AVAILABLE',
    NOW(),
    'system'
),
(
    18,
    3,
    9,
    'FRIDAY',
    'AVAILABLE',
    NOW(),
    'system'
);

-- ============================================
-- 11. BODY METRICS (Member Health Tracking)
-- ============================================
INSERT INTO
    body_metrics (
        metrics_id,
        member_id,
        measurement_date,
        weight_kg,
        height_cm,
        body_fat_percentage,
        muscle_mass_kg,
        bmi,
        notes,
        created_at,
        created_by
    )
VALUES
    -- Member 1 progress
    (
        1,
        1,
        '2026-01-01',
        75.5,
        175,
        22.5,
        55.2,
        24.65,
        'Initial measurement',
        NOW(),
        'system'
    ),
    (
        2,
        1,
        '2026-01-08',
        74.8,
        175,
        21.8,
        55.8,
        24.44,
        '1 week progress',
        NOW(),
        'system'
    ),
    (
        3,
        1,
        '2026-01-15',
        74.2,
        175,
        21.2,
        56.3,
        24.24,
        '2 weeks progress - good',
        NOW(),
        'system'
    ),

-- Member 2 progress
(
    4,
    2,
    '2026-01-05',
    68.0,
    165,
    28.5,
    45.2,
    24.98,
    'Initial - focus on fat loss',
    NOW(),
    'system'
),
(
    5,
    2,
    '2026-01-12',
    67.3,
    165,
    27.8,
    45.6,
    24.72,
    '1 week - slight improvement',
    NOW(),
    'system'
),

-- Member 3 progress
(
    6,
    3,
    '2025-12-15',
    82.0,
    180,
    18.5,
    63.5,
    25.31,
    'Advanced member baseline',
    NOW(),
    'system'
),
(
    7,
    3,
    '2026-01-01',
    83.2,
    180,
    17.8,
    65.1,
    25.68,
    'Muscle gain phase',
    NOW(),
    'system'
),
(
    8,
    3,
    '2026-01-15',
    84.0,
    180,
    17.5,
    66.0,
    25.93,
    'Excellent progress',
    NOW(),
    'system'
),

-- Member 5 (VIP)
(
    9,
    5,
    '2025-10-01',
    90.0,
    178,
    25.0,
    62.5,
    28.41,
    'VIP initial assessment',
    NOW(),
    'system'
),
(
    10,
    5,
    '2025-11-01',
    87.5,
    178,
    22.5,
    64.2,
    27.61,
    '1 month - great progress',
    NOW(),
    'system'
),
(
    11,
    5,
    '2025-12-01',
    85.0,
    178,
    20.0,
    65.8,
    26.83,
    '2 months - on track',
    NOW(),
    'system'
),
(
    12,
    5,
    '2026-01-01',
    83.2,
    178,
    18.5,
    66.5,
    26.27,
    '3 months - excellent',
    NOW(),
    'system'
);

-- ============================================
-- 12. FOOD (Nutrition Database)
-- ============================================
INSERT INTO
    food (
        food_id,
        name,
        description,
        protein_g,
        carbs_g,
        fat_g,
        note,
        created_at,
        created_by
    )
VALUES
    -- Proteins
    (
        1,
        'Ức gà luộc',
        'Thịt ức gà luộc không da, nguồn protein chất lượng cao',
        31.0,
        0.0,
        3.6,
        'Tốt cho tăng cơ, ít calo',
        NOW(),
        'system'
    ),
    (
        2,
        'Trứng gà luộc',
        'Trứng gà luộc chín (whole egg)',
        13.0,
        1.1,
        11.0,
        'Protein hoàn chỉnh, nhiều vitamin',
        NOW(),
        'system'
    ),
    (
        3,
        'Cá hồi nướng',
        'Cá hồi Nauy nướng',
        25.0,
        0.0,
        13.0,
        'Giàu Omega-3, tốt cho tim mạch',
        NOW(),
        'system'
    ),
    (
        4,
        'Thịt bò nạc',
        'Thịt bò nạc, ít mỡ',
        26.0,
        0.0,
        8.0,
        'Nhiều sắt và kẽm',
        NOW(),
        'system'
    ),

-- Carbs
(
    5,
    'Cơm gạo lứt',
    'Gạo lứt nấu chín',
    2.6,
    23.0,
    0.9,
    'Carb phức hợp, nhiều chất xơ',
    NOW(),
    'system'
),
(
    6,
    'Khoai lang',
    'Khoai lang luộc/hấp',
    1.6,
    20.1,
    0.1,
    'Carb lành mạnh, nhiều vitamin A',
    NOW(),
    'system'
),
(
    7,
    'Yến mạch',
    'Yến mạch nguyên hạt',
    13.0,
    67.0,
    7.0,
    'Giàu chất xơ hòa tan',
    NOW(),
    'system'
),
(
    8,
    'Bánh mì nguyên cám',
    'Bánh mì whole wheat',
    9.0,
    41.0,
    3.5,
    'Carb phức, nhiều chất xơ',
    NOW(),
    'system'
),

-- Vegetables
(
    9,
    'Bông cải xanh',
    'Broccoli hấp',
    2.8,
    7.0,
    0.4,
    'Rất nhiều vitamin C và K',
    NOW(),
    'system'
),
(
    10,
    'Rau chân vịt',
    'Spinach luộc',
    2.9,
    3.6,
    0.4,
    'Giàu sắt và canxi',
    NOW(),
    'system'
),
(
    11,
    'Cà chua',
    'Cà chua tươi',
    0.9,
    3.9,
    0.2,
    'Nhiều lycopene, chống oxy hóa',
    NOW(),
    'system'
),

-- Fruits
(
    12,
    'Chuối',
    'Chuối tiêu chín',
    1.1,
    23.0,
    0.3,
    'Nhiều kali, tốt sau tập',
    NOW(),
    'system'
),
(
    13,
    'Táo',
    'Táo tươi có vỏ',
    0.3,
    14.0,
    0.2,
    'Nhiều chất xơ',
    NOW(),
    'system'
),
(
    14,
    'Cam',
    'Cam tươi',
    0.9,
    12.0,
    0.1,
    'Rất nhiều vitamin C',
    NOW(),
    'system'
),

-- Healthy Fats
(
    15,
    'Quả bơ',
    'Avocado',
    2.0,
    9.0,
    15.0,
    'Chất béo lành mạnh',
    NOW(),
    'system'
),
(
    16,
    'Hạt hạnh nhân',
    'Almond rang',
    21.0,
    22.0,
    50.0,
    'Protein thực vật, vitamin E',
    NOW(),
    'system'
),
(
    17,
    'Dầu ô liu',
    'Extra virgin olive oil',
    0.0,
    0.0,
    100.0,
    'Chất béo không bão hòa đơn',
    NOW(),
    'system'
),

-- Dairy
(
    18,
    'Sữa tươi không đường',
    'Low-fat milk',
    3.4,
    5.0,
    1.0,
    'Canxi, protein',
    NOW(),
    'system'
),
(
    19,
    'Sữa chua Hy Lạp',
    'Greek yogurt plain',
    10.0,
    3.6,
    0.4,
    'Probiotic, protein cao',
    NOW(),
    'system'
),
(
    20,
    'Phô mai cottage',
    'Cottage cheese',
    11.0,
    3.4,
    4.3,
    'Protein casein tốt trước ngủ',
    NOW(),
    'system'
);

-- ============================================
-- 13. WORKOUT DEVICES
-- ============================================
INSERT INTO
    workout_device (
        device_id,
        name,
        type,
        price,
        date_imported,
        date_maintenance,
        image_url,
        created_at,
        created_by
    )
VALUES
    -- Cardio Equipment
    (
        1,
        'Treadmill Pro X1',
        'Cardio',
        35000000,
        '2025-06-15',
        '2026-06-15',
        'https://example.com/treadmill-x1.jpg',
        NOW(),
        'system'
    ),
    (
        2,
        'Treadmill Basic T2',
        'Cardio',
        18000000,
        '2025-08-20',
        '2026-08-20',
        'https://example.com/treadmill-t2.jpg',
        NOW(),
        'system'
    ),
    (
        3,
        'Rowing Machine R3',
        'Cardio',
        12000000,
        '2025-09-10',
        '2026-03-10',
        'https://example.com/rowing-r3.jpg',
        NOW(),
        'system'
    ),
    (
        4,
        'Exercise Bike B5',
        'Cardio',
        8500000,
        '2025-10-05',
        '2026-04-05',
        'https://example.com/bike-b5.jpg',
        NOW(),
        'system'
    ),
    (
        5,
        'Elliptical Trainer E4',
        'Cardio',
        22000000,
        '2025-07-12',
        '2026-07-12',
        'https://example.com/elliptical.jpg',
        NOW(),
        'system'
    ),

-- Strength Equipment
(
    6,
    'Smith Machine Pro',
    'Strength',
    45000000,
    '2025-05-20',
    '2026-05-20',
    'https://example.com/smith-machine.jpg',
    NOW(),
    'system'
),
(
    7,
    'Power Rack Heavy Duty',
    'Strength',
    38000000,
    '2025-06-01',
    '2026-06-01',
    'https://example.com/power-rack.jpg',
    NOW(),
    'system'
),
(
    8,
    'Bench Press Station',
    'Strength',
    15000000,
    '2025-07-15',
    '2026-07-15',
    'https://example.com/bench-press.jpg',
    NOW(),
    'system'
),
(
    9,
    'Cable Crossover Machine',
    'Strength',
    52000000,
    '2025-08-10',
    '2026-08-10',
    'https://example.com/cable-crossover.jpg',
    NOW(),
    'system'
),
(
    10,
    'Leg Press Machine',
    'Strength',
    28000000,
    '2025-09-05',
    '2026-09-05',
    'https://example.com/leg-press.jpg',
    NOW(),
    'system'
),

-- Free Weights
(
    11,
    'Dumbbells Set 2.5-50kg',
    'Free Weights',
    25000000,
    '2025-05-01',
    NULL,
    'https://example.com/dumbbells.jpg',
    NOW(),
    'system'
),
(
    12,
    'Barbell Olympic Set',
    'Free Weights',
    18000000,
    '2025-05-01',
    NULL,
    'https://example.com/barbell.jpg',
    NOW(),
    'system'
),
(
    13,
    'Kettlebell Set 4-32kg',
    'Free Weights',
    8000000,
    '2025-06-10',
    NULL,
    'https://example.com/kettlebells.jpg',
    NOW(),
    'system'
),

-- Functional Training
(
    14,
    'TRX Suspension Trainer',
    'Functional',
    3500000,
    '2025-07-01',
    '2026-01-01',
    'https://example.com/trx.jpg',
    NOW(),
    'system'
),
(
    15,
    'Battle Rope 15m',
    'Functional',
    1500000,
    '2025-08-01',
    NULL,
    'https://example.com/battle-rope.jpg',
    NOW(),
    'system'
),
(
    16,
    'Plyo Box Set',
    'Functional',
    4000000,
    '2025-07-20',
    NULL,
    'https://example.com/plyo-box.jpg',
    NOW(),
    'system'
);

-- ============================================
-- 14. WORKOUTS (Exercise Library v2)
-- ============================================
INSERT INTO
    workout (
        workout_id,
        name,
        description,
        duration,
        difficulty,
        type,
        created_at,
        created_by
    )
VALUES
    -- Bodyweight - Beginner
    (
        1,
        'Push-ups',
        'Nằm sấp, tay chống đất ngang vai, đẩy người lên xuống',
        10,
        'BEGINNER',
        'Strength',
        NOW(),
        'system'
    ),
    (
        2,
        'Squats',
        'Đứng thẳng, hạ người xuống như ngồi ghế, đứng lên',
        12,
        'BEGINNER',
        'Strength',
        NOW(),
        'system'
    ),
    (
        3,
        'Plank',
        'Chống tay/cánh tay, giữ thân thẳng',
        5,
        'BEGINNER',
        'Core',
        NOW(),
        'system'
    ),
    (
        4,
        'Jumping Jacks',
        'Nhảy tại chỗ, tay chân mở rộng',
        10,
        'BEGINNER',
        'Cardio',
        NOW(),
        'system'
    ),
    (
        5,
        'Lunges',
        'Bước chân ra trước, hạ người xuống',
        10,
        'BEGINNER',
        'Strength',
        NOW(),
        'system'
    ),

-- Intermediate
(
    6,
    'Burpees',
    'Squat, chống tay, push-up, nhảy lên',
    15,
    'INTERMEDIATE',
    'HIIT',
    NOW(),
    'system'
),
(
    7,
    'Mountain Climbers',
    'Tư thế plank, đưa chân lên xuống nhanh',
    12,
    'INTERMEDIATE',
    'Cardio',
    NOW(),
    'system'
),
(
    8,
    'Diamond Push-ups',
    'Push-up với tay tạo hình kim cương',
    10,
    'INTERMEDIATE',
    'Strength',
    NOW(),
    'system'
),
(
    9,
    'Jump Squats',
    'Squat kết hợp nhảy bật cao',
    12,
    'INTERMEDIATE',
    'HIIT',
    NOW(),
    'system'
),
(
    10,
    'Side Plank',
    'Plank nghiêng một bên',
    8,
    'INTERMEDIATE',
    'Core',
    NOW(),
    'system'
),

-- Advanced
(
    11,
    'Pistol Squats',
    'Squat một chân, chân còn lại thẳng ra trước',
    10,
    'ADVANCED',
    'Strength',
    NOW(),
    'system'
),
(
    12,
    'Handstand Push-ups',
    'Chống tay ngược, đẩy người lên xuống',
    8,
    'ADVANCED',
    'Strength',
    NOW(),
    'system'
),
(
    13,
    'Muscle-ups',
    'Từ xà đơn lên trên xà song',
    6,
    'ADVANCED',
    'Strength',
    NOW(),
    'system'
),
(
    14,
    'Box Jumps',
    'Nhảy lên box/bục cao',
    15,
    'ADVANCED',
    'HIIT',
    NOW(),
    'system'
),
(
    15,
    'Dragon Flag',
    'Nâng toàn thân từ vai, core siêu mạnh',
    5,
    'ADVANCED',
    'Core',
    NOW(),
    'system'
),

-- Cardio
(
    16,
    'Running 5K',
    'Chạy bộ 5km với tốc độ trung bình',
    30,
    'INTERMEDIATE',
    'Cardio',
    NOW(),
    'system'
),
(
    17,
    'HIIT Sprint Intervals',
    '30s sprint, 30s rest, lặp lại',
    20,
    'INTERMEDIATE',
    'HIIT',
    NOW(),
    'system'
),
(
    18,
    'Cycling',
    'Đạp xe cardio tốc độ đều',
    45,
    'BEGINNER',
    'Cardio',
    NOW(),
    'system'
),
(
    19,
    'Rowing 2000m',
    'Rowing machine 2000m',
    10,
    'INTERMEDIATE',
    'Cardio',
    NOW(),
    'system'
),

-- Flexibility
(
    20,
    'Yoga Flow',
    'Chuỗi động tác yoga cơ bản',
    30,
    'BEGINNER',
    'Flexibility',
    NOW(),
    'system'
),
(
    21,
    'Static Stretching',
    'Giãn cơ tĩnh sau tập',
    15,
    'BEGINNER',
    'Flexibility',
    NOW(),
    'system'
),
(
    22,
    'Dynamic Warm-up',
    'Khởi động động học trước tập',
    10,
    'BEGINNER',
    'Flexibility',
    NOW(),
    'system'
),

-- Strength Training (with equipment)
(
    23,
    'Barbell Bench Press',
    'Nằm đẩy tạ đòn trên ghế',
    15,
    'INTERMEDIATE',
    'Strength',
    NOW(),
    'system'
),
(
    24,
    'Barbell Deadlift',
    'Nâng tạ đòn từ sàn lên',
    12,
    'INTERMEDIATE',
    'Strength',
    NOW(),
    'system'
),
(
    25,
    'Barbell Squat',
    'Squat với tạ đòn trên vai',
    15,
    'INTERMEDIATE',
    'Strength',
    NOW(),
    'system'
),
(
    26,
    'Pull-ups',
    'Kéo xà đơn',
    10,
    'INTERMEDIATE',
    'Strength',
    NOW(),
    'system'
),
(
    27,
    'Dumbbell Shoulder Press',
    'Đẩy tạ đơn lên trên vai',
    12,
    'INTERMEDIATE',
    'Strength',
    NOW(),
    'system'
),
(
    28,
    'Cable Rows',
    'Kéo cable về phía ngực',
    15,
    'BEGINNER',
    'Strength',
    NOW(),
    'system'
),
(
    29,
    'Leg Press',
    'Đẩy chân trên máy leg press',
    15,
    'BEGINNER',
    'Strength',
    NOW(),
    'system'
),
(
    30,
    'Lat Pulldown',
    'Kéo lat bar xuống trước ngực',
    12,
    'BEGINNER',
    'Strength',
    NOW(),
    'system'
);

-- ============================================
-- 15. DAILY DIETS (Diet Plans for Members)
-- ============================================
INSERT INTO
    daily_diet (
        diet_id,
        member_id,
        pt_id,
        diet_date,
        total_calories,
        total_protein,
        total_carbs,
        total_fat,
        notes,
        created_at,
        created_by
    )
VALUES
    -- Member 1 diet plans (cutting phase)
    (
        1,
        1,
        1,
        '2026-01-15',
        0,
        0,
        0,
        0,
        'Ngày 1 - Cutting diet',
        NOW(),
        'system'
    ),
    (
        2,
        1,
        1,
        '2026-01-16',
        0,
        0,
        0,
        0,
        'Ngày 2 - Cutting diet',
        NOW(),
        'system'
    ),

-- Member 3 diet plans (bulking phase)
(
    3,
    3,
    3,
    '2026-01-15',
    0,
    0,
    0,
    0,
    'Ngày 1 - Bulking phase',
    NOW(),
    'system'
),
(
    4,
    3,
    3,
    '2026-01-16',
    0,
    0,
    0,
    0,
    'Ngày 2 - Bulking phase',
    NOW(),
    'system'
),

-- Member 5 VIP custom plan
(
    5,
    5,
    2,
    '2026-01-15',
    0,
    0,
    0,
    0,
    'VIP nutrition plan - Day 1',
    NOW(),
    'system'
);

-- ============================================
-- 16. DIET DETAILS (Meals in Diet Plans)
-- ============================================
-- Member 1 - Day 1 (Cutting - 1800 kcal target)
INSERT INTO
    diet_detail (
        detail_id,
        diet_id,
        food_id,
        meal_type,
        amount_g,
        meal_order,
        created_at,
        created_by
    )
VALUES
    -- Breakfast
    (
        1,
        1,
        2,
        'BREAKFAST',
        150,
        1,
        NOW(),
        'system'
    ), -- 3 eggs
    (
        2,
        1,
        7,
        'BREAKFAST',
        50,
        2,
        NOW(),
        'system'
    ), -- Oatmeal
    (
        3,
        1,
        12,
        'BREAKFAST',
        100,
        3,
        NOW(),
        'system'
    ), -- Banana

-- Lunch
(
    4,
    1,
    1,
    'LUNCH',
    150,
    1,
    NOW(),
    'system'
), -- Chicken breast
(
    5,
    1,
    5,
    'LUNCH',
    150,
    2,
    NOW(),
    'system'
), -- Brown rice
(
    6,
    1,
    9,
    'LUNCH',
    200,
    3,
    NOW(),
    'system'
), -- Broccoli

-- Snack
(
    7,
    1,
    13,
    'SNACK',
    150,
    1,
    NOW(),
    'system'
), -- Apple
(
    8,
    1,
    16,
    'SNACK',
    30,
    2,
    NOW(),
    'system'
), -- Almonds

-- Dinner
(
    9,
    1,
    3,
    'DINNER',
    150,
    1,
    NOW(),
    'system'
), -- Salmon
(
    10,
    1,
    6,
    'DINNER',
    200,
    2,
    NOW(),
    'system'
), -- Sweet potato
(
    11,
    1,
    10,
    'DINNER',
    150,
    3,
    NOW(),
    'system'
), -- Spinach

-- Member 1 - Day 2
(
    12,
    2,
    2,
    'BREAKFAST',
    150,
    1,
    NOW(),
    'system'
),
(
    13,
    2,
    8,
    'BREAKFAST',
    80,
    2,
    NOW(),
    'system'
), -- Whole wheat bread
(
    14,
    2,
    15,
    'BREAKFAST',
    80,
    3,
    NOW(),
    'system'
), -- Avocado
(
    15,
    2,
    4,
    'LUNCH',
    150,
    1,
    NOW(),
    'system'
), -- Beef
(
    16,
    2,
    6,
    'LUNCH',
    200,
    2,
    NOW(),
    'system'
), -- Sweet potato
(
    17,
    2,
    11,
    'LUNCH',
    150,
    3,
    NOW(),
    'system'
), -- Tomato
(
    18,
    2,
    19,
    'SNACK',
    200,
    1,
    NOW(),
    'system'
), -- Greek yogurt
(
    19,
    2,
    14,
    'SNACK',
    150,
    2,
    NOW(),
    'system'
), -- Orange
(
    20,
    2,
    1,
    'DINNER',
    180,
    1,
    NOW(),
    'system'
), -- Chicken
(
    21,
    2,
    5,
    'DINNER',
    120,
    2,
    NOW(),
    'system'
), -- Brown rice
(
    22,
    2,
    9,
    'DINNER',
    200,
    3,
    NOW(),
    'system'
), -- Broccoli

-- Member 3 - Day 1 (Bulking - 3000 kcal target)
(
    23,
    3,
    2,
    'BREAKFAST',
    200,
    1,
    NOW(),
    'system'
), -- 4 eggs
(
    24,
    3,
    7,
    'BREAKFAST',
    100,
    2,
    NOW(),
    'system'
), -- Oatmeal
(
    25,
    3,
    12,
    'BREAKFAST',
    150,
    3,
    NOW(),
    'system'
), -- Banana
(
    26,
    3,
    18,
    'BREAKFAST',
    250,
    4,
    NOW(),
    'system'
), -- Milk
(
    27,
    3,
    1,
    'LUNCH',
    250,
    1,
    NOW(),
    'system'
), -- Chicken breast
(
    28,
    3,
    5,
    'LUNCH',
    250,
    2,
    NOW(),
    'system'
), -- Brown rice
(
    29,
    3,
    9,
    'LUNCH',
    200,
    3,
    NOW(),
    'system'
), -- Broccoli
(
    30,
    3,
    15,
    'LUNCH',
    50,
    4,
    NOW(),
    'system'
), -- Avocado
(
    31,
    3,
    16,
    'SNACK',
    50,
    1,
    NOW(),
    'system'
), -- Almonds
(
    32,
    3,
    12,
    'SNACK',
    150,
    2,
    NOW(),
    'system'
), -- Banana
(
    33,
    3,
    20,
    'SNACK',
    150,
    3,
    NOW(),
    'system'
), -- Cottage cheese
(
    34,
    3,
    4,
    'DINNER',
    200,
    1,
    NOW(),
    'system'
), -- Beef
(
    35,
    3,
    6,
    'DINNER',
    300,
    2,
    NOW(),
    'system'
), -- Sweet potato
(
    36,
    3,
    10,
    'DINNER',
    200,
    3,
    NOW(),
    'system'
), -- Spinach
(
    37,
    3,
    2,
    'PRE_WORKOUT',
    100,
    1,
    NOW(),
    'system'
), -- 2 eggs
(
    38,
    3,
    8,
    'PRE_WORKOUT',
    60,
    2,
    NOW(),
    'system'
), -- Bread
(
    39,
    3,
    1,
    'POST_WORKOUT',
    150,
    1,
    NOW(),
    'system'
), -- Chicken
(
    40,
    3,
    5,
    'POST_WORKOUT',
    200,
    2,
    NOW(),
    'system'
), -- Rice
(
    41,
    3,
    12,
    'POST_WORKOUT',
    100,
    3,
    NOW(),
    'system'
);
-- Banana

-- Member 5 VIP - Day 1
INSERT INTO
    diet_detail (
        detail_id,
        diet_id,
        food_id,
        meal_type,
        amount_g,
        meal_order,
        created_at,
        created_by
    )
VALUES (
        42,
        5,
        2,
        'BREAKFAST',
        180,
        1,
        NOW(),
        'system'
    ),
    (
        43,
        5,
        7,
        'BREAKFAST',
        80,
        2,
        NOW(),
        'system'
    ),
    (
        44,
        5,
        14,
        'BREAKFAST',
        150,
        3,
        NOW(),
        'system'
    ),
    (
        45,
        5,
        19,
        'BREAKFAST',
        150,
        4,
        NOW(),
        'system'
    ),
    (
        46,
        5,
        3,
        'LUNCH',
        200,
        1,
        NOW(),
        'system'
    ), -- Salmon
    (
        47,
        5,
        5,
        'LUNCH',
        200,
        2,
        NOW(),
        'system'
    ),
    (
        48,
        5,
        9,
        'LUNCH',
        200,
        3,
        NOW(),
        'system'
    ),
    (
        49,
        5,
        15,
        'LUNCH',
        60,
        4,
        NOW(),
        'system'
    ),
    (
        50,
        5,
        16,
        'SNACK',
        40,
        1,
        NOW(),
        'system'
    ),
    (
        51,
        5,
        13,
        'SNACK',
        150,
        2,
        NOW(),
        'system'
    ),
    (
        52,
        5,
        1,
        'DINNER',
        200,
        1,
        NOW(),
        'system'
    ),
    (
        53,
        5,
        6,
        'DINNER',
        250,
        2,
        NOW(),
        'system'
    ),
    (
        54,
        5,
        10,
        'DINNER',
        150,
        3,
        NOW(),
        'system'
    );

-- ============================================
-- END OF MOCK DATA
-- ============================================

-- Update sequences to continue from max IDs
SELECT setval (
        'role_role_id_seq', (
            SELECT MAX(role_id)
            FROM role
        )
    );

SELECT setval (
        'permission_permission_id_seq', (
            SELECT MAX(permission_id)
            FROM permission
        )
    );

SELECT setval (
        'users_user_id_seq', (
            SELECT MAX(user_id)
            FROM users
        )
    );

SELECT setval (
        'service_package_package_id_seq', (
            SELECT MAX(package_id)
            FROM service_package
        )
    );

SELECT setval (
        'additional_service_service_id_seq', (
            SELECT MAX(service_id)
            FROM additional_service
        )
    );

SELECT setval (
        'personal_trainer_pt_id_seq', (
            SELECT MAX(pt_id)
            FROM personal_trainer
        )
    );

SELECT setval (
        'member_member_id_seq', (
            SELECT MAX(member_id)
            FROM member
        )
    );

SELECT setval (
        'slot_slot_id_seq', (
            SELECT MAX(slot_id)
            FROM slot
        )
    );

SELECT setval (
        'available_slot_available_slot_id_seq', (
            SELECT MAX(available_slot_id)
            FROM available_slot
        )
    );

SELECT setval (
        'body_metrics_metrics_id_seq', (
            SELECT MAX(metrics_id)
            FROM body_metrics
        )
    );

SELECT setval (
        'food_food_id_seq', (
            SELECT MAX(food_id)
            FROM food
        )
    );

SELECT setval (
        'workout_device_device_id_seq', (
            SELECT MAX(device_id)
            FROM workout_device
        )
    );

SELECT setval (
        'workout_workout_id_seq', (
            SELECT MAX(workout_id)
            FROM workout
        )
    );

SELECT setval (
        'daily_diet_diet_id_seq', (
            SELECT MAX(diet_id)
            FROM daily_diet
        )
    );

SELECT setval (
        'diet_detail_detail_id_seq', (
            SELECT MAX(detail_id)
            FROM diet_detail
        )
    );

-- Summary
SELECT
    'Mock data inserted successfully!' as message,
    (
        SELECT COUNT(*)
        FROM role
    ) as roles,
    (
        SELECT COUNT(*)
        FROM permission
    ) as permissions,
    (
        SELECT COUNT(*)
        FROM users
    ) as users,
    (
        SELECT COUNT(*)
        FROM service_package
    ) as packages,
    (
        SELECT COUNT(*)
        FROM additional_service
    ) as services,
    (
        SELECT COUNT(*)
        FROM personal_trainer
    ) as pts,
    (
        SELECT COUNT(*)
        FROM member
    ) as members,
    (
        SELECT COUNT(*)
        FROM slot
    ) as slots,
    (
        SELECT COUNT(*)
        FROM available_slot
    ) as available_slots,
    (
        SELECT COUNT(*)
        FROM body_metrics
    ) as body_metrics,
    (
        SELECT COUNT(*)
        FROM food
    ) as foods,
    (
        SELECT COUNT(*)
        FROM workout_device
    ) as devices,
    (
        SELECT COUNT(*)
        FROM workout
    ) as workouts,
    (
        SELECT COUNT(*)
        FROM daily_diet
    ) as diets,
    (
        SELECT COUNT(*)
        FROM diet_detail
    ) as diet_details;