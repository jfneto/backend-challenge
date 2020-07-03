# frozen_string_literal: true

# == Schema Information
#
# Table name: batches
#
#  id               :bigint           not null, primary key
#  purchase_channel :string
#  reference        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_batches_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Batch < ApplicationRecord
  validates_presence_of :purchase_channel

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  has_many :orders
end
