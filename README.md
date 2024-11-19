NAME
====

Date::Calendar::Julian - Conversions from / to the Julian calendar

SYNOPSIS
========

What is  the peculiarity of  15 February  for people using  the Julian
calendar? And can you please print it in, say, Dutch?

```perl6
use Date::Calendar::Julian;

my Date $feb15-grg;
my Date::Calendar::Julian $palindrome-jul;

$feb15-grg      .= new(2020, 2, 15);
$palindrome-jul .= new-from-date($feb15-grg);

say $palindrome-jul;
# --> 2020-02-02
$palindrome-jul.locale = 'nl';
say $palindrome-jul.strftime("%A %e %B %Y");
# --> zaterdag  2 februari 2020

my Str $s1 = $palindrome-jul.strftime("%Y%m%d");
if $s1 eq $s1.flip {
  say "$s1 is a palindrome in YYYYMMDD format!";
}
$s1 = $palindrome-jul.strftime("%d%m%Y");
if $s1 eq $s1.flip {
  say "$s1 is a palindrome in DDMMYYYY format!";
}
$s1 = $palindrome-jul.strftime("%m%d%Y");
if $s1 eq $s1.flip {
  say "$s1 is a palindrome in MMDDYYYY format!";
}
```

The Perl  & Raku Conference  was scheduled to  end on 1st  August when
using the Julian calendar. What is the corresponding Gregorian date?

```perl6
use Date::Calendar::Julian;
my Date::Calendar::Julian $TPRC-Amsterdam-jul;
my Date                   $TPRC-Amsterdam-grg;

$TPRC-Amsterdam-jul .= new(year  => 2020
                         , month =>    8
                         , day   =>    1);
$TPRC-Amsterdam-grg = $TPRC-Amsterdam-jul.to-date;

say $TPRC-Amsterdam-grg;
# --> 2020-08-14

```

INSTALLATION
============

```shell
zef install Date::Calendar::Julian
```

or

```shell
git clone https://github.com/jforget/raku-Date-Calendar-Julian.git
cd raku-Date-Calendar-Julian
zef install .
```

DESCRIPTION
===========

Date::Calendar::Julian  is a  class representing  dates in  the Julian
calendar. It allows  you to convert an Julian date  into Gregorian (or
possibly other) calendar and the other way.

With class Date::Calendar::Julian::AUC, you  can count the years since
the founding of Rome.

AUTHOR
======

Jean Forget <J2N-FORGET at orange dot fr>

COPYRIGHT AND LICENSE
=====================

Copyright (c) 2020, 2021, 2024 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

