# frozen_string_literal: true

module OrdersHelper
  def load_orders_by(user, purchase_channel)
    Order.where('user_id = :user and purchase_channel = :purchase_channel and batch_id is null',
                user: user, purchase_channel: purchase_channel)
  end

  def inlcude_orders_in_batch(orders, batch)
    orders.each do |o|
      o.batch = batch
      o.status = 'PRODUCTION'
      o.save
    end
  end
end
