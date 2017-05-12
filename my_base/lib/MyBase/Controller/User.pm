package MyBase::Controller::User;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
use SHA::Model::User;
 
sub login {
    my $c   = shift;
    my $res = {
        success => \1,
    };

    unless (
        $c->{'args'}->{'email'}
        && $c->{'args'}->{'passwd'}
        && $c->{'args'}->{'captcha'}
    ){
        $res = {
            success => \0,
            error   => 'Не хватает параметров',
        };
        
        return $c->render( json => $res );
    }

    if ( $c->{'args'}->{'captcha'} ne $c->session->{'captcha'} ){
        $res = {
            success => \0,
            error   => 'Текст с картинки введен неправильно',
        };
        return $c->render( json => $res );
    }
        
    my $user
        = SHA::Model::User
            ->new()
                ->find2login(
                    $c->{'args'}->{'email'},
                    $c->{'args'}->{'passwd'}
                );
    
    if( $user ){
        $c->session->{'user_id'} = $user->{'id'};
        $res = {
            success => \1,
            data    => $user,
        };        
    }
    else {
        $res = {
            success => \0,
            error   => 'Логин или пароль не подходят!',
        };                
    }
    
    $c->render( json => $res );
}

sub logout {
    my $c   = shift;
    my $res = {
        success => \1,
    };
    
    $c->session( expires => 1 );
    
    $c->render( json => $res );
}

1;