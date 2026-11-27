-- =======================================================
-- Database Setup Script for Experiment 7 Registration
-- Database: event_db
-- Compatible with MySQL 8.x / 9.x
-- =======================================================

CREATE DATABASE IF NOT EXISTS event_db;
USE event_db;

-- Drop table if resetting
-- DROP TABLE IF EXISTS registrations;

CREATE TABLE IF NOT EXISTS registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address TEXT NOT NULL,
    course VARCHAR(50) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Initial Dummy Records for testing
INSERT INTO registrations (fullname, email, address, course, gender) 
VALUES 
    ('Alice Johnson', 'alice.johnson@example.com', '123 University Campus, Block A', 'web-dev', 'female'),
    ('Bob Smith', 'bob.smith@example.com', '45 North Avenue, Tech Park', 'code', 'male'),
    ('Charlie Brown', 'charlie.brown@example.com', '78 Silicon Lane, South Wing', 'ai-ml', 'male'),
    ('Diana Prince', 'diana.prince@example.com', '99 Cyber Road, Metro Heights', 'cyber', 'female')
ON DUPLICATE KEY UPDATE fullname=VALUES(fullname);
