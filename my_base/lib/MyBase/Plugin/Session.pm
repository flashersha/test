package MyBase::Plugin::Session;
use Data::Dumper;
use Hash::Merge ();
use SHA::Model::User;

use Mojo::Base 'Mojolicious::Plugin';

my $merger = Hash::Merge->new( 'RIGHT_PRECEDENT' );

use constant {
	UNDEF_USER_ID => 0, 
};

sub register {
	my ( $self, $app ) = @_;
	
	$app->routes->add_condition( session => sub {
		my ($r, $c, $captures, $pattern ) = @_;
		$c->check_session()
			? 1
			: 0
			;
	});

	$app->routes->add_condition( auth => sub {
		my ($r, $c, $captures, $pattern ) = @_;
		$c->session->{'user_id'}
			? 1
			: 0
			;
	});	

	$app->helper( check_session => sub {
		my ($c) = @_;		
		$c->res->headers->header('Server' => 'MyBase');
		
		my $session =
			$c->session->{'user_id'}
				? 1
				: $c->set_session()
				;
		
		return
			defined $c->session->{'user_id'}
				? 1
				: 0
				;
	});

	$app->helper( set_session => sub {
		my ($c) = @_;
		
		$c->session({
			user_id  => UNDEF_USER_ID,
		});
		$c->csrf_token();
		
		return $c->session();
	});

	$app->hook( before_dispatch => sub {
		my ($c, $args) = @_;
		my $user       = undef;
	
		# Настройки из конфига
		$c->stash->{'settings'} = $c->app->config->{'settings'};
		
		# Параметры
		my $json_params =
			$c->req->json
				|| {};
	
		my $data_params =
			$c->req->params
				? $c->req->params->to_hash
				: {}
				;
	
		my $data     =
			$merger->merge( $json_params, $data_params );
	
		$c->{'args'} = $data;		
	
		# Данные пользователя
		if( my $token = $data->{'token'} ){
			$user =
				SHA::Model::User
					->new()
						->find2token( $token );
		}
		elsif( my $user_id = $c->session->{'user_id'} ){
			$user =
				SHA::Model::User
					->new( id => $user_id )
						->get();		
		}
	
		if( $user ){
			$user->{'csrf_token'}    = $c->session->{'csrf_token'};
			$c->stash->{'user'}      = $user;
			$c->session->{'user_id'} = $user->{'id'};
		}
		elsif( my $token = $data->{'token'} ){
			$c->session->{'user_id'} = UNDEF_USER_ID;			
		}
	
		$c->stash->{'session'} = $c->session;
	
		return $c;
	});


	$app->hook( before_routes => sub {
		my $c = shift;
		
		# Проверка на csrf		
		if( $c->req->method !~ /get/i ) {
			my $session = $c->stash('session');
			my $csrf    = $c->{'args'}->{'csrf_token'};
		
			if(
				!$session->{'csrf_token'}
				|| $csrf ne $session->{'csrf_token'} 
			){
				#$c->app->log->debug("CSRFProtect: Wrong CSRF protection token for [".$c->req->url->to_string."]!");
				$c->session( expires => 1 );
				return $c->render(
					json   => {
						success => \0,
						error   => 'Wrong CSRF protection',
					}
				);
			}
		}
	
	});	

	return 1;
}

1;
