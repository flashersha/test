package MyBase::Plugin::Utils;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
	my ( $self, $app ) = @_;
	
    $app->helper( limit_offset => sub {
        my ($c)    = @_;
        my $offset =
            $c->{'args'}->{'current'}
                || $c->config->{'settins'}->{'page'}->{'rows'};
        
        my $limit =
            $c->{'args'}->{'rowCount'}
                || 1;
		
        $offset = ($offset - 1) * $limit;
        
        return $limit, $offset;
    } );
    
    $app->helper( order_by => sub {
        my ($c)   = @_;
        my $order = [];
        my $set   = {
            desc => '-',
            asc  => '+',
        };
        
        for my $key ( keys %{ $c->{'args'} } ){
            if( $key =~ /^sort\[(\w+)\]$/i ){
                push @{$order},  
                    $set->{lc( $c->{'args'}->{$key} )}
                    . $1
                ;
                
                last;
            }
        }        
        
        return $order;
    } );    
	
}
    
1;