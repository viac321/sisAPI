class EarthquakeController < ApplicationController
  def index
    begin
      data = `rake obtain_data:fetch[1,1000,'mb']` # Execute the correct task and obtain the data
        @earthquakes = JSON.parse(data) # Parse the data to JSON
        render json: @earthquakes # Return the data as the response of the endpoint
    rescue => e
        # If an error occurs, return a 500 status with the error message
        render json: { error: e.message }, status: :internal_server_error
        Rails.logger.error e.backtrace.join("\n")
        raise e
    end
  end
end