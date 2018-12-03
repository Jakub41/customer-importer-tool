# frozen_string_literal: true

class AddCompanyOwnerToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :company_owner, :boolean
  end
end
