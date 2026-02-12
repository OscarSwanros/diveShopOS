class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Generate UUID primary keys for all models
  before_create :set_uuid_primary_key

  private

  def set_uuid_primary_key
    self.id = SecureRandom.uuid if id.blank?
  end
end
