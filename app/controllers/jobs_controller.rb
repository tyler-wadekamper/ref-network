class JobsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:send_weekly_email]
  before_action :authenticate_api_key, only: [:send_weekly_email]

  def send_weekly_email
    WeeklyQuestionEmailJob.perform_now
    render json: { status: 'Weekly email job started successfully' }, status: :ok
  end

  private

  def authenticate_api_key
    puts request.headers['API_KEY']
    puts ENV['RAILS_MASTER_KEY']
    api_key = request.headers['API_KEY']
    unless api_key == ENV['RAILS_MASTER_KEY']
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
