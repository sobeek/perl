#! usr/bin/perl -l

$str = q{46.29.9.32 [03/Mar/2017:18:31:56 +0300] "GET /music HTTP/1.1" 200 85363 "https://my.mail.ru/some/page/261505"GET /music/search/.%3A%3A%5D+vk.com%2Frealtones+%5B%3A%3A.+-+%D0%A0%D0%B8%D0%BD%D0%B3%D1%82%D0%BE%D0%BD+%5BEllie+Goulding+-+I+Need+Your+Love+%28Florian+Paetzold+Edit%29%5D HTTP/1.1" 200 48925 "-" "Opera/9.80 (Windows NT 5.1; U; ru) Presto/2.7.62 Version/11.01" "5.04"};

$str2 = q{195.178.193.216 [03/Mar/2017:18:28:38 +0300] "GET /music/songs/817140dc852240b835117445e0503ac2 HTTP/1.1" 200 64619 "-" "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" "7.39"};

@patt1 = qw /^(.*?)\s
            \[(.*?)\]\s
            "(.*?)"\s
            (\d+)\s
            (\d+)\s
            "(.*?)"\s
            "(.*?)"\s
            "(\d+(?:\.\d+)*|-)$"
            /;
my @patt = qw /
            ^(.*?)\s
            \[(?<time>[^\]]*)\]\s
            "(?<request>[^"]*)"\s
            (?<code>\d+)\s
            (?<bytes>\d+)\s
            "(?<referrer>[^"]*)"\s
            "(?<user_agent>[^"]*)"\s
            "(?<coeff>\d+(?:\.\d+)*|-)"$
            /;

            my $patt = qr /
                        ^(.*?)\s
                        \[(?<time>[^\]]*)\]\s
                        "(?<request>[^"]*)"\s
                        (?<code>\d+)\s
                        (?<bytes>\d+)\s
                        "(?<referrer>[^"]*)"\s
                        "(?<user_agent>[^"]*)"\s
                        "(?<coeff>\d+(?:\.\d+)*|-)"$
                        /x;

print $patt;

print 1 if $str1 =~ $patt;
#print @patt;
__DATA__
for $s ($str, $str2) {
    print "S: $s";
    for $p (@patt) {
        print "-------------------------\n$p";
        print "MATCHED: "."$1"."..." if $s =~ /$p/;
        print $+[0]." ".$-[0];
        print "INVALID!!" if $-[0];
        $s = substr $s, $+[0];
    }
}
