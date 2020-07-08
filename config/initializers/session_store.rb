if Rails.env === "production"
  Rails.application.config.session_store :cookie_store, key: "hashketball", domain: "http://veneue.herokuapp.com"
else
  Rails.application.config.session_store :cookie_store, key: "hashketball"
end
