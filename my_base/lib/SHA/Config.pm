package SHA::Config;
use Moo;
use FindBin qw($Bin);

my $config = undef;

has path2config => ('is' => 'ro', required => 1, default => sub { qq{$Bin/../../config/my_base.conf} });
has config      => ('is' => 'lazy');

sub _build_config {
    my ($self) = @_;
    die "File not exists " . $self->path2config
        unless -f $self->path2config;
    
    $config ||= do $self->path2config;
    
    return $config;
}

1;