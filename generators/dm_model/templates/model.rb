<% max = min = 10 -%>
<% Array(attributes).each do |attribute|
  max = attribute.name.size if max < attribute.name.size
  min = attribute.name.size if min > attribute.name.size

  Array(DataMapper::Property::PRIMITIVES).collect{|i| i.to_s}|DataMapper::Types.constants
  unless (Array(DataMapper::Property::PRIMITIVES).collect{|i| i.to_s}|DataMapper::Types.constants).include? attribute.type.to_s
    raise "unknown property type '#{attribute.type}'"
  end
  
  max += 1
end
-%>
class <%= class_name %>
  include DataMapper::Resource
  
  property :id,<%= " " * (max - 2) %>Serial
<% Array(attributes).each do |attribute| -%>
  property :<%= attribute.name %>,<%= " " * (max - attribute.name.size) %><%= attribute.type %>
<% end -%>
<% unless options[:skip_timestamps] -%>
  property :created_at, <%= " " * (max - 11) %>DateTime
  property :updated_at, <%= " " * (max - 11) %>DateTime
<% end -%>
end