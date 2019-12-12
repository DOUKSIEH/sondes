#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use Encode;
use LWP;
use HTML::TreeBuilder;

my $ua = LWP::UserAgent->new;
$ua->agent( 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36' );
my $response = $ua->get( 'http://www.softia.fr' );
my $content = $response->content;
$content = decode( 'utf-8', $content ); # la page est en utf-8, alors on decode l'utf-8

my $tree = HTML::TreeBuilder->new;
$tree->parse($content);

my @divs = $tree->look_down # on cherche les <div> qui ont class="post article"
(
  '_tag' => 'div',
  'class' => 'container'
);

foreach my $div (@divs)
{
  my @ps = $div->find('p'); # on cherche les <p>
  my $p = shift @ps; # seul le premier <p> nous interesse
  printf "- \%s\n", $p->as_text;
}