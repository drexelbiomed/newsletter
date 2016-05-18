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
require 'uri'

Slim::Engine.disable_option_validator!

helpers do

  def bme_path
    "http://www.biomed.drexel.edu/new04/Content/newsletter/"
  end

  def newsletter_base_href
    "http://biomed.drexel.edu/labs/newsletter/"
  end

  def format_date(stringy)
    Date.strptime(stringy, '%m-%d-%y').strftime("%B %d, %Y")
  end

  def data_file
    current_page.data.data_file
  end

  def quarter_term
    eval("data."+"#{data_file}.term")
  end

  def read_in_browser
    newsletter_base_href + "#{quarter_term.downcase.gsub(" ", "-")}.html"
  end

  def spotlight
    eval("data."+"#{data_file}.spotlight")
  end

  def students
    eval("data."+"#{data_file}.students")
  end

  def research
    eval("data."+"#{data_file}.research")
  end

  def faculty
    eval("data."+"#{data_file}.faculty")
  end

  def alumni
    eval("data."+"#{data_file}.alumni")
  end

  def utm_source
    "newsletter"
  end

  def utm_medium
    "email"
  end

  def home_link
      html = '<a href="http://drexel.edu/biomed'
      html += google_utm('home_logo')
      html += '">'
  end

  def end_link
    "</a>"
  end

  def a_href(section, index=999)
    if index == 999
      html = '<a href="'
      html += eval("#{section}.url")
      html += google_utm('spotlight')
      html += '">'
    else
      html = '<a href="'
      html += eval("#{section}"+"["+"#{index}"+"].url")
      html += google_utm("#{section}")
      html += '">'
    end
  end

  # def utm_term
    # depends on where in the newsletter it is
    # i.e. alumni, spotlight, students, faculty
  # end

  def utm_campaign
    # grab info directly from YAML file
    eval("data."+"#{data_file}.campaign")
  end

  def google_utm(utm_term)
    "?utm_source=#{utm_source}&amp;utm_medium=#{utm_medium}&amp;utm_term=#{utm_term}&amp;utm_campaign=#{utm_campaign}"

  end

  def track_opens_url
    "http://google-analytics.com/collect?v=1&tid=UA-48789419-1&cid=555&t=event&ec=email&ea=open&el=#{utm_campaign}"
  end
end


# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# page '/biomed-newsletter-inline.html', :layout => false

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
  # activate :minify_html
  # activate :imageoptim
  ignore "*.jpg"
  ignore "*.jpeg"
  ignore "*.gif"
  ignore "*.psd"
  ignore "images/*"
  ignore ".git/"
end
