require "grape/cache/dsl"
require "grape/cache/version"
require "grape/cache/backend/memory"


module Grape
  class API
    class Instance
      include Grape::Cache::DSL
    end  
  end
end
