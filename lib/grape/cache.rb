require 'grape'
require 'active_support'
require 'active_support/concern'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/object/blank'

require "grape/cache/dsl"
require "grape/cache/version"
require "grape/cache/backend/memory"


module Grape
  if defined?(Grape::API)
    if Grape::API.const_defined?(:Instance)
      Grape::API::Instance.include(Grape::Cache::DSL)
    else
      Grape::API.include(Grape::Cache::DSL)
    end
  end
end
