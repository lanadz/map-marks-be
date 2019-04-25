module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)['data']
    end

    def json_errors
      JSON.parse(response.body)['errors']
    end
  end
end