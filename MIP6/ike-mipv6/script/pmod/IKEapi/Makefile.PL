use ExtUtils::MakeMaker;

require 5.002 ;

WriteMakefile(
	NAME      => 'IKEapi',
	VERSION   => '1.00',
	'linkext'   => {LINKTYPE => ''},
	'dist'	  =>	{COMPRESS=>'gzip', SUFFIX=>'gz'},
	) ;

