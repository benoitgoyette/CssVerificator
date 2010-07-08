require 'Verificator'
class NumberVerificator < Verificator
  def perform(uri)
    errors = []
    css_num = get_css.size
    errors << "There are more than 2 css files. (#{css_num})" if css_num > 2
  end
end