# Whitelabel Design Notes

## Tenant Resolution Middleware
- Resolution order: custom_domain -> subdomain -> 404
- Set `Current.organization` via `ActiveSupport::CurrentAttributes`
- Cache domain->org lookup in Rails.cache (5-min TTL)
- Invalidate cache on organization domain update

## Organization Whitelabel Columns
- `custom_domain` (string, nullable, partial unique index)
- `subdomain` (string, nullable, partial unique index)
- `brand_primary_color` (string, nullable, hex color)
- `brand_accent_color` (string, nullable, hex color)
- `tagline` (string, nullable)
- `locale` (string, not null, default "en")
- `time_zone` (string, not null, default "UTC")
- Logos/favicon: Active Storage attachments, not columns

## Explicitly Deferred
- No theme JSON blob or customization table (premature)
- No custom_css field (support nightmare)
- No ssl_certificate column (infrastructure concern, handled by Caddy)

## Infrastructure
- Caddy reverse proxy handles TLS for custom domains (auto Let's Encrypt)
- All custom domains route to same Rails process
- Rails reads request.host, resolves tenant, doesn't care about TLS
