# require 'config/initializers/constants.rb'
namespace :min do
  
  desc "Minify javascript src for production environment"
  task :js do
    outfile = File.join(RAILS_ROOT,"public","javascripts","legrandclub.js")
    java_bin = system("which java") ? "java" : "JAVA_HOME=/home/deploy/jre1.6.0_17/ && PATH=$JAVA_HOME/bin:$PATH && java"
    libs = JS_FILE 
    File.delete outfile if File.exist?(outfile)
    libs.each do |lib|
      system "#{java_bin} -jar #{RAILS_ROOT}/lib/compressor/yuicompressor-2.4.2.jar public/javascripts/#{lib} >> #{outfile} "
      system "echo '\n' >> #{outfile}"
    end
  end

  desc "Minify css for production environment"
  task :css do
    outfile = File.join(RAILS_ROOT,"public","stylesheets","global.css")

    java_bin = system("which java") ? "java" : "JAVA_HOME=/home/deploy/jre1.6.0_17/ && PATH=$JAVA_HOME/bin:$PATH && java"
    libs = "global-raw.css"
    File.delete outfile if File.exist?(outfile)
    libs.each do |lib|
      system "#{java_bin} -jar #{RAILS_ROOT}/lib/compressor/yuicompressor-2.4.2.jar public/stylesheets/#{lib} >> #{outfile}"
      system "echo '\n' >> #{outfile}"
    end
  end
  
  task :all => [:js, :css] do
    puts "done!"
  end
end
