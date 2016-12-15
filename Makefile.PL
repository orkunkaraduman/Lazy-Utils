use strict;
use warnings;
use ExtUtils::MakeMaker;


WriteMakefile(
	NAME				=> 'OK::Utils',
	VERSION_FROM		=> 'lib/OK/Utils.pm',
	MIN_PERL_VERSION	=> '5.014',
	PREREQ_PM			=> { 'Switch' => 0, 'FindBin' => 0, 'Cwd' => 0, 'File::Basename' => 0, },
	EXE_FILES			=> [ qw(
							)
	],
	AUTHOR				=> 'Orkun Karaduman <orkunkaraduman@gmail.com>',
	ABSTRACT			=> "Orkun Karaduman's utilities",
	LICENSE				=> 'gpl_3',
	META_MERGE			=> {
		"meta-spec" => { version => 2 },
		resources => {
			homepage   => 'https://metacpan.org/release/OK-Utils',
			license    => 'https://www.gnu.org/licenses/gpl-3.0.html',
			repository => {
				type => 'git',
				url => 'git://git@github.com:orkunkaraduman/OK-Utils.git',
				web => 'https://github.com/orkunkaraduman/OK-Utils',
			},
			bugtracker => {
				web    => 'https://github.com/orkunkaraduman/OK-Utils/issues',
				mailto => 'bug-OK-Utils@rt.cpan.org',
			},
		},
	},
);
