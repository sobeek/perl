#! usr/bin/perl -l
use DDP;

%a = (1,2,3,4);
#keys %a = (7,8);

$a{$_ + 10} = $a{$_} for keys %a;

p %a;


__DATA__

my %hash;
$hash{$_}++ for @a;
print "$_ -> $hash{$_}" for sort{$a<=>$b} keys %hash;

$a = 1;
$b = 1;

do {print $a; print $b} if ($a || $b);
