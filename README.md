# NAME

Lazy::Utils - Utilities for lazy

# VERSION

version 1.05

# SYNOPSIS

Utilities for lazy

## Methods

### trim($str)

trims given string

$str: _string will be trimed_

return value: _trimed string_

### ltrim($str)

trims left given string

$str: _string will be trimed_

return value: _trimed string_

### rtrim($str)

trims right given string

$str: _string will be trimed_

return value: _trimed string_

### file\_get\_contents($path)

gets all contents of file in string type

$path: _path of file_

return value: _file contents in string type, otherwise undef because of errors_

### file\_put\_contents($path, $contents)

puts all contents of file in string type

$path: _path of file_

$contents: _file contents in string type_

return value: _success 1, otherwise undef_

### shellmeta($s)

escapes metacharacters of double-quoted shell string

$s: _double-quoted shell string_

return value: _escaped string_

### \_system($cmd, @argv)

executes a system command like Perl system call

$cmd: _command_

@argv: _command line arguments_

return value: _exit code of command. 511 if fatal error occurs_

returned $?: _return code of wait call like on Perl system call_

returned $!: _system error message like on Perl system call_

### bashReadLine($prompt)

reads a line using bash

$prompt: _prompt_

return value: _line_

### commandArgs($prefs, @argv)

resolves command line arguments, eg: -opt1 -opt2=val2 --opt3 val3 --opt4=val4 cmd param1 param2 ... -- long parameter

$prefs: _preferences in hash type_

> optionAtAll: _accepts options after command or first parameter otherwise evaluates as parameter, by default 0_
>
> noCommand: _use first parameter instead of command, by default 0_

@argv: _command line arguments_

return value: _{ -opt1 =&gt; &#39;&#39;, --opt2 =&gt; &#39;val2&#39;, --opt3 =&gt; &#39;val3&#39;, --opt4 =&gt; &#39;val4&#39;, command =&gt; &#39;cmd&#39;, parameters =&gt; \[&#39;param1&#39;, &#39;param2&#39;, ...\], long =&gt; &#39;long parameter&#39; }_

### cmdArgs(@argv)

resolves command line arguments using commandArgs with default preferences

### whereisBin($name, $path)

searches valid binary in search path

$name: _binary name_

$path: _search path, by default &quot;/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin&quot;_

return value: _binary path founded in search path, otherwise undef_

### fileCache($tag, $expiry, $subref)

gets most recent cached value in file cache by given tag and caller function if there is cached value in expiry period. Otherwise tries to get current value using $subref, puts value in cache and cleanups old cache values.

$tag: _tag for cache_

$expiry: _cache expiry period_

> &lt;0: _always gets most recent cached value if there is any cached value. Otherwise tries to get current value using $subref, puts and cleanups._
>
> &#x3d;0: _never gets cached value. Always tries to get current value using $subref, puts and cleanups._
>
> &gt;0: _gets most recent cached value in cache if there is cached value in expiry period. Otherwise tries to get current value using $subref, puts and cleanups._

$subref: _sub reference to get current value_

return value: _cached or current value, otherwise undef if there isn&#39;t cached value and current value doesn&#39;t get_

# INSTALLATION

To install this module type the following

        perl Makefile.PL
        make
        make test
        make install

from CPAN

        cpan -i Lazy::Utils

# DEPENDENCIES

This module requires these other modules and libraries:

- Switch
- FindBin
- Cwd
- File::Basename
- JSON

# REPOSITORY

**GitHub** [https://github.com/orkunkaraduman/Lazy-Utils](https://github.com/orkunkaraduman/Lazy-Utils)

**CPAN** [https://metacpan.org/release/Lazy-Utils](https://metacpan.org/release/Lazy-Utils)

# AUTHOR

Orkun Karaduman &lt;orkunkaraduman@gmail.com&gt;

# COPYRIGHT AND LICENSE

Copyright (C) 2017  Orkun Karaduman &lt;orkunkaraduman@gmail.com&gt;

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see &lt;http://www.gnu.org/licenses/&gt;.
