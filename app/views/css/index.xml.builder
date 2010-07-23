xml.instruct! 
xml.css_verificator do
  xml.css_list(:count=>@css_list.size) do
    @css_list.each do |css|
      xml.css css[0]
    end
  end
  xml.verifications do
    @results.each do |klass, results|
      unless results.blank?
        xml.result(:type=>t(klass)) do
          results.each do |error|
            xml.error error
          end
        end
      end
    end
  end
end
   
   