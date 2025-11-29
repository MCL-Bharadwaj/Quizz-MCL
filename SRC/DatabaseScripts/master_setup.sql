-- Master Script for LMS Database Setup
-- Execute this script to create the complete LMS database schema
-- 
-- Prerequisites:
-- 1. PostgreSQL server running
-- 2. Superuser privileges (to create/drop database)
--
-- Usage: psql -U postgres -f master_setup.sql

\echo 'Starting LMS Database Setup...'

-- Connect to postgres database first (to be able to drop/create our database)
\c postgres;

-- Drop and recreate the database
DROP DATABASE IF EXISTS lms;
CREATE DATABASE lms;

-- Connect to our new database
\c lms;

-- Step 1: Create schema and extensions
\echo 'Step 1: Creating schema and extensions...'
\i '01_create_schema.sql'

-- Step 2: Create roles table
\echo 'Step 2: Creating roles table...'
\i '02_create_roles_table.sql'

-- Step 3: Create users table
\echo 'Step 3: Creating users table...'
\i '03_create_users_table.sql'

-- Step 4: Create user roles (RBAC) table
\echo 'Step 4: Creating user roles table...'
\i '04_create_user_roles_table.sql'

-- Step 5: Create students table
\echo 'Step 5: Creating students table...'
\i '05_create_students_table.sql'

-- Step 6: Create parents table
\echo 'Step 6: Creating parents table...'
\i '06_create_parents_table.sql'

-- Step 7: Create tutors table
\echo 'Step 7: Creating tutors table...'
\i '07_create_tutors_table.sql'

-- Step 8: Create programs table
\echo 'Step 8: Creating programs table...'
\i '08_create_programs_table.sql'

-- Step 9: Create classrooms table
\echo 'Step 9: Creating classrooms table...'
\i '09_create_classrooms_table.sql'

-- Step 10: Create class instances table
\echo 'Step 10: Creating class instances table...'
\i '10_create_class_instances_table.sql'

-- Step 11: Create materials tables
\echo 'Step 11: Creating materials tables...'
\i '11_create_materials_table.sql'

-- Step 12: Create triggers
\echo 'Step 12: Creating triggers...'
\i '12_create_triggers.sql'

-- Step 13: Create views
\echo 'Step 13: Creating views...'
\i '13_create_views.sql'

\echo 'LMS Database Setup Complete!'
\echo 'You can now start using the LMS database schema.'
\echo ''
\echo 'Next steps:'
\echo '1. Create your first administrator user'
\echo '2. Set up initial programs and classrooms'
\echo '3. Configure your application to connect to this database'
\echo ''
\echo 'For detailed documentation, see: LMS_Schema_Documentation.md'