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
require 'time'
require 'slim'
require 'uri'
require 'premailer'
require 'open-uri'
require 'htmlentities'
require 'nokogiri'

Slim::Engine.disable_option_validator!

helpers do
  def decode(this)
    coder = HTMLEntities.new
    string = this
    coder.decode(string)
  end

  def feed_xml
    feed = Nokogiri::XML(open('https://drexel.edu/biomed/news-and-events/rss'))
  end

  def tree
    tree = Hash.new { |hash, key| hash[key] = {} }
  end

  def fix_relative_img(link)
    link.gsub(/~\/media/,"http://drexel.edu/~/media")
  end

  def parse_date(date)
    Date.parse(date, "%a, %b %e, %Y %H:%M:%S %z").strftime("%B %e, %Y")
  end

  def feed
    items = []
    # Search for only rss "items"
    # Iterate through the children elements i.e.
    # Title, Description, GUID, pubDate
    # Skip over randomly injected "text" or whitespace elements
    # Structure into a hash format
    feed_xml.css('rss item').each_with_index do |item, index|
      details = []
      item.children.each do |element|
        if element.name != "text"
          content = decode(element.inner_html)
        end
        details << content
      end
      # puts details

      items << {:title       => details[1],
        :description => fix_relative_img(details[3]),
        :link        => details[5],
        :pubDate     => parse_date(details[7]),
        :guid        => details[9]}
      end
      return items
    end

    def bme_path
      "http://www.biomed.drexel.edu/media/newsletter/"
    end

    def newsletter_base_href
      "http://biomed.drexel.edu/media/newsletter/"
    end

    def format_date(string)
      Date.strptime(string, '%m-%d-%y').strftime("%B %d, %Y")
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

    def faculty_even
      faculty.select.each_with_index{ |_, i| i.even? }
    end

    def faculty_odd
      faculty.select.each_with_index{ |_, i| i.odd? }
    end

    def alumni
      eval("data."+"#{data_file}.alumni")
    end

    def utm_source
      current_page.data.utm_source ||= current_page.data.source
    end

    def utm_medium
      "HTML_Email"
    end

    def home_link
      html = '<a target="_blank" href="http://drexel.edu/biomed'
      if environment == :development
        html += "#development"
        html += '">'
        html += "<!-- Analytics Tags: "
        html += gua
        html += " -->"
      else
        html += gua
        html += '">'
      end
    end

    def end_link
      "</a>"
    end

    def a_href(section, index=888)
      if index == 888
        html = '<a target="_blank" href="'
        html += eval("#{section}.url")
        html += gua
        html += '">'
      else
        html = '<a target="_blank" href="'
        html += eval("#{section}"+"["+"#{index}"+"].url")
        html += gua
        html += '">'
      end
    end

    def link_me (title, link)
      html = '<a target="_blank" href="'
      html += link
      html += '">'
      html += title
      html += '</a>'
    end

    # def utm_term
      # depends on where in the newsletter it is
      # i.e. alumni, spotlight, students, faculty
    # end

    def utm_campaign
      # grab info directly from YAML file
      current_page.data.utm_campaign ||= current_page.data.campaign
    end

    def utm_term
      if environment == :development
        # "This is in development"
      else
        # grab info directly from YAML file
        current_page.data.term ||= current_page.data.term
      end
    end

    def utm_dp
      current_page.data.utm_dp ||= ""
    end

    def utm_dt
      current_page.data.utm_dt ||= ""
    end

    def utm_dl
      current_page.data.utm_dl ||= ""
    end

    def ga
      if environment == :development
        # "This is in development"
      else
        "?utm_source=#{utm_source}&amp;utm_medium=#{utm_medium}&amp;utm_campaign=#{utm_campaign}"
      end
    end

    def gua
      if environment == :development
        '#'
      else
        "?utm_source=#{utm_source}&utm_medium=#{utm_medium}&utm_campaign=#{utm_campaign}"
      end
    end

    def tracking_id
      "UA-87264639-1"
    end

    def track_opens_url
      if environment == :development
        tracking_link = "https://placehold.it/5x5"
      else
        tracking_link = "https://google-analytics.com/collect?v=1&tid=#{tracking_id}&cid=333&t=event&ec=email&ea=open&cn=#{utm_campaign}&cs=#{utm_source}&cm=#{utm_medium}&dt=#{utm_dt}&dp=#{utm_dp}&dl=#{utm_dl}"
      end
      "<img src=\"#{tracking_link}\" />"
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
  # activate :relative_assets

  # Or use a different image path
  set :http_prefix, "/media/newsletter"

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