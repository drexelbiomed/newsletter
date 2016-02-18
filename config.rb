###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###
require 'date'
require 'slim'

Slim::Engine.disable_option_validator!

helpers do

  def bme_path
    "http://www.biomed.drexel.edu/new04/Content/newsletter/"
  end

  def format_date(stringy)
    Date.strptime(stringy, '%m-%d-%y').strftime("%B %d, %Y")
  end

  def data_file
    current_page.data.data_file
  end

  def spotlight
    return eval("data."+"#{data_file}.spotlight")
  end

  def students
    return eval("data."+"#{data_file}.students")
  end

  def faculty
    return eval("data."+"#{data_file}.faculty")
  end

  def alumni
    return eval("data."+"#{data_file}.alumni")
  end
end


# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload


# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

require 'slim'

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

activate :deploy do |deploy|
  deploy.build_before = true # default: false
  deploy.method = :ftp
  deploy.host            = data.ftp.host
  deploy.path            = data.ftp.path
  deploy.user            = data.ftp.user
  deploy.password        = data.ftp.password
  # Optional Settings
  # deploy.remote   = "custom-remote" # remote name or git url, default: origin
  # deploy.branch   = "custom-branch" # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = "custom-message"      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  set :http_prefix, "/labs/newsletter"

  # activate :gzip
  activate :minify_html
  # activate :imageoptim
  ignore "*.jpg"
  ignore "*.jpeg"
  ignore "*.gif"
  ignore "*.psd"
  ignore "images/*"
  ignore ".git/"
end
