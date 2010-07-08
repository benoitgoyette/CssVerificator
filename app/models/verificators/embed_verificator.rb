require 'verificator'
class EmbedVerificator < Verificator
  def perform(uri)
    doc = Hpricot(get_page.body)
    result = doc.search('style')
    errors = []
    errors << "Warning: the page #{uri.to_s} includes embeded styles" unless result.blank?
  end
end