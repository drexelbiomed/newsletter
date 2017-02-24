require 'premailer'

html_file = ARGV[0]
v2 = ARGV[1]

premailer = Premailer.new("build/#{html_file}.html", :warn_level => Premailer::Warnings::SAFE)

# Write the plain-text output
# This must come before to_inline_css (https://github.com/premailer/premailer/issues/201)
File.open("emails/#{html_file}.txt", "w") do |fout|
  fout.puts premailer.to_plain_text
end

# Write the HTML output
File.open("emails/#{html_file}.html", "w") do |fout|
  fout.puts premailer.to_inline_css
end

# Output any CSS warnings
premailer.warnings.each do |w|
  puts "#{w[:message]} (#{w[:level]}) may not render properly in #{w[:clients]}"
end