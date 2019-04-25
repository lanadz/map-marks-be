class Remark < ApplicationRecord
  validates :body, presence: true
  validates :user_name, presence: true
  validates :point, presence: { message: "GPS coordinates are invalid" }

  scope :with_distance, -> (lng, lat) {
    select("*, ST_Distance(point, 'POINT(#{lng} #{lat})') as distance").order('distance asc')
  }
  scope :within, -> (lng, lat, distance_in_km = 1) {
    with_distance(lng, lat).where("ST_Distance(point, 'POINT(? ?)') < ?",  lng.to_f, lat.to_f, distance_in_km).order('distance asc')
  }

  scope :at_position, -> (lng, lat) {
    with_distance(lng, lat).where(point: "POINT(#{lng} #{lat})")
  }

  def lng
    point.try(:x)
  end

  def lat
    point.try(:y)
  end
end
