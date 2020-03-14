#!/usr/bin/env perl6
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

use HTML::Parser::XML;
use HTTP::UserAgent;
use JSON::Tiny;

say @*ARGS.join(' ');
my $arg = @*ARGS.join(' ');
my $filename = join("-", @*ARGS) ~ '.html';
my $search = join("+", @*ARGS);

my $fh = open $filename, :w;
$fh.say("<!DOCTYPE html>\n<html>\n<head>\n<title>{$arg}</title>\n</head>\n<body>");
$fh.say("<h1>{$arg}</h1>");
$fh.say('<br>');

for (0 .. 10)
{

    my $url = "https://www.bing.com/images/async?q={$search}&first={(150*i)+1}&count=150&safeSearch=off&size=wallpaper";
    my $ua = HTTP::UserAgent.new(useagent => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36');
    my $parser = HTML::Parser::XML.new;
    my $response = $ua.get($url);
    $parser.parse($response.content);
    my @content = $parser.xmldoc.elements(:class(* eq 'iusc'), :RECURSE);
    for @content
    {
        my $ijn = $_.attribs{'m'};
        $ijn .= subst(/\&quot\;/, '"', :g);
        my %js = from-json $ijn;
        my $image = %js{'murl'};
        $fh.say("<img src=\"{$image}\">");
    }
}
$fh.say("</body>\n</html>");
$fh.close;

# my @f = $filename.IO.lines(:chomp);
# my @fo = @f.unique;
# spurt $filename, @fo.join("\n");
