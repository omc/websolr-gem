# frozen_string_literal: true

# If we're running this Gem within a Rails context, then we should be able to
# load an initializer:
if defined?(Rails)
  require File.expand_path('websolr/railtie', File.dirname(__FILE__))
end

require File.expand_path('websolr/connection', File.dirname(__FILE__))
