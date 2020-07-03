# frozen_string_literal: true

class Api::V1::BatchesController < Api::V1::ApiController
  # before_action :set_batch, only: %i[show edit update destroy]

  before_action :require_authorization!
  include OrdersHelper

  # PUT
  def close_orders
    @reference = params[:reference]
    @batch = Batch.where(reference: @reference)[0]
    i = 0
    @batch.orders.each do |o|
      next unless o.status == 'PRODUCTION'

      i += 1
      o.status = 'CLOSED'
      o.save
    end
    render json: "Updated #{i} orders to status closed", status: :ok
  end

  def sent_orders
    @batch = Batch.where(reference: params[:reference])[0]
    @orders = Order.where(batch: @batch).where(delivery_service: params[:delivery_service])
    @orders.each do |o|
      o.status = 'SENT'
      o.save
    end
    render json: "Updated #{@orders.size} orders to status SENT", status: :ok
  end

  # POST /batches
  def create
    @batch = Batch.new(batch_params.merge(reference: random_reference('BR')))
    @orders = load_orders_by(current_user, @batch.purchase_channel)

    if current_user.admin
      render json: 'Operation don\'t permited to admin user', status: :unauthorized
    elsif @orders.size <= 0
      render json: 'Operation can\'t be completed. Don\'t have orders pending of producing',
             status: :unprocessable_entity
    elsif @batch.save
      inlcude_orders_in_batch(@orders, @batch)
      render json: "{\"reference\":\"#{@batch.reference}\", \"qtd_orders\":#{@orders.size}}", status: :created
    else
      render json: @batch.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_batch
    @batch = Batch.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def batch_params
    params.require(:batch).permit(:reference, :purchase_channel)
  end

  def require_authorization!
    render json: '{}', status: :forbidden unless current_user.admin
  end
end
