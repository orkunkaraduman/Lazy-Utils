package MyPerl::Utils;

use strict;
use warnings;
no warnings qw(qw);
use v5.10;
use Exporter qw(import);


sub ltrim
{
	my $s = shift;
	$s =~ s/^\s+//;
	return $s
}

sub rtrim
{
	my $s = shift;
	$s =~ s/\s+$//;
	return $s
}

sub trim
{
	my $s = shift;
	$s =~ s/^\s+|\s+$//g;
	return $s
}

sub file_get_contents
{
	my $file = $_[0];
	my $document = do
	{
		local $/ = undef;
		open my $fh, "<", $file or die "could not open $file: $!";
		my $result = <$fh>;
		close $fh;
		$result;
	};
	return $document;
}


our @EXPORT_OK = qw(ltrim rtrim trim file_get_contents);
our @EXPORT = @EXPORT_OK;

return 1;
