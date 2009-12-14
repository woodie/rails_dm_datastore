class <%= class_name %>
  include DataMapper::Resource
  
  property :id, Serial
<% for attribute in attributes -%>
  property :<%= attribute.name %>, <%= attribute.type %>
<% end -%>
end