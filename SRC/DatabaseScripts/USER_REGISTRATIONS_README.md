# ✅ User Registration Table - Final Version

## What You Have Now

### **Clean SQL - All Frontend Fields, No Triggers/Indexes**

```sql
CREATE TABLE IF NOT EXISTS lms.user_registrations (
    -- Primary key
    registration_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- User type
    user_type VARCHAR(20) NOT NULL,
    
    -- Basic user information (matches frontend form exactly)
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10),
    
    -- Address information (matches frontend form)
    address1 VARCHAR(100),
    address2 VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    
    -- Role-specific data as JSON
    student_data JSONB,
    tutor_data JSONB,
    parent_data JSONB,
    
    -- Link to created user
    user_id UUID REFERENCES lms.users(user_id),
    
    -- Timestamp
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

---

## Table Columns Explained

| Column | Type | Description |
|--------|------|-------------|
| `registration_id` | UUID | Auto-generated unique ID |
| `user_type` | VARCHAR(20) | "student", "tutor", or "parent" |
| **User Info** | | |
| `email` | VARCHAR(255) | From frontend: email field |
| `password_hash` | VARCHAR(255) | Hashed password (BCrypt) |
| `first_name` | VARCHAR(100) | From frontend: firstName |
| `middle_name` | VARCHAR(100) | From frontend: middleName |
| `last_name` | VARCHAR(100) | From frontend: lastName |
| `phone` | VARCHAR(20) | From frontend: phone |
| `date_of_birth` | DATE | From frontend: dateOfBirth |
| `gender` | VARCHAR(10) | From frontend: gender |
| **Address** | | |
| `address1` | VARCHAR(100) | From frontend: address1 |
| `address2` | VARCHAR(100) | From frontend: address2 |
| `city` | VARCHAR(100) | From frontend: city |
| `state` | VARCHAR(100) | From frontend: state |
| `country` | VARCHAR(100) | From frontend: country |
| `postal_code` | VARCHAR(20) | From frontend: postalCode |
| **Role Data** | | |
| `student_data` | JSONB | Student form fields as JSON |
| `tutor_data` | JSONB | Tutor form fields as JSON |
| `parent_data` | JSONB | Parent form fields as JSON |
| **Links** | | |
| `user_id` | UUID | Links to created user in users table |
| `created_at` | TIMESTAMP | Auto-set to current time |

---

## Example Data Saved

### Student Registration
```json
{
  "registration_id": "a1b2c3d4-e5f6-...",
  "user_type": "student",
  "email": "john@example.com",
  "password_hash": "$2a$12$...",
  "first_name": "John",
  "middle_name": null,
  "last_name": "Doe",
  "phone": "555-1234",
  "date_of_birth": "2010-05-15",
  "gender": "Male",
  "address1": "123 Main St",
  "address2": "Apt 4B",
  "city": "Dallas",
  "state": "TX",
  "country": "USA",
  "postal_code": "75001",
  "student_data": {
    "gradeLevel": "10th Grade",
    "emergencyContactName": "Jane Doe",
    "emergencyContactPhone": "555-5678",
    "emergencyContactRelationship": "Mother",
    "specialNeeds": null,
    "learningPreferences": "Visual learner"
  },
  "user_id": "created-user-id-here",
  "created_at": "2025-10-20T14:30:00Z"
}
```

### Tutor Registration
```json
{
  "registration_id": "b2c3d4e5-f6g7-...",
  "user_type": "tutor",
  "email": "sarah@example.com",
  "first_name": "Sarah",
  "last_name": "Smith",
  "tutor_data": {
    "department": "Mathematics",
    "qualifications": "PhD Mathematics",
    "specializations": "Calculus, Algebra",
    "yearsOfExperience": 5,
    "isFullTime": true,
    "preferredSubjects": "Math, Statistics",
    "bio": "Passionate educator..."
  },
  "user_id": "created-user-id-here",
  "created_at": "2025-10-20T15:00:00Z"
}
```

---

## What Gets Saved

✅ **All frontend form fields** - Every field from your React form  
✅ **Role-specific data** - Student/Tutor/Parent fields as JSON  
✅ **Password hashed** - BCrypt encryption  
✅ **Timestamp** - When registration was submitted  
✅ **User link** - References created user account  

❌ **No triggers** - Simple table, no automation  
❌ **No indexes** - No performance optimization (can add later if needed)  
❌ **No status tracking** - No approval workflow  
❌ **No IP/user-agent** - No security metadata  

---

## How to Deploy

### Option 1: Using psql
```bash
psql -h your-db-host -U your-username -d your-database -f DatabaseScripts/21_create_user_registrations_table.sql
```

### Option 2: Azure Data Studio / pgAdmin
1. Open the SQL file: `DatabaseScripts/21_create_user_registrations_table.sql`
2. Copy the SQL
3. Paste and execute in your database

---

## Simple Queries

### View all registrations
```sql
SELECT * FROM lms.user_registrations 
ORDER BY created_at DESC;
```

### View by user type
```sql
SELECT * FROM lms.user_registrations 
WHERE user_type = 'student'
ORDER BY created_at DESC;
```

### View with created user info
```sql
SELECT 
    r.registration_id,
    r.email,
    r.first_name,
    r.last_name,
    r.user_type,
    r.created_at,
    u.user_id,
    u.is_active
FROM lms.user_registrations r
LEFT JOIN lms.users u ON r.user_id = u.user_id
ORDER BY r.created_at DESC;
```

---

## ✅ Build Status

```
Build succeeded with 7 warning(s)
0 Error(s)
✅ All frontend fields included
✅ No triggers or indexes
✅ Clean and simple
```

---

## Files Modified

| File | What Changed |
|------|--------------|
| `DatabaseScripts/21_create_user_registrations_table.sql` | Simple CREATE TABLE with all frontend fields |
| `Domain/Entities/UserRegistration.cs` | Entity with all properties matching table |
| `Functions/RegistrationFunction.cs` | Saves all fields to registration table |
| `Data/LmsDbContext.cs` | Added UserRegistrations DbSet |

---

**Ready to deploy! Just run the SQL script in your database.** 🚀
