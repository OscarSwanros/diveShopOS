# Module Development Guide

How to add a new domain module to DiveShopOS.

## Steps

### 1. Define the Domain

Before writing code, document:
- What business problem does this module solve?
- What are the core entities (models)?
- How does this module relate to existing modules?
- What safety gates apply?

### 2. Create Models

```bash
bin/rails generate model ModelName organization:references field:type --primary-key-type=uuid
```

Every model must:
- Belong to an Organization
- Have UUID primary key
- Include appropriate validations (both model and database level)
- Include `discarded_at` if customer-facing data

### 3. Create Controllers

Follow RESTful conventions:
```bash
bin/rails generate controller ModelNames index show new create edit update destroy
```

Every controller action must:
- Scope queries through `current_organization`
- Call `authorize` for Pundit
- Use strong parameters

### 4. Create Service Objects

For business logic that coordinates multiple models:

```ruby
# app/services/domain_name/action_name.rb
module DomainName
  class ActionName
    def initialize(params)
      @params = params
    end

    def call
      # Business logic here
      # Return a result object
    end
  end
end
```

### 5. Create Views

- Use Turbo Frames for partial page updates
- Use Tailwind CSS classes from the design system
- All strings use `I18n.t()`
- Follow patterns in `Documentation/Design/DESIGN_SYSTEM.md`

### 6. Write Tests

- Model tests: validations, associations, scopes
- Service tests: all branches, especially safety gate rejections
- Controller tests: authorization, happy path, error cases
- System tests: critical user workflows

### 7. Update Documentation

- Add module to `Documentation/Domains/README.md`
- Update CLAUDE.md domain module registry if needed
- Add any new safety gates to the safety gates list

### 8. Review Legal Documents

When adding a new feature that collects, stores, or processes user data, review and update:
- `docs/privacy-policy.md` -- ensure all new data types and processing are covered
- `docs/terms-of-use.md` -- ensure terms cover any new functionality or liability considerations
