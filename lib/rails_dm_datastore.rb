# patch for -- dm-core 0.10.2 & rails 2.3.5
require 'dm-core'
require 'dm-ar-finders'
require 'dm-timestamps'
require 'dm-validations'
DataMapper.setup(:default, "appengine://auto")

module DataMapper
  module Resource
    # avoid object references in URLs
    def to_param; id.to_s; end
    # silence deprecation warnings
    def new_record?; new?; end
    # avoid NoMethodError
    def update_attributes(*args); update(*args); end
  end
end

# DataMapper::Validate
class Dictionary; alias count length; end
 
module Extlib
  module Hook
    module ClassMethods
      def inline_call(method_info, scope)
        name = method_info[:name]
        if scope == :instance
          args = method_defined?(name) &&
              instance_method(name).arity != 0 ? '*args' : ''
        else
          args = respond_to?(name) &&
              method(name).arity != 0 ? '*args' : ''
        end
        # ObjectSpace._id2ref should be replaced with WeakRef
        %(#{name}(#{args})) # Always call hook... set_timestamps_on_save()
      end
    end
  end
end
