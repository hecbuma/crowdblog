module Crowdblog
  class Engine < ::Rails::Engine
    isolate_namespace Crowdblog

    Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
      Rails.configuration.cache_classes ? require(c) : load(c)
    end

    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w( crowdblog.css crowdblog.js )
    end
  end
end
