class TemplatesController < ApplicationController
  def file
    path = params[:path] || "index"
    render :template => "templates/#{path}", :layout => nil
  end
end
