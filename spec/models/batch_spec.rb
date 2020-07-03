# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch, type: :model do
  context 'mandatory' do
    it 'fields' do
      batch = Batch.new
      batch.valid?
      expect(batch.errors[:purchase_channel]).to include('não pode ficar em branco')
    end
  end
end
