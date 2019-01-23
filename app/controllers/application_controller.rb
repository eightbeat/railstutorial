class ApplicationController < ActionController::Base
  protect_forgecy with: :exception
  
  def hello
    render html: 'hello,world!'
  end
end
