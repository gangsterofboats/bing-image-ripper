#!/usr/bin/env ruby
################################################################################
# Bing Image Ripper - compile links from Bing image searches into an HTML file #
# Copyright (C) 2018 Michael Wiseman                                           #
#                                                                              #
# This program is free software: you can redistribute it and/or modify it      #
# under the terms of the GNU General Public License as published by the Free   #
# Software Foundation, either version 3 of the License, or (at your option)    #
# any later version.                                                           #
#                                                                              #
# This program is distributed in the hope that it will be useful, but WITHOUT  #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        #
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for    #
# more details.                                                                #
#                                                                              #
# You should have received a copy of the GNU General Public License along with #
# this program.  If not, see <https://www.gnu.org/licenses/>.                  #
################################################################################
require 'http'
require 'json'
require 'nokogiri'

puts ARGV.join(' ')
file_name = ARGV.join('-') + '.html'
search = ARGV.join('+')

fh = File.open(file_name, 'w+')
fh.puts("<!DOCTYPE html>\n<html>\n<head>\n<title>#{ARGV.join(' ')}</title>\n</head>\n<body>")
fh.puts("<h1>#{ARGV.join(' ')}</h1>")
fh.puts('<br>')

# http = HTTP.headers('User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36')
(0..40).each do |i|
  uri = "https://www.bing.com/images/async?q=#{search}&first=#{(150*i)+1}&count=150&safeSearch=off&size=wallpaper&qft=+filterui:age-lt525600"
  # uri = "https://www.bing.com/images/async?q=#{search}&first=#{(150*i)+1}&count=150&safeSearch=off&size=wallpaper"
  result = HTTP.get(uri).to_s
  doc = Nokogiri::HTML(result)
  content = doc.css('.iusc')
  content.each do |line|
    ijs = JSON.parse(line['m'])
    image = ijs['murl']
    fh.puts("<img src=\"#{image}\">")
  end
end
fh.puts("</body>\n</html>")
fh.close

fo = File.readlines(file_name)
fo.uniq!
File.open(file_name, 'w+') do |fi|
  fo.each { |item| fi.write("#{item}") }
end
