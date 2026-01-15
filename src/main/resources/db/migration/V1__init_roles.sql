-- Initialize Roles (only if they don't exist)
INSERT IGNORE INTO
    roles (
        name,
        description,
        active,
        created_at,
        created_by,
        updated_at,
        updated_by
    )
VALUES (
        'ADMIN',
        'Quản trị viên hệ thống',
        true,
        NOW(),
        'system',
        NOW(),
        'system'
    ),
    (
        'MEMBER',
        'Khách hàng',
        true,
        NOW(),
        'system',
        NOW(),
        'system'
    ),
    (
        'PT',
        'Huấn luyện viên cá nhân',
        true,
        NOW(),
        'system',
        NOW(),
        'system'
    );