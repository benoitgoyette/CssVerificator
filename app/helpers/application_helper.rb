module ApplicationHelper
  LOCALES = ['fr', 'en']
  
  def locale_selector
    list = LOCALES.collect do |locale|
      "<li>#{wrap_for_locale locale}</li>"
    end
    list.join ""
  end
  
  def wrap_for_locale(locale)
    if I18n.locale.to_s != locale
      link_to locale.capitalize, css_path(:locale=>locale)
    else
      locale.capitalize
    end
  end
  
end
