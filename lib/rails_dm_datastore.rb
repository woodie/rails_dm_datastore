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
    def update_attributes(*args); update(*args); end
  end
end
# DataMapper::Validate
class Dictionary; alias count length; end

# TODO: still need to fix this TypeError
# compared with non class/module
