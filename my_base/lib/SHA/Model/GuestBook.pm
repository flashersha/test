package SHA::Model::GuestBook;
use Mojo::DOM;
use Moo;
use SQL::Abstract::More;
use Data::Dumper;

extends 'SHA::Model';

my $sql    = SQL::Abstract::More->new;
my $table  = 'guest_book';
my $view   = 'guestbook_view';

has id        => (is => 'rw');
has user_id   => (is => 'rw');
has text      => (is => 'rw', isa => sub {
        $_[0] =
            Mojo::DOM
                ->new()
                    ->xml(0)
                        ->parse($_[0])
                            ->all_text if $_[0];    
    });

has ctime    => (is => 'rw', required => 1, default => sub {
        \'NOW()';
    });

has attrs    => (is => 'rw', required => 1, default => sub {
        [ qw(user_name email ctime text) ]
    });

sub list {
    my ( $m, $order, $limit, $offset ) = @_;
    my ( $res, $count ) = ( [], 0 );

    # count
    my ($stmt, @bind) = $sql->select(
        -columns  => ['COUNT(id)|count'],
        -from     => $view,
    );    
    
    $count =
        $m->single( $stmt, \@bind )
           ->{'count'}
                || 0;
    
    if( $count ){
        # select
        ($stmt, @bind) = $sql->select(
            -columns  => $m->attrs,
            -from     => $view,
            -limit    => $limit,
            -offset   => $offset,
            -order_by => $order,
        );

        $res = $m->search( $stmt, \@bind );
    }
        
    return @{[ $res, $count ]};
}

sub save {
    my ( $m, $user_id, $text ) = @_;
    my $res = {};
    $user_id ||= $m->user_id;
    $text    ||= $m->text;

    my ($stmt, @bind) = $sql->insert(
        -into      => $table,
        -values    => {
            text    => $text,
            user_id => $user_id,
        },
    );
    
    $res = $m->save_tx( $stmt, \@bind );
    
    return $res;
}

1;