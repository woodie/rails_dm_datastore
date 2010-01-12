<% max = 2
   presets = {'Text' => ':lazy => false', 'String' => ':length => 500'}
   reserved_dm_names = DataMapper::Resource.instance_methods +
                       DataMapper::Resource.private_instance_methods 
   datastore_types = %w(AncestorKey BigDecimal Blob Boolean ByteString
       Category Class Date DateTime Email Float Integer Key Link Object 
       PhoneNumber PostalAddres Rating String Text Time TrueClass) -%>
<% Array(attributes).each do |attribute|
     if reserved_dm_names.include? attribute.name
       raise "reserved property name '#{attribute.name}'"
     elsif !datastore_types.include? attribute.type.to_s.classify
       raise "unknown property type '#{attribute.type}'"
     end
     max = attribute.name.size if attribute.name.size > max -%>
<% end -%>
class <%= class_name %>
  include DataMapper::Resource
  
  property :id,<%= " " * (max - 2) %> Serial
<% Array(attributes).each do |attribute|
     klass = attribute.type.to_s.classify.to_s
     klass += 's' if klass.eql? 'PostalAddres' # classify bug
     more = presets.has_key?(klass) ? ", #{presets[klass]}" : ''
     pad = max - attribute.name.size
     rad = 13 - klass.size
     %>  property :<%= attribute.name %>, <%= " " * pad
     %><%= "#{klass}" %>, <%= " " * rad %>:required => true<%= more %>
<% end -%>
<% unless options[:skip_timestamps] -%>
  timestamps :at 
<% end -%>
end
