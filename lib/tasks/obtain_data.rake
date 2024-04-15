require 'active_record'
require 'open-uri'
require 'json'

class Earthquake < ActiveRecord::Base
  self.table_name = "earthquakes"
end

namespace :obtain_data do
    desc 'Fetch earthquake data from USGS and persist in database'
    task :fetch, [:page, :per_page, :mag_type] => :environment do |t, args|
      args.with_defaults(page: nil, per_page: nil, mag_type: nil)
  
      page = args[:page]
      per_page = args[:per_page] ? [args[:per_page].to_i, 1000].min : nil
      mag_types = args[:mag_type].split(',') if args[:mag_type]
  
      uri = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson'
      json = URI.open(uri).read
      data = JSON.parse(json)
  
      earthquakes = []
  
      data['features'].each do |feature|
        earthquake_attributes = {
          external_id: feature['id'],
          magnitude: feature['properties']['mag'],
          place: feature['properties']['place'],
          time: DateTime.strptime(feature['properties']['time'].to_s, '%Q'),
          tsunami: feature['properties']['tsunami'] == 1,
          mag_type: feature['properties']['magType'],
          title: feature['properties']['title'],
          longitude: feature['geometry']['coordinates'][0],
          latitude: feature['geometry']['coordinates'][1],
          external_url: feature['properties']['url'],
          quake_type: feature['properties']['type']
        }
        
        earthquakes << earthquake_attributes
      end
  
      if mag_types.present?
        earthquakes = earthquakes.select { |quake| mag_types.include?(quake[:mag_type]) }
      end
      
      total = earthquakes.count
      page = page.to_i
      per_page = per_page.to_i
      start_index = (page - 1) * per_page
      end_index = start_index + per_page - 1
      earthquakes = earthquakes[start_index..end_index]
  
      result = {
        earthquakes: earthquakes,
        pagination: {
          current_page: page,
          total: total,
          per_page: per_page
        }
      }
  
      result.to_json
    end
  end
  


    