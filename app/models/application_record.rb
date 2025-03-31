class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  before_create :set_uuid

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
