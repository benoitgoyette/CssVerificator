require 'verificator'
class EmbedVerificator < Verificator
  def perform(uri)
    doc = Hpricot(get_page.body)
    result = doc.search('style')
    errors = []
    #TODO replace hard coded errors with keys and puts error messages in locale files instead
    errors << "Warning: the page #{uri.to_s} <span class=\"warning\">includes embeded styles</span>" unless result.blank?
  end
end