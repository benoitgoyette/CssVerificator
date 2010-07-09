require 'verificator'
class EmbedVerificator < Verificator
  def perform(uri)
    doc = Hpricot(get_page.body)
    result = doc.search('style')
    errors = []
    errors << "Warning: the page #{uri.to_s} <span class=\"warning\">includes embeded styles</span>" unless result.blank?
  end
end