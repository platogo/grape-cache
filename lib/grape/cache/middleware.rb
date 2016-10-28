require_relative 'backend/memory'

module Grape
  module Cache
    class Middleware < Grape::Middleware::Base
      attr_accessor :backend

      def initialize(app, backend: nil)
        @app = app
        @backend = backend || Grape::Cache::Backend::Memory.new
      end

      def call!(env)
        env['grape.cache'] = self
        result = catch(:cache_hit) { @app.call(env) }
        if env['grape.cache.capture_key']
          backend.store(env['grape.cache.capture_key'], result, env['grape.cache.capture_metadata'])
        end
        result
      end
    end
  end
end

