# Define development domains
DEVELOPMENT_DOMAINS = [
  "localhost:3001",   # Rails server
  "localhost:3000",   # Frontend dev server
  "localhost:5173",   # Vite default
  "localhost:8080",   # Webpack default
  "127.0.0.1:3000",
  "127.0.0.1:3001",
  "127.0.0.1:5173",
  "127.0.0.1:8080",
  "192.168.0.133:3001"
].freeze

# Define production domains
PRODUCTION_DOMAINS = [
  "localhost://web:80", # docker rails server
  "localhost:3000",
  "localhost:3001",
   "192.168.0.133:3001"
].freeze

def determine_allowed_domains
  return DEVELOPMENT_DOMAINS + PRODUCTION_DOMAINS if Rails.env.development? || Rails.env.test?
  PRODUCTION_DOMAINS
end

SecureHeaders::Configuration.default do |config|
  # Basic Security Headers
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy =  %w[strict-origin-when-cross-origin]

  # Determine allowed domains based on environment
  allowed_domains = determine_allowed_domains

  # Asset domains (CDNs, etc.)
  asset_domains = %w[
    *.amazonaws.com
    *.cloudfront.net
    *.googleapis.com
    *.gstatic.com
    swagger-ui.s3.amazonaws.com
    swagger-ui-dist.jsdelivr.net
  ]

  # Development-specific protocols
  connect_src_protocols = Rails.env.development? ? %w[http: https: ws: wss:] : %w[https: wss:]

  # CSP Configuration
  config.csp = {
    default_src: [ "'self'" ] + allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },

    script_src: [
      "'self'",
      "'unsafe-inline'",
      "'unsafe-eval'",
      "blob:",  # Add for Swagger
      *allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },
      *asset_domains.map { |d| "https://#{d}" }
    ],

    style_src: [
      "'self'",
      "'unsafe-inline'",
      *allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },
      *asset_domains.map { |d| "https://#{d}" }
    ],

    img_src: [
      "'self'",
      "data:",
      "blob:",
      *allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },
      *asset_domains.map { |d| "https://#{d}" }
    ],

    connect_src: [
      "'self'",
      *allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },
      *asset_domains.map { |d| "https://#{d}" }
    ],

    font_src: [
      "'self'",
      "data:",
      *allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },
      *asset_domains.map { |d| "https://#{d}" }
    ],
    form_action: [ "'self'" ] + allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },
    frame_ancestors: [ "'none'" ],
    base_uri: [ "'self'" ],
    object_src: [ "'none'" ],
    worker_src: [ "'self'", "blob:" ],
    manifest_src: [ "'self'" ],
    media_src: [ "'self'" ] + allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" }
  }

  # Optional: Use report-only mode in development
  # if Rails.env.development?
  #   config.csp_report_only = config.csp.merge({
  #     report_uri: [ "/csp_violation_report" ]
  #   })
  # end
end

# SecureHeaders::Configuration.override(:swagger_ui) do |config|
#   allowed_domains = determine_allowed_domains
#   connect_src_protocols = Rails.env.development? ? %w[http: https: ws: wss:] : %w[https: wss:]

#   config.csp = {
#     default_src: [
#       "'self'",
#       "'unsafe-inline'",
#       "'unsafe-eval'",
#       "'wasm-unsafe-eval'",
#       *allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" }
#     ],
#     script_src: [
#       "'self'",
#       "'unsafe-inline'",
#       "'unsafe-eval'",
#       "'wasm-unsafe-eval'",
#       "blob:",
#       *allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },
#       *asset_domains.map { |d| "https://#{d}" }
#     ],
#     style_src: [
#       "'self'",
#       "'unsafe-inline'",
#       *allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },
#       *asset_domains.map { |d| "https://#{d}" }
#     ],
#     img_src: [
#       "'self'",
#       "data:",
#       "blob:",
#       *allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },
#       *asset_domains.map { |d| "https://#{d}" }
#     ],
#     connect_src: [
#       "'self'",
#       *allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },
#       *asset_domains.map { |d| "https://#{d}" }
#     ],
#     font_src: [
#       "'self'",
#       "data:",
#       *allowed_domains.map { |d| "#{connect_src_protocols.join(' ')}//#{d}" },
#       *asset_domains.map { |d| "https://#{d}" }
#     ],
#     worker_src: [ "'self'", "blob:" ],
#     object_src: [ "'none'" ],
#     base_uri: [ "'self'" ]
#   }
# end

# Environment-specific overrides
if Rails.env.development?
  SecureHeaders::Configuration.override(:development) do |config|
    config.csp = SecureHeaders::Configuration.default.csp.merge(
      # Additional development-specific rules
      connect_src: [
        "'self'",
        "ws://localhost:3035",  # Webpack dev server websocket
        "http://localhost:3035",
        "ws://localhost:5173",  # Vite websocket
        "http://localhost:5173",
        *DEVELOPMENT_DOMAINS.map { |d| "http://#{d}" },
        *DEVELOPMENT_DOMAINS.map { |d| "ws://#{d}" },
        *PRODUCTION_DOMAINS.map { |d| "https://#{d}" },
        *PRODUCTION_DOMAINS.map { |d| "wss://#{d}" }
      ],
      script_src: [
        "'self'",
        "'unsafe-inline'",
        "'unsafe-eval'",
        "'wasm-unsafe-eval'",
        *DEVELOPMENT_DOMAINS.map { |d| "http://#{d}" }
      ]
    )
  end
end
