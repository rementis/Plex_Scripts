#!/usr/bin/perl
use strict;
use File::Find;
use Cwd qw();

my $directory = Cwd::cwd();

if ($ARGV[0]) {
  $directory = $ARGV[0];
}

my $output_csv = '/tmp/plex.csv';

open OUTPUT, ">$output_csv" or die "Cannot open $output_csv";

my @files;

print "\nGenerating list...\n\n";
find(\&check_file, $directory);

sub check_file {
  push @files, $File::Find::name;
}
@files = sort(@files);

foreach(@files){
  my $file = $_;
  if ( $file =~ /\.sub$/ ) { next }
  if ( $file =~ /\.srt$/ ) { next }
  if ( $file =~ /\.nfo$/ ) { next }
  if ( $file =~ /\.txt$/ ) { next }
  if ( -f $file ) {
    my $output = `ffprobe "$file" 2>&1`;
    if ( $output =~ /Duration: N\/A/ ) { next }
    if ( $output =~ /Unable to open/ ) { next }
    my $output2 = `ffprobe -select_streams v:0 -show_streams "$file" 2>&1`;
    $output2 =~ /codec_name=(\w+)/;
    my $codec = $1;
    print "$file $codec\n";
    $file =~ s/,//g;
    print OUTPUT "$file,$codec\n";
  }
}

