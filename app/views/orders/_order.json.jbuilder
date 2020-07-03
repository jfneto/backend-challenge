# frozen_string_literal: true

json.extract! order, :reference, :purchase_channel, :client_name, :address, :delivery_service, :total_value, :itens, :status, :batch_id, :created_at, :updated_at
json.url order_url(order, format: :json)
