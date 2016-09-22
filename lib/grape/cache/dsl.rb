require_relative 'endpoint_cache_config'
require_relative 'middleware'

module Grape
  module Cache
    module DSL
      extend ActiveSupport::Concern

      included do
        before_validation do
          if options[:route_options][:cache].present?
            options[:route_options][:cache].validate_cache(self, env['grape.cache'])
          end
        end
      end

      module ClassMethods
        def cache(*arguments, &block)
          config = Grape::Cache::EndpointCacheConfig.new(arguments.extract_options!)
          config.instance_eval(&block) if block_given?
          route_setting :cache, config
        end

        def route(methods, paths = ['/'], route_options = {}, &block)
          super(methods, paths, route_options.deep_merge({cache: route_setting(:cache)}), &block)
        end
      end
    end
  end
end
