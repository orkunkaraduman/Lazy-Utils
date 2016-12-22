package Lazy::Utils;
=head1 NAME

Lazy::Utils - Utilities for lazy

=head1 VERSION

version 1.03

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
	our $VERSION     = '1.03';
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw(trim ltrim rtrim file_get_contents shellmeta _system bashReadLine cmdArgs);
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw();
}


=head2 Methods

=cut

=head3 trim($str)

trims given string

$str: I<string will be trimed>

return value: I<trimed string>

=cut
sub trim
{
	my ($s) = @_;
	$s =~ s/^\s+|\s+$//g;
	return $s
}

=head3 ltrim($str)

trims left given string

$str: I<string will be trimed>

return value: I<trimed string>

=cut
sub ltrim
{
	my ($s) = @_;
	$s =~ s/^\s+//;
	return $s
}

=head3 rtrim($str)

trims right given string

$str: I<string will be trimed>

return value: I<trimed string>

=cut
sub rtrim
{
	my ($s) = @_;
	$s =~ s/\s+$//;
	return $s
}

=head3 file_get_contents($path)

gets all contents of file in string type

$path: I<path of file>

return value: I<file contents in string type>

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

=head3 shellmeta($s)

escapes metacharacters of double-quoted shell string

$s: I<double-quoted shell string>

return value: I<escaped string>

=cut
sub shellmeta
{
	my ($s) = @_;
	return unless defined $s;
	$s =~ s/(\\|\"|\$)/\\$1/g;
	return $s;
}

=head3 _system($cmd, @argv)

executes a system command like Perl system call

$cmd: I<command>

@argv: I<command line arguments>

return value: I<exit code of command. 511 if fatal error occurs>

returned $?: I<return code of wait call like on Perl system call>

returned $!: I<system error message like on Perl system call>

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

=head3 bashReadLine($prompt)

reads a line using bash

$prompt: I<prompt>

return value: I<line>

=cut
sub bashReadLine
{
	my ($prompt) = @_;
	unless ( -t *STDIN ) {
		my $line = <STDIN>;
		chomp $line if defined $line;
		return $line;
	}
	$prompt = shellmeta(shellmeta($prompt));
	my $cmd = '/bin/bash -c "read -p \"'.$prompt.'\" -r -e && echo -n \"\$REPLY\""';
	$_ = `$cmd`;
	return (not $?)? $_: undef;
}

=head3 cmdArgs(@argv)

resolves command line arguments, eg: -opt1 --opt2 val2 command_string parameter1 parameter2 ...

@argv: I<command line arguments>

return value: I<{ -opt1 =\> 'opt1', --opt2 =\> 'val2', command => 'command_string', parameters =\> ['parameter1', 'parameter2', ...] }>

=cut
sub cmdArgs
{
	my @argv = @_;
	my %result;
	$result{command} = undef;
	$result{parameters} = [];
	while (@argv)
	{
		my $argv = shift @argv;

		if (@{$result{parameters}})
		{
			push @{$result{parameters}}, $argv;
			next;
		}

		if (substr($argv, 0, 2) eq '--')
		{
			$result{$argv} = shift @argv;
			next;
		}

		if (substr($argv, 0, 1) eq '-')
		{
			$result{$argv} = substr($argv, 1);
			next;
		}

		if (defined $result{command})
		{
			push @{$result{parameters}}, $argv;
			next;
		}

		$result{command} = $argv;
	}
	return \%result;
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
