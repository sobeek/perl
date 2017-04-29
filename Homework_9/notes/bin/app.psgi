#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use notes;

notes->to_app;

use Plack::Builder;

builder {
    enable 'Deflater';
    notes->to_app;
}



=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use notes;
use Plack::Builder;

builder {
    enable 'Deflater';
    notes->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use notes;
use notes_admin;

builder {
    mount '/'      => notes->to_app;
    mount '/admin'      => notes_admin->to_app;
}

=end comment

=cut

