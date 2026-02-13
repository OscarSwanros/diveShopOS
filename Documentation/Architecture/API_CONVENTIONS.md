# API Conventions

## Overview

DiveShopOS exposes a versioned JSON API under `/api/v1/`. Every web UI action has a corresponding API endpoint. New features must include API endpoints alongside web controllers.

## Authentication

### Token-Based Auth (Bearer Token)

API tokens use SHA256-hashed storage (same pattern as GitHub PATs):

1. **Create a token** via `POST /api/v1/authentication` with email + password
2. **Use the token** via `Authorization: Bearer <token>` header
3. The plain token is returned once on creation; only the digest is stored

```bash
# Get a token
curl -X POST /api/v1/authentication \
  -H "Content-Type: application/json" \
  -d '{"email": "user@shop.com", "password": "secret"}'

# Use the token
curl /api/v1/customers \
  -H "Authorization: Bearer <token>"
```

### Token Lifecycle

- Tokens have an optional `expires_at` timestamp
- Tokens can be revoked via `DELETE /api/v1/api_tokens/:id`
- `last_used_at` is updated on each use
- Expired and revoked tokens are rejected with `401 Unauthorized`

### Tenant Resolution

The token belongs to a User who belongs to an Organization. The token IS the tenant identifier -- no additional headers needed.

## Request/Response Format

### Success (single resource)

```json
{
  "data": {
    "id": "uuid",
    "name": "Example",
    "created_at": "2026-01-01T00:00:00Z",
    "updated_at": "2026-01-01T00:00:00Z"
  }
}
```

### Success (collection)

```json
{
  "data": [
    { "id": "uuid", "name": "Example" }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 25,
    "total_count": 42,
    "total_pages": 2
  }
}
```

### Error

```json
{
  "error": {
    "code": "string",
    "message": "Human-readable message",
    "details": ["optional array of specifics"]
  }
}
```

### Error Codes

| Code | HTTP Status | When |
|------|-------------|------|
| `unauthorized` | 401 | Missing or invalid token |
| `invalid_credentials` | 401 | Bad email/password on authentication |
| `forbidden` | 403 | Pundit authorization denied |
| `not_found` | 404 | Resource doesn't exist or wrong tenant |
| `parameter_missing` | 400 | Required parameter not provided |
| `validation_failed` | 422 | Model validation errors |
| `safety_gate_failed` | 422 | Safety gate check failed |
| `completion_failed` | 422 | Course completion validation failed |

## Pagination

Collections use page-based pagination:

| Parameter | Default | Max | Description |
|-----------|---------|-----|-------------|
| `page` | 1 | -- | Page number |
| `per_page` | 25 | 100 | Items per page |

## HTTP Status Codes

| Action | Success | Common Errors |
|--------|---------|---------------|
| GET (index) | 200 | 401 |
| GET (show) | 200 | 401, 403, 404 |
| POST (create) | 201 | 401, 403, 422 |
| PATCH (update) | 200 | 401, 403, 404, 422 |
| DELETE (destroy) | 204 | 401, 403, 404 |

## Endpoints

### Authentication & Tokens

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/v1/authentication` | Exchange email+password for token |
| GET | `/api/v1/api_tokens` | List current user's tokens |
| POST | `/api/v1/api_tokens` | Create new token |
| DELETE | `/api/v1/api_tokens/:id` | Revoke a token |

### Customers

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/customers` | List customers |
| POST | `/api/v1/customers` | Create customer |
| GET | `/api/v1/customers/:id` | Show customer |
| PATCH | `/api/v1/customers/:id` | Update customer |
| DELETE | `/api/v1/customers/:id` | Deactivate customer |

### Certifications (nested under customers)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/customers/:id/certifications` | List certifications |
| POST | `/api/v1/customers/:id/certifications` | Create certification |
| GET | `/api/v1/customers/:id/certifications/:id` | Show certification |
| PATCH | `/api/v1/customers/:id/certifications/:id` | Update certification |
| DELETE | `/api/v1/customers/:id/certifications/:id` | Soft-delete certification |

### Medical Records (nested under customers)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/customers/:id/medical_records` | List medical records |
| POST | `/api/v1/customers/:id/medical_records` | Create medical record |
| GET | `/api/v1/customers/:id/medical_records/:id` | Show medical record |
| PATCH | `/api/v1/customers/:id/medical_records/:id` | Update medical record |
| DELETE | `/api/v1/customers/:id/medical_records/:id` | Soft-delete medical record |

### Users (Staff)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/users` | List staff users |
| POST | `/api/v1/users` | Create user (owner only) |
| GET | `/api/v1/users/:id` | Show user |
| PATCH | `/api/v1/users/:id` | Update user |
| DELETE | `/api/v1/users/:id` | Delete user (owner only) |

### Instructor Ratings

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/instructor_ratings` | List ratings |
| POST | `/api/v1/instructor_ratings` | Create rating |
| GET | `/api/v1/instructor_ratings/:id` | Show rating |
| PATCH | `/api/v1/instructor_ratings/:id` | Update rating |
| DELETE | `/api/v1/instructor_ratings/:id` | Delete rating |

### Courses

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/courses` | List courses (filter: `agency`, `course_type`) |
| POST | `/api/v1/courses` | Create course |
| GET | `/api/v1/courses/:id` | Show course |
| PATCH | `/api/v1/courses/:id` | Update course |
| DELETE | `/api/v1/courses/:id` | Delete course |

### Course Offerings (nested under courses)

CRUD at `/api/v1/courses/:course_id/course_offerings`

### Class Sessions (nested under course offerings)

CRUD at `/api/v1/courses/:course_id/course_offerings/:offering_id/class_sessions`

### Session Attendances (nested under class sessions)

| Method | Path | Description |
|--------|------|-------------|
| PATCH | `.../class_sessions/:id/session_attendances/batch_update` | Batch update attendance |

### Enrollments (nested under course offerings)

CRUD at `/api/v1/courses/:course_id/course_offerings/:offering_id/enrollments`

| Method | Path | Description |
|--------|------|-------------|
| POST | `.../enrollments/:id/complete` | Complete enrollment (safety gates enforced) |

### Dive Sites

CRUD at `/api/v1/dive_sites`

### Excursions

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/excursions` | List excursions (filter: `status`) |
| POST | `/api/v1/excursions` | Create excursion |
| GET | `/api/v1/excursions/:id` | Show excursion |
| PATCH | `/api/v1/excursions/:id` | Update excursion |
| DELETE | `/api/v1/excursions/:id` | Delete excursion |

### Trip Dives (nested under excursions)

CRUD at `/api/v1/excursions/:excursion_id/trip_dives`

### Trip Participants (nested under excursions)

CRUD at `/api/v1/excursions/:excursion_id/trip_participants` (capacity gate enforced on create)

## Adding API Endpoints for New Features

When adding a new domain module:

1. Create `app/controllers/api/v1/<resource>_controller.rb` inheriting from `Api::V1::BaseController`
2. Include `ApiPagination` for index actions
3. Add jbuilder templates in `app/views/api/v1/<resource>/`
4. Add routes in the `namespace :api { namespace :v1 { ... } }` block (exclude `new`/`edit`)
5. Add tests in `test/controllers/api/v1/<resource>_controller_test.rb`
6. Ensure Pundit policies include `index?` and `show?` methods
7. Use `render_safety_gate_failure` for safety gate errors
8. Use `render_validation_errors` for model validation errors

## Controller Pattern

```ruby
module Api
  module V1
    class ResourcesController < BaseController
      include ApiPagination

      before_action :set_resource, only: [:show, :update, :destroy]

      def index
        @resources = paginate(policy_scope(current_organization.resources))
      end

      def show
      end

      def create
        @resource = current_organization.resources.build(resource_params)
        authorize @resource

        if @resource.save
          render :show, status: :created
        else
          render_validation_errors(@resource)
        end
      end

      def update
        if @resource.update(resource_params)
          render :show
        else
          render_validation_errors(@resource)
        end
      end

      def destroy
        @resource.destroy
        head :no_content
      end

      private

      def set_resource
        @resource = current_organization.resources.find(params[:id])
        authorize @resource
      end

      def resource_params
        params.require(:resource).permit(:field1, :field2)
      end
    end
  end
end
```
