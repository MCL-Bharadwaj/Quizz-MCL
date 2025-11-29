# LMS DataLayer

This folder contains the PostgreSQL database schema and DDL scripts for the Learning Management System (LMS) application.

## Quick Start

1. **Create a PostgreSQL database:**
   ```sql
   CREATE DATABASE lms_db;
   ```

2. **Execute the master setup script:**
   ```bash
   psql -d lms_db -f master_setup.sql
   ```

## Files Overview

| File | Purpose |
|------|---------|
| `master_setup.sql` | Master script that executes all DDL files in correct order |
| `01_create_schema.sql` | Creates the LMS schema and enables UUID extension |
| `02_create_roles_table.sql` | Defines system roles (Student, Teacher, Admin, etc.) |
| `03_create_users_table.sql` | Base user table for all system users |
| `04_create_user_roles_table.sql` | RBAC implementation - user-role relationships |
| `05_create_students_table.sql` | Student-specific information and attributes |
| `06_create_parents_table.sql` | Parent/guardian information and student relationships |
| `07_create_tutors_table.sql` | Tutor/teacher information and qualifications |
| `08_create_programs_table.sql` | Educational programs and course definitions |
| `09_create_classrooms_table.sql` | Classroom management and student enrollments |
| `10_create_class_instances_table.sql` | Individual class sessions and attendance tracking |
| `11_create_materials_table.sql` | Learning materials, assignments, and progress tracking |
| `12_create_triggers.sql` | Database triggers for automatic timestamp updates |
| `13_create_views.sql` | Useful views for reporting and common queries |
| `LMS_Schema_Documentation.md` | Comprehensive schema documentation |

## Key Features

- **UUID Primary Keys**: Better scalability and security
- **Role-Based Access Control**: Comprehensive RBAC implementation
- **Audit Trails**: Automatic timestamp tracking with triggers
- **Data Validation**: CHECK constraints for data integrity
- **Performance Optimized**: Strategic indexing for common queries
- **Comprehensive Views**: Pre-built views for reporting
- **Flexible Content**: JSON support for metadata and extensibility

## Database Schema Highlights

### Core Entities
- **Users**: Base user information for all system participants
- **Students**: Student-specific data with enrollment tracking
- **Parents**: Parent/guardian information with student relationships
- **Tutors**: Teacher information with qualifications and availability
- **Programs**: Educational programs with detailed specifications
- **Classrooms**: Class management with scheduling and capacity
- **Class Instances**: Individual class sessions with attendance
- **Materials**: Learning content with progress tracking

### Advanced Features
- **Material Progress Tracking**: Individual student progress on assignments
- **Attendance Management**: Detailed attendance tracking per session
- **Flexible Scheduling**: Support for various class schedules and timezones
- **Multi-role Support**: Users can have multiple roles simultaneously
- **Parent-Student Relationships**: Flexible family structure support

## Usage Examples

### Create a User and Student
```sql
-- Create a user
INSERT INTO lms.users (email, password_hash, first_name, last_name) 
VALUES ('john.doe@email.com', 'hashed_password', 'John', 'Doe');

-- Create student record
INSERT INTO lms.students (user_id, student_number, grade_level) 
VALUES ((SELECT user_id FROM lms.users WHERE email = 'john.doe@email.com'), 'STU001', '10th Grade');

-- Assign student role
INSERT INTO lms.user_roles (user_id, role_id) 
VALUES (
    (SELECT user_id FROM lms.users WHERE email = 'john.doe@email.com'),
    (SELECT role_id FROM lms.roles WHERE role_name = 'Student')
);
```

### Query Active Classrooms
```sql
SELECT * FROM lms.v_classroom_details 
WHERE status = 'Active' 
ORDER BY start_date;
```

## Prerequisites

- PostgreSQL 12+ (for JSONB and UUID support)
- Database with appropriate permissions for:
  - Creating schemas
  - Creating tables and indexes
  - Creating functions and triggers
  - Installing extensions (uuid-ossp)

## Support

For detailed information about the schema design, relationships, and usage patterns, please refer to the `LMS_Schema_Documentation.md` file.