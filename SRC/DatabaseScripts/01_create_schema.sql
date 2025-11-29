-- LMS Database Schema Creation
-- Create schema for LMS application
CREATE SCHEMA IF NOT EXISTS lms;

-- Set search path to include the lms schema
SET search_path TO lms, public;

-- Enable pgcrypto for UUID generation (this is in public schema)
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;