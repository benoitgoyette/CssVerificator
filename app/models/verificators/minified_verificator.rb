require 'verificator'
class MinifiedVerificator < Verificator
  def perform(uri)
    errors = []
    errors = get_css.collect {|css, content| verify_minified(css, content)}
  end
  
  protected
    def verify_minified(css, res)
      total_size = res.body.size
      line_count = res.body.lines.count
      
      err = ""
      if (total_size/line_count) < 100
        err = "#{css} doesn't seem to be minified (ratio  #{total_size} characters / #{line_count} lines =  #{total_size/line_count}) " 
      end
      
      match = res.body.match(/\/\*/) || res.body.match(/\*\//)
      unless match.blank?
        err = "#{css} doesn't seem to be minified " if err.blank?
        err += " (contains comments) " 
      end
    end 
end
