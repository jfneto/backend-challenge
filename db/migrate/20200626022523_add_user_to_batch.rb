# frozen_string_literal: true

class AddUserToBatch < ActiveRecord::Migration[6.0]
  def change
    add_reference :batches, :user, null: false, foreign_key: true
  end
end
