class RemarkFilter
  def initialize(params)
    @lng = params[:lng]
    @lat = params[:lat]
    @radius_in_km = params[:radius]
    @q = params[:q]&.downcase
  end

  def run
    result = Remark.all

    if radius_in_km.present? && valid_lat_lng?
      result = result.within(lng, lat, radius_in_km)
    end

    if q.present?
      result = result.where("(LOWER(user_name) LIKE :q OR LOWER(body) like :q)", q: "%#{q}%")
      if valid_lat_lng?
        result = result.with_distance(lng, lat)
      end
    end

    result
  end

  private

  attr_reader :lng, :lat, :radius_in_km, :q

  def valid_lat_lng?
    remark = Remark.new(point: "POINT(#{lng} #{lat})")
    lat.present? && lng.present? && remark.point.present?
  end
end