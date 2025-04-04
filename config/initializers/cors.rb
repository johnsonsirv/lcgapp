Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    case Rails.env
    when "development"
      # Allow both http and https for development
      origins(*DEVELOPMENT_DOMAINS,
              *DEVELOPMENT_DOMAINS.map { |d| d.gsub("http://", "https://") },
              *PRODUCTION_DOMAINS)
    else
      origins(*PRODUCTION_DOMAINS)
    end

    resource "*",
    headers: :any,
    methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
    credentials: true,
    expose: [
      "Authorization",
      "X-Request-Id",
      "Content-Type",
      "Accept",
      "Origin"
    ],
    max_age: 600
  end
end
