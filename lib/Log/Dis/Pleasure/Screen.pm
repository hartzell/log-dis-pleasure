
package Log::Dis::Pleasure::Screen;

use namespace::autoclean;
use Moo;

use Log::Dis::Patchy::Helpers qw(append_newline_callback);

sub _build_ldo_name         {'screen'}
sub _build_ldo_package_name {'Log::Dispatch::Screen::Color'}

with 'Log::Dis::Patchy::Output';

around _build_ldo_init_args => sub {
    my ( $orig, $self ) = ( shift, shift );
    my $args = $self->$orig(@_);

    $args->{callbacks} = [ append_newline_callback() ];
    $args->{stderr}    = 0;
    $args->{color}     = {
        debug   => { text => 'blue' },
        info    => { text => 'green', },
        warning => { text => 'red', },
        error   => {
            background => 'white',
            bold       => 1,
            text       => 'red',
        },
    };

    return $args;
};

1;
