class TemplatesController < ApplicationController
  def file
    path = params[:path] || "index"
    render :template => "templates/#{path}.html", :layout => nil
  end
end
