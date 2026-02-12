# Rails Conventions

## Project-Specific Rails Patterns

### Controllers
- Keep controllers thin -- standard CRUD actions following RESTful conventions
- Scope all queries through `current_organization`
- Use Pundit for authorization in every action
- Use strong parameters, never in models

```ruby
class ExcursionsController < ApplicationController
  def index
    @excursions = policy_scope(current_organization.excursions)
  end

  def create
    @excursion = current_organization.excursions.build(excursion_params)
    authorize @excursion

    if @excursion.save
      redirect_to @excursion
    else
      render :new, status: :unprocessable_entity
    end
  end
end
```

### Models
- Focus on associations, validations, scopes, and core domain logic
- Use concerns sparingly -- only for truly cross-cutting behavior
- Use Rails enum for status fields
- Always include organization scoping

### Service Objects
- Live in `app/services/<domain>/`
- Single public method: `call`
- Use for business logic that coordinates multiple models
- All safety gates are service objects

```ruby
# app/services/excursions/validate_participant_eligibility.rb
module Excursions
  class ValidateParticipantEligibility
    def initialize(customer:, excursion:)
      @customer = customer
      @excursion = excursion
    end

    def call
      # Returns Result object with success/failure + reasons
    end
  end
end
```

### Hotwire Patterns

#### Turbo Frames
- Use for partial page updates (editing inline, loading sections)
- Name frames descriptively: `excursion_#{excursion.id}`, `customer_details`

#### Turbo Streams
- Use for real-time updates (new bookings, status changes)
- Broadcast from models or service objects

#### Stimulus Controllers
- Keep small and focused
- Use data attributes for configuration
- Prefer Turbo for navigation, Stimulus for behavior

### Localization
- All user-facing strings use `I18n.t()`
- Organize keys by domain: `excursions.index.title`, `customers.form.email_label`
- Supported languages: English (default), Spanish, French

### Testing
- Minitest with fixtures
- One test file per model, controller, service
- Test safety gates exhaustively
- System tests for critical user workflows
