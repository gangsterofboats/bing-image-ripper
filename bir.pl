#!/usr/bin/env perl
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

use strict;
use warnings;
# use List::MoreUtils 'uniq';
use Data::Dumper;
use JSON;
use LWP;
use XML::LibXML;
use feature 'say';

say "@ARGV";
my $arg = join(' ', @ARGV);
my $filename = join('-', @ARGV) . '.html';
my $search = join('+', @ARGV);

open(my $fh, '>', $filename);
say $fh "<!DOCTYPE html>\n<html>\n<head>\n<title>$arg</title>\n</head>\n<body>";
say $fh "<h1>$arg</h1>";
say $fh '<br>';

for my $i (0..10)
{
    my $url = "https://www.bing.com/images/async?q=$search&first=@{[(150*$i)+1]}&count=150&safeSearch=off&size=wallpaper";
    my $ua = LWP::UserAgent->new;
    my $content = $ua->get($url, 'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36')->content;
    my $doc = XML::LibXML->load_html(string => $content);
    my @content = $doc->findnodes('//*[@class="iusc"]//@m');
    foreach (@content)
    {
        my $json = JSON->new;
        my %ijn = %{$json->decode($_->to_literal())};
        my $image = $ijn{'murl'};
        say $fh "<img src=\"$image\">";
    }
}
say $fh "</body>\n</html>";
close $fh;

# open(my $ifh, '<', $filename);
# my @f = <$ifh>;
# close $ifh;
# chomp(@f);
# my @fo = uniq @f;

# open(my $ofh, '>', $filename);
# foreach (@fo)
# {
    # say $ofh "$_";
# }
# close $ofh;
