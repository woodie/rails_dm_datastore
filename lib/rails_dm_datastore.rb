# patch for -- dm-core 0.10.2 & rails 2.3.5
require 'dm-core'
require 'dm-ar-finders'
require 'dm-timestamps'
require 'dm-validations'
DataMapper.setup(:default, "appengine://auto")

require 'rails_dm_datastore/action_view_partials'
require 'rails_dm_datastore/active_support_conversions'
require 'rails_dm_datastore/datamapper_resource'
require 'rails_dm_datastore/datamapper_validate'
require 'rails_dm_datastore/extlib_hook'
