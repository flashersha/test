package MyBase;
use strict;

use Mojo::Base 'Mojolicious';
use FindBin qw($Bin);
use SHA::Config;
use Data::UUID;

my $uuid = Data::UUID->new;
#$ENV{MOJO_MAX_MESSAGE_SIZE} = 1_073_741_824;

sub startup {
    my $app    = shift;
    my ($r, $rt, $app_rt);
    
    $app->{'config'} =
        SHA::Config
            ->new()
                ->config;
        
	$app->sessions->cookie_name       ($app->{'config'}->{'session'}->{'cookie_name'}       );
	$app->sessions->default_expiration($app->{'config'}->{'session'}->{'default_expiration'});
	$app->sessions->secure            ($app->{'config'}->{'session'}->{'secure'}            );    

    $app->plugin('MyBase::Plugin::Session');
    $app->plugin('MyBase::Plugin::Utils');
    
    $app->defaults->{'handler'} = 'tx';
    
    # xslate быстрее toolkit,
    # TTerse -> используем синтаксис toolkit
    $app->plugin( xslate_renderer => {
        template_options => {
            syntax    => 'TTerse',
            cache_dir => "$Bin/../.xslate_cache",
            path      => [ "$Bin/../templates" ],
            function  => {
                rand  => sub {
                    return $uuid->create_str;
                },
                config => $app->{'config'},
            },
            header => ['app/header.html.tx'],
            footer => ['app/footer.html.tx'],
        }
    });
    
    $r = $app->routes->over( session => 1 );
    
    #*****************************************************
    # сайт с авторизацией
    #*****************************************************
    $rt = $r->any('/list')->over( auth => 1 );
        # главная
        $rt->get('/')->to('page#list');

    #*****************************************************
    # app
    #*****************************************************
    $app_rt = $r->any('/app')->over( auth => 1 );
        $app_rt->get ('/list')->to('app-guest_book#list');
        $app_rt->post('/list')->to('app-guest_book#add');
    
    #*****************************************************
    # сайт без авторизации
    #*****************************************************        
    $r->post('/login'  )->to('user#login'  );
    $r->get ('/logout' )->to('user#logout' );
    $r->get("/list"    )->to( cb => sub {
        my $c = shift;
        return $c->redirect_to("/");
    });
        
    $r->get ('/captcha')->to('page#captcha');
    $r->any('/'        )->to('page#index'   );
    $r->any('/(*)'     )->to('page#page_404');
}

1;