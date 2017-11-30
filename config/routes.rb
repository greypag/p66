Rails.application.routes.draw do
  root 'homes#index'

  resources :homes
  resources :users, only: [:index, :new, :create, :update, :show, :destroy]
  resources :messages, only: [:update, :show, :edit, :destroy]
  resources :tests do
    # member do
    #   post :add_to_cart
    # end
  end
  # resources :carts do
  #   collection do
  #     delete :clean
  #   end
  # end
  # resources :items, controller: 'cart_items'
  resources :payment_records
  resources :payout_records
  resources :test_records
  resources :qars
  resources :prompts
  resources :responses


  post '/resendtoken' => 'application#resendtoken'

  get '/activeuser' => 'application#activeuser'

  post '/forget_email' => 'application#forget_email'
  post '/forget_password' => 'application#forget_password'

  get '/resetpassword' => 'application#getresetpassword'
  post '/resetpassword' => 'application#postresetpassword'

  get '/resetpasswordsuccessful' => 'application#resetpasswordsuccessful'


  match '/login' => 'users#login', :via => [:post, :get]
  match '/logout' => 'users#logout', :via => [:post, :get]

  get '/thankyou' => 'homes#thankyou'

  get '/active_link_done' => 'homes#active_link_done'
  get '/active_link_fail' => 'homes#active_link_fail'

  # homes inner pages routes
  get '/howitworks' => 'homes#howitworks'
  get '/aboutthetests' => 'homes#aboutthetests'
  get '/aboutparrot' => 'homes#aboutparrot'
  get '/parrotforbusiness' => 'homes#parrotforbusiness'
  get '/howtobecomeaparrotrater' => 'homes#howtobecomeaparrotrater'
  get '/contactus' => 'homes#contactus'
  get '/test' => 'homes#testtemplate'
  get '/faq' => 'homes#faq'
  get '/privatepolicy' => 'homes#privatepolicy'

  # cart
  # post '/save_item' => 'tests#save_item'
  post '/add_to_cart' => 'tests#add_to_cart'
  get '/cart_number_reload' => 'homes#cart_number_reload'
  get '/cart' => 'carts#cart'
  post '/delete_item' => 'carts#delete_item'
  post '/clean_cart' => 'carts#clean_cart'
  post '/cart_login' => 'carts#cart_login'

  # payment
  get '/checkout' => 'paypals#new'
  post '/checkout_with_credit_card' => 'paypals#checkout_with_credit_card'
  post '/checkout_with_paypal' => 'paypals#checkout_with_paypal'
  get '/thankyoupurchase' => 'paypals#thankyoupurchase'
  post '/cancel_order' => 'paypals#cancel_order'
  get '/payout_new' => 'paypals#payout_new'
  match '/payout_create' => 'paypals#payout_create', :via => [:post, :get]


  # admin home
  get '/dashboard' => 'users#dashboard'
  get '/cashflow' => 'users#cashflow'
  get '/invite' => 'users#invite'
  post '/invite_user' => 'users#invite_user'
  post '/invite_as_rater' => 'users#invite_as_rater'

  # user home
  get '/home' => 'users#home'
  get '/account' => 'users#edit', :as => 'edit_user'
  get '/payment' => 'payment_records#index'
  # get '/prompts' => 'users#prompts'
  # post '/change_password' => 'users#change_password'

  # rater home
  get '/rating_history' => 'users#rating_history'

  # test
  get '/sendscores' => 'test_records#sendscores'
  get '/score_histiry' => 'test_records#score_histiry'
  post '/send_response' => 'tests#send_response'
  post '/close_test' => 'tests#close_test'
  get '/finished_test' => 'tests#finished_test'
  get '/test_begin_camera' => 'test_records#test_begin_camera'
  post '/post_test_begin_photo' => 'test_records#post_test_begin_photo'
  get '/test_end_camera' => 'test_records#test_end_camera'
  post '/post_test_end_photo' => 'test_records#post_test_end_photo'


  # response
  post '/change_response_type' => 'responses#change_response_type'
  post '/audio_record_create' => 'responses#audio_record_create'
  get '/rater_available' => 'responses#rater_available'
  get '/photo_verification/:id(.:format)' => 'test_records#photo_verification', :as => 'photo_verification'
  post '/post_photo_verification' => 'test_records#post_photo_verification'
  get '/rate_response/:id(.:format)' => 'responses#rate_response', :as => 'rate_response'
  match '/give_a_rate' => 'responses#give_a_rate', :via => [:post, :get]
  post '/test_answer' => 'responses#test_answer'
  # get '/recorder' => 'responses#recorder'

  # Contact us
  get '/contact_us' => 'messages#index', :as => 'messages'
  get '/new_message' => 'messages#new', :as => 'new_message'
  post '/contact_us' => 'messages#create'
  post '/message_delete' => 'messages#delete'
  post '/message_reply' => 'messages#reply'
  get '/inbox_reload' => 'messages#inbox_reload'
  get '/sendbox_reload' => 'messages#sendbox_reload'


  get '*slug' => 'application#not_found'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
