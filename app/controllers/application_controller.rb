class ApplicationController < ActionController::Base
  before_action :set_search

  def set_search
    @q = Todo.ransack(params[:q])
  end
  
end
