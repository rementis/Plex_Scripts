#!/usr/bin/perl
use strict;
use File::Find;

my $directory = '/media/media9/Plex/Movies';
my @files;

print "\nListing files which are not h264...\n\n";
find(\&check_file, $directory);

sub check_file {
  push @files, $File::Find::name;
}

foreach(@files){
  my $file = $_;
  if ( $file =~ /\.sub$/ ) { next }
  if ( $file =~ /\.srt$/ ) { next }
  if ( -f $file ) {
    my $output = `ffprobe "$file" 2>&1`;
    if ( $output =~ /Duration: N\/A/ ) { next }
    if ( $output =~ /Unable to open/ ) { next }
    if ( $output !~ /h264/ ) {
      print "$file\n";
    }
  }
}
