# NAME

Lazy::Utils - Utilities for lazy

# VERSION

version 1.02

# SYNOPSIS

Utilities for lazy

## Methods

### trim

trims given string

> trim($str)
>
> **$str:** string will be trimed
>
> **return value:** trimed string

### ltrim

trims left given string

> ltrim($str)
>
> **$str:** string will be trimed
>
> **return value:** trimed string

### rtrim

trims right given string

> rtrim($str)
>
> **$str:** string will be trimed
>
> **return value:** trimed string

### file\_get\_contents

get all contents of file, by string type

> file\_get\_contents($path)
>
> **$path:** path of file
>
> **return value:** file contents by string type

### shellmeta

escape metacharacters for double-quoted shell string

> shellmeta($s)
>
> **$s:** double-quoted shell string
>
> **return value:** escaped string

### \_system

executes a system command like Perl system call

> \_system($cmd, @argv)
>
> **$cmd:** command
>
> **@argv:** command line arguments
>
> **return value:** exit code of command. 511 if fatal error occurs
>
> **returned $?:** return code of wait call, like Perl system call
>
> **returned $!:** system error message, like Perl system call

### bashReadLine

reads a line using bash

> bashReadLine($prompt)
>
> **$prompt:** prompt
>
> **return value:** line

### cmdArgs

resolves command line arguments, eg: -opt1 --opt2 val2 command\_string parameter1 parameter2 ...

> cmdArgs(@argv)
>
> **@argv:** command line arguments
>
> **return value:** { -opt1 =&gt; &#39;opt1&#39;, --opt2 =&gt; &#39;val2&#39;, command =&gt; &#39;command\_string&#39;, parameters =&gt; \[&#39;parameter1&#39;, &#39;parameter2&#39;, ...\] }

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
