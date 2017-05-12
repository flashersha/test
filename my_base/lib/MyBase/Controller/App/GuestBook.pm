package MyBase::Controller::App::GuestBook;
use Mojo::Base 'Mojolicious::Controller';
use SHA::Model::GuestBook;

sub list {
    my $c   = shift;
    my $res = {
        success => \1,
    };
    
    my $order            = $c->order_by();
    my ($limit, $offset) = $c->limit_offset();
    
    ($res->{'rows'}, $res->{'total'}) =
        SHA::Model::GuestBook
            ->new()
                ->list( $order, $limit, $offset );

    
    $res->{'current'}  = $c->{'args'}->{'current'};
    $res->{'rowCount'} = $c->{'args'}->{'rowCount'};    
    
    $c->render( json => $res );
}

sub add {
    my $c   = shift;
    my $res = {
        success => \1,
    };
    
    unless( $c->{'args'}->{'text'} ){
        $res = {
            success => \0,
            error   => 'Не хватает параметров',
        };
        
        return $c->render( json => $res );        
    }

    $res->{'data'} =
        SHA::Model::GuestBook
            ->new (
                user_id => $c->stash->{'user'}->{'id'},
                text    => $c->{'args'}->{'text'}
            )
            ->save();

    $c->render( json => $res );    
}

1;