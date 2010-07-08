require 'net/http'
require 'hpricot'

class Verificator
  # @logger = BufferedLogger.new
  # @@verificators = get_verificators
  #@@instance=Verificator.new  
  #attr_accessor :verificators
  @@css_documents = {}
  @@page = nil
  @@page_uri = nil
  cattr_accessor :css_documents
  cattr_accessor :page
  cattr_accessor :page_uri

  #
  # This method must be overloaded by subclassed Verificators
  def perform(uri)
    raise Exception.new("The Verificator class #{self.class} does not declare the perform method!")
  end

  def get_css(uri=nil)
    return Verificator.css_documents if uri.nil?
    Verificator.css_documents[uri]
  end

  def fetch(uri_str, limit = 10)
    Verificator.fetch uri_str, limit
  end
  
  def get_page(uri=nil)
    if uri.nil?
      Verificator.page
    else
      Verificator.fetch(uri)
    end
  end


  class << self
    def verify(url)
      errors = {}
      uri = to_uri(url)
      prepare(uri)
      each do |verificator|
        err = []
        err = verificator.perform(uri)
        puts ">>>>>>>>>>>>>ERROR >>>> " + err.class.name + "    for " + verificator.class.name 
        err = err.flatten.uniq.compact unless err.blank?
        errors.merge!({verificator.class.name => err})
      end
      errors
    end

    def get_links(uri=nil)
      raise Exception.new("Missing page") if uri.nil? && @@page.nil?
      @@page = fetch(uri) if @@page.nil?
      doc = Hpricot(@@page.body)
      res = doc.search('link[@href]')
      css = res.collect do |link| 
        href =  link.attributes['href']
        link_uri = URI.parse(href)
        if link_uri.relative? 
          page_uri = uri || @@page_uri
          link_uri.scheme = page_uri.scheme
          link_uri.userinfo = page_uri.userinfo
          link_uri.host = page_uri.host
          link_uri.port = page_uri.port
        end
        link_uri.to_s
      end
    end
  
    def fetch(uri_str, limit = 10)
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0
      puts ">>>>>>>>>> FETCHING URI #{uri_str}"
      uri_str = uri_str.to_s if uri_str.is_a? URI
      response = Net::HTTP.get_response(URI.parse(uri_str))
      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
      else
        response.error!
      end
    end
  
    def prepare(url)
      @@page_uri = to_uri(url)
      @@page = fetch @@page_uri
      list = get_links
      
      list.each do |css| 
        begin
          res = fetch(css)
          sleep 0.25
          if res['Content-Type'] == 'text/css'
            @@css_documents[css] = res
          end
        end
      end
      
    end

    def to_uri(url)
      return url if url.is_a? URI
      uri = URI.parse(url)
      if uri.instance_of? URI::Generic
        url = "http://" + url
        uri = URI.parse(url)
      end
      uri
    end
  
    def each(&block)
      verificators = get_verificators
      verificators.each do |verificator| 
        instance = verificator.new
        if instance.respond_to?('perform')
          yield instance
        end
      end
    end

    def get_verificators
      verificators = []
      Dir.entries(File.join(File.dirname(__FILE__), 'verificators')).each do |file|
        if File.extname(File.join(File.dirname(__FILE__), 'verificators', file))==".rb"
          lower_class_name = file.gsub(/\.rb/, '')
          require File.join(File.dirname(__FILE__), 'verificators', file)
          verificators << Object.const_get(lower_class_name.camelize)
        end
      end
      verificators.uniq!
      puts verificators.join ", "
      verificators
    end
  end
end

Dir.entries(File.join(File.dirname(__FILE__), 'verificators')).each do |file|
  if File.extname(File.join(File.dirname(__FILE__), 'verificators', file))==".rb"
    puts File.join(File.dirname(__FILE__), 'verificators', file)
    require File.join(File.dirname(__FILE__), 'verificators', file)
  end
end

