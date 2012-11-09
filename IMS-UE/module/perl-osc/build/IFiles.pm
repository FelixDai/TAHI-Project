package osc::Install::Files;

$self = {
          'inc' => '-I. -I./build -I/usr/local/include/osc -DUSE_POSIX_LOCKING -DHAVE_REALLOC -DUSE_OPENSSL_SHA1 -Wall -fno-rtti -w',
          'typemaps' => [
                          'perlobject.map',
                          'osc.map'
                        ],
          'deps' => [],
          'libs' => '-L/usr/local/lib -L/lib -lpthread -lopensigcomp -lcrypto'
        };


# this is for backwards compatiblity
@deps = @{ $self->{deps} };
@typemaps = @{ $self->{typemaps} };
$libs = $self->{libs};
$inc = $self->{inc};

	$CORE = undef;
	foreach (@INC) {
		if ( -f $_ . "/osc/Install/Files.pm") {
			$CORE = $_ . "/osc/Install/";
			last;
		}
	}

1;
