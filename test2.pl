use strict;
use warnings;
use Selenium::Remote::Driver; 
use MIME::Base64; 
my $d = Selenium::Remote::Driver->new(
    remote_server_addr => '127.0.0.1',
    port => 9999,
    );
my $url='http://www.youtube.com/results?search_query=fenrir'; 
my $filename = '_screen_' . time() . '.png'; 
# YouTube の検索結果画面にアクセス 
$d->get($url); 

wait_for_page_to_load($d,10000); 
# スクリーンショット撮影 
my $png = $d->screenshot(); 
# ファイルに保存 
open my $fh, '>', $filename or die $!; 
binmode $fh; 
$png = $d->screenshot();
print $fh MIME::Base64::decode_base64($png); 
close $fh; 
$d->quit(); 
# via https://github.com/aivaturi/Selenium-Remote-Driver/wiki/Example-Snippets 
sub wait_for_page_to_load { my ($driver,$timeout) = @_; my $ret = 0; my $sleeptime = 2000; 
# milliseconds 
$timeout = (defined $timeout) ? $timeout : 30000 ; do { sleep ($sleeptime/1000); 
# Sleep for the given sleeptime 
$timeout = $timeout - $sleeptime; } while (($driver->execute_script("return document.readyState") ne 'complete') && ($timeout > 0)); if ($driver->execute_script("return document.readyState") eq 'complete') { $ret = 1; } return $ret; }
