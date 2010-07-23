require 'verificator'
class NumberVerificator < Verificator
  def perform(uri)
    errors = []
    css_num = get_css.size
      #TODO replace hard coded errors with keys and puts error messages in locale files instead
    errors << "There are <span class=\"error\">more than 2 css files</span>. (#{css_num})" if css_num > 2
  end
end