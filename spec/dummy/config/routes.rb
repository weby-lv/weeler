Dummy::Application.routes.draw do

  mount Weeler::Engine => "/weeler-admin"
  resources :anonymous # HACK
end
