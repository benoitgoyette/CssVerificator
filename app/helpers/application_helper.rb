module ApplicationHelper
  
  def locale_selector
    list = (['fr', 'en'] - [I18n.locale.to_s]).collect do |locale|
      link_to locale, css_path(:locale=>locale)
    end
    list.join " | "
  end
end
