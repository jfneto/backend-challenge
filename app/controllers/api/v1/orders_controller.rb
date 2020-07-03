# frozen_string_literal: true

# Api controller for orders
class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_order, only: %i[show destroy]
  before_action :require_authorization!, only: %i[index show update destroy status purchase_channel create]
  before_action :set_params_status, only: :status
  before_action :set_params_channel, only: :purchase_channel
  before_action :set_order_for_update, only: :update

  # def index
  #   @orders = current_user.orders
  # end

  def status
    @orders = load_orders_status

    respond_to do |format|
      if @orders.nil?
        format.json { render json: 'Parametro inicial inválido. Use "reference" ou "client_name"' }
      else
        format.json { render json: @orders }
      end
    end
  end

  # TODO: refatorar para melhorar a logica
  def purchase_channel
    @orders = if current_user.admin
                Order.where(purchase_channel: @purchase_channel)
                     .where(status: @status)
                     .order('created_at DESC').limit(@limit)
              else
                Order.where('purchase_channel = ? and user_id = ? and status = ?',
                            @purchase_channel, current_user, @status)
                     .order('created_at DESC').limit(@limit)
              end

    respond_to do |format|
      format.json { render json: @orders }
    end
  end

  # TODO: quando o usuario for admin não permitir criar registro
  def create
    @order = Order.new(order_params.merge(user: current_user,
                                          status: 'READY',
                                          reference: random_reference('BR')))
    respond_to do |format|
      if @order.save
        format.json { render :show, status: :created, location: @order }
      else
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.status == 'PRODUCTION'
        if @order.update(order_params)
          format.json { render :show, status: :ok, location: @order }
        else
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
        format.json { render json: 'Somente ordens em produção pode ser alteradas', status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  def set_order_for_update
    @order = Order.where(reference: params[:reference])[0]
  end

  def set_params_status
    @reference = params.key?(:reference) ? params[:reference] : nil
    @client_name = params.key?(:client_name) ? params[:client_name] : nil
    @limit = params.key?(:limit) ? params[:limit] : 5
  end

  def set_params_channel
    @purchase_channel = params[:purchase_channel]
    @status = params.key?(:status) ? params[:status] : 'READY'
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:reference, :purchase_channel, :client_name, :address, :delivery_service,
                                  :total_value, :itens, :status, :batch_id)
  end

  def require_authorization!
    unless @order.nil?
      render json: {}, status: :forbidden unless current_user == @order.user
    end
  end

  def load_orders_status
    if @reference.nil?
      Order.where(client_name: @client_name).where(user: current_user).order('created_at DESC').limit(@limit)
    else
      Order.where(reference: @reference).where(user: current_user)
    end
  end
end

# TODO, remover apos concluir o desenvolvimento
# email: "admin@admin.com", authentication_token: "xJKAiVS1auX_eYEjwUdv"
# email: "devel.neto@gmail.com", authentication_token: "VDff2KV8SfVsARaSzE-n",
# email: "outro@outro.com", authentication_token: "iJudrhwvBj256sfaegih"
