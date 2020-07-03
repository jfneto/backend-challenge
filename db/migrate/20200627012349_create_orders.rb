# frozen_string_literal: true

# class
class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :reference
      t.string :purchase_channel
      t.string :client_name
      t.string :address
      t.string :delivery_service
      t.decimal :total_value, precision: 13, scale: 2
      t.string :itens
      t.string :status
      t.references :batch, null: true, foreign_key: true

      t.timestamps
    end
  end
end
