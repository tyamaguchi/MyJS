use strict;
use warnings;
#
#use Selenium::Remote::Driver
#
#my $driver;
#my $driver = Selenium::Remote::Driver->new(
#    remote_server_addr => '127.0.0.1',
#    port => 9999,
#    );
#
#my $res = $driver->get('http://www.yahoo.co.jp');
#
#print $driver->get_title();
#print $driver->get_body();


use Selenium::Remote::Driver; 
use Test::More tests => 1; 
my $d = Selenium::Remote::Driver->new(
    remote_server_addr => '127.0.0.1',
    port => 9999,
    );
# Sleipnir Start の YouTube アイコンをクリックした時の挙動を確認 
# 期待される動作: 入力されたキーワードで YouTube 検索し、結果を別タブで表示 
my $search_word = 'fenrir'; 

# Sleipnir Start トップページにアクセス 
$d->get("http://www.sleipnirstart.com"); 

# テキスト「fenrir」を入力 
$d->find_element('//input[@id="search_txt"]')->send_keys($search_word); 

# YouTube アイコンをクリック 
$d->find_element('//input[@id="i_t"]')->click(); 

# ページが表示されるまで待つ 
wait_for_page_to_load($d,10000); 

# 検索結果のタブを選択 
my $h = $d->get_window_handles(); 
$d->switch_to_window($h->[1]); 

# ページタイトルが「fenrir - YouTube」になっているかどうかチェック 
is $d->get_title(), 
$search_word.' - YouTube', 'search results title'; 
$d->quit(); 
# via https://github.com/aivaturi/Selenium-Remote-Driver/wiki/Example-Snippets 
sub wait_for_page_to_load { 
    my ($driver,$timeout) = @_; 
    my $ret = 0; 
    my $sleeptime = 2000; 
    # milliseconds 
    $timeout = (defined $timeout) ? $timeout : 30000 ; 
    do { 
     sleep ($sleeptime/1000); 
     # Sleep for the given sleeptime 
     $timeout = $timeout - $sleeptime;
    } 
    while (($driver->execute_script("return document.readyState") ne 'complete') && ($timeout > 0)); 
     if ($driver->execute_script("return document.readyState") eq 'complete') { $ret = 1; } 
    return $ret; 
}
