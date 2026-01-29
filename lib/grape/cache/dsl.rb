require_relative 'endpoint_cache_config'
require_relative 'middleware'

module Grape
  module Cache
    module DSL
      extend ActiveSupport::Concern

      module ClassMethods
        def install_grape_cache_hook!
          return if instance_variable_defined?(:@_grape_cache_hook_installed) && @_grape_cache_hook_installed

          run_cache_validation = proc do
            config = respond_to?(:route_setting) ? route_setting(:cache) : nil
            config ||= options.dig(:route_options, :cache) if respond_to?(:options)
            config ||= options.dig(:route_options, :cache) if defined?(options) && options.is_a?(Hash)

            config.validate_cache(self, env['grape.cache']) if config.present?
          end

          before(&run_cache_validation)
          before_validation(&run_cache_validation) if respond_to?(:before_validation)

          @_grape_cache_hook_installed = true
        end

        def cache(*arguments, &block)
          install_grape_cache_hook!
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
