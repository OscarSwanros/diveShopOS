module ApplicationHelper
  def nav_link(label, path, active: false, mobile: false)
    if mobile
      css = active ?
        "block px-3 py-2 rounded-md text-sm font-medium text-blue-600 bg-blue-50" :
        "block px-3 py-2 rounded-md text-sm font-medium text-gray-600 hover:text-gray-900 hover:bg-gray-50"
    else
      css = active ?
        "inline-flex items-center px-3 py-2 text-sm font-medium text-blue-600 border-b-2 border-blue-600" :
        "inline-flex items-center px-3 py-2 text-sm font-medium text-gray-600 hover:text-gray-900 border-b-2 border-transparent"
    end

    link_to label, path, class: css
  end
end
