package Log::Dis::Pleasure;

# ABSTRACT: Make logging a Pleasure.

use namespace::autoclean;
use Moo;

# Built from the Log::Dis::Patchy dispatchouli example clone.

with qw(Log::Dis::Patchy);

use Log::Dis::Patchy::Helpers qw(prepend_pid_callback);
use MooX::StrictConstructor;
use MooX::Types::MooseLike::Base qw(AnyOf Bool Str Undef);

has to_self =>
    ( is => 'rw', isa => Bool, default => 0, trigger => \&_reset_dispatcher );
has to_screen =>
    ( is => 'rw', isa => Bool, default => 1, trigger => \&_reset_dispatcher );
has to_file =>
    ( is => 'rw', isa => Bool, default => 0, trigger => \&_reset_dispatcher );
has log_file => ( is => 'rw', isa => Str, trigger => \&_reset_dispatcher );
has log_path => ( is => 'rw', isa => Str, trigger => \&_reset_dispatcher );

sub _reset_dispatcher {
    my $self = shift;
    $self->_clear_dispatcher();
}

has log_pid => ( is => 'ro', isa => Bool, default => 1 );

sub _build_debug {
    my $self = shift;
    $self->env_value('DEBUG');
}

sub _build_outputs {
    my $self = shift;
    my @outputs;

    push( @outputs, 'Log::Dis::Pleasure::Self' )   if $self->to_self;
    push( @outputs, 'Log::Dis::Pleasure::Screen' ) if $self->to_screen;
    push( @outputs, 'Log::Dis::Pleasure::File' )   if $self->to_file;

    return \@outputs;
}

sub _build_callbacks {
    my $self = shift;
    my @callbacks;
    push( @callbacks, prepend_pid_callback() ) if $self->log_pid;
    return \@callbacks;
}

sub env_prefix { return; }

sub env_value {
    my ( $self, $suffix ) = @_;

    my @path = grep {defined} ( $self->env_prefix, 'DISPLEASURE' );

    for my $prefix (@path) {
        my $name = join q{_}, $prefix, $suffix;
        return $ENV{$name} if defined $ENV{$name};
    }

    return;
}

sub _build__proxy_package {'Log::Dis::Pleasure::Proxy'}

sub new_tester {
    my ( $class, $arg ) = @_;
    $arg ||= {};

    return $class->new(
        {   ident   => "$$:$0",
            log_pid => 0,
            %$arg,
            to_screen => 0,
            to_file   => 0,
            to_self   => 1,
        }
    );
}

1;
