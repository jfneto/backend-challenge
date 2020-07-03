# frozen_string_literal: true

class AddAdminToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :name, :string
  end
end
