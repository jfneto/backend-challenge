# frozen_string_literal: true

# Class with control the batches
class BatchesController < ApplicationController
  before_action :set_batch, only: %i[show edit update destroy]
  require 'securerandom'

  # GET /batches
  # GET /batches.json
  def index
    @batches = if current_user.admin
                 Batch.all
               else
                 Batch.where(user_id: current_user.id)
               end
  end

  # GET /batches/1
  # GET /batches/1.json
  def show; end

  # GET /batches/new
  def new
    @batch = Batch.new
  end

  # POST /batches
  # POST /batches.json
  def create
    @batch = Batch.new(batch_params.merge(reference: random_reference('BR')))
    @orders = load_orders_by(current_user, @batch.purchase_channel)

    respond_to do |format|
      if @orders.size <= 0
        format.html { redirect_to :index, notice: 'Operation can\'t be completed. Don\'t have orders pending of producing' }
      elsif @batch.save
        inlcude_orders_in_batch(@orders, @batch)
        format.html { redirect_to @batch, notice: 'Batch was successfully created.' }
        format.json { render :show, status: :created, location: @batch }
      else
        format.html { render :new }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
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
end
