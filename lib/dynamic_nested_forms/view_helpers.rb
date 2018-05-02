module DynamicNestedForms
  module ViewHelpers
    # .nested-container
    #   .nested-autocomplete
    #   .nested-items
    #    .nested-item
    #     .nested-content
    #     .nested-value
    #     .remove-item
    def autocomplete_to_add_item(name, f, association, source, options = {})
      new_object              = f.object.send(association).klass.new
      options[:class]         = ["autocomplete add-item", options[:class]].compact.join " "
      options[:data]          ||= {}
      options[:data][:id]     = new_object.object_id
      options[:data][:source] = source
      options[:data][:item]   = f.fields_for(association, new_object, child_index: options[:data][:id]) do |builder|
        render(association.to_s.singularize + "_item", f: builder).gsub "\n", ""
      end
      
      text_field_tag "autocomplete_nested_content", nil, options
    end
    
    # def link_to_add_item(name, f, association, options = {})
    #   options = data_attr name, f, association, options
    #   link_to name, "#", options
    # end
    # 
    # def data_attr(name, f, association, options = {})
    #   new_object       = f.object.send(association).klass.new
    #   options[:class]  = ["add-item", options[:class]].compact.join " "
    #   options[:id]     = new_object.object_id
    #   options[:item] = f.fields_for(association, new_object, child_index: options[:id]) do |builder|
    #     render(association.to_s.singularize + "_item", f: builder).gsub "\n", ""
    #   end
    #   options
    # end
    
    def link_to_remove_item(name = nil, options = {})
      name ||= "Remove"
      options[:class] = ["remove-item", options[:class]].compact.join " "
      link_to name, "#", options
    end
  end
end