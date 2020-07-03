class CreateBatches < ActiveRecord::Migration[6.0]
  def change
    create_table :batches do |t|
      t.string :reference
      t.string :purchase_channel

      t.timestamps
    end
  end
end
