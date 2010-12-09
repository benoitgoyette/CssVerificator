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

      match = res.body.match(/\/\*/) || res.body.match(/\*\//)
      unless match.blank?
      #TODO replace hard coded errors with keys and puts error messages in locale files instead
        err += "#{css.to_s} doesn't seem to be minified because <span class=\"error\">it contains comments</span> " 
      end

      if (total_size/line_count) > 100
        if err.blank?
          err = "#{css} doesn't seem to be minified because " 
        else
          err += " and "
        end
      #TODO replace hard coded errors with keys and puts error messages in locale files instead
        err += " <span class=\"error\">the ratio #{total_size} characters / #{line_count} lines =  #{total_size/line_count} is greater than 100</span> " 
      end
    end 
end
