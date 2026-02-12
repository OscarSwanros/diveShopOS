# Database Design

## Conventions

### Primary Keys
All tables use UUID primary keys for:
- Multi-tenancy safety (no sequential ID guessing)
- Future sync and API compatibility
- Safe cross-tenant references

### Organization Scoping
Every table with business data includes:
```ruby
t.references :organization, null: false, foreign_key: true, type: :string
```

### Soft Deletes
Customer-facing data uses soft deletes via a `discarded_at` timestamp:
- Customer records
- Certifications
- Medical records
- Waivers
- Booking records

Soft-deleted records are excluded from default scopes but remain queryable for audit purposes.

### Timestamps
All tables include `created_at` and `updated_at` via `t.timestamps`.

### Indexes
- Always index `organization_id` (every query is scoped)
- Index foreign keys
- Add composite indexes for common query patterns
- Index `discarded_at` on soft-delete tables

### Data Types
- Money: `decimal` with precision 10, scale 2
- Dates: `date` for calendar dates, `datetime` for timestamps
- Status fields: `integer` with Rails enum
- Phone numbers: `string` (no formatting constraints at DB level)
- Email: `string` with uniqueness constraint scoped to organization

### Constraints
Prefer both database-level constraints AND ActiveRecord validations:
```ruby
# Migration
t.string :email, null: false
add_index :customers, [:organization_id, :email], unique: true

# Model
validates :email, presence: true, uniqueness: { scope: :organization_id }
```
