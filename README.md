# DynamicNestedForms

Dynamic Nested Forms with autocomplete and using jQuery.
Gem helps to make the simple dynamic control of multiple nested forms in Ruby on Rails application.
- Search for related objects using [jQuery UI Autocomplete](https://jqueryui.com/autocomplete).
- Easy to add sub-objects directly to a form to create or update the main object.
- Full management of the nested form.

![Dynamic Nested Forms screenshot](https://user-images.githubusercontent.com/5441376/39106736-62ec2eae-46c6-11e8-867c-94a8e311f7c2.gif)

## Installation

Dynamic Nested Forms works with Rails 5.0 onwards
Add this line to your application's Gemfile:

```ruby
gem "dynamic_nested_forms"
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install dynamic_nested_forms
```

## Usage

### Configuring Assets

Because Dynamic Nested Forms using [jQuery UI Autocomplete](https://jqueryui.com/autocomplete) and internal methods of gem, so add to application.js

app/assets/javascripts/application.js
```javascript
//= require jquery
//= require jquery-ui
//= require dynamic_nested_forms
```

If you want to include default styles [jQuery UI Autocomplete](https://jqueryui.com/autocomplete), add in application.css

app/assets/stylesheets/application.css
```css
*= require jquery-ui
```

### Configuring Models

Create related models using standard methods Rails

app/models/patient.rb
```ruby
class Patient < ApplicationRecord
  has_many :appointments
  has_many :physicians, through: :appointments
  accepts_nested_attributes_for :appointments, allow_destroy: true
  accepts_nested_attributes_for :physicians
end
```

app/models/physician.rb
```ruby
class Physician < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments
end
```

app/models/appointment.rb
```ruby
class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :physician
end
```

### Configuring Controllers

Create contrller for main model and additional controller relationship model

app/controllers/patients_controller.rb
```ruby
class PatientsController < ApplicationController
  ...
  # GET /patients/new
  def new
    @patient = Patient.new
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients
  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      redirect_to @patient, notice: 'Patient was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /patients/1
  def update
    if @patient.update(patient_params)
      redirect_to @patient, notice: 'Patient was successfully updated.'
    else
      render :edit
    end
  end
  ...
end
```

In additional controller add index action. This will generate collections with searched objects.
- `params[:term]` - Param with insert chars to autocomplete_to_add_item in view.
- `params[:added_obj]` - Optional. This param help you to save only unique nested objects.

app/controllers/appointments_controller.rb
```ruby
class AppointmentsController < ApplicationController
  def index
    @appointments = Physician.where("name LIKE ?", "%#{params[:term]}%")
    render json: @appointments.map { |u| { value: u.id, label: u.name, content: u.name }}
  end
end
```

### Strong Parameters

Don't forget to include the attributes of the associated model into the controller of the main model.

app/controllers/patients_controller.rb
```ruby
class PatientsController < ApplicationController
  ...
  def patient_params
    params.require(:patient).permit(:name, appointments_attributes: [:id, :patient_id, :physician_id, :_destroy])
  end
  ...
end
```

### Configuring Routes

All three controller Teams, Users, and TeamUsers should be included in the file routes.rb

config/routes.rb
```ruby
Rails.application.routes.draw do
  
  resources :patients
  resources :physicians
end
```

### Configuring Views

Add helper `autocomplete_to_add_item` to enable the search for objects of the associated model and add them as nested form in a main form

```ruby
autocomplete_to_add_item(name, f, association, source, options = {})
```

source - The URL the value from search_to_add_fields to be searched.

app/views/patients/_form.html.erb
```erb
<%= form_with(model: patient, local: true) do |form| %>
  <div class="field nested-container">
    <%= form.label "Appointments" %>
    <%= autocomplete_to_add_item "autocomplete_appointment", form, :appointments, appointments_index_path %>
    <div class="nested-items">
      <%= form.fields_for :appointments, @appointments do |appointment_f| %>
        <%= render "appointment_item", f: appointment_f %>
      <% end %>
    </div>
  </div>
<% end %>
```

app/views/patients/_appointment_item.html.erb
```erb
<div class="nested-item">
  <div class="nested-content">
    <% if f.object.physician %>
      <%= f.object.physician.name %>
    <% end %>
  </div>
  <%= f.hidden_field :physician_id, class: "nested-value" %>
  <%= f.hidden_field :_destroy %>
  <%= link_to_remove_item %>
</div>
```

### Sylize

You can add you class to autocomplete form

app/views/patients/_form.html.erb
```erb
<%= autocomplete_to_add_item "autocomplete_appointment", form, :appointments, appointments_index_path, class: "my-class" %>
```

... or to link_to_remove_item

app/views/patients/_appointment_item.html.erb
```erb
<%= link_to_remove_item "Remove", class: "my-class" %>
```

Rename default link_to_remove_item

app/views/patients/_appointment_item.html.erb
```erb
<%= link_to_remove_item "Delete appointment" %>
```

... or add icon or special char to link_to_remove_item

app/views/patients/_appointment_item.html.erb
```erb
<%= link_to_remove_item "&times;".html_safe %>
```

### If you need only unique objects

In additional controller add option `params[:added_obj]`. This will generate collections with searched unique objects.

app/controllers/appointments_controller.rb
```ruby
class AppointmentsController < ApplicationController
  def index
    @appointments = Physician.where("name LIKE ?", "%#{params[:term]}%").where.not(id: params[:added_obj])
    render json: @appointments.map { |u| { value: u.id, label: u.name, content: u.name }}
  end
end
```

## Contributing

[Fork the project](https://help.github.com/articles/fork-a-repo/) and send a [pull request](https://help.github.com/articles/about-pull-requests/) or add an [Issue on GitHub](https://github.com/reformgroup/dynamic_nested_forms/issues)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
