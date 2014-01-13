require 'api_constraints'

ExampleMobilePns::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    # This scoped route allows us to access the /api/ route without needing to go through /api/v1/
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :users do
        resources :devices
      end

      resources :permitted_apps
    end
  end  
end
