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
          @databases ||= Databases.new(self)
        end

        def perform_get_request(path)
          url = build_uri(path)
          req = Net::HTTP::Get.new(url)
          set_headers(req)
          response = start_request(req, url)
          parse_response(response)
        end

        def perform_post_request(path, params = {})
          url = build_uri(path)
          req = Net::HTTP::Post.new(url)
          set_headers(req)
          req.body = params.to_json
          response = start_request(req, url)
          parse_response(response)
        end

        private
        def build_uri(path)
          URI.join(@basic_url, path)
        end

        def set_headers(req)
          req['Accept'] = 'application/vnd.heroku+json; version=3'
          req.basic_auth '', @oauth_client_key
        end

        def start_request(req, url)
          http_new = Net::HTTP.new(url.hostname, url.port)
          http_new.use_ssl = true
          response = http_new.start { |http| http.request(req) }
        end

        def parse_response(response)
          if %w[200 201].include? response.code
            JSON.parse(response.body, symbolize_names: true)
          else
            { error: { status: response.code.to_i } }
          end
        end
      end
    end
  end
end
