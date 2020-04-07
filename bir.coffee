#!/usr/bin/env coffee
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

fs = require('fs');
https = require('https');
jsdom = require('jsdom');
{ JSDOM } = jsdom;

args = process.argv.slice(2);
console.log("#{args.join(' ')}");
filename = args.join('-').concat('.html');
search = args.join('+');

fs.writeFile(filename, "<!DOCTYPE html>\n<html>\n<head>\n<title>#{args.join(' ')}</title>\n</head>\n<body>", (err) -> {});
fs.appendFile(filename, "\n<h1>#{args.join(' ')}</h1>\n", (err) -> {});
fs.appendFile(filename, "<br>\n", (err) -> {});
fs.appendFile(filename, "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>\n", (err) -> {});

for i in [0..10]
    uri = "https://www.bing.com/images/async?q=#{search}&first=#{(150*i)+1}&count=150&safeSearch=off&size=wallpaper&qft=+filterui:age-lt525600"
    # uri = "https://www.bing.com/images/async?q=#{search}&first=#{(150*i)+1}&count=150&safeSearch=off&size=wallpaper";
    https.get(uri, (resp) ->
        data = '';
        resp.on('data', (chunk) ->
            data += chunk;
        );
        resp.on('end', () ->
            dom = new JSDOM(data);
            doc = dom.window.document;
            content = doc.querySelectorAll('.iusc');
            for ct in content
                j = JSON.parse(ct.getAttribute('m'));
                image = j.murl;
                fs.appendFile(filename, "<img src=\"#{image}\">\n", (err) -> {});
        );
    )

fs.appendFile(filename, "</body>\n</html>", (err) -> {});
