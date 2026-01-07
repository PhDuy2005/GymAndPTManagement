---
config:
  layout: elk
---
erDiagram
  USER {
    int user_id PK
    string username
    string password_hash
    string fullname
    string email
    string phone_number
    int role_id FK
    string status
    string avatar_url
    date dob
    string gender
    datetime created_at
  }

  ROLE {
    int role_id PK
    string name
    text description
    datetime created_at
    int updated_by
    datetime updated_at
  }

  PERMISSION {
    int permission_id PK
    string name
    string api_path
    datetime created_at
    int updated_by
    datetime updated_at
  }

  PERMISSION_ROLE {
    int role_id PK, FK
    int permission_id PK, FK
  }

  MEMBER {
    int member_id PK
    int user_id FK
    string cccd
    decimal money_spent
    decimal money_debt
    date join_date
  }

  PERSONAL_TRAINER {
    int pt_id PK
    int user_id FK
    string about
    string specialization
    string certifications
    int experience_years
    decimal rating
    string status
    text note
  }

  SERVICE_PACKAGE {
    int package_id PK
    string package_name
    decimal price
    string type
    boolean is_active
    datetime created_at
  }

  ADDITIONAL_SERVICE {
    int additional_service_id PK
    string name
    decimal cost_price
    decimal suggest_sell_price
  }

  CONTRACT {
    int contract_id PK
    int member_id FK
    int package_id FK
    int main_pt_id FK
    datetime start_date
    datetime end_date
    string status
    text notes
    datetime signed_at
    int created_by
  }

  SLOT {
    int slot_id PK
    time start_time
    time end_time
  }

  AVAILABLE_SLOT {
    int available_slot_id PK
    int pt_id FK
    int slot_id FK
    string day_of_week
    boolean is_available
  }

  BOOKING {
    int booking_id PK
    int contract_id FK
    int member_id FK
    int real_pt_id FK
    int slot_id FK
    date booking_date
  }

  CHECKIN_LOG {
    int checkin_id PK
    int member_id FK
    int booking_id FK
    time checkin_time
    time checkout_time
    string status
  }

  BODY_METRICS {
    int metric_id PK
    int member_id FK
    date measured_date
    decimal weight
    decimal height
    decimal muscle_mass
    decimal body_fat_percentage
    decimal bmi
  }

  INVOICE {
    int invoice_id PK
    int member_id FK
    datetime created_at
    decimal total_amount
    decimal discount_amount
    decimal final_amount
    string payment_method
    string payment_status
  }

  INVOICE_DETAIL {
    int detail_id PK
    int invoice_id FK
    int service_id FK
    int additional_service_id FK
    int quantity
    decimal unit_price
    decimal total_amount
  }

  DAILY_DIET {
    int diet_id PK
    int member_id FK
    int pt_id FK
    date diet_date
    decimal water_liters
    text note
  }

  FOOD {
    int food_id PK
    string name
    text description
    decimal calories
    decimal protein_g
    decimal carbs_g
    decimal fat_g
    text note
  }

  DIET_DETAIL {
    int diet_id PK, FK
    int food_id PK, FK
    string prep_method
    decimal amount
    text note
  }

  WORKOUT_DEVICE {
    int device_id PK
    string name
    string type
    decimal price
    date date_imported
    date date_maintenance
  }

  WORKOUT {
    int workout_id PK
    int pt_id FK
    int device_id FK
    string name
    text description
  }

  WORKOUT_IMAGE {
    int image_id PK
    int workout_id FK
    string image_url
  }
  ROLE ||--o{ USER : has
  ROLE ||--o{ PERMISSION_ROLE : maps
  PERMISSION ||--o{ PERMISSION_ROLE : maps

  USER ||--|| MEMBER : is
  USER ||--|| PERSONAL_TRAINER : is

  MEMBER ||--o{ CONTRACT : signs
  SERVICE_PACKAGE ||--o{ CONTRACT : included
  PERSONAL_TRAINER ||--o{ CONTRACT : manages

  CONTRACT ||--o{ BOOKING : creates
  MEMBER ||--o{ BOOKING : books
  PERSONAL_TRAINER ||--o{ BOOKING : trains
  SLOT ||--o{ BOOKING : uses

  BOOKING ||--o{ CHECKIN_LOG : logs
  MEMBER ||--o{ CHECKIN_LOG : has

  MEMBER ||--o{ BODY_METRICS : tracks

  MEMBER ||--o{ INVOICE : billed
  INVOICE ||--o{ INVOICE_DETAIL : contains
  SERVICE_PACKAGE ||--o{ INVOICE_DETAIL : service
  ADDITIONAL_SERVICE ||--o{ INVOICE_DETAIL : extra

  PERSONAL_TRAINER ||--o{ AVAILABLE_SLOT : owns
  SLOT ||--o{ AVAILABLE_SLOT : scheduled

  MEMBER ||--o{ DAILY_DIET : follows
  PERSONAL_TRAINER ||--o{ DAILY_DIET : plans
  DAILY_DIET ||--o{ DIET_DETAIL : includes
  FOOD ||--o{ DIET_DETAIL : consists

  WORKOUT_DEVICE ||--o{ WORKOUT : used_in
  PERSONAL_TRAINER ||--o{ WORKOUT : designs
  WORKOUT ||--o{ WORKOUT_IMAGE : illustrates