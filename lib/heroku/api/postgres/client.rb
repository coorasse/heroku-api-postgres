# frozen_string_literal: true

module Heroku
  module Api
    module Postgres
      def self.connect(api_key = ENV.fetch('HEROKU_API_KEY', nil))
        Client.new.tap do |c|
          c.api_key = api_key
          c.heroku_client = PlatformAPI.connect(api_key)
        end
      end

      def self.connect_oauth(oauth_client_key = ENV.fetch('HEROKU_OAUTH_TOKEN', nil))
        Client.new.tap do |c|
          c.oauth_client_key = oauth_client_key
          c.heroku_client = PlatformAPI.connect_oauth(oauth_client_key)
        end
      end

      class Client
        attr_accessor :api_key, :api_host, :oauth_client_key, :heroku_client

        def initialize
          @api_host = 'https://api.heroku.com'
        end

        def backups
          @backups ||= Backups.new(self)
        end

        def databases
          @databases ||= Databases.new(self)
        end

        def credentials
          @credentials ||= Credentials.new(self)
        end

        def perform_get_request(path, options = {})
          url = build_uri(path, **options)
          req = Net::HTTP::Get.new(url)
          add_auth_headers(req)
          response = start_request(req, url)
          parse_response(response)
        end

        def perform_post_request(path, params = {}, options = {})
          url = build_uri(path, **options)
          req = Net::HTTP::Post.new(url)
          add_auth_headers(req)
          req.body = params.to_json
          response = start_request(req, url)
          parse_response(response)
        end

        private

        def build_uri(path, host: api_host)
          URI.join(host, path)
        end

        def add_auth_headers(req)
          req['Accept'] = 'application/vnd.heroku+json; version=3'
          req.basic_auth '', @oauth_client_key
        end

        def start_request(req, url)
          http_new = Net::HTTP.new(url.hostname, url.port)
          http_new.use_ssl = true
          http_new.start { |http| http.request(req) }
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
