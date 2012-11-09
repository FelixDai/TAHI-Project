use Cwd;
use ExtUtils::MakeMaker;
use File::Spec::Functions qw/catfile/;
use ExtUtils::Depends;
use Data::Dumper;

mkdir 'build', 0777;

$CC = 'g++';

# XSファイル一覧の取得
our @xs_files = <*.xs>;

our $osc = ExtUtils::Depends->new('osc');

# 警告をエラーに扱う(-Werror)とコンパイルできない
$osc->set_inc('-I. -I./build -I/usr/local/include/osc -DUSE_POSIX_LOCKING -DHAVE_REALLOC -DUSE_OPENSSL_SHA1 -Wall -fno-rtti -w');
$osc->set_libs('-L/usr/local/lib -L/lib -lpthread -lopensigcomp -lcrypto');
$osc->add_xs(@xs_files);
$osc->add_pm('lib/osc.pm', '$(INST_LIBDIR)/osc.pm');

my $cwd = cwd();
$osc->add_typemaps(catfile($cwd, 'perlobject.map'),catfile($cwd, 'osc.map'));
$osc->install(catfile('build', 'osc-autogen.h'));

# IFiles.pmの生成
$osc->save_config(catfile('build', 'IFiles.pm'));

## my %x=$osc->get_makefile_vars();
## print Dumper \%x;

WriteMakefile(
    NAME              => 'osc',
    VERSION_FROM      => 'lib/osc.pm',
    ABSTRACT_FROM     => 'lib/osc.pm',
    AUTHOR            => 'cerezaware <hok@ntt-at.co.jp>',
    XSPROTOARG        => '-noprototypes',
    PREREQ_PM         => {},
    CC                => $CC,
    LD                => '$(CC)',
    $osc->get_makefile_vars,
);
