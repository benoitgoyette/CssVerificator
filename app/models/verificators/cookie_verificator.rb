require 'verificator'
class CookieVerificator < Verificator
  def perform(uri)
    errors = []
    get_css.each do |css, content|
       errors << "#{css.to_s} <span class=\"error\">sets a cookie</span>" unless content['Cookie'].blank? || content['Set-Cookie'].blank?
    end
    errors
  end
  
end