class WelcomeController < ApplicationController
  def index
    if params[:url].present?
      @url = params[:url]
      sample = Sample.new()
      @result = sample.issues(@url)
      @message = sample.message if sample.message.present?
    end
  end
end
