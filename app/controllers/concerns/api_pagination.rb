# frozen_string_literal: true

module ApiPagination
  extend ActiveSupport::Concern

  DEFAULT_PER_PAGE = 25
  MAX_PER_PAGE = 100

  private

  def paginate(scope)
    page = [ params.fetch(:page, 1).to_i, 1 ].max
    per_page = params.fetch(:per_page, DEFAULT_PER_PAGE).to_i.clamp(1, MAX_PER_PAGE)

    total_count = scope.count
    total_pages = (total_count.to_f / per_page).ceil
    total_pages = 1 if total_pages == 0

    @pagination = {
      current_page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: total_pages
    }

    scope.offset((page - 1) * per_page).limit(per_page)
  end
end
