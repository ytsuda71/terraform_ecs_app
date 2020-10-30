class HealthCheckController < ApplicationController
  # ALBにステータスokを返す為のアクション
  def index
    render json: '{ "status": "ok" }'
  end
end
