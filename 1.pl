#! usr/bin/perl -l
use DDP;
use Date::Parse;

$date1 = "03 Mar 2017 18:42:19 +0300";
$date2 = "03 Mar 2017 18:42:19 +0200";

$time1 = str2time($date1);
$time2 = str2time($date2);
print $time1, "\n", $time2;
print $time1 - $time2;
__DATA__;
@c = strptime($date);
print "@c";
($ss,$mm,$hh,$day,$month,$year,$zone) = strptime($date);
