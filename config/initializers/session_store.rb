# frozen_string_literal: true

# Share session cookies across subdomains so that a session set on
# diveshopos.com can be read on shop.diveshopos.com after registration.
# In development, use lvh.me (resolves to 127.0.0.1) for subdomain testing.
Rails.application.config.session_store :cookie_store,
  key: "_diveshopos_session",
  domain: :all,
  tld_length: 2
