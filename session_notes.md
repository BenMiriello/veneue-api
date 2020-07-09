## Starting App:
- don't use -api flag
- If you did, run rails new from directory containing app (after starting a new branch) and run rails new to overwrite it, then review conflicts.
- in my case I'm overwriting with command
```
rails new veneue-api --database=postgresql --skip-spring
```

Proper start command:
```
rails new app-name --database=postgresql
...
rails db:create
```

add to gemfile
```
gem 'bcrypt', '~> 3.1.7'
gem 'rack-cors', :require => 'rack/cors'
```

run
```
bundle
...
touch config/initializers/cors.rb
touch config/initializers/session_store.rb
```

in cors.rb
```
Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        origins "http://localhost:3000"
        resource "*",
            headers: :any,
            methods: [:get, :post, :put, :patch, :delete, :options, :head],
            credentials: true
    end

    allow do
        origins "https://veneue.herokuapp.com"
        resource "*",
            methods: [:get, :post, :put, :patch, :delete, :options, :head],
            credentials: true
    end
end
```

in config/initializers/session_store.rb
```
Rails.application.config.session_store :cookie_store, key: "_veneue", domain: "http://veneue.herokuapp.com"
```

Test with new route
```
root to "static#home"
```

Create app/controllers/static_controller.rb
```
class StaticController < ApplicationController
  skip_before_action :authorized

  def home
    render json: { status: "It's working" }
  end
end
```

-----------------------

```
rails g model User email password_digest
```

gives us migration:
```
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
```

```
rails db:migrate
```

in app/models/user add
```
has_secure_password

validates_presence_of :email, :name
validates_uniqueness_of :email, :name
```

in app/controllers/sessions_controller
```
class SessionsController < ApplicationController
  def create
    user = User
      .find_by(email: params["user"]["email"])
      .try(:authenticate, params["user"]["password"])
    
    if user
      session[:user_id] = user.id
      render json: {
        status: :created,
        logged_in: true,
        user: user
      }
    else
      render json: {status: 401}
    end
  end
end
```
create a user in rails c
```
User.create(email: "ben@ben.ben", password: "ben", name: "ben")
```

test post to create session with curl
```
curl --header "Content-Type: application/json" \
--request POST \
--data '{"user": {"email": "ben@ben.ben", "password": "ben"}}' \
http://localhost:3001/sessions
```

If it works this should return
```
{"status":"created","logged_in":true,"user":{"id":10,"name":"ben","email":"ben@ben.ben","password_digest":"$2a$12$LG2w7ymuRveKvdfrX1fhAOorl5UKdBpHO5LFYIitXg6RbdSp4kMH2","created_at":"2020-07-06T22:07:28.313Z","updated_at":"2020-07-06T22:07:28.313Z"}}%  
```


add new routes
```
delete :logout, to: "sessions#logout"
get :logged_in, to: "sessions#logged_in"
```

create new concern at app/controllers/concerns/current_user_concern.rb
```
module CurrentUserConcern
    extend ActiveSupport::Concern
    
    included do
        before_action :set_current_user
    end

    def set_current_user
        if session[:user_id]
            @current_user = User.find(session[:user_id])
        end
    end
end
```

then in SessionsController
```
    include CurrentUserConcern
...
    def logged_in
        if @current_user
            render json: {
                logged_in: true,
                user: @current_user
            }
        else
            render json: { logged_in: false }
        end
    end

    def logout
        reset_session
        render json: { status: 200, logged_out: true }
    end
```

