#! usr/bin/perl -l
use strict;
use warnings;

use Local::Reducer;
use Local::Reducer::Sum;
use Local::Reducer::MaxDiff;

use Local::Source::Text;
use Local::Source::Array;
use Local::Source::Filehandler;

#use Local::Row;
use Local::Row::Simple;
use Local::Row::JSON;

my $x;

#my $x = Reducer->new(name => "Shadowfax", color => "white");
#print $x->get_name();


my $source_array = Local::Source::Array->new(array => [
        '{"price": 4}',
        '{"price": 5}',
        '{"price": 6}',
    ]);

#print $source_array->next();
#print $source_array->next();


my $source_text = Local::Source::Text->new(text =>
    "sended:1024,received:2048\nsended:2048,received:10240"
    );
#print $source_text->next();

my $reducer = Local::Reducer::Sum->new(
    field => 'price',
    source => Local::Source::Array->new(array => [
        '{"price": 1}',
        '{"price": 2}',
        '{"price": 3}',
    ]),
    row_class => 'Local::Row::JSON',
    initial_value => 0,
);

print "REDUCED(1): ".$reducer->reduce_n(1);
print "REDUCED(1): ".$reducer->reduce_n(1);
print "REDUCED ALREADY: ".$reducer->reduced();
print $reducer->reduce_all;

$reducer = Local::Reducer::MaxDiff->new(
    top => 'received',
    bottom => 'sended',
    source => Local::Source::Text->new(text =>"sended:1024,received:2048\nsended:2048,received:10240"),
    row_class => 'Local::Row::Simple',
    initial_value => 0,
);

print "REDUCED(1): ".$reducer->reduce_n(1);
print "REDUCED(1): ".$reducer->reduce_n(1);
print "REDUCED ALREADY: ".$reducer->reduced();
print $reducer->reduce_all;
#$reducer->reduce_all();
#print $x while $x = $source_text->next();

=head
open my $filehandle, "text.txt" or die $!;

my $source_file= Local::Source::Filehandler->new(filehandle =>
    $filehandle
    );
print $x while $x = $source_file->next();


while (my $got = $source_text->next()) {
    $x = Local::Row::Simple->new(str => $got);
    my $text = $x->{str};
    #$text ? print $text : last;
    my $text_field = $x->get('received', 0);
    #$text_field ?
    print $text_field;
    # last;

}
=cut




__DATA__
while (my $got = $source_array->next()) {
    <>;
    $x = Local::Row::JSON->new(str => $got);
    my $text = $x->{str};
    #$text ? print $text : last;
    my $text_field = $x->get('price', 0);
    #$text_field ?
    print $text_field;
    # last;

}
