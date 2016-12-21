package Lazy::Utils;
=head1 NAME

Lazy::Utils - Utilities for lazy

=head1 VERSION

version 1.02

=head1 SYNOPSIS

Utilities for lazy

=cut
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use utf8;
use Config;
use Switch;
use FindBin;
use Cwd;
use File::Basename;


BEGIN
{
	require Exporter;
	# set the version for version checking
	our $VERSION     = '1.02';
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw(trim ltrim rtrim file_get_contents shellmeta _system bashReadLine);
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();
}


=head2 Methods

=cut

=head3 trim

trims given string

=over

trim($str)

B<$str:> string will be trimed

B<return value:> trimed string

=back

=cut
sub trim
{
	my ($s) = @_;
	$s =~ s/^\s+|\s+$//g;
	return $s
}

=head3 ltrim

trims left given string

=over

ltrim($str)

B<$str:> string will be trimed

B<return value:> trimed string

=back

=cut
sub ltrim
{
	my ($s) = @_;
	$s =~ s/^\s+//;
	return $s
}

=head3 rtrim

trims right given string

=over

rtrim($str)

B<$str:> string will be trimed

B<return value:> trimed string

=back

=cut
sub rtrim
{
	my ($s) = @_;
	$s =~ s/\s+$//;
	return $s
}

=head3 file_get_contents

get all contents of file, by string type

=over

file_get_contents($path)

B<$path:> path of file

B<return value:> file contents by string type

=back

=cut
sub file_get_contents
{
	my ($path) = @_;
	my $document = do
	{
		local $/ = undef;
		open my $fh, "<", $path or return;
		my $result = <$fh>;
		close $fh;
		$result;
	};
	return $document;
}

=head3 shellmeta

escape metacharacters for double-quoted shell string

=over

shellmeta($s)

B<$s:> double-quoted shell string

B<return value:> escaped string

=back

=cut
sub shellmeta
{
	my ($s) = @_;
	return unless defined $s;
	$s =~ s/(\\|\"|\$)/\\$1/g;
	return $s;
}

=head3 _system

executes a system command like Perl system call

=over

_system($cmd, @args)

B<$cmd:> command

B<@args:> command line arguments

B<return value:> exit code of command. 511 if fatal error occurs

B<returned $?:> return code of wait call, like Perl system call

B<returned $!:> system error message, like Perl system call

=back

=cut
sub _system
{
	my $pid;
	if (not defined($pid = fork))
	{
		return 511;
	}
	if (not $pid)
	{
		no warnings FATAL => 'exec';
		exec(@_);
		exit 511;
	}
	if (waitpid($pid, 0) <= 0)
	{
		return 511;
	}
	return $? >> 8;
}

=head3 bashReadLine

reads a line using bash

=over

bashReadLine($prompt)

B<$prompt:> prompt

B<return value:> line

=back

=cut
sub bashReadLine
{
	my ($prompt) = @_;
	$prompt = shellmeta(shellmeta($prompt));
	my $cmd = '/bin/bash -c "read -p \"'.$prompt.'\" -r -e && echo -n \"\$REPLY\""';
	$_ = `$cmd`;
	return (not $?)? $_: undef;
}


1;
__END__
=head1 INSTALLATION

To install this module type the following

	perl Makefile.PL
	make
	make test
	make install

from CPAN

	cpan -i Lazy::Utils

=head1 DEPENDENCIES

This module requires these other modules and libraries:

=over

=item *

Switch

=item *

FindBin

=item *

Cwd

=item *

File::Basename

=back

=head1 REPOSITORY

B<GitHub> L<https://github.com/orkunkaraduman/Lazy-Utils>

B<CPAN> L<https://metacpan.org/release/Lazy-Utils>

=head1 AUTHOR

Orkun Karaduman <orkunkaraduman@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016  Orkun Karaduman <orkunkaraduman@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut
