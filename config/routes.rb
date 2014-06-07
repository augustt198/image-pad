ImgPad::Application.routes.draw do

  root 'image#index'

  #match '/:id/show' => 'image#show', via: [:get]
  match '/img' => 'image#img', via: [:get]
  match '/clear' => 'image#clear', via: [:get]
  match '/add' => 'image#add', via: [:get]
  match '/color' => 'image#color', via: [:get]
  match '/back' => 'image#back', via: [:get]
  match '/space' => 'image#space', via: [:get]

end
