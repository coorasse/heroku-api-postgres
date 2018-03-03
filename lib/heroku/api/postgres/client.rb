module Heroku
  module Api
    module Postgres
      def self.connect_oauth(oauth_client_key = ENV['HEROKU_OAUTH_TOKEN'])
        Client.new(oauth_client_key)
      end

      class Client
        def initialize(oauth_client_key)
          @oauth_client_key = oauth_client_key
          @basic_url = 'https://postgres-starter-api.heroku.com'
        end

        def backups
          @backups ||= Backups.new(self)
        end

        def databases
          @backups ||= Databases.new(self)
        end

        def perform_get_request(path)
          url = URI.join(@basic_url, path)
          req = Net::HTTP::Get.new(url)
          req['Accept'] = 'application/vnd.heroku+json; version=3'
          req.basic_auth '', @oauth_client_key
          http_new = Net::HTTP.new(url.hostname, url.port)
          http_new.use_ssl = true
          response = http_new.start { |http| http.request(req) }
          parse_response(response)
        end

        private

        def parse_response(response)
          if response.code == '200'
            JSON.parse(response.body, symbolize_names: true)
          else
            { error: { status: response.code.to_i } }
          end
        end
      end
    end
  end
end
