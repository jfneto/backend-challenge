# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'mandatory' do
    it 'fields' do
      order = Order.new
      order.valid?
      expect(order.errors[:address]).to include("can't be blank")
      expect(order.errors[:client_name]).to include("can't be blank")
      expect(order.errors[:delivery_service]).to include("can't be blank")
      expect(order.errors[:itens]).to include("can't be blank")
      expect(order.errors[:purchase_channel]).to include("can't be blank")
      expect(order.errors[:total_value]).to include("can't be blank")
    end
  end
end
