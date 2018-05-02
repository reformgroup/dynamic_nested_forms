FactoryBot.define do
  factory :physician do
    name { Faker::Name.name }
  end
  
  factory :patient do
    name { Faker::Name.name }
    
    factory :patient_with_appointments do
      
      transient do
        appointments_count 5
      end
      
      after(:create) do |patient, evaluator|
        create_list(:physician, evaluator.appointments_count, patient: patient)
      end
    end
  end
end