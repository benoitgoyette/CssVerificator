require 'verificator'
class NumberVerificator < Verificator
  def perform(uri)
    errors = []
    css_num = get_css.size
    errors << "There are <span class=\"error\">more than 2 css files</span>. (#{css_num})" if css_num > 2
  end
end