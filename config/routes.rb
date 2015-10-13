SimpleAttach::Application.routes.draw do
  root 'upload#index'
  post '/upload' => 'upload#attach'
end
