require "yaml"
require "spreadsheet"
require "Date"

# Newsletter ID
news_id = "summer2014"

Spreadsheet.client_encoding = 'UTF-8'

puts "loading data"
data = YAML::load(File.open("data/#{news_id}.yml"))
puts "data loaded succesfully"

puts "create a new spreadsheet"
book = Spreadsheet::Workbook.new

sheet1 = book.create_worksheet
sheet1.name = "My First Worksheet"

# Options
base_url = "http://biomed.drexel.edu/new04/Content/newsletter/#{news_id}/"
images_people_url = base_url + "images/people/"
default_img_url = "http://www.pages.drexel.edu/~ut27/Biomed.jpg"

puts "populate spreadsheet with some data"

i = 0
row = sheet1.row(i)

# Labels
row.push("Start Date", "End Date", "Headline", "Text", "Media", "Media Credit", "Media Caption", "Media thumbnail", "Type", "Tag")

# Start Date [1]  End Date [2]  Headline [3]  Text [2]  Media [4] Media Credit [2]  Media Caption [2] Media Thumbnail [5] Type [6]  Tag [7]

# [1] (Required) 
# [2] (Optional) 
# [3] (Required)
# [4] (Optional) can be a link to: youtube, vimeo, soundcloud, dailymotion, instagram, twit pic, twitter status, google plus status, wikipedia, or an image
# [5] (Optional) Link to a image file. The image should be no larger than 32px x 32px.
# [6] (Optional) This indicates which slide is the title slide. You can also set era slides but please note that era slides will only display headlines and dates (no media) 
# [7] (Optional) Tags (Categories) You can have up to 6. If you define more than 6 some of them won't be displayed.

# Loop
data["news"].each do |news|
  i += 1
  row = sheet1.row(i)
  puts "populating row #{i}"

  # Date
  date_str = news.fetch("date")
  start_date  = Date.strptime(date_str, '%m-%d-%y').strftime("%-m/%-d/%Y %H:%M:%S")
  end_date = " "

  # Headline
  headline = news.fetch("title")
  
  # Text
  text = news.fetch("lines").join("<br>")[0..200].concat("...")
  # text = " "
  
  # Media
  people_img = news.fetch("images")[0]
  media = people_img.length > 1 ? images_people_url+people_img : default_img_url
  media_caption = base_url + "#" + news.fetch("anchor") 
  media_credit = news.fetch("people").join(", ")
  media_thumb = " "
  
  type = " "
  tag = " "

  row.push(start_date, end_date, headline, text, media, media_credit, media_caption, media_thumb, type, tag)

end


# sheet1.row(0).concat %w{Name Country Acknowlegement}
# sheet1[1,0] = 'Japan'
# row = sheet1.row(1)
# row.push 'Creator of Ruby'
# row.unshift 'Yukihiro Matsumoto'
# sheet1.row(2).replace [ 'Daniel J. Berger', 'U.S.A.',
#                         'Author of original code for Spreadsheet::Excel' ]
# sheet1.row(3).push 'Charles Lowe', 'Author of the ruby-ole Library'
# sheet1.row(3).insert 1, 'Unknown'
# sheet1.update_row 4, 'Hannes Wyss', 'Switzerland', 'Author'

puts "Save file"
book.write 'spreadsheets/excel-file.xls'

# ("spreadsheets/myspeadsheet.xlsx")