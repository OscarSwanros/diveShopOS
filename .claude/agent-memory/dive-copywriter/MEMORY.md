# DiveShopOS Copywriter Memory

## Brand Identity
- Product name: **DiveShopOS** (one word, capital S, capital OS)
- Domain: diveshopos.com
- Contact: hello@diveshopos.com
- Tagline: "The operating system for dive shops and schools."
- Positioning: Professional operations software, not a consumer app or booking widget

## Brand Voice Patterns
- Headline style: Active, operational ("Run your dive operation, not your software.")
- Never use emojis in any copy
- Professional tone -- write like a knowledgeable diver running a business, not a marketing department
- Avoid superlatives and hype ("the best", "revolutionary") -- state capabilities directly
- Use em dashes (--) not en dashes for parenthetical statements

## Key Differentiators (messaging hierarchy)
1. Safety gates (the core differentiator -- always lead with this)
2. Agency neutrality (list agencies: PADI, SSI, NAUI, SDI/TDI, RAID, CMAS, BSAC)
3. Whitelabel / custom domains ("yourdiveshop.com, not diveshopos.com/shop/123")
4. Modern web platform (no native app, real-time, works on tablet)
5. All-in-one operations

## Terminology Decisions
- "Safety gates" -- the branded term for built-in business rule enforcement
- "Agency neutral" -- preferred phrasing for certification agency compatibility
- Use specific diving examples to make safety gates concrete (e.g., "Open Water diver on advanced wreck dive", "regulator overdue for service")
- "Excursions" not "trips" (matches the domain model)

## Site Infrastructure
- Jekyll site in `/docs/` directory, deployed to diveshopos.com via GitHub Pages
- Layout: default.html, includes header.html and footer.html
- CNAME: diveshopos.com
- Pages: index, privacy-policy, terms-of-use

## Legal Copy Patterns
- Terms of Use: `/Users/swanros/code/vamosabucear/docs/terms-of-use.md`
- Diving safety disclaimer is Section 2, prominently placed before operational terms
- Key phrase: "The dive professional is always the final authority on safety decisions"
- Safety tools described as "advisory, not authoritative"
- Override capability acknowledged as by-design, with audit logging
- Data ownership: customer owns data, DiveShopOS is processor
- Governing law state left as [To Be Determined] -- needs resolution
- 30-day data export window after termination; 30-day notice for material Terms changes
- "Safety gates" becomes "safety compliance tools" in user-facing legal copy
- ALL CAPS for warranty disclaimers and liability limitations (standard legal convention)
- Use "life-support gear" when referring to regulators, BCDs, cylinders in legal context

## See Also
- [terminology.md](terminology.md) -- Diving terminology reference (to be created)
