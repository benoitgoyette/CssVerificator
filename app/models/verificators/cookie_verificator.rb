require 'verificator'
class CookieVerificator < Verificator
  def perform(uri)
    errors = []
    get_css.each do |css, content|
       errors << "#{css} sets a cookie" unless content['Cookie'].blank? || content['Set-Cookie'].blank?
    end
    errors
  end
end