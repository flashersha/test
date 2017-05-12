package MyBase::Controller::Page;
use Mojo::Base 'Mojolicious::Controller';
use GD::SecurityImage;
use FindBin qw($Bin);
use Data::Dumper;

sub index {
    my $c = shift;
    
    $c->render(
        template => '/app/page/index',
    );
}

sub list {
    my $c    = shift;
    
    $c->render(
        template => '/app/page/list',
    );
}


sub page_404 {
    my $c = shift;
    
    $c->render(
        template => 'page/_404',
        status   => 404,
    );    
}

sub captcha {
    my $c      = shift;
    my @chars  = ("A".."Z", "a".."z", 0..9);
    my $string = '';
    $string .= $chars[rand @chars] for 1..8;
    
    my $image = GD::SecurityImage->new(
        width    => 200,
        height   => 80,
        lines    => 30,
        font     => "$Bin/../public/fonts/Roboto-Black.ttf",
        ptsize   => 24,
        scramble => 0,
    );
    $image->random( $string );
    $image->create( ttf => 'default' );
    $image->particle;

    my( $image_data, $mime_type, $random_number ) = $image->out;
    
    $c->session->{'captcha'} = $random_number;
        
    $c->render(
        data   => $image_data,
        format => $mime_type,
    );
}

1;