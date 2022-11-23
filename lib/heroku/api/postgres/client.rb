# frozen_string_literal: true

module Heroku
  module Api
    module Postgres
      def self.connect_oauth(oauth_client_key = ENV['HEROKU_OAUTH_TOKEN'])
        Client.new(oauth_client_key)
      end

      class Client
        STARTER_HOST = 'https://postgres-starter-api.heroku.com'
        PRO_HOST = 'https://postgres-api.heroku.com'

        attr_reader :oauth_client_key, :heroku_client

        def initialize(oauth_client_key)
          @oauth_client_key = oauth_client_key
          @basic_url = STARTER_HOST
          @heroku_client = PlatformAPI.connect_oauth(oauth_client_key)
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

        # the database id matches the field `id` in pro plans and the field addon_service.id in free plans
        def db_host(app_id, database_id)
          all_addons = heroku_client.addon.list_by_app(app_id)
          database_json = all_addons.find do |addon|
            [addon['id'], addon['addon_service']['id']].include?(database_id)
          end
          return STARTER_HOST if database_json.nil?

          host_for(database_json)
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

        def host_for(database_json)
          starter_plan?(database_json) ? STARTER_HOST : PRO_HOST
        end

        def starter_plan?(database)
          database['plan']['name'].match(/(dev|basic)$/)
        end

        def build_uri(path, host: @basic_url)
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
