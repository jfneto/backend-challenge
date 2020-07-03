# frozen_string_literal: true

class Api::V1::ReportsController < Api::V1::ApiController
  # Quando um usuário administrador solicitar este método o mesmo irá retornar os dados referentes a todos os registros
  # Quando um usuário não administrador executar este método apenas seus registros serão somandos e devolvidos.
  def financial_report
    res = ActiveRecord::Base.connection_pool.with_connection do |con|
      con.exec_query(build_sql)
    end
    render json: res
  end

  private

  def build_sql
    select = 'purchase_channel, sum(total_value)total_value, count(*) qtd_orders'
    from = 'orders'
    where = "user_id = #{current_user.id}"
    group_by = 'purchase_channel'

    if current_user.admin
      "SELECT #{select} FROM #{from} GROUP BY #{group_by}"
    else
      "SELECT #{select} FROM #{from} WHERE #{where} GROUP BY #{group_by}"
    end
  end
end
