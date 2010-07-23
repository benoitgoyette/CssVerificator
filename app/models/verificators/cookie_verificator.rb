require 'verificator'
class CookieVerificator < Verificator
  def perform(uri)
    errors = []
    get_css.each do |css, content|
      #TODO replace hard coded errors with keys and put error messages in locale files instead
      #    in this format  "errors << {:css=>css.to_s, :error=>:cookie_error}"
      errors << "#{css.to_s} <span class=\"error\">sets a cookie</span>" unless content['Cookie'].blank? || content['Set-Cookie'].blank?
    end
    errors
  end
  
end