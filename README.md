NAME
====

Date::Calendar::Julian - Conversions from / to the Julian calendar

SYNOPSIS
========

When does the  Perl & Raku Conference in Amsterdam  begin? Please give
your answer in Dutch and in the Julian calendar.

```perl6
use Date::Calendar::Julian;
my Date                   $TPRC-Amsterdam-grg;
my Date::Calendar::Julian $TPRC-Amsterdam-jul;

$TPRC-Amsterdam-grg .= new(2020, 8, 10);
$TPRC-Amsterdam-jul .= new-from-date($TPRC-Amsterdam-grg);

say $TPRC-Amsterdam-jul;
# --> 2020-07-28
$TPRC-Amsterdam-jul.locale = 'nl';
say $TPRC-Amsterdam-jul.strftime("%A %d %B %Y");
# --> maandag 28 juli 2020
```

The Perl  & Raku Conference ends  on 1st August when  using the Julian
calendar. What is the corresponding Gregorian date?

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

AUTHOR
======

Jean Forget <JFORGET@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright © 2020 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

