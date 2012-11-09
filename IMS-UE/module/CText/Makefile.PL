use 5.008008;
use ExtUtils::MakeMaker;


WriteMakefile(
    NAME              => 'CText',
    VERSION_FROM      => 'lib/CText.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/CText.pm', # retrieve abstract from module
       AUTHOR         => 'NTT-AT') : ()),
    LIBS              => ['-lufs -lssl'], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    # NOECHO            => '',
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
