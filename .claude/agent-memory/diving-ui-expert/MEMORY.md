# DiveShopOS UI/UX Expert Memory

## Marketing Site (Jekyll / GitHub Pages)
- Location: `docs/` directory, deployed via GitHub Pages
- CSS file: `docs/assets/css/style.css` (plain CSS, no Tailwind)
- Layouts: `docs/_layouts/default.html` (landing), `docs/_layouts/page.html` (legal pages)
- Uses CSS custom properties aligned with Tailwind palette equivalents
- Legacy aliases `--color-primary` / `--color-primary-dark` maintained for backward compat
- Safety section uses emerald color family (`--color-safety-*`) with green-50 background + top border accent
- `site-content--full` class enables full-width section-based layouts
- System font stack, no external font dependencies
- Supports both markdown-rendered content and section-based HTML

## Design System Patterns
- Safety-critical content: emerald/green color family, visually distinct from primary blue
- Feature cards: `--radius-xl` border radius, `--shadow-lg` on hover, generous `--space-8` padding
- Buttons: 44px min touch target (`min-height: 2.75rem`), focus ring via box-shadow
- All animations respect `prefers-reduced-motion: reduce`
- Focus indicators: 2px gap + 4px ring via `--focus-ring` custom property

## File Paths
- Design system doc: `Documentation/Design/DESIGN_SYSTEM.md`
- Design philosophy: `Documentation/Design/DESIGN_PHILOSOPHY.md`
- Rails conventions: `Documentation/Architecture/RAILS_CONVENTIONS.md`
