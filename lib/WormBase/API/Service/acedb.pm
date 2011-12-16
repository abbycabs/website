package WormBase::API::Service::acedb;

use Moose;
use WormBase::Ace;

use namespace::clean -except => 'meta';

has 'dbh'     => (
    is        => 'rw',
    isa       => 'WormBase::Ace',
    predicate => 'has_dbh',
    writer    => 'set_dbh',
    handles   => [qw/fetch raw_query find fetch_many raw_fetch/],
);

# Roles to consume.
with 'WormBase::API::Role::Service';

has 'timeout' => (
    is        => 'ro',
    isa       => 'Str'
);

has 'query_timeout' => (
    is              => 'ro',
    isa             => 'Str'
);

has 'program'  => (
    is         => 'ro',
    lazy_build => 1,
);

sub _build_program {
    my $self = shift;
    return $self->conf->{program};
}

has 'path'     => (
    is         => 'ro',
    lazy_build => 1,
);

sub _build_path {
    my $self = shift;
    return $self->conf->{path};
}

sub connect {
    my $self = shift;
    # my $conf = $self->conf;

    my %options = (
        name => 'ws228', # hardcode for now
    );

    my $dbh = WormBase::Ace->connect(%options)
        or $self->log->error(WormBase::Ace->error);
    return $dbh;
}

sub ping {
  my ($self,$dbh)=@_;
  return $dbh->reopen; # this ping should always work!
}

1;
