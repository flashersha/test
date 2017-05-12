package SHA::Model;
use SHA::DB;
use Moo;
use Data::Dumper;
use Try::Tiny;

my $dbh = undef;

sub _db {
    my $m = shift;
    $dbh ||= SHA::DB->connect();
    die 'Do not connect to DB'
        unless $dbh;
    
    return $dbh;
}

sub single {
    my ($m, $statement, $bind_values) = @_;
    my $hash_ref = {};

    $hash_ref    =
        $m->_db->selectrow_hashref(
            $statement,
            undef,
            $bind_values ? @{$bind_values} : undef,
        );
    
    return $hash_ref;
}

sub search {
    my ($m, $statement, $bind_values) = @_;
    my $array_ref = [];
    $array_ref    =
        $m->_db->selectall_arrayref(
            $statement,
            { Slice => {} },
            $bind_values ? @{$bind_values} : undef,
        );
    
    return $array_ref;    
}

sub save_tx {
    my ($m, $statement, $bind_values) = @_;
    
    $m->_db->begin_work;
    
    try {
        my $data = $m->_db->do(
            $statement,
            undef,
            $bind_values ? @{$bind_values} : undef,
        );        
        $m->_db->commit;
        
        return $data;
    }
    catch {
        warn "got dbi error: $_";
        $m->_db->rollback;
        
        return undef;
    };
}

sub save {
    my ($m, $statement, $bind_values) = @_;
    
    try {
        my $data = $m->_db->do(
            $statement,
            undef,
            @{$bind_values}
        );

        return $data;
    }
    catch {
        warn "got dbi error: $_";        
        return undef;
    };
}

1;