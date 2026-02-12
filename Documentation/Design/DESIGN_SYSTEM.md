# Design System

## Overview

DiveShopOS uses Tailwind CSS with a consistent design system optimized for dive shop operational environments. The system prioritizes clarity, accessibility, and efficiency.

## Color System

### Semantic Colors
Use Tailwind's color scale consistently. Do not use arbitrary hex values.

**Primary**: Blue (`blue-600` / `blue-700`) -- Actions, links, primary buttons
**Success**: Green (`green-600`) -- Valid status, active certifications, cleared medical
**Warning**: Yellow/Amber (`amber-500`) -- Expiring soon, review needed, due soon
**Danger**: Red (`red-600`) -- Expired, invalid, overdue, destructive actions
**Neutral**: Gray scale -- Backgrounds, borders, secondary text

### Safety-Specific Color Coding

**Certification status**: `green-600` (active) / `amber-500` (expiring) / `red-600` (expired)
**Medical clearance**: `green-600` (cleared) / `amber-500` (review) / `red-600` (not cleared)
**Equipment service**: `green-600` (current) / `amber-500` (due soon) / `red-600` (overdue) / `gray-400` (retired)

**Important**: Never rely on color alone. Always pair with text labels or icons for accessibility.

## Typography

Use Tailwind's default font scale:
- **Headings**: `text-2xl font-bold` (page), `text-xl font-semibold` (section), `text-lg font-medium` (subsection)
- **Body**: `text-sm` or `text-base`
- **Labels**: `text-sm font-medium text-gray-700`
- **Help text**: `text-sm text-gray-500`

## Spacing

Follow Tailwind's spacing scale consistently. Common patterns:
- Page padding: `p-6` or `px-4 py-6`
- Card padding: `p-4` or `p-6`
- Stack spacing: `space-y-4` or `space-y-6`
- Inline spacing: `space-x-2` or `space-x-4`
- Form field spacing: `space-y-4`

## Components

### Buttons
```html
<!-- Primary -->
<button class="inline-flex items-center px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
  Save Booking
</button>

<!-- Secondary -->
<button class="inline-flex items-center px-4 py-2 bg-white text-gray-700 text-sm font-medium rounded-md border border-gray-300 hover:bg-gray-50">
  Cancel
</button>

<!-- Danger -->
<button class="inline-flex items-center px-4 py-2 bg-red-600 text-white text-sm font-medium rounded-md hover:bg-red-700">
  Remove Diver
</button>
```

### Cards
```html
<div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
  <!-- Card content -->
</div>
```

### Status Badges
```html
<!-- Active/Valid -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
  Active
</span>

<!-- Expiring -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800">
  Expiring
</span>

<!-- Expired/Invalid -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
  Expired
</span>
```

### Tables
Use responsive tables for manifests, schedules, inventory:
```html
<div class="overflow-x-auto">
  <table class="min-w-full divide-y divide-gray-200">
    <thead class="bg-gray-50">
      <tr>
        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
      </tr>
    </thead>
    <tbody class="bg-white divide-y divide-gray-200">
      <tr>
        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">...</td>
      </tr>
    </tbody>
  </table>
</div>
```

## Accessibility

### Contrast
- All text meets WCAG AA (4.5:1 minimum)
- Safety-critical information meets WCAG AAA (7:1)

### Interactive Elements
- Minimum click target: 44x44px
- Clear focus indicators: `focus:ring-2 focus:ring-offset-2 focus:ring-blue-500`
- Keyboard navigable

### ARIA
- Meaningful labels on all interactive elements
- Status indicators include text (not just color)
- Form errors are announced via `aria-describedby`

### Motion
- Respect `prefers-reduced-motion`
- Keep animations subtle and functional

## Responsive Design

- Mobile-first approach
- Optimized for desktop/tablet (dive shop primary devices)
- Tables become scrollable on small screens
- Navigation collapses on mobile
