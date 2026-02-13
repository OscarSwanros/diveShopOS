module ApplicationHelper
  def page_title
    title = content_for(:page_title).presence ||
            I18n.t("#{controller_name}.#{action_name}.title", default: nil) ||
            controller_name.humanize.titleize
    org = current_organization&.name
    org ? "#{title} | #{org}" : title
  end

  def nav_link(label, path, active: false, mobile: false, badge_count: nil)
    if mobile
      css = active ?
        "block px-3 py-2 rounded-md text-sm font-medium text-blue-600 bg-blue-50" :
        "block px-3 py-2 rounded-md text-sm font-medium text-gray-600 hover:text-gray-900 hover:bg-gray-50"
    else
      css = active ?
        "inline-flex items-center px-3 py-2 text-sm font-medium text-blue-600 border-b-2 border-blue-600" :
        "inline-flex items-center px-3 py-2 text-sm font-medium text-gray-600 hover:text-gray-900 border-b-2 border-transparent"
    end

    link_to path, class: css do
      badge_html = if badge_count && badge_count > 0
        content_tag(:span, badge_count,
          class: "ml-1.5 inline-flex items-center justify-center px-1.5 py-0.5 text-xs font-medium rounded-full bg-amber-100 text-amber-800",
          aria: { label: t("navigation.pending_reviews_count", count: badge_count) })
      end
      safe_join([ label, badge_html ].compact)
    end
  end

  def nav_dropdown_link(label, path, active: false)
    css = active ?
      "block px-4 py-2 text-sm text-blue-600 bg-blue-50" :
      "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 hover:text-gray-900"
    link_to label, path, class: css, role: "menuitem"
  end

  def nav_section_header(label)
    content_tag(:div, label, class: "px-3 pt-4 pb-1 text-xs font-semibold text-gray-400 uppercase tracking-wider")
  end

  def operations_nav_active?
    controller_name.in?(%w[equipment_items service_records checklist_templates checklist_items checklist_runs checklist_responses excursion_checklist_runs dive_sites medical_records all_customer_tanks])
  end

  def user_menu_nav_active?
    controller_name.in?(%w[users instructor_ratings]) || controller_path.start_with?("settings")
  end

  def brand_css_variables
    return "" unless current_organization
    Rails.cache.fetch([ "brand_css", current_organization.id, current_organization.updated_at ]) do
      Branding::CssVariablesGenerator.new(current_organization).call
    end
  end
end
