require 'net/http'
require 'json'

module Heroku
  module Api
    module Postgres
      class Backups
        def initialize(oauth_client_key = ENV['HEROKU_OAUTH_TOKEN'])
          @oauth_client_key = oauth_client_key
          @basic_url = 'https://postgres-starter-api.heroku.com'
        end

        def schedules(database_id)
          perform_get_request("/client/v11/databases/#{database_id}/transfer-schedules")
        end

        private
        def perform_get_request(path)
          url = URI.join(@basic_url, path)
          req = Net::HTTP::Get.new(url)
          req['Accept'] = 'application/vnd.heroku+json; version=3'
          req.basic_auth '', @oauth_client_key
          http_new = Net::HTTP.new(url.hostname, url.port)
          http_new.use_ssl = true
          response = http_new.start { |http| http.request(req) }
          if response.code == '200'
            JSON.parse(response.body, symbolize_names: true)
          else
            {error: {status: response.code.to_i}}
          end
        end
      end
    end
  end
end
