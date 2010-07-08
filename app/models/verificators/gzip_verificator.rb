require 'Verificator'
class GzipVerificator < Verificator
  def perform(uri)
    errors = []
    get_css.each do |css, res|
      errors << css + " is not gzipped" unless res['Content-Encoding'] || res['Content-Encoding'] == 'gzip'
    end
    errors
  end
  
end