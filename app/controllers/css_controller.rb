class CssController < ApplicationController
  class Site
    attr_accessor :url
  end
  
  before_filter :locale
  
  def index
    
    logger.debug ">>>>>>>>>>>>>>>>>>>>  #{I18n.locale}"
    
    @site = Site.new
    @results = []
    @css_list = []
    url = params[:site][:url] if params[:site]
    if url
      @site.url = url
      begin
        @results = Verificator.verify url
        @css_list = Verificator.css_documents
      rescue Exception => e
        @results = {'error' => get_correct_error_message(e)}
        logger.info e.message
        logger.debug e.backtrace.join("\n")
      end
      respond_to do |format|
        format.html
        format.xml 
        #TODO do the json part
        format.json { render :json => @results.to_json}
      end
    else
      respond_to do |format|
        format.html
        format.xml 
        #TODO do the json part
        format.json { render :json => {:messge=>t('specify_url')}.to_json}
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