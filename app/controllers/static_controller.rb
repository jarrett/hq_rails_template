class StaticController < ApplicationController
  skip_before_filter :require_user, only: [:home]
  
  def home
  end
end