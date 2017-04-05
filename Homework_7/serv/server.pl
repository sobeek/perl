#!usr/bin/perl -l
use strict;
use warnings;
use Socket ':all';
use 5.010;
use LWP::Simple;

$| = 1;
socket my $s, AF_INET, SOCK_STREAM, IPPROTO_TCP;
setsockopt $s, SOL_SOCKET, SO_REUSEPORT, 1;
#bind $s, sockaddr_in(1234, INADDR_ANY);

my $port = 8888;
bind($s , sockaddr_in($port, INADDR_ANY))
    or  die "bind failed : $!";

listen $s, SOMAXCONN;
my ($port1, $addr) = sockaddr_in(getsockname($s));
print "Listening on ".inet_ntoa($addr).":".$port;


#run();
#$SIG{'INT'} = \&cls_conn($s);

sub run {
    while (my $peer = accept my $c, $s) {
        # got client socket $c
        # $peer = getpeername($c);
        my ($port, $addr) = sockaddr_in($peer);
        my $ip = inet_ntoa($addr);
        my $host = gethostbyaddr($addr, AF_INET);
        print "Client connected from $ip:$port ($host)";
        my $url;
        while (1) {
            my $r = recv $c, my $buf, 1024, 0;
            if (defined $r) {
                chomp ($buf);
                given ($buf) {
                    when ('FIN') {
                        send $c, "BYE", 0 or die "send: $!";
                        shutdown $s, 2;
                        #close $s;
                    }
                    when (/^URL\s/) {
                        $url = substr $buf, $+[0];
                        print $url;
                        send $c, "Yes! We've got url $url", 0 or die "send: $!";
                    }
                    when ('HEAD') {
                        my $header = get_head($url);
                        my $msg = $url ? "Getting head from $url" : "No url defined!";
                        send $c, $header, 0 or die "send: $!";
                        send $c, $msg, 0 or die "send: $!";


                        # Команда HEAD делает HEAD запрос на запомненый URL и возвращает заголовки
                    }
                    when ('GET') {
                        my $msg = $url ? "Sending request to $url" : "No url defined!";
                        send $c, $msg, 0 or die "send: $!";
                        #Команда GET делает GET запрос на запомненый URL и возвращает тело
                    }
                    default {
                        send $c, "Unknown command", 0 or die "send: $!";
                    }
                }
                warn "There!";
                #shutdown $s, 0 if $buf =~ /^FIN$/;
                #exit (0) if $buf =~ /^FIN$/;
                print $buf;
                undef $buf;
                #send $c, $buf, 0 or die "send: $!";
            }
        }
        #my $r = recv $c, my $buf, 1024, 0;
        #print $buf;
        #send $c, $buf, 0 or die "send: $!";

    }
}

sub get_head {
    my $url = shift;
    #$url = 'http://mail.ru';
    $url = 'mail.ru';
    #use Socket;
    # создать сокет
    socket(Server, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
    # построить адрес удаленной машины
    my $remote_port = 80;
    my $internet_addr = inet_aton($url) or die "Невозможно преобразовать $url в адрес Интернета: $!\n";
    my $paddr = sockaddr_in($remote_port, $internet_addr);
    # соединение
    connect(Server, $paddr) or die "Невозможно соединиться с $url:$remote_port: $!\n";
    select((select(Server), $| = 1)[0]); # активизировать буферизацию команд
    # послать что то через сокет
    print 1;
    print Server "HEAD /$url HTTP/1.1\nHost: $internet_addr";
    warn;
    # прочесть ответ удаленной машины
    my $answer = <Server>;
    warn;
    print $answer;
    return $answer;
    print $url;
    #my $content = get ($url);
    #print $content;
    # по окончании завершить соединение
    #close(Server);
    #return $content;
}

sub cls_conn {
    shutdown $_[0], 2;
    print "SHUTDOWN";
    exit(0)
}

get_head();
