# Supabase Database Setup Guide

This guide will help you recreate the Supabase database for the Crime Dashboard application.

## Prerequisites

1. A Supabase account (sign up at https://supabase.com)
2. Basic knowledge of SQL and database concepts

## Step 1: Create a New Supabase Project

1. Go to https://supabase.com and sign in (or create an account)
2. Click **"New Project"** button
3. Fill in the project details:
   - **Name**: `crime-dashboard` (or any name you prefer)
   - **Database Password**: Create a strong password (save this securely)
   - **Region**: Choose the region closest to your users
   - **Pricing Plan**: Select Free tier for development
4. Click **"Create new project"**
5. Wait 2-3 minutes for the project to be provisioned

## Step 2: Get Your Project Credentials

1. Once your project is ready, go to **Settings** → **API**
2. Copy the following values:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon/public key** (the `anon` key, not the `service_role` key)

## Step 3: Enable PostGIS Extension

PostGIS is required for geographic data (location coordinates).

1. Go to **Database** → **Extensions** in your Supabase dashboard
2. Search for **"PostGIS"**
3. Click **"Enable"** to activate the extension
4. Wait for it to be enabled (this may take a minute)

## Step 4: Create Database Tables

1. Go to **SQL Editor** in your Supabase dashboard
2. Click **"New query"**
3. Copy and paste the SQL script from `database_setup.sql` (see below)
4. Click **"Run"** to execute the script
5. Verify that both tables (`users` and `crime_report`) are created successfully

## Step 5: Set Up Row Level Security (RLS)

1. Go to **Authentication** → **Policies** in your Supabase dashboard
2. For the `users` table:
   - Click on `users` table
   - Create a policy that allows public read access (for development)
   - Policy name: `Allow public read`
   - Policy definition: `SELECT` operation, `true` as the expression
3. For the `crime_report` table:
   - Click on `crime_report` table
   - Create a policy that allows public read and write access (for development)
   - Policy name: `Allow public access`
   - Policy definition: `ALL` operations, `true` as the expression

**Note**: For production, you should implement proper authentication and more restrictive policies.

## Step 6: Update Your Application Configuration

1. Open `src/integrations/supabase/client.ts`
2. Replace the `SUPABASE_URL` with your new project URL
3. Replace the `SUPABASE_PUBLISHABLE_KEY` with your new anon/public key

```typescript
const SUPABASE_URL = "https://YOUR_PROJECT_ID.supabase.co";
const SUPABASE_PUBLISHABLE_KEY = "YOUR_ANON_KEY_HERE";
```

**Important**: The old credentials in the file point to a deactivated database. You must update these values for the application to work.

## Step 7: Generate TypeScript Types

1. Install Supabase CLI (if not already installed):
   ```bash
   npm install -g supabase
   ```

2. Login to Supabase:
   ```bash
   supabase login
   ```

3. Link your project:
   ```bash
   supabase link --project-ref YOUR_PROJECT_ID
   ```

4. Generate types:
   ```bash
   supabase gen types typescript --linked > src/integrations/supabase/types.ts
   ```

**Alternative Method** (if CLI doesn't work):
1. Go to **Settings** → **API** in Supabase dashboard
2. Scroll down to **"TypeScript types"**
3. Copy the generated types
4. Replace the content of `src/integrations/supabase/types.ts` with the copied types

## Step 8: Test the Connection

1. Start your development server:
   ```bash
   npm run dev
   ```

2. Check the browser console for any connection errors
3. Verify that data can be fetched from Supabase

## Step 9: Insert Sample Data (Optional)

You can insert sample data using the SQL script in `sample_data.sql` (see below) or use the mock data generator in your application.

**Note**: The sample data script uses PostGIS functions (`ST_SetSRID` and `ST_MakePoint`) to insert geographic coordinates. Make sure PostGIS is enabled before running the sample data script.

## Step 10: Understanding PostGIS Location Data

The `location` field in `crime_report` uses PostGIS `GEOGRAPHY(POINT, 4326)` type. This stores coordinates as:
- **Format**: Longitude, Latitude (X, Y)
- **SRID**: 4326 (WGS84 coordinate system)

When querying from Supabase, the location data may be returned in different formats:
- As a GeoJSON object
- As a WKT (Well-Known Text) string
- As a PostGIS geometry object

The application code in `src/utils/data.ts` handles parsing this data. If you encounter issues with location data:
1. Check that PostGIS extension is enabled
2. Verify coordinates are in the correct format (longitude, latitude)
3. Check the browser console for location parsing warnings

## Troubleshooting

### Issue: "relation does not exist"
- **Solution**: Make sure you ran the `database_setup.sql` script completely

### Issue: "permission denied"
- **Solution**: Check your RLS policies and ensure they allow the operations you're trying to perform

### Issue: "PostGIS extension not found"
- **Solution**: Go to Extensions and enable PostGIS

### Issue: Connection timeout
- **Solution**: Check your internet connection and verify the Supabase URL is correct

### Issue: Type mismatches
- **Solution**: Regenerate the TypeScript types after creating the database schema

## Database Schema Overview

### `users` Table
- Stores user information (citizens who report crimes)
- Fields: id, created_at, first_name, last_name, email, phone_number, address, city, state, pincode, points, level, language

### `crime_report` Table
- Stores crime incident reports
- Fields: id, created_at, user_id (foreign key to users), date, time, location (PostGIS geography), incident_type, report_type, status, perpetrator, details
- Has a foreign key relationship with `users` table

## Security Notes

⚠️ **Important**: The current setup allows public read/write access for development purposes. For production:

1. Implement proper authentication (Supabase Auth)
2. Create more restrictive RLS policies
3. Use service role key only on the server side
4. Never expose service role key in client-side code
5. Validate and sanitize all user inputs

## Next Steps

1. Set up authentication if needed
2. Implement proper RLS policies based on user roles
3. Add indexes for better query performance
4. Set up database backups
5. Monitor database usage and performance

