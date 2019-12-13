#!/usr/bin/perl
package Foo;
use strict;
use warnings;

use Data::Dumper;
use Encode;
use LWP;
use HTML::TreeBuilder;
use HTML::FormatText;

my $ua = LWP::UserAgent->new;
#$ua->agent( 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36' );
my $response  = $ua->request( HTTP::Request->new( GET => 'http://www.softia.fr' ) );
#my $response = $ua->get( 'http://www.softia.fr' );
my $content = $response->content;
$content = decode( 'utf-8', $content ); # la page est en utf-8, alors on decode l'utf-8

my $tree = HTML::TreeBuilder->new;
$tree->parse($content);

my @hs = $tree->look_down # on cherche les h4 
(
  '_tag' => 'h4'
#   ,
#   'class' => 'container'
);

foreach my $h (@hs)
{
  my @ps = HTML::FormatText->new($h->find('h4')); # on cherche les h
  my $p = shift @ps; # seul le premier <p> nous interesse
  printf "- \%s\n", $p;
}