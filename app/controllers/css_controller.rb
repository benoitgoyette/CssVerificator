class CssController < ApplicationController
  
  before_filter :locale
  # @@verificator = Verificator.new
  
  def index
    @site = Site.new
    url = params[:site][:url] if params[:site]
    if url
      if url.match(/192\.168\.10\.136/)
        @results = { :me => 'Own site'}
      else
        @site.url = url
        @results = Verificator.verify url
        @css_list = Verificator.css_documents
        logger.debug ">>>>>>>>>>>> CSS LIST " + @css_list.inspect
      end
    end
  end
  
  def locale
    I18n.locale = session[:locale] = params[:locale] || session[:locale]
  end
  
  class Site
    attr_accessor :url
  end
end