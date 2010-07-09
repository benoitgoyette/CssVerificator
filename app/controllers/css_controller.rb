class CssController < ApplicationController
  class Site
    attr_accessor :url
  end
  
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
        begin
          @results = Verificator.verify url
          @css_list = Verificator.css_documents
        rescue Exception => e
          @results = {'error' => get_correct_error_message(e)}
          logger.info e.message
          logger.debug e.backtrace.join("\n")
        end
      end
    end
  end
  
  def locale
    I18n.locale = session[:locale] = params[:locale] || session[:locale]
  end
  
protected
  def get_correct_error_message(e)
    case e.class.name
      when "SocketError"
        t('errors','404')
      else
        e.message
    end
  end
end