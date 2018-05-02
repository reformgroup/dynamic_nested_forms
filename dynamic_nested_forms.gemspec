$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dynamic_nested_forms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dynamic_nested_forms"
  s.version     = DynamicNestedForms::VERSION
  s.authors     = ["Nikolay Lipovtsev"]
  s.email       = ["n.lipovtsev@gmail.com"]
  s.homepage    = "https://github.com/reformgroup/dynamic_nested_forms"
  s.summary     = "Dynamic Nested Forms with autocomplete and using jQuery."
  s.description = "Gem helps to make the simple dynamic control of multiple nested forms in Ruby on Rails application.
- Search for related objects using [jQuery UI Autocomplete](https://jqueryui.com/autocomplete).
- Easy to add sub-objects directly to a form to create or update the main object.
- Full management of the nested form."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,spec}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "coffee-rails", "~> 4.2"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"
  
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.7"
  s.add_development_dependency "capybara"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "factory_bot_rails", "~> 4.0"
  s.add_development_dependency "faker"
end
