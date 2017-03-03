package Lazy::Utils;
=head1 NAME

Lazy::Utils - Utility functions

=head1 VERSION

version 1.10

=head1 ABSTRACT

Utility functions

	use Lazy::Utils;
	 
	trim($str);
	ltrim($str);
	rtrim($str);
	file_get_contents($path, $prefs);
	file_put_contents($path, $contents, $prefs);
	shellmeta($s, $whitespace);
	_system($cmd, @argv);
	bashReadLine($prompt);
	commandArgs($prefs, @argv);
	cmdArgs(@argv);
	whereisBin($name, $path);
	fileCache($tag, $expiry, $subref);
	getPodText($fileName, $section, $exclude_section);

=cut
use strict;
use warnings;
use v5.14;
use FindBin;
use JSON;
use Pod::Simple::Text;


BEGIN
{
	require Exporter;
	our $VERSION     = '1.10';
	our @ISA         = qw(Exporter);
	our @EXPORT      = qw(trim ltrim rtrim file_get_contents file_put_contents shellmeta _system bashReadLine commandArgs cmdArgs whereisBin fileCache getPodText);
	our @EXPORT_OK   = qw();
}


=head1 DESCRIPTION

Collection of utility functions all of exported by default

=head2 Functions

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

=head3 file_get_contents($path, $prefs)

gets all contents of file in string type

$path: I<path of file>

$prefs: I<preferences in hash type, by default undef>

=over

utf8: I<opens file-handle as :utf8 mode, by default 0>

=back

return value: I<file contents in string type, otherwise undef because of errors>

=cut
sub file_get_contents
{
	my ($path, $prefs) = @_;
	$prefs = {} unless ref($prefs) eq 'HASH';
	my $result = do
	{
		local $/ = undef;
		my $mode = "";
		$mode .= " :utf8" if $prefs->{utf8};
		open my $fh, "<$mode", $path or return;
		my $result = <$fh>;
		close $fh;
		$result;
	};
	return $result;
}

=head3 file_put_contents($path, $contents, $prefs)

puts all contents of file in string type

$path: I<path of file>

$contents: I<file contents in string type>

$prefs: I<preferences in hash type, by default undef>

=over

utf8: I<opens file-handle as :utf8 mode, by default 0>

=back

return value: I<success 1, otherwise undef>

=cut
sub file_put_contents
{
	my ($path, $contents, $prefs) = @_;
	$prefs = {} unless ref($prefs) eq 'HASH';
	my $result = do
	{
		local $\ = undef;
		my $mode = "";
		$mode .= " :utf8" if $prefs->{utf8};
		open my $fh, ">$mode", $path or return;
		my $result = print $fh $contents;
		close $fh;
		$result;
	};
	return $result;
}

=head3 shellmeta($s, $whitespace)

escapes metacharacters of double-quoted shell string

$s: I<double-quoted shell string>

$whitespace: I<escape whitespace characters, by default 0>

return value: I<escaped string>

=cut
sub shellmeta
{
	my ($s, $whitespace) = @_;
	return unless defined $s;
	$s =~ s/(\\|\"|\$)/\\$1/g;
	$s =~ s/(\s)/\\$1/g if $whitespace;
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

$prompt: I<prompt, by default ''>

return value: I<line>

=cut
sub bashReadLine
{
	my ($prompt) = @_;
	unless ( -t *STDIN )
	{
		my $line = <STDIN>;
		chomp $line if defined $line;
		return $line;
	}
	$prompt = "" unless defined($prompt);
	$prompt = shellmeta(shellmeta($prompt));
	my $cmd = '/bin/bash -c "read -p \"'.$prompt.'\" -r -e && echo -n \"\$REPLY\" 2>/dev/null"';
	$_ = `$cmd`;
	return (not $?)? $_: undef;
}

=head3 commandArgs($prefs, @argv)

resolves command line arguments.

valuableArgs is off, eg;

	--opt1 --opt2=val2 cmd param1 param2 param3
	-opt1 -opt2=val2 cmd param1 param2 param3
	-opt1 -opt2=val2 cmd param1 -- param2 param3
	-opt1 cmd param1 -opt2=val2 param2 param3
	-opt1 cmd param1 -opt2=val2 -- param2 param3
	cmd -opt1 param1 -opt2=val2 param2 param3
	cmd -opt1 param1 -opt2=val2 -- param2 param3

valuableArgs is on, eg;

	-opt1 -opt2=val2 cmd param1 param2 param3
	-opt1 -opt2 val2 cmd param1 param2 param3
	-opt1 -opt2 -- cmd param1 param2 param3
	cmd -opt1 -opt2 val2 param1 param2 param3
	cmd -opt1 -opt2 -- param1 param2 param3
	cmd param1 -opt1 -opt2 val2 param2 param3
	cmd param1 -opt1 -opt2 -- param2 param3

$prefs: I<preferences in hash type>

=over

valuableArgs: I<accepts option value after option if next argument is not an option, by default 0>

noCommand: I<use first parameter instead of command, by default 0>

optionAtAll: I<DEPRECATED: now, it is always on. accepts options after command or first parameter otherwise evaluates as parameter, by default 0>

=back

@argv: I<command line arguments>

return value: eg;

	{ --opt1 => '', --opt2 => 'val2', command => 'cmd', parameters => ['param1', 'param2', 'param3'] }
	{ -opt1 => '', -opt2 => 'val2', command => 'cmd', parameters => ['param1', 'param2', 'param3'] }
	{ -opt1 => '', -opt2 => '', command => 'cmd', parameters => ['param1', 'param2', 'param3'] }

=head3 cmdArgs(@argv)

resolves command line arguments using commandArgs with default preferences

=cut
sub commandArgs
{
	my ($prefs, @argv) = @_;
	$prefs = {} unless ref($prefs) eq 'HASH';
	my %result;
	$result{command} = undef;
	$result{parameters} = undef;

	my @parameters;
	my $opt;
	my $long;
	while (@argv)
	{
		my $argv = shift @argv;

		if ($long)
		{
			push @parameters, $argv;
			next;
		}

		if (substr($argv, 0, 2) eq '--')
		{
			if (length($argv) == 2)
			{
				$opt = undef;
				$long = 1;
				next;
			}
			my @arg = split('=', $argv, 2);
			$result{$arg[0]} = $arg[1];
			$opt = undef;
			unless (defined($result{$arg[0]}))
			{
				$result{$arg[0]} = "";
				$opt = $arg[0];
			}
			next;
		}

		if (substr($argv, 0, 1) eq '-' and length($argv) != 1)
		{
			my @arg = split('=', $argv, 2);
			$result{$arg[0]} = $arg[1];
			$opt = undef;
			unless (defined($result{$arg[0]}))
			{
				$result{$arg[0]} = "";
				$opt = $arg[0];
			}
			next;
		}

		if ($prefs->{valuableArgs} and $opt)
		{
			$result{$opt} = $argv;
			$opt = undef;
			next;
		}
		$opt = undef;

		push @parameters, $argv;
	}

	$result{command} = shift @parameters if not $prefs->{noCommand};
	$result{parameters} = \@parameters;

	return \%result;
}

sub cmdArgs
{
	my @argv = @_;
	return commandArgs(undef, @argv);
}

=head3 whereisBin($name, $path)

searches valid binary in search path

$name: I<binary name>

$path: I<search path, by default "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin">

return value: I<array of binary path founded in search path>

=cut
sub whereisBin
{
	my ($name, $path) = @_;
	return () unless $name;
	$path = "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" unless $path;
	return grep(-x $_, map("$_/$name", split(":", $path)));
}

=head3 fileCache($tag, $expiry, $subref)

gets most recent cached value in file cache by given tag and caller function if there is cached value in expiry period. Otherwise tries to get current value using $subref, puts value in cache and cleanups old cache values.

$tag: I<tag for cache>

$expiry: I<cache expiry period>

=over

E<lt>0: I<always gets most recent cached value if there is any cached value. Otherwise tries to get current value using $subref, puts and cleanups.>

=0: I<never gets cached value. Always tries to get current value using $subref, puts and cleanups.>

E<gt>0: I<gets most recent cached value in cache if there is cached value in expiry period. Otherwise tries to get current value using $subref, puts and cleanups.>

=back

$subref: I<sub reference to get current value>

return value: I<cached or current value, otherwise undef if there isn't cached value and current value doesn't get>

=cut
sub fileCache
{
	my ($tag, $expiry, $subref) = @_;
	my $result;
	my $now = time();
	my @cleanup;
	my $caller = (caller(1))[3];
	$caller = (caller(1))[0] unless $caller;
	$caller = "main"  unless $caller;
	$caller = (caller(0))[3].",$caller";
	my $tmpBase = "/tmp/";
	my $tmpPrefix = $caller =~ s/\Q::\E/-/gr.".".$tag =~ s/(\W)/uc(sprintf("%%%x", ord($1)))/ger.",";
	for my $tmpPath (sort {$b cmp $a} glob("${tmpBase}$tmpPrefix*"))
	{
		if (my ($epoch, $pid) = $tmpPath =~ /^\Q${tmpBase}$tmpPrefix\E(\d*)\.(\d*)/)
		{
			if ($expiry < 0 or ($expiry > 0 and $now-$epoch < $expiry))
			{
				if (not defined($result))
				{
					my $tmp;
					$tmp = file_get_contents($tmpPath);
					if ($tmp)
					{
						if ($tmp =~ /^SCALAR\n(.*)/)
						{
							$result = $1;
						} else
						{
							eval { $result = from_json($tmp, {utf8 => 1}) };
						}
					}
				}
				next;
			}
		}
		unshift @cleanup, $tmpPath;
	}
	if (not defined($result))
	{
		$result = $subref->() if defined($subref);
		if (defined($result))
		{
			my $tmp;
			unless (ref($result))
			{
				$tmp = "SCALAR\n$result";
			} else
			{
				eval { $tmp = to_json($result, {utf8 => 1, pretty => 1}) } if ref($result) eq "ARRAY" or ref($result) eq "HASH";
			}
			if ($tmp and file_put_contents("${tmpBase}tmp.$tmpPrefix$now.$$", $tmp) and rename("${tmpBase}tmp.$tmpPrefix$now.$$", "${tmpBase}$tmpPrefix$now.$$"))
			{
				pop @cleanup;
				for (@cleanup)
				{
					unlink($_);
				}
			}
		}
	}
	return $result;
}

=head3 getPodText($fileName, $section, $exclude_section)

gets a text of pod contents in given file

$fileName: I<file name of searching pod, by default running file>

$section: I<searching head1 section of pod, by default undef gets all of contents>

$exclude_section: I<excludes section name, by default undef>

return value: I<text of pod in string or array by line, otherwise undef if an error occurs>

=cut
sub getPodText
{
	my ($fileName, $section, $exclude_section) = @_;
	$fileName = "$FindBin::Bin/$FindBin::Script" unless $fileName;
	return unless -e $fileName;
	my $parser = Pod::Simple::Text->new();
	my $text;
	$parser->output_string(\$text);
	eval { $parser->parse_file($fileName) };
	return if $@;
	utf8::decode($text);
	$section = ltrim($section) if $section;
	my @text = split(/^/m, $text);
	my $result;
	my @result;
	for my $line (@text)
	{
		chomp $line;
		if (defined($section) and not defined($result))
		{
			if ($line eq $section)
			{
				unless ($exclude_section)
				{
					$result = "$line\n";
					push @result, $line;
				} else
				{
					$result = "";
				}
			}
			next;
		}
		last if defined($section) and $line =~ /^\S+/;
		$result = "" unless defined($result);
		$result .= "$line\n";
		push @result, $line;
	}
	return @result if wantarray;
	return $result;
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

JSON

=item *

Pod::Simple::Text

=back

=head1 REPOSITORY

B<GitHub> L<https://github.com/orkunkaraduman/Lazy-Utils>

B<CPAN> L<https://metacpan.org/release/Lazy-Utils>

=head1 AUTHOR

Orkun Karaduman <orkunkaraduman@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017  Orkun Karaduman <orkunkaraduman@gmail.com>

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
