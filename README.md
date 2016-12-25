# NAME

Lazy::Utils - Utilities for lazy

# VERSION

version 1.04

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

return value: _file contents in string type_

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

### cmdArgs(@argv)

resolves command line arguments, eg: -opt1 --opt2 val2 command\_string parameter1 parameter2 ...

@argv: _command line arguments_

return value: _{ -opt1 =&gt; &#39;opt1&#39;, --opt2 =&gt; &#39;val2&#39;, command =&gt; &#39;command\_string&#39;, parameters =&gt; \[&#39;parameter1&#39;, &#39;parameter2&#39;, ...\] }_

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

# REPOSITORY

**GitHub** [https://github.com/orkunkaraduman/Lazy-Utils](https://github.com/orkunkaraduman/Lazy-Utils)

**CPAN** [https://metacpan.org/release/Lazy-Utils](https://metacpan.org/release/Lazy-Utils)

# AUTHOR

Orkun Karaduman &lt;orkunkaraduman@gmail.com&gt;

# COPYRIGHT AND LICENSE

Copyright (C) 2016  Orkun Karaduman &lt;orkunkaraduman@gmail.com&gt;

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
