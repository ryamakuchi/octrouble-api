class WelcomeController < ApplicationController
  def index
    if params[:url].present?
      @url = params[:url]
      sample = Sample.new(url: params[:url])

      @result = sample.issues
    end
  end
end
