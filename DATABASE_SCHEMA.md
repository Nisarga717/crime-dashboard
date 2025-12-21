# Database Schema Reference

This document provides a quick reference for the Crime Dashboard database schema.

## Tables

### `users` Table

Stores user information for citizens who report crimes.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | BIGSERIAL | NO | auto | Primary key |
| created_at | TIMESTAMPTZ | NO | NOW() | Timestamp when user was created |
| first_name | TEXT | YES | NULL | User's first name |
| last_name | TEXT | YES | NULL | User's last name |
| email | TEXT | YES | NULL | User's email address |
| phone_number | TEXT | YES | NULL | User's phone number |
| address | TEXT | YES | NULL | User's street address |
| city | TEXT | YES | NULL | User's city |
| state | TEXT | YES | NULL | User's state |
| pincode | INTEGER | YES | NULL | Postal/ZIP code |
| points | INTEGER | YES | 0 | User's reward points |
| level | INTEGER | YES | 1 | User's level/rank |
| language | TEXT | YES | NULL | Preferred language |

**Indexes:**
- Primary key on `id`
- Index on `email`

### `crime_report` Table

Stores crime incident reports with geographic location data.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | BIGSERIAL | NO | auto | Primary key |
| created_at | TIMESTAMPTZ | NO | NOW() | Timestamp when report was created |
| user_id | BIGINT | YES | NULL | Foreign key to `users.id` |
| date | DATE | YES | NULL | Date of the incident |
| time | TIME | YES | NULL | Time of the incident |
| location | GEOGRAPHY(POINT, 4326) | YES | NULL | PostGIS geography point (longitude, latitude) |
| incident_type | TEXT | YES | NULL | Type of incident (e.g., "Theft", "Assault") |
| report_type | TEXT | YES | NULL | Type of report (e.g., "Citizen Report", "Police Report") |
| status | TEXT | YES | NULL | Status: "New", "Under Investigation", "Resolved", "False Report" |
| perpetrator | TEXT | YES | NULL | Name or description of perpetrator |
| details | TEXT | YES | NULL | Detailed description of the incident |
| incident_severity | TEXT | YES | 'Medium' | Severity: "Low", "Medium", "High", "Critical" |

**Indexes:**
- Primary key on `id`
- Foreign key index on `user_id`
- Index on `date`
- Index on `status`
- Index on `incident_type`
- GIST index on `location` (for spatial queries)

**Relationships:**
- `user_id` → `users.id` (Foreign key, ON DELETE SET NULL)

## Common Incident Types

- Theft
- Vehicle Theft
- Burglary
- Robbery
- Assault
- Harassment
- Fraud
- Public Disturbance
- Drug Offense
- Traffic Violation
- Property Damage
- Eve Teasing

## Status Values

- **New**: Newly reported incident
- **Under Investigation**: Incident is being investigated
- **Resolved**: Incident has been resolved
- **False Report**: Report was determined to be false

## Severity Levels

- **Low**: Minor incidents with minimal impact
- **Medium**: Moderate incidents requiring attention
- **High**: Serious incidents requiring immediate action
- **Critical**: Critical incidents requiring urgent response

## PostGIS Location Format

The `location` column uses PostGIS `GEOGRAPHY(POINT, 4326)` type:
- **SRID**: 4326 (WGS84 coordinate system)
- **Format**: Longitude, Latitude (X, Y)
- **Example**: Surat, Gujarat is approximately `POINT(72.8311 21.1702)`

When inserting data, use:
```sql
ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography
```

## Row Level Security (RLS)

Both tables have RLS enabled. Current policies allow public access for development. **Update these for production use.**

## Notes

1. The `perpetrator` field was corrected from the original typo "perpertrator"
2. The `incident_severity` field was added to match the application interface
3. All text fields are nullable to allow for partial data entry
4. Timestamps use `TIMESTAMPTZ` for timezone-aware storage

