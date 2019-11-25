# frozen_string_literal: true

# Include the Websolr::Connection class if needed
require 'websolr/connection'

# Namespace this code to Websolr
module Websolr
  # Create a Railtie, which will allow us to define one or more initializers:
  class Railtie < ::Rails::Railtie
    # Define an initializer that sets up the connection to Solr using a custom
    # Websolr::Connection connection class. If there is a WEBSOLR_LB variable
    # set, and it is true, then add the prefer-replica header.
    initializer 'setup_solr' do
      require 'rsolr'
      headers = {}
      if ENV['WEBSOLR_LB'].present? && ENV['WEBSOLR_LB'] == 'true'
        headers.merge!({'X-Websolr-Routing': 'prefer-replica'})
      end
      Sunspot::Session.connection_class = Websolr::Connection.new(headers)
    end
  end
end
