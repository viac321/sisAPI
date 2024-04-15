class Earthquake < ApplicationRecord::Base
    attr_accessor :id, :type, :external_id, :magnitude, :place, :time, :tsunami, :mag_type, :title, :longitude, :latitude, :external_url
    validates :magnitude, inclusion: { in: -1.0..10.0 }
    validates :latitude, inclusion: { in: -90.0..90.0 }
    validates :longitude, inclusion: { in: -180.0..180.0 }

    # Validación de unicidad
    validates :external_id, uniqueness: true

  def initialize(attributes)
    @id = attributes['id']
    @type = attributes['type']
    @external_id = attributes['attributes']['external_id']
    @magnitude = attributes['attributes']['magnitude']
    @place = attributes['attributes']['place']
    @time = attributes['attributes']['time']
    @tsunami = attributes['attributes']['tsunami']
    @mag_type = attributes['attributes']['mag_type']
    @title = attributes['attributes']['title']
    @longitude = attributes['attributes']['coordinates']['longitude']
    @latitude = attributes['attributes']['coordinates']['latitude']
    @external_url = attributes['links']['external_url']
  end

  def to_json
    {
      id: @id,
      type: @type,
      attributes: {
        external_id: @external_id,
        magnitude: @magnitude,
        place: @place,
        time: @time,
        tsunami: @tsunami,
        mag_type: @mag_type,
        title: @title,
        coordinates: {
          longitude: @longitude,
          latitude: @latitude
        }
      },
      links: {
        external_url: @external_url
      }
    }.to_json
  end
end
