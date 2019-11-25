# frozen_string_literal: true

# Namespace this code to Websolr
module Websolr
  # Create a special connection class. We might want other classes in this
  # namespace later
  class Connection
    attr_accessor :auth_token, :connection, :default_headers

    # Set up the Connection object with some attributes, namely headers, a
    # connection, and auth (if set)
    def initialize(default_headers = {})
      self.default_headers = default_headers
      self.connection      = create_connection
      self.auth_token    ||= self.class.auth_token

      patch_rsolr_client if auth_token.present?
    end

    # Pull the auth token from the environment. At some point maybe we add the
    # the ability to have separate READ/WRITE tokens, maybe we read from a YAML
    # file.
    def self.auth_token
      ENV['WEBSOLR_AUTH']
    end

    # Set the authentication headers for the connection. These will change each
    # second, so the hash it returns should not be cached.
    def self.auth_headers
      time  = Time.now.to_i.to_s
      nonce = time.split(//).sort_by{rand}.join
      auth  = OpenSSL::HMAC.hexdigest('sha1', auth_token, "#{time}#{nonce}")
      { 'X-Websolr-Time': time, 'X-Websolr-Nonce': nonce, 'X-Websolr-Auth': auth }
    end

    # Create a new RSolr Client that is optimally configured for Websolr.
    # Sunspot uses this class to manage connecting to Solr.
    def connect(opts = {})
      RSolr::Client.new(connection, opts)
    end

    # Create a Websolr-optimized connection. This method returns a Faraday
    # connection that has some custom headers, HTTP Keep-Alive, and Typhoeus
    # set up.
    def create_connection
      conn_opts = { request: {} }
      conn_opts[:request][:params_encoder] = Faraday::FlatParamsEncoder
      conn_opts[:headers] = default_headers
      Faraday.new(conn_opts) do |conn|
        conn.response :raise_error
        conn.headers = {
          user_agent: 'Websolr Client (Faraday with Typhoeus)',
          'Keep-Alive': 'timeout=10, max=1000'
        }.merge(conn_opts[:headers])
        conn.adapter  :typhoeus
      end
    end

    # If there is an auth token set, then patch the RSolr::Client method for
    # making requests, and inject the headers into the options. These headers
    # change every second, so they can't be cached. The method will need to make
    # call to Websolr::Connection::auth_headers each time to get the right
    # values.
    def patch_rsolr_client
      RSolr::Client.class_eval <<-RUBY
      def send_and_receive path, opts
        if opts[:headers].present?
          opts[:headers].merge!(Websolr::Connection::auth_headers)
        else
          opts[:headers] = Websolr::Connection::auth_headers
        end
        request_context = build_request path, opts
        execute request_context
      end
      RUBY
    end
  end
end
