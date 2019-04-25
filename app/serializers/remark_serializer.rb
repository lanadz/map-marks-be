class RemarkSerializer
  def initialize(object)
    @object = object
  end

  def as_json(*)
    {
        id: object.id,
        user_name: object.user_name,
        body: object.body,
        lat: object.lat,
        lng: object.lng,
        created_at: object.created_at.strftime("%F"),
        updated_at: object.updated_at.strftime("%F"),
        distance: object.try(:distance).try(:to_i),
    }
  end

  def to_json(*)
    as_json
  end

  private

  attr_reader :object
end
