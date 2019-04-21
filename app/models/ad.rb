class Ad < ApplicationRecord
  include RailsSortable::Model
  set_sortable :sort, without_updating_timestamps: true

  belongs_to :country
  belongs_to :brand
  has_one_attached :image

  validates :title, presence: true
  validates :brand_id, presence: true
  validates :country_id, presence: true
  validate :image_attached

  def thumbnail
    return self.image.variant(resize: '80x80!').processed
  end

  def preview_image
    return self.image.variant(resize: '180x160!').processed
  end

  private
  def image_attached
    if !image.attached?
      errors.add(:image, "must attach an image")
    end
  end
end
