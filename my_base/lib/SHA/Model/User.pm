package SHA::Model::User;
use Moo;
use SQL::Abstract::More;
use Digest::MD5 qw(md5_hex);
use Data::Dumper;

extends 'SHA::Model';

my $sql   = SQL::Abstract::More->new();
my $table = 'users';

has id        => (is => 'rw');
has user_name => (is => 'rw');
has passwd    => (is => 'rw');
has email     => (is => 'rw');
has token     => (is => 'rw');
has homepage  => (is => 'rw');

has attrs     => (is => 'rw', default => sub{
    [qw(id email user_name passwd homepage)]
});

sub get {
    my ($m, $id) = @_;
    my ( $res )  = ( undef );
    $id ||= $m->id;

    my ($stmt, @bind) = $sql->select(
        -from    => $table,
        -where   => { id => $id },
    );
        
    $res = $m->single( $stmt, \@bind );
    
    delete $res->{'passwd'}
        if $res;
    
    return $res;
}

sub find2login {
    my ($m, $email, $passwd) = @_;
    my $res = undef;
    
    die "attr email not exist"
        unless $email;

    die "attr passwd not exist"
        unless $passwd;

    my ($stmt, @bind) = $sql->select(
        -from    => $table,
        -where   => {
            email  => $email,
            passwd => md5_hex($passwd),
        },
    );
    
    delete $res->{'passwd'}
        if $res;
        
    $res = $m->single( $stmt, \@bind );
    
    delete $res->{'passwd'}
        if $res;
    
    return $res;
}

1;