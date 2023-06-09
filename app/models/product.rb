class Product < ApplicationRecord
  enum status: { deactive: 0, active: 1 }

  validates :name, :price, :photo_url, :status, presence: true
  validates :name, length: { maximum: 100 }, uniqueness: { case_sensitive: false }
  validates_format_of :photo_url, with: URI.regexp

  paginates_per 5
end
