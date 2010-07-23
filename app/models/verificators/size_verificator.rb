require 'verificator'
class SizeVerificator < Verificator
  def perform(uri)
    errors=[]
    total_size = 0
    get_css.each do |css, response|
      total_size += response.body.size
    end
    doc = Hpricot(get_page.body)
    embed_styles = doc.search('style')
    total_size += embed_styles.size
    
    #TODO replace hard coded errors with keys and puts error messages in locale files instead
    errors << "The total size for all styles <span class=\"error\">is grater than 100k</span> (#{total_size} bytes)" if total_size > 100 * 1024
  end

end