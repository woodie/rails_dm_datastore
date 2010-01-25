# patch for -- dm-core 0.10.2 & rails 2.3.5
require 'dm-core'
require 'dm-ar-finders'
require 'dm-timestamps'
require 'dm-validations'
DataMapper.setup(:default, "appengine://auto")
#DataMapper.setup(:ephemeral, "in_memory::")
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
 
 
 #Override Extlib::Hook::ClassMethods.inline_call to check in the given weak reference

module LocalObjectSpace
  def self.extended(klass)
    (class << klass; self;end).send :attr_accessor, :hook_scopes
   
    klass.hook_scopes = []
  end
  
  def object_by_id(object_id)
    self.hook_scopes.each do |object|
      return object if object.object_id == object_id
    end
  end
  
end
 
module Extlib
  module Hook
    module ClassMethods
      
      extend LocalObjectSpace
        
      #end
      
      def inline_call(method_info, scope)
        Extlib::Hook::ClassMethods.hook_scopes << method_info[:from]
        name = method_info[:name]
        
        if scope == :instance
          args = method_defined?(name) && instance_method(name).arity != 0 ? '*args' : ''
          %(#{name}(#{args}) if self.class <= Extlib::Hook::ClassMethods.object_by_id(#{method_info[:from].object_id}))
        else
          args = respond_to?(name) && method(name).arity != 0 ? '*args' : ''
          %(#{name}(#{args}) if self <= Extlib::Hook::ClassMethods.object_by_id(#{method_info[:from].object_id}))
        end
      end
    end
  end
end

# makes the shorthand <%= render @posts %> work for collections of DataMapper objects
module ActionView
  module Partials
  alias :render_partial_orig :render_partial
  private
  
    def render_partial(options = {})
      if DataMapper::Collection === options[:partial]
        collection = options[:partial]
        options[:partial] = options[:partial].first.class.to_s.tableize.singular
        render_partial_collection(options.merge(:collection => collection))
      else
        render_partial_orig(options)      
      end
    end
  
  end
end