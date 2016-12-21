package Lazy::Utils;
=head1 NAME

Lazy::Utils - Utilities for lazy

=head1 VERSION

version 1.01

=head1 SYNOPSIS

Utilities for lazy

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

=cut
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.14;
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
	our $VERSION     = '1.01';
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw();
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw(str_trim str_ltrim str_rtrim file_get_contents);
}


sub str_trim
{
	my $s = shift;
	$s =~ s/^\s+|\s+$//g;
	return $s
}

sub str_ltrim
{
	my $s = shift;
	$s =~ s/^\s+//;
	return $s
}

sub str_rtrim
{
	my $s = shift;
	$s =~ s/\s+$//;
	return $s
}

sub file_get_contents
{
	my $file = $_[0];
	my $document = do
	{
		local $/ = undef;
		open my $fh, "<", $file or return;
		my $result = <$fh>;
		close $fh;
		$result;
	};
	return $document;
}


1;
__END__
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
