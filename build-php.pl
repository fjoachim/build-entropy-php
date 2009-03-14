# Main driver script for the PHP build process
#
# Invoke with
#     sudo perl -Ilib build-php.pl
#

use strict;
use warnings;
use Data::Dumper;
use Imports;
use Package::php5;

my $basedir = qx(pwd);
chomp $basedir;
die "you must run this script in the build-entropy-php directory" unless ($basedir =~ m#/build-entropy-php$#);

check_dotpear();
check_arch();



my $config = Config->new(
	cpus                 => 2,
	basedir              => $basedir,
	prefix               => '/usr/local/php5',
	orahome              => "$basedir/install",
	pdflib_lite          => 1,
	mysql_install_prefix => undef,
	variants             => {
		apache1          => {
			apxs_option  => '--with-apxs',
			suffix       => '',
		},
		apache2          => {
			apxs_option  => '--with-apxs2=/usr/sbin/apxs',
			suffix       => '-apache2',
		},
	},
	version              => '5.2.9',
	release              => 3,
	debug                => 1,
);

# my $php5 = Package::php5->new(config => $config, variant => 'apache2');
# $php5->create_distimage();

#use Package::pdflib_commercial;
#my $pdflib = Package::pdflib_commercial->new(config => $config, variant => 'apache2');
#$pdflib->prepackage_hook($config->prefix());

my $php = Package::php5->new(config => $config, variant => 'apache2');
# $php->create_distimage();
$php->install();



# use Package::pdflib;
# my $p = Package::pdflib->new(config => $config, variant => 'apache2');
# $p->install();


# use Package::pdflib_commercial;
# my $p = Package::pdflib_commercial->new(config => $config, variant => 'apache2');
# $p->download();


# use Package::mssql;
# my $p = Package::mssql->new(config => $config, variant => 'apache2');
# $p->install();


# use Package::ming;
# my $p = Package::ming->new(config => $config, variant => 'apache2');
# $p->install();


# use Package::postgresql;
# my $p = Package::postgresql->new(config => $config, variant => 'apache2');
# $p->install();


# use Package::imapcclient;
# my $p = Package::imapcclient->new(config => $config, variant => 'apache2');
# $p->install();


# use Package::mysql;
# my $p = Package::mysql->new(config => $config, variant => 'apache2');
# $p->install();


# If there is a ~/.pear directory, "make install-pear" will not work properly
sub check_dotpear {
	if (-e "$ENV{HOME}/.pear") {
		die "There is a ~/.pear directory, you need to move it aside temporarily for the build\n";
	}
}

# if we don't build on x86_64, the resulting mcrypt extension will work on i386 but will crash on x86_64
sub check_arch {
	my $x86_64 = `sysctl -n hw.optional.x86_64`; chomp $x86_64;
	unless ($x86_64) {
		die "This build process must be run on an x86_64 architecture system\n";
	}
}

