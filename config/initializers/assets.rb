
# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add node_modules folder to the asset load path, its location has been
# customized due to what's set in .yarnrc.
Rails.application.config.assets.paths << '/node_modules'
