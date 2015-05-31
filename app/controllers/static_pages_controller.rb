#
# StaticPagesController
#
#  - Unauthenticated static pages acting as application advertising
#
class StaticPagesController < ApplicationController
  def home
    redirect_to dashboard_path(@current_user) if signed_in?
  end

  def help
  end

  def about
  end

  def password_reset
  end
end
