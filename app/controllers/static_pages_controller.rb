class StaticPagesController < ApplicationController
  def home
      # no point in giving welcome sign up when you're already member
      #
      redirect_to @current_user if signed_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
