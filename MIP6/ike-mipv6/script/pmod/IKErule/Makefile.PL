use ExtUtils::MakeMaker;

require 5.002 ;

WriteMakefile(
	NAME      => 'IKErule',
	VERSION   => '1.00',
	'linkext'   => {LINKTYPE => ''},
	'dist'	  =>	{COMPRESS=>'gzip', SUFFIX=>'gz'},
	) ;

