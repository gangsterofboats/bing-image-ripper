#!/usr/bin/env python
################################################################################
# Bing Image Ripper - compile links from Bing image searches into an HTML file #
# Copyright (C) 2020 Michael Wiseman                                           #
#                                                                              #
# This program is free software: you can redistribute it and/or modify it      #
# under the terms of the GNU Affero General Public License as published by the #
# Free Software Foundation, either version 3 of the License, or (at your       #
# option) any later version.                                                   #
#                                                                              #
# This program is distributed in the hope that it will be useful, but WITHOUT  #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        #
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License #
# for more details.                                                            #
#                                                                              #
# You should have received a copy of the GNU Affero General Public License     #
# along with this program.  If not, see <https://www.gnu.org/licenses/>.       #
################################################################################

import json
import re
import requests
import sys
from bs4 import BeautifulSoup
# from selenium import webdriver

print(' '.join(sys.argv[1:]))
arg = ' '.join(sys.argv[1:])
file_name = '-'.join(sys.argv[1:]) + '.html'
search = '+'.join(sys.argv[1:])

fh = open(file_name, 'w')
fh.write(f'<!DOCTYPE html>\n<html>\n<head>\n<title>{arg}</title>\n</head>\n<body>\n')
fh.write(f'<h1>{arg}</h1>')
fh.write('\n<br>\n')
header = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'}

for i in range(0, 11):
    uri = f'https://www.bing.com/images/async?q={search}&first={(150*i)+1}&count=150&safeSearch=off&size=wallpaper'
    doc = requests.get(uri, headers=header).text
    content = BeautifulSoup(doc, 'html.parser')
    images = content.select('.iusc')
    for line in images:
        ijs = json.loads(line['m'])
        image = ijs['murl']
        fh.write(f'<img src="{image}">\n')
fh.write('</body>\n</html>')
fh.close()

# f = open(file_name, 'r').read().split('\n')
# fo = list(dict.fromkeys(f))
# ofh = open(file_name, 'w')
# for item in fo:
    # ofh.write(f'{item}\n')
# ofh.close()
