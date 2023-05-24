class PagesController < ApplicationController
  before_action :redirect_if_logged_in, only: [:home]
  layout 'pages'

  def home
  end

  def redirect_if_logged_in
    redirect_to questions_path if user_signed_in?
  end
end
