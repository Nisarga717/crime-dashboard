-- Crime Dashboard Database Setup Script
-- Run this script in your Supabase SQL Editor

-- Enable PostGIS extension (required for geographic data)
-- Note: Enable this through the Supabase dashboard Extensions section first
-- CREATE EXTENSION IF NOT EXISTS postgis;

-- Create users table
CREATE TABLE IF NOT EXISTS public.users (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone_number TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    pincode INTEGER,
    points INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    language TEXT
);

-- Create crime_report table
CREATE TABLE IF NOT EXISTS public.crime_report (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    user_id BIGINT REFERENCES public.users(id) ON DELETE SET NULL,
    date DATE,
    time TIME,
    location GEOGRAPHY(POINT, 4326), -- PostGIS geography type for coordinates
    incident_type TEXT,
    report_type TEXT,
    status TEXT,
    perpetrator TEXT, -- Note: Fixed typo from "perpertrator" to "perpetrator"
    details TEXT,
    incident_severity TEXT DEFAULT 'Medium' -- Severity: Low, Medium, High, Critical
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_crime_report_user_id ON public.crime_report(user_id);
CREATE INDEX IF NOT EXISTS idx_crime_report_date ON public.crime_report(date);
CREATE INDEX IF NOT EXISTS idx_crime_report_status ON public.crime_report(status);
CREATE INDEX IF NOT EXISTS idx_crime_report_incident_type ON public.crime_report(incident_type);
CREATE INDEX IF NOT EXISTS idx_crime_report_location ON public.crime_report USING GIST(location);
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);

-- Enable Row Level Security (RLS)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.crime_report ENABLE ROW LEVEL SECURITY;

-- Create policies for public access (DEVELOPMENT ONLY - NOT FOR PRODUCTION)
-- Policy for users table - allow public read access
CREATE POLICY "Allow public read on users" ON public.users
    FOR SELECT
    USING (true);

-- Policy for crime_report table - allow public read and write access
CREATE POLICY "Allow public read on crime_report" ON public.crime_report
    FOR SELECT
    USING (true);

CREATE POLICY "Allow public insert on crime_report" ON public.crime_report
    FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Allow public update on crime_report" ON public.crime_report
    FOR UPDATE
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow public delete on crime_report" ON public.crime_report
    FOR DELETE
    USING (true);

-- Add comments to tables for documentation
COMMENT ON TABLE public.users IS 'Stores user information for citizens who report crimes';
COMMENT ON TABLE public.crime_report IS 'Stores crime incident reports with geographic location data';

-- Add comments to important columns
COMMENT ON COLUMN public.crime_report.location IS 'PostGIS geography point storing latitude/longitude coordinates';
COMMENT ON COLUMN public.crime_report.status IS 'Status values: New, Under Investigation, Resolved, False Report';
COMMENT ON COLUMN public.crime_report.incident_type IS 'Type of incident: Theft, Assault, Burglary, etc.';
COMMENT ON COLUMN public.crime_report.incident_severity IS 'Severity values: Low, Medium, High, Critical';

