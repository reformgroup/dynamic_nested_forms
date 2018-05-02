class CreateAppointments < ActiveRecord::Migration[5.1]
  def change
    create_table :appointments do |t|
      t.references :patient, foreign_key: true
      t.references :physician, foreign_key: true

      t.timestamps
    end
  end
end
