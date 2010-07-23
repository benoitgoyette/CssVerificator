ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'css'
  map.resources 'css', :only=>[:index]
end
