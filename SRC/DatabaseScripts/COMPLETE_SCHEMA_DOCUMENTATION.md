# Learning Management System (LMS) - Complete Database Schema Documentation

**Generated:** November 13, 2025  
**Database:** PostgreSQL  
**Schema:** lms  
**Version:** 1.0

---

## Table of Contents

1. [Schema Overview](#schema-overview)
2. [Schema Creation (File 01)](#1-schema-creation)
3. [Roles Table (File 02)](#2-roles-table)
4. [Users Table (File 03)](#3-users-table)
5. [User Roles Table (File 04)](#4-user-roles-table)
6. [Students Table (File 05)](#5-students-table)
7. [Parents Table (File 06)](#6-parents-table)
8. [Parent-Student Relationships (File 07)](#7-parent-student-relationships-table)
9. [Tutors Table (File 08)](#8-tutors-table)
10. [Programs Table (File 09)](#9-programs-table)
11. [Classrooms Table (File 10)](#10-classrooms-table)
12. [Classroom Enrollments (File 11)](#11-classroom-enrollments-table)
13. [Class Instances (File 12)](#12-class-instances-table)
14. [Class Instance Attendance (File 13)](#13-class-instance-attendance-table)
15. [Material Types Table (File 14)](#14-material-types-table)
16. [Materials Table (File 15)](#15-materials-table)
17. [Class Instance Materials (File 16)](#16-class-instance-materials-table)
18. [Student Material Progress (File 17)](#17-student-material-progress-table)
19. [Payments Table (File 18)](#18-payments-table)
20. [Entity Relationships](#entity-relationships)

---

## Schema Overview

The LMS database is designed to manage a comprehensive learning management system with support for:
- Multi-role user management (Students, Tutors, Parents, Content Creators, Administrators)
- Program and classroom management
- Class scheduling and attendance tracking
- Learning materials and progress tracking
- Payment processing
- Parent-student relationships

---

## 1. Schema Creation

**File:** `01_create_schema.sql`

### Purpose
Creates the PostgreSQL schema and enables required extensions.

### Components
- **Schema:** `lms` - Primary schema for all LMS tables
- **Extension:** `pgcrypto` - Enables UUID generation via `gen_random_uuid()`
- **Search Path:** Sets `lms` as primary schema with `public` as fallback

### SQL
```sql
CREATE SCHEMA IF NOT EXISTS lms;
SET search_path TO lms, public;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
```

---

## 2. Roles Table

**File:** `02_create_roles_table.sql`

### Purpose
Defines system roles for Role-Based Access Control (RBAC).

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `role_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique role identifier |
| `role_name` | VARCHAR(50) | UNIQUE, NOT NULL | Role name |
| `role_description` | TEXT | | Role description |
| `is_active` | BOOLEAN | DEFAULT TRUE | Active status |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Default Roles
- **Student** - Students enrolled in classes
- **Tutors** - Teachers/Tutors conducting classes
- **Parent** - Parents/Guardians of students
- **Content Creator** - Users who create and manage program content
- **Administrator** - System administrators with full access

### Indexes
- `idx_roles_name` - On `role_name`
- `idx_roles_active` - On `is_active`

### Constraints
- `unique_role_name` - Ensures unique role names

---

## 3. Users Table

**File:** `03_create_users_table.sql`

### Purpose
Generic user table serving as the base for all user types.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `user_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique user identifier |
| `email` | VARCHAR(255) | UNIQUE, NOT NULL | User email address |
| `password_hash` | VARCHAR(255) | NOT NULL | Hashed password |
| `first_name` | VARCHAR(100) | NOT NULL | First name |
| `middle_name` | VARCHAR(100) | | Middle name |
| `last_name` | VARCHAR(100) | NOT NULL | Last name |
| `phone` | VARCHAR(20) | | Phone number |
| `date_of_birth` | DATE | | Date of birth |
| `gender` | VARCHAR(10) | CHECK constraint | Gender (Male, Female, Other, Prefer not to say) |
| `address1` | VARCHAR(100) | | Address line 1 |
| `address2` | VARCHAR(100) | | Address line 2 |
| `city` | VARCHAR(100) | | City |
| `state` | VARCHAR(100) | | State/Province |
| `country` | VARCHAR(100) | | Country |
| `postal_code` | VARCHAR(20) | | Postal/ZIP code |
| `profile_picture_url` | TEXT | | Profile picture URL |
| `is_active` | BOOLEAN | DEFAULT TRUE | Active status |
| `is_verified` | BOOLEAN | DEFAULT FALSE | Email verification status |
| `last_login` | TIMESTAMP WITH TIME ZONE | | Last login timestamp |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Indexes
- `idx_users_email` - On `email`
- `idx_users_active` - On `is_active`
- `idx_users_verified` - On `is_verified`
- `idx_users_name` - On `first_name, last_name`

### Check Constraints
- Gender must be one of: 'Male', 'Female', 'Other', 'Prefer not to say'

---

## 4. User Roles Table

**File:** `04_create_user_roles_table.sql`

### Purpose
Manages many-to-many relationships between users and roles (RBAC).

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `user_role_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique user-role assignment ID |
| `user_id` | UUID | NOT NULL, FK to users(user_id), CASCADE | User reference |
| `role_id` | UUID | NOT NULL, FK to roles(role_id), CASCADE | Role reference |
| `assigned_by` | UUID | FK to users(user_id) | User who assigned the role |
| `assigned_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Assignment timestamp |
| `is_active` | BOOLEAN | DEFAULT TRUE | Active status |

### Indexes
- `idx_user_roles_user_id` - On `user_id`
- `idx_user_roles_role_id` - On `role_id`
- `idx_user_roles_active` - On `is_active`
- `idx_user_roles_assigned_by` - On `assigned_by`

### Constraints
- `UNIQUE(user_id, role_id)` - Prevents duplicate role assignments

---

## 5. Students Table

**File:** `05_create_students_table.sql`

### Purpose
Extends user information with student-specific data.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `student_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique student identifier |
| `user_id` | UUID | UNIQUE, NOT NULL, FK to users(user_id), CASCADE | User reference |
| `student_number` | VARCHAR(50) | UNIQUE, NOT NULL | Student number (e.g., MCL001) |
| `enrollment_date` | DATE | NOT NULL, DEFAULT CURRENT_DATE | Enrollment date |
| `graduation_date` | DATE | | Graduation date |
| `grade_level` | VARCHAR(20) | | Current grade level |
| `emergency_contact_name` | VARCHAR(200) | | Emergency contact name |
| `emergency_contact_phone` | VARCHAR(20) | | Emergency contact phone |
| `emergency_contact_relationship` | VARCHAR(50) | | Relationship to student |
| `special_needs` | TEXT | | Special needs/accommodations |
| `learning_preferences` | TEXT | | Learning preferences |
| `is_enrolled` | BOOLEAN | DEFAULT TRUE | Current enrollment status |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Indexes
- `idx_students_user_id` - On `user_id`
- `idx_students_number` - On `student_number`
- `idx_students_enrolled` - On `is_enrolled`
- `idx_students_enrollment_date` - On `enrollment_date`
- `idx_students_grade_level` - On `grade_level`

---

## 6. Parents Table

**File:** `06_create_parents_table.sql`

### Purpose
Stores parent/guardian information linked to users.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `parent_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique parent identifier |
| `user_id` | UUID | UNIQUE, NOT NULL, FK to users(user_id), CASCADE | User reference |
| `occupation` | VARCHAR(100) | | Occupation |
| `employer` | VARCHAR(200) | | Employer name |
| `work_phone` | VARCHAR(20) | | Work phone number |
| `preferred_contact_method` | VARCHAR(20) | CHECK constraint | Preferred contact method |
| `preferred_contact_time` | VARCHAR(50) | | Preferred contact time |
| `is_primary_contact` | BOOLEAN | DEFAULT FALSE | Primary contact flag |
| `can_pickup_student` | BOOLEAN | DEFAULT TRUE | Pickup authorization |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Indexes
- `idx_parents_user_id` - On `user_id`
- `idx_parents_primary_contact` - On `is_primary_contact`

### Check Constraints
- `preferred_contact_method` must be one of: 'Email', 'Phone', 'SMS', 'App Notification'

---

## 7. Parent-Student Relationships Table

**File:** `07_parent_student_relationships.sql`

### Purpose
Manages many-to-many relationships between parents and students.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `relationship_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique relationship identifier |
| `parent_id` | UUID | NOT NULL, FK to parents(parent_id), CASCADE | Parent reference |
| `student_id` | UUID | NOT NULL, FK to students(student_id), CASCADE | Student reference |
| `relationship_type` | VARCHAR(50) | NOT NULL, CHECK constraint | Type of relationship |
| `is_primary_contact` | BOOLEAN | DEFAULT FALSE | Primary contact flag |
| `can_make_decisions` | BOOLEAN | DEFAULT TRUE | Decision-making authorization |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |

### Indexes
- `idx_parent_student_parent_id` - On `parent_id`
- `idx_parent_student_student_id` - On `student_id`
- `idx_parent_student_primary` - On `is_primary_contact`

### Constraints
- `UNIQUE(parent_id, student_id, relationship_type)` - Prevents duplicate relationships
- `relationship_type` must be one of: 'Father', 'Mother', 'Guardian', 'Stepfather', 'Stepmother', 'Grandparent', 'Other'

---

## 8. Tutors Table

**File:** `08_create_tutors_table.sql`

### Purpose
Stores tutor/teacher information linked to users.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `tutor_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique tutor identifier |
| `user_id` | UUID | UNIQUE, NOT NULL, FK to users(user_id), CASCADE | User reference |
| `employee_id` | VARCHAR(50) | UNIQUE, NOT NULL | Employee ID |
| `hire_date` | DATE | NOT NULL, DEFAULT CURRENT_DATE | Hire date |
| `termination_date` | DATE | | Termination date |
| `department` | VARCHAR(100) | | Department |
| `title` | VARCHAR(100) | | Job title |
| `qualifications` | VARCHAR(255) | | Qualifications |
| `specializations` | VARCHAR(255) | | Areas of specialization |
| `years_of_experience` | INTEGER | DEFAULT 0 | Years of experience |
| `hourly_rate` | DECIMAL(10, 2) | | Hourly rate |
| `is_full_time` | BOOLEAN | DEFAULT TRUE | Full-time employment status |
| `is_available` | BOOLEAN | DEFAULT TRUE | Availability status |
| `preferred_subjects` | VARCHAR(255) | | Preferred subjects |
| `bio` | TEXT | | Biography/description |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Indexes
- `idx_tutors_user_id` - On `user_id`
- `idx_tutors_employee_id` - On `employee_id`
- `idx_tutors_available` - On `is_available`
- `idx_tutors_department` - On `department`
- `idx_tutors_hire_date` - On `hire_date`

---

## 9. Programs Table

**File:** `09_create_programs_table.sql`

### Purpose
Stores information about different educational programs.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `program_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique program identifier |
| `program_name` | VARCHAR(200) | NOT NULL | Program name |
| `program_code` | VARCHAR(50) | UNIQUE, NOT NULL | Program code |
| `description` | TEXT | | Program description |
| `objectives` | TEXT | | Learning objectives |
| `prerequisites` | TEXT | | Prerequisites |
| `duration_weeks` | INTEGER | | Program duration in weeks |
| `difficulty_level` | VARCHAR(20) | CHECK constraint | Difficulty level |
| `age_group_min` | INTEGER | | Minimum age |
| `age_group_max` | INTEGER | | Maximum age |
| `max_class_size` | INTEGER | DEFAULT 10 | Maximum class size |
| `min_class_size` | INTEGER | DEFAULT 3 | Minimum class size |
| `price` | DECIMAL(10, 2) | | Program price |
| `currency` | VARCHAR(3) | DEFAULT 'USD' | Currency code |
| `is_active` | BOOLEAN | DEFAULT TRUE | Active status |
| `created_by` | UUID | FK to users(user_id) | Creator reference |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Default Programs
- **Level 0 - The Beginner** - Beginner level
- **Level 1 - The Thinker** - Intermediate level
- **Level 2 - The Builder** - Advanced level
- **Level 3 - The Creator** - Advanced level
- **Level 4 - The Innovator** - Expert level

### Indexes
- `idx_programs_code` - On `program_code`
- `idx_programs_active` - On `is_active`
- `idx_programs_difficulty` - On `difficulty_level`
- `idx_programs_age_group` - On `age_group_min, age_group_max`
- `idx_programs_created_by` - On `created_by`

### Check Constraints
- `difficulty_level` must be one of: 'Beginner', 'Intermediate', 'Advanced', 'Expert'

---

## 10. Classrooms Table

**File:** `10_create_classrooms_table.sql`

### Purpose
Stores information about classrooms/classes.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `classroom_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique classroom identifier |
| `classroom_name` | VARCHAR(200) | NOT NULL | Classroom name |
| `classroom_code` | VARCHAR(50) | UNIQUE, NOT NULL | Classroom code |
| `program_id` | UUID | NOT NULL, FK to programs(program_id), CASCADE | Program reference |
| `primary_tutor_id` | UUID | NOT NULL, FK to tutors(tutor_id) | Primary tutor reference |
| `secondary_tutor_id` | UUID | FK to tutors(tutor_id) | Secondary tutor reference |
| `room_number` | VARCHAR(50) | | Room number |
| `capacity` | INTEGER | NOT NULL, DEFAULT 20 | Maximum capacity |
| `start_date` | DATE | NOT NULL | Start date |
| `end_date` | DATE | NOT NULL | End date |
| `schedule_days` | VARCHAR(20) | NOT NULL | Schedule days (e.g., 'Mon,Wed,Fri') |
| `start_time` | TIME | NOT NULL | Start time |
| `end_time` | TIME | NOT NULL | End time |
| `timezone` | VARCHAR(50) | DEFAULT 'UTC' | Timezone |
| `is_online` | BOOLEAN | DEFAULT FALSE | Online class flag |
| `meeting_url` | TEXT | | Meeting URL for online classes |
| `status` | VARCHAR(20) | DEFAULT 'Planned', CHECK constraint | Classroom status |
| `notes` | TEXT | | Additional notes |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Indexes
- `idx_classrooms_code` - On `classroom_code`
- `idx_classrooms_program_id` - On `program_id`
- `idx_classrooms_primary_tutor` - On `primary_tutor_id`
- `idx_classrooms_status` - On `status`
- `idx_classrooms_dates` - On `start_date, end_date`

### Check Constraints
- `end_date >= start_date`
- `end_time > start_time`
- `status` must be one of: 'Planned', 'Active', 'Completed', 'Cancelled', 'Postponed'

---

## 11. Classroom Enrollments Table

**File:** `11_create_classroom_enrollments_table.sql`

### Purpose
Manages student enrollments in classrooms.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `enrollment_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique enrollment identifier |
| `classroom_id` | UUID | NOT NULL, FK to classrooms(classroom_id), CASCADE | Classroom reference |
| `student_id` | UUID | NOT NULL, FK to students(student_id), CASCADE | Student reference |
| `enrollment_date` | DATE | NOT NULL, DEFAULT CURRENT_DATE | Enrollment date |
| `enrollment_status` | VARCHAR(20) | DEFAULT 'Active', CHECK constraint | Enrollment status |
| `enrollment_notes` | TEXT | | Enrollment notes |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Indexes
- `idx_classroom_enrollments_classroom` - On `classroom_id`
- `idx_classroom_enrollments_student` - On `student_id`
- `idx_classroom_enrollments_status` - On `enrollment_status`

### Constraints
- `UNIQUE(classroom_id, student_id)` - Prevents duplicate enrollments
- `enrollment_status` must be one of: 'Active', 'Dropped', 'Completed', 'Withdrawn'

---

## 12. Class Instances Table

**File:** `12_create_class_instances_table.sql`

### Purpose
Represents individual class sessions/meetings.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `instance_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique instance identifier |
| `classroom_id` | UUID | NOT NULL, FK to classrooms(classroom_id), CASCADE | Classroom reference |
| `instance_number` | INTEGER | NOT NULL | Sequential number within classroom |
| `session_date` | DATE | NOT NULL | Session date |
| `start_time` | TIME | NOT NULL | Scheduled start time |
| `end_time` | TIME | NOT NULL | Scheduled end time |
| `actual_start_time` | TIMESTAMP WITH TIME ZONE | | Actual start time |
| `actual_end_time` | TIMESTAMP WITH TIME ZONE | | Actual end time |
| `conducting_tutor_id` | UUID | NOT NULL, FK to tutors(tutor_id) | Conducting tutor reference |
| `assistant_tutor_id` | UUID | FK to tutors(tutor_id) | Assistant tutor reference |
| `session_title` | VARCHAR(200) | | Session title |
| `session_description` | TEXT | | Session description |
| `learning_objectives` | TEXT | | Learning objectives |
| `location` | VARCHAR(200) | | Location |
| `meeting_url` | TEXT | | Meeting URL |
| `recording_url` | TEXT | | Recording URL |
| `status` | VARCHAR(20) | DEFAULT 'Scheduled', CHECK constraint | Session status |
| `attendance_required` | BOOLEAN | DEFAULT TRUE | Attendance requirement |
| `notes` | TEXT | | Session notes |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Indexes
- `idx_class_instances_classroom` - On `classroom_id`
- `idx_class_instances_date` - On `session_date`
- `idx_class_instances_tutor` - On `conducting_tutor_id`
- `idx_class_instances_status` - On `status`

### Constraints
- `UNIQUE(classroom_id, instance_number)` - Ensures unique instance numbering
- `end_time > start_time`
- `status` must be one of: 'Scheduled', 'In Progress', 'Completed', 'Cancelled', 'Postponed'

---

## 13. Class Instance Attendance Table

**File:** `13_create_class_instance_attendance_table.sql`

### Purpose
Tracks student attendance for class sessions.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `attendance_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique attendance record identifier |
| `instance_id` | UUID | NOT NULL, FK to class_instances(instance_id), CASCADE | Class instance reference |
| `student_id` | UUID | NOT NULL, FK to students(student_id), CASCADE | Student reference |
| `attendance_status` | VARCHAR(20) | DEFAULT 'Present', CHECK constraint | Attendance status |
| `arrival_time` | TIMESTAMP WITH TIME ZONE | | Actual arrival time |
| `departure_time` | TIMESTAMP WITH TIME ZONE | | Actual departure time |
| `participation_score` | INTEGER | CHECK (0-100) | Participation score |
| `notes` | TEXT | | Attendance notes |
| `marked_by` | UUID | FK to tutors(tutor_id) | Tutor who marked attendance |
| `marked_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | When attendance was marked |

### Indexes
- `idx_attendance_instance` - On `instance_id`
- `idx_attendance_student` - On `student_id`
- `idx_attendance_status` - On `attendance_status`

### Constraints
- `UNIQUE(instance_id, student_id)` - One attendance record per student per session
- `attendance_status` must be one of: 'Present', 'Absent', 'Late', 'Excused'
- `participation_score` between 0 and 100

---

## 14. Material Types Table

**File:** `14_create_material_types_table.sql`

### Purpose
Defines different types of learning materials.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `material_type_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique material type identifier |
| `type_name` | VARCHAR(100) | UNIQUE, NOT NULL | Type name |
| `type_description` | TEXT | | Type description |
| `icon_url` | TEXT | | Icon URL |
| `color_code` | VARCHAR(7) | | Hex color code |
| `is_active` | BOOLEAN | DEFAULT TRUE | Active status |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Default Material Types
- **Learning Notes** - Study notes and reading materials
- **Practice Exercise** - Interactive practice problems and exercises
- **Homework** - Take-home assignments
- **Quiz** - Short assessments and quizzes
- **Exam** - Formal examinations
- **Video Lesson** - Video-based learning content
- **Audio Lesson** - Audio-based learning content
- **Presentation** - Slide presentations and visual aids
- **Document** - PDF documents and text files
- **Interactive Content** - Interactive learning modules
- **Lab Exercise** - Hands-on laboratory work
- **Project** - Long-term project assignments

### Indexes
- `idx_material_types_name` - On `type_name`

---

## 15. Materials Table

**File:** `15_create_materials_table.sql`

### Purpose
Stores learning materials and resources.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `material_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique material identifier |
| `material_type_id` | UUID | NOT NULL, FK to material_types(material_type_id) | Material type reference |
| `title` | VARCHAR(300) | NOT NULL | Material title |
| `description` | TEXT | | Material description |
| `content` | TEXT | | Material content |
| `file_url` | TEXT | | File URL |
| `file_size_bytes` | BIGINT | | File size in bytes |
| `file_mime_type` | VARCHAR(100) | | MIME type |
| `thumbnail_url` | TEXT | | Thumbnail URL |
| `duration_minutes` | INTEGER | | Duration for video/audio content |
| `difficulty_level` | VARCHAR(20) | CHECK constraint | Difficulty level |
| `estimated_completion_time` | INTEGER | | Estimated completion time (minutes) |
| `points_possible` | INTEGER | DEFAULT 0 | Possible points |
| `is_required` | BOOLEAN | DEFAULT TRUE | Required material flag |
| `is_published` | BOOLEAN | DEFAULT FALSE | Published status |
| `version` | VARCHAR(20) | DEFAULT '1.0' | Version number |
| `tags` | TEXT | | JSON array of tags |
| `metadata` | JSONB | | Additional metadata |
| `created_by` | UUID | NOT NULL, FK to users(user_id) | Creator reference |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Indexes
- `idx_materials_type` - On `material_type_id`
- `idx_materials_created_by` - On `created_by`
- `idx_materials_published` - On `is_published`
- `idx_materials_difficulty` - On `difficulty_level`

### Check Constraints
- `difficulty_level` must be one of: 'Beginner', 'Intermediate', 'Advanced', 'Expert'

---

## 16. Class Instance Materials Table

**File:** `16_create_class_instance_materials_table.sql`

### Purpose
Links materials to specific class instances (junction table).

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `instance_material_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique identifier |
| `instance_id` | UUID | NOT NULL, FK to class_instances(instance_id), CASCADE | Class instance reference |
| `material_id` | UUID | NOT NULL, FK to materials(material_id), CASCADE | Material reference |
| `sequence_order` | INTEGER | NOT NULL, DEFAULT 1 | Sequence order |
| `is_required` | BOOLEAN | DEFAULT TRUE | Required flag |
| `due_date` | TIMESTAMP WITH TIME ZONE | | Due date |
| `points_possible` | INTEGER | DEFAULT 0 | Possible points |
| `instructions` | TEXT | | Special instructions |
| `assigned_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Assignment timestamp |
| `assigned_by` | UUID | FK to tutors(tutor_id) | Assigning tutor reference |

### Indexes
- `idx_instance_materials_instance` - On `instance_id`
- `idx_instance_materials_material` - On `material_id`
- `idx_instance_materials_sequence` - On `sequence_order`

### Constraints
- `UNIQUE(instance_id, material_id)` - Prevents duplicate material assignments

---

## 17. Student Material Progress Table

**File:** `17_create_student_material_progress_table.sql`

### Purpose
Tracks student progress and submissions for materials.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `progress_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique progress record identifier |
| `instance_material_id` | UUID | NOT NULL, FK to class_instance_materials, CASCADE | Instance material reference |
| `student_id` | UUID | NOT NULL, FK to students(student_id), CASCADE | Student reference |
| `status` | VARCHAR(20) | DEFAULT 'Not Started', CHECK constraint | Progress status |
| `progress_percentage` | INTEGER | DEFAULT 0, CHECK (0-100) | Progress percentage |
| `time_spent_minutes` | INTEGER | DEFAULT 0 | Time spent in minutes |
| `score` | DECIMAL(5, 2) | | Achieved score |
| `max_score` | DECIMAL(5, 2) | | Maximum possible score |
| `submission_url` | TEXT | | Submission URL |
| `submission_notes` | TEXT | | Submission notes |
| `feedback` | TEXT | | Tutor feedback |
| `started_at` | TIMESTAMP WITH TIME ZONE | | Start timestamp |
| `completed_at` | TIMESTAMP WITH TIME ZONE | | Completion timestamp |
| `submitted_at` | TIMESTAMP WITH TIME ZONE | | Submission timestamp |
| `graded_at` | TIMESTAMP WITH TIME ZONE | | Grading timestamp |
| `graded_by` | UUID | FK to tutors(tutor_id) | Grading tutor reference |

### Indexes
- `idx_student_progress_instance_material` - On `instance_material_id`
- `idx_student_progress_student` - On `student_id`
- `idx_student_progress_status` - On `status`

### Constraints
- `UNIQUE(instance_material_id, student_id)` - One progress record per student per material
- `status` must be one of: 'Not Started', 'In Progress', 'Completed', 'Submitted', 'Graded', 'Overdue'
- `progress_percentage` between 0 and 100

---

## 18. Payments Table

**File:** `18_create_payments_table.sql`

### Purpose
Tracks payment transactions for classrooms and users.

### Schema

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `payment_id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique payment identifier |
| `user_id` | UUID | NOT NULL, FK to users(user_id), CASCADE | User reference |
| `classroom_id` | UUID | FK to classrooms(classroom_id), SET NULL | Classroom reference |
| `amount` | DECIMAL(10, 2) | NOT NULL, CHECK (> 0) | Payment amount |
| `currency` | VARCHAR(10) | DEFAULT 'INR' | Currency code |
| `payment_method` | VARCHAR(50) | NOT NULL, CHECK constraint | Payment method |
| `payment_status` | VARCHAR(20) | DEFAULT 'Pending', CHECK constraint | Payment status |
| `transaction_id` | VARCHAR(100) | UNIQUE | Transaction ID |
| `receipt_number` | VARCHAR(50) | UNIQUE | Unique receipt number |
| `payment_date` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Payment date |
| `remarks` | TEXT | | Payment remarks |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Last update timestamp |

### Check Constraints
- `amount > 0`
- `payment_method` must be one of: 'UPI', 'Credit Card', 'Debit Card', 'Net Banking', 'Cash', 'Other'
- `payment_status` must be one of: 'Pending', 'Completed', 'Failed', 'Refunded'

---

## Entity Relationships

### User-Centric Relationships
```
users (1) ──< (many) user_roles >── (many) roles
users (1) ──< (1) students
users (1) ──< (1) parents
users (1) ──< (1) tutors
users (1) ──< (many) payments
users (1) ──< (many) materials (as creator)
users (1) ──< (many) programs (as creator)
```

### Student-Parent Relationships
```
parents (1) ──< (many) parent_student_relationships >── (many) students
```

### Program-Classroom-Student Flow
```
programs (1) ──< (many) classrooms
classrooms (1) ──< (many) classroom_enrollments >── (many) students
classrooms (1) ──< (many) class_instances
classrooms (many) >── (1) tutors (primary_tutor)
classrooms (many) >── (1) tutors (secondary_tutor)
```

### Class Instance Relationships
```
class_instances (1) ──< (many) class_instance_attendance >── (many) students
class_instances (1) ──< (many) class_instance_materials >── (many) materials
class_instances (many) >── (1) tutors (conducting_tutor)
class_instances (many) >── (1) tutors (assistant_tutor)
```

### Material Progress Tracking
```
class_instance_materials (1) ──< (many) student_material_progress >── (many) students
student_material_progress (many) >── (1) tutors (graded_by)
```

### Material Type Hierarchy
```
material_types (1) ──< (many) materials
```

---

## Database Features

### Security Features
- **Password Hashing:** User passwords stored as hashes
- **Role-Based Access Control (RBAC):** Flexible multi-role system
- **CASCADE Deletes:** Automatic cleanup of related records

### Data Integrity
- **Foreign Key Constraints:** Maintain referential integrity
- **Unique Constraints:** Prevent duplicate records
- **Check Constraints:** Validate data values
- **NOT NULL Constraints:** Ensure required fields

### Performance Optimization
- **Comprehensive Indexing:** All foreign keys and frequently queried fields
- **Composite Indexes:** For complex queries
- **JSONB Support:** Efficient storage and querying of metadata

### Audit Trail
- **Timestamps:** `created_at` and `updated_at` on most tables
- **User Tracking:** `created_by`, `assigned_by`, `marked_by`, `graded_by`
- **Status Tracking:** Historical status changes preserved

### Scalability Features
- **UUID Primary Keys:** Distributed system support
- **Soft Deletes:** Via `is_active` flags where applicable
- **Versioning:** Material versioning support
- **Metadata Storage:** JSONB for extensibility

---

## Common Query Patterns

### Get all students in a classroom
```sql
SELECT s.*, u.first_name, u.last_name
FROM lms.students s
JOIN lms.users u ON s.user_id = u.user_id
JOIN lms.classroom_enrollments ce ON s.student_id = ce.student_id
WHERE ce.classroom_id = '<classroom_id>'
AND ce.enrollment_status = 'Active';
```

### Get attendance for a class instance
```sql
SELECT s.student_number, u.first_name, u.last_name, a.attendance_status
FROM lms.class_instance_attendance a
JOIN lms.students s ON a.student_id = s.student_id
JOIN lms.users u ON s.user_id = u.user_id
WHERE a.instance_id = '<instance_id>';
```

### Get student progress on materials
```sql
SELECT m.title, smp.status, smp.progress_percentage, smp.score
FROM lms.student_material_progress smp
JOIN lms.class_instance_materials cim ON smp.instance_material_id = cim.instance_material_id
JOIN lms.materials m ON cim.material_id = m.material_id
WHERE smp.student_id = '<student_id>';
```

### Get parent-student relationships
```sql
SELECT p.*, u.first_name as parent_first_name, u.last_name as parent_last_name,
       s.student_number, su.first_name as student_first_name, su.last_name as student_last_name,
       psr.relationship_type
FROM lms.parent_student_relationships psr
JOIN lms.parents p ON psr.parent_id = p.parent_id
JOIN lms.students s ON psr.student_id = s.student_id
JOIN lms.users u ON p.user_id = u.user_id
JOIN lms.users su ON s.user_id = su.user_id
WHERE psr.parent_id = '<parent_id>';
```

---

## Migration Notes

### Dependencies Order
Execute SQL files in the following order:
1. `01_create_schema.sql` - Schema and extensions
2. `02_create_roles_table.sql` - Roles
3. `03_create_users_table.sql` - Users
4. `04_create_user_roles_table.sql` - User-Role assignments
5. `05_create_students_table.sql` - Students
6. `06_create_parents_table.sql` - Parents
7. `07_parent_student_relationships.sql` - Parent-Student links
8. `08_create_tutors_table.sql` - Tutors
9. `09_create_programs_table.sql` - Programs
10. `10_create_classrooms_table.sql` - Classrooms
11. `11_create_classroom_enrollments_table.sql` - Enrollments
12. `12_create_class_instances_table.sql` - Class sessions
13. `13_create_class_instance_attendance_table.sql` - Attendance
14. `14_create_material_types_table.sql` - Material types
15. `15_create_materials_table.sql` - Materials
16. `16_create_class_instance_materials_table.sql` - Instance-Material links
17. `17_create_student_material_progress_table.sql` - Student progress
18. `18_create_payments_table.sql` - Payments

### Rollback Considerations
Use CASCADE deletes carefully in production. Consider implementing soft deletes for critical tables.

---

## Best Practices

### Data Entry
- Always create a user record before creating student/parent/tutor records
- Assign roles via `user_roles` table after user creation
- Use transaction blocks for multi-table operations

### Performance
- Use prepared statements for repeated queries
- Limit result sets with appropriate WHERE clauses
- Use indexes for all foreign key and frequently searched columns

### Security
- Never store plain text passwords
- Validate user roles before data access
- Use parameterized queries to prevent SQL injection
- Implement row-level security if needed

### Maintenance
- Regularly analyze query performance
- Archive old class instances and attendance records
- Monitor table sizes and implement partitioning if needed
- Keep statistics updated with ANALYZE

---

**Document Version:** 1.0  
**Last Updated:** November 13, 2025  
**Maintained By:** MathCodeLab Development Team
