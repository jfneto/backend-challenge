# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id               :bigint           not null, primary key
#  address          :string
#  client_name      :string
#  delivery_service :string
#  itens            :string
#  purchase_channel :string
#  reference        :string
#  status           :string
#  total_value      :decimal(13, 2)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  batch_id         :bigint
#  user_id          :bigint           not null
#
# Indexes
#
#  index_orders_on_batch_id  (batch_id)
#  index_orders_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (batch_id => batches.id)
#  fk_rails_...  (user_id => users.id)
#
class Order < ApplicationRecord
  belongs_to :batch, required: false
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  validates_presence_of :address, on: :create, message: "can't be blank"
  validates_presence_of :client_name, on: :create, message: "can't be blank"
  validates_presence_of :delivery_service, on: :create, message: "can't be blank"
  validates_presence_of :itens, on: :create, message: "can't be blank"
  validates_presence_of :purchase_channel, on: :create, message: "can't be blank"
  # validates_presence_of :status, on: :create, message: "can't be blank"
  validates_presence_of :total_value, on: :create, message: "can't be blank"
end
