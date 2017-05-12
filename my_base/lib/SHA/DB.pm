package SHA::DB;
use SHA::Config;
use DBI;
 
my $schema   = undef;
my $conf_db  =
    SHA::Config
        ->new()
            ->config->{'db_mysql'};

sub connect {
    my ($self) = @_;

    return $schema ||= DBI->connect(
        $conf_db->{'dbi'},
        $conf_db->{'user'},
        $conf_db->{'passwd'},
        $conf_db->{'attr'}        
    );
}

1;