#! /usr/bin/perl
=head1 NAME

readme-gen.pl - README and MANIFEST generator

=head1 VERSION

version not defined

=head1 SYNOPSIS

README and MANIFEST generator

=cut
use strict;
use warnings;
no warnings qw(qw utf8);
use v5.10;
use utf8;
use open qw(:std :locale);
use Config;
use FindBin;
use Cwd;


my $base = "${FindBin::Bin}/..";
cwd($base);


system('pod2markdown --html-encode-chars 1 lib/Lazy/Utils.pm > README.md');
system('pod2text lib/Lazy/Utils.pm > README');
system('git ls-files | grep -v "^\.gitignore" > MANIFEST');


exit 0;
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
