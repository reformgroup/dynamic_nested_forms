module DynamicNestedForms
  class Engine < Rails::Engine
    isolate_namespace DynamicNestedForms
    
    config.generators do |g|
      g.test_framework :rspec
    end
    
    # configure our plugin on boot
    initializer 'dynamic_nested_forms' do
      ActiveSupport.on_load(:action_view) do
        require "dynamic_nested_forms/view_helpers"
        class ActionView::Base
          include DynamicNestedForms::ViewHelpers
        end
      end
    end
  end
end