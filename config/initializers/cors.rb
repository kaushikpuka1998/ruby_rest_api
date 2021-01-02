Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'example.com'
    resource '*',
    methods: [:get, :post, :patch, :put]
  end
end
