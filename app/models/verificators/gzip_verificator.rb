require 'Verificator'
class GzipVerificator < Verificator
  def perform(uri)
    errors = []
    get_css.each do |css, res|
      errors << css.to_s + " <span class=\"error\">is not gzipped</span>" unless res['Content-Encoding'] || res['Content-Encoding'] == 'gzip'
    end
    errors
  end
  
end