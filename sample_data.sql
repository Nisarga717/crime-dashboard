-- Sample Data Insertion Script
-- Run this script after running database_setup.sql
-- This will insert sample data for testing purposes

-- Insert sample users (20 users from Surat, Gujarat)
INSERT INTO public.users (first_name, last_name, email, phone_number, address, city, state, pincode, points, level, language) VALUES
('Raj', 'Sharma', 'raj.sharma1@example.com', '+91 9876543210', '123, Adajan Road, Surat', 'Surat', 'Gujarat', 395007, 150, 2, 'Gujarati'),
('Amit', 'Patel', 'amit.patel2@example.com', '+91 9876543211', '456, City Light Road, Surat', 'Surat', 'Gujarat', 395007, 200, 3, 'Gujarati'),
('Rahul', 'Shah', 'rahul.shah3@example.com', '+91 9876543212', '789, Vesu Road, Surat', 'Surat', 'Gujarat', 395007, 75, 1, 'Hindi'),
('Priya', 'Singh', 'priya.singh4@example.com', '+91 9876543213', '321, Althan Road, Surat', 'Surat', 'Gujarat', 395007, 300, 4, 'Gujarati'),
('Neha', 'Kumar', 'neha.kumar5@example.com', '+91 9876543214', '654, Athwa Road, Surat', 'Surat', 'Gujarat', 395007, 125, 2, 'English'),
('Anjali', 'Verma', 'anjali.verma6@example.com', '+91 9876543215', '987, Dumas Road, Surat', 'Surat', 'Gujarat', 395007, 180, 2, 'Gujarati'),
('Vikram', 'Desai', 'vikram.desai7@example.com', '+91 9876543216', '147, Katargam Road, Surat', 'Surat', 'Gujarat', 395007, 250, 3, 'Gujarati'),
('Sanjay', 'Mehta', 'sanjay.mehta8@example.com', '+91 9876543217', '258, Varachha Road, Surat', 'Surat', 'Gujarat', 395007, 90, 1, 'Hindi'),
('Kavita', 'Joshi', 'kavita.joshi9@example.com', '+91 9876543218', '369, Udhna Road, Surat', 'Surat', 'Gujarat', 395007, 220, 3, 'Gujarati'),
('Deepika', 'Gandhi', 'deepika.gandhi10@example.com', '+91 9876543219', '741, Piplod Road, Surat', 'Surat', 'Gujarat', 395007, 160, 2, 'English'),
('Rohan', 'Patel', 'rohan.patel11@example.com', '+91 9876543220', '852, Adajan Road, Surat', 'Surat', 'Gujarat', 395007, 110, 1, 'Gujarati'),
('Sneha', 'Sharma', 'sneha.sharma12@example.com', '+91 9876543221', '963, City Light Road, Surat', 'Surat', 'Gujarat', 395007, 190, 2, 'Gujarati'),
('Arjun', 'Singh', 'arjun.singh13@example.com', '+91 9876543222', '159, Vesu Road, Surat', 'Surat', 'Gujarat', 395007, 140, 2, 'Hindi'),
('Pooja', 'Kumar', 'pooja.kumar14@example.com', '+91 9876543223', '357, Althan Road, Surat', 'Surat', 'Gujarat', 395007, 270, 4, 'Gujarati'),
('Mohit', 'Verma', 'mohit.verma15@example.com', '+91 9876543224', '468, Athwa Road, Surat', 'Surat', 'Gujarat', 395007, 95, 1, 'English'),
('Divya', 'Shah', 'divya.shah16@example.com', '+91 9876543225', '579, Dumas Road, Surat', 'Surat', 'Gujarat', 395007, 210, 3, 'Gujarati'),
('Karan', 'Desai', 'karan.desai17@example.com', '+91 9876543226', '680, Katargam Road, Surat', 'Surat', 'Gujarat', 395007, 175, 2, 'Gujarati'),
('Meera', 'Mehta', 'meera.mehta18@example.com', '+91 9876543227', '791, Varachha Road, Surat', 'Surat', 'Gujarat', 395007, 130, 2, 'Hindi'),
('Nikhil', 'Joshi', 'nikhil.joshi19@example.com', '+91 9876543228', '802, Udhna Road, Surat', 'Surat', 'Gujarat', 395007, 240, 3, 'Gujarati'),
('Isha', 'Gandhi', 'isha.gandhi20@example.com', '+91 9876543229', '913, Piplod Road, Surat', 'Surat', 'Gujarat', 395007, 165, 2, 'English');

-- Insert sample crime reports (100 reports)
-- Note: Using ST_SetSRID and ST_MakePoint for PostGIS geography
-- Coordinates are around Surat, Gujarat (approximately 21.1702° N, 72.8311° E)

INSERT INTO public.crime_report (user_id, date, time, location, incident_type, report_type, status, perpetrator, details, incident_severity) VALUES
(1, '2024-01-15', '14:30:00', ST_SetSRID(ST_MakePoint(72.8311, 21.1702), 4326)::geography, 'Theft', 'Citizen Report', 'New', 'Unknown', 'Victim reported their mobile phone was snatched by two individuals on a motorcycle.', 'Medium'),
(2, '2024-01-16', '09:15:00', ST_SetSRID(ST_MakePoint(72.8320, 21.1710), 4326)::geography, 'Burglary', 'Citizen Report', 'Under Investigation', 'Raj Kumar', 'Store owner reported break-in and theft of cash and electronics.', 'High'),
(3, '2024-01-17', '18:45:00', ST_SetSRID(ST_MakePoint(72.8300, 21.1690), 4326)::geography, 'Harassment', 'Citizen Report', 'New', 'Unknown', 'Complainant reported harassment while walking home from work.', 'Low'),
(4, '2024-01-18', '22:00:00', ST_SetSRID(ST_MakePoint(72.8330, 21.1720), 4326)::geography, 'Property Damage', 'Citizen Report', 'Resolved', 'Amit Shah', 'Vehicle parked outside residence was damaged overnight.', 'Low'),
(5, '2024-01-19', '11:20:00', ST_SetSRID(ST_MakePoint(72.8290, 21.1680), 4326)::geography, 'Public Disturbance', 'Citizen Report', 'New', 'Unknown', 'Resident reported suspicious activity in the neighborhood.', 'Low'),
(6, '2024-01-20', '16:00:00', ST_SetSRID(ST_MakePoint(72.8340, 21.1730), 4326)::geography, 'Theft', 'Citizen Report', 'Under Investigation', 'Rahul Verma', 'Personal belongings stolen from apartment.', 'Medium'),
(7, '2024-01-21', '19:30:00', ST_SetSRID(ST_MakePoint(72.8280, 21.1670), 4326)::geography, 'Harassment', 'Citizen Report', 'New', 'Unknown', 'Victim reported being followed by unknown individuals.', 'Medium'),
(8, '2024-01-22', '13:45:00', ST_SetSRID(ST_MakePoint(72.8350, 21.1740), 4326)::geography, 'Fraud', 'Citizen Report', 'Under Investigation', 'Vikram Singh', 'Shop owner reported counterfeit currency used for purchase.', 'High'),
(9, '2024-01-23', '20:15:00', ST_SetSRID(ST_MakePoint(72.8270, 21.1660), 4326)::geography, 'Assault', 'Police Report', 'Resolved', 'Sanjay Patel', 'Verbal altercation escalated to physical assault.', 'High'),
(10, '2024-01-24', '10:00:00', ST_SetSRID(ST_MakePoint(72.8360, 21.1750), 4326)::geography, 'Fraud', 'Citizen Report', 'New', 'Unknown', 'Complainant reported online fraud and money loss.', 'Medium');

-- Add more sample reports (you can expand this list)
-- For brevity, I'm adding a few more examples. You can generate more using the pattern above.

INSERT INTO public.crime_report (user_id, date, time, location, incident_type, report_type, status, perpetrator, details, incident_severity) VALUES
(11, '2024-01-25', '15:30:00', ST_SetSRID(ST_MakePoint(72.8260, 21.1650), 4326)::geography, 'Vehicle Theft', 'Citizen Report', 'Under Investigation', 'Unknown', 'Motorcycle stolen from parking area.', 'High'),
(12, '2024-01-26', '08:20:00', ST_SetSRID(ST_MakePoint(72.8370, 21.1760), 4326)::geography, 'Theft', 'Citizen Report', 'New', 'Karan Mehta', 'Wallet stolen from shopping mall.', 'Low'),
(13, '2024-01-27', '17:00:00', ST_SetSRID(ST_MakePoint(72.8250, 21.1640), 4326)::geography, 'Eve Teasing', 'Citizen Report', 'Under Investigation', 'Unknown', 'Woman reported harassment on public transport.', 'Medium'),
(14, '2024-01-28', '12:15:00', ST_SetSRID(ST_MakePoint(72.8380, 21.1770), 4326)::geography, 'Robbery', 'Police Report', 'Resolved', 'Nikhil Joshi', 'Armed robbery at convenience store.', 'Critical'),
(15, '2024-01-29', '21:45:00', ST_SetSRID(ST_MakePoint(72.8240, 21.1630), 4326)::geography, 'Drug Offense', 'Police Report', 'Under Investigation', 'Unknown', 'Drug activity reported in residential area.', 'High');

-- Note: To insert more sample data, you can:
-- 1. Use the generateMockData() function in your application
-- 2. Expand this SQL script with more INSERT statements
-- 3. Use a script to generate random data

-- Verify the data was inserted correctly
SELECT COUNT(*) as total_users FROM public.users;
SELECT COUNT(*) as total_reports FROM public.crime_report;

