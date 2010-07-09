require 'net/http'
require 'hpricot'

class Verificator
  @@verificators = []
  @@css_documents = {}
  @@page = nil
  @@page_uri = nil
  cattr_accessor :css_documents
  cattr_accessor :page
  cattr_accessor :page_uri
  cattr_accessor :verificators

  #
  # This method must be overloaded by subclassed Verificators
  def perform(uri)
    raise Exception.new("The Verificator class #{self.class} does not declare the perform method!")
  end

  #
  # helper methods
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
        err = err.flatten.uniq.compact unless err.blank?
        errors.merge!({verificator.class.name => err})
      end
      errors
    end
    
    def prepare(url)
      @@page_uri = to_uri(url)
      @@page = fetch @@page_uri
      list = get_page_links
      list.each do |css| 
        css_response = get_single_css(css)
        get_css_imports(css_response.body)
      end
    end

    def get_page_links
      doc = Hpricot(@@page.body)
      res = doc.search('link[@href]')
      css = res.collect do |link| 
        href =  link.attributes['href']
        normalize_uri(href).to_s
      end
    end

    def get_single_css(css_uri)
      begin
        res = fetch(css_uri)
        sleep 0.25
        if res['Content-Type'] == 'text/css'
          @@css_documents[css_uri] = res
        end
        res
      end
    end

    def normalize_uri(uri)
      link_uri  = URI.parse(uri)
      puts ">>>>>> NORMALIZING #{uri} #{link_uri.path[0, 1]}"
      if link_uri.relative? 
        page_uri = @@page_uri
        link_uri.scheme = page_uri.scheme
        link_uri.userinfo = page_uri.userinfo
        link_uri.host = page_uri.host
        link_uri.port = page_uri.port if page_uri.port != 80
        link_uri.path = "/" + link_uri.path if link_uri.path[0,1] != "/"
      end
      puts ">>>>>> NORMALIZED  #{link_uri.to_s}"
      link_uri
    end

    def get_imports_tags(content)
      res = []
      w = /@import\s+[url\s*\(]*"([\w\.\-\/\s]*)"[\)]*\s*;.*$/
      m = w.match content
      if m
        puts ">>>>>>>> FOUND: #{m[1]}"
        res << m[1]
        res << get_imports_tags($')
      end
      res.flatten.compact
    end

    def get_css_imports(content)
      puts "GETTING CSS IMPORTS !!!"
      tags = get_imports_tags(content)
      puts "   FOUND TAGS #{tags.compact.inspect}"
      tags.compact
      tags.each do |tag|
        puts ">>>>>>>>>>>>>>> FOUND CSS_IMPORT #{tag}"
        css_response = get_single_css(normalize_uri(tag))
        get_css_imports(css_response.body)
      end  
    end
  
    def fetch(uri_str, limit = 10)
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0
      uri_str = uri_str.to_s if uri_str.is_a? URI
      response = Net::HTTP.get_response(URI.parse(uri_str))
      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
      else
        response.error!
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
      # verificators = get_verificators
      verificators.each do |verificator| 
        instance = verificator.constantize.new
        if instance.respond_to?('perform')
          yield instance
        end
      end
    end
  end
  
end

Dir.entries(File.join(File.dirname(__FILE__), 'verificators')).each do |file|
  if File.extname(File.join(File.dirname(__FILE__), 'verificators', file))==".rb"
    lower_class_name = file.gsub(/\.rb/, '')
    require File.join(File.dirname(__FILE__), 'verificators', file)
    Verificator.verificators << lower_class_name.camelize
  end
end

