# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.references :company, index: true
      t.references :user, index: true
      t.string :name
      t.string :address
      t.string :zip_code
      t.string :city
      t.string :country_code

      t.timestamps
    end
  end
end
