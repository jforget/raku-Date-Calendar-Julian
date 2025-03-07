use v6.d;
use Date::Names;
use Date::Calendar::Strftime;
use Date::Calendar::Julian::Common;
use List::MoreUtils <last_index>;

unit class Date::Calendar::Julian:ver<0.1.1>:auth<zef:jforget>:api<1>
      does Date::Calendar::Julian::Common
      does Date::Calendar::Strftime;

method year-shift {
  0;
}

method gist {
  sprintf("%04d-%02d-%02d", $.year, $.month, $.day);
}


=begin pod

=head1 NAME

Date::Calendar::Julian - Converting from / to the Julian calendar

=head1 SYNOPSIS

Converting a Gregorian date (e.g. 15 February 2020) into Julian

=begin code :lang<raku>

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

=end code

Converting a Julian date (e.g. 1st August 2020) into Gregorian

=begin code :lang<raku>
use Date::Calendar::Julian;
my Date::Calendar::Julian $TPRC-Amsterdam-jul;
my Date                   $TPRC-Amsterdam-grg;

$TPRC-Amsterdam-jul .= new(year  => 2020
                         , month =>    8
                         , day   =>    1);
$TPRC-Amsterdam-grg = $TPRC-Amsterdam-jul.to-date;

say "The Perl and Raku conference was scheduled to end on ", $TPRC-Amsterdam-grg;
# --> The Perl and Raku conference was scheduled to end on 2020-08-14

=end code

Conversion with a calendar which defines days as sunset to sunset

=begin code :lang<raku>

use Date::Calendar::Strftime;
use Date::Calendar::Hebrew;
use Date::Calendar::Julian;
my  Date::Calendar::Julian $d-ju;
my  Date::Calendar::Hebrew $d-he;

$d-ju .= new(year => 2024, month => 10, day => 31, daypart => before-sunrise());
$d-he .= new-from-date($d-ju);
say $d-he.strftime("%A %d %B %Y");
# ---> "Yom Reviʻi 12 Heshvan 5785"

$d-ju .= new(year => 2024, month => 10, day => 31, daypart => daylight());
$d-he .= new-from-date($d-ju);
say $d-he.strftime("%A %d %B %Y");
# ---> "Yom Reviʻi 12 Heshvan 5785" again

$d-ju .= new(year => 2024, month => 10, day => 31, daypart => after-sunset());
$d-he .= new-from-date($d-ju);
say $d-he.strftime("%A %d %B %Y");
# ---> "Yom Chamishi 13 Heshvan 5785" instead of "Yom Reviʻi 12 Heshvan 5785"

=end code

=head1 DESCRIPTION

Date::Calendar::Julian is  a class  representing the  Julian calendar,
the forerunner  of the  Gregorian calendar. The  module allows  you to
convert Julian dates  into other calendars and to  convert other dates
into the Julian calendar.

The Julian  differ from the Gregorian  calendar only on the  leap year
rule. For  the Julian calendar,  every multiple of  4 is a  leap year.
There is no adjustment on a century year.

This  module  adopts a  simplified  point  of  view about  the  Julian
calendar. Except for  the leap year rule, everything in  the module is
similar  to the  Gregorian calendar.  Days are  midnight to  midnight,
weeks are  Monday to Sunday, years  are 1st January to  31st December.
Historically, the rules were not as rigid as that, especially the rule
defining the beginning of the year.

Another simplification is that there is a year zero. Generally, people
consider that the day  before 1st January 1 AD is  31st December 1 BC.
But another point of view is  possible, by deciding that the numbering
of the  years follows the  rule of integers  and that the  number just
before 1 is 0, not -1 (or 1  BC). This is the point of view adopted by
this module. And also by the core module C<Date> (which implements the
Gregorian calendar).

=head2 Constructors

=head3 new

Create a  Julian date by  giving the year,  month and day  numbers and
optionally the locale and the daypart.

=head3 new-from-date

Build a  Julian date  by cloning  an object  from another  class. This
other   class    can   be    the   core    class   C<Date>    or   any
C<Date::Calendar::>R<xxx>   class  with   a  C<daycount>   method  and
hopefully a C<daypart> method.

This method does not allow a  C<locale> build parameter. The object is
built with the default locale, C<'en'>.

=head3 new-from-daycount

Build a Julian  date from the Modified Julian Day  number and from the
C<daypart> parameter (optional).

This method does not allow a  C<locale> build parameter. The object is
built with the default locale, C<'en'>.

=head2 Accessors

=head3 gist

Gives a short string representing the date, in C<YYYY-MM-DD> format.

=head3 year, month, day

The numbers defining the date.

=head3 daycount

The MJD (Modified Julian Date) number for the date.

=head3 daypart

A  number indicating  which part  of the  day. This  number should  be
filled   and   compared   with   the   following   subroutines,   with
self-documenting names:

=item before-sunrise()
=item daylight()
=item after-sunset()

=head3 locale

The two-char  string defining the  locale used  for the date.  Use any
value allowed by the module C<Date::Names>.

This attribute can be updated after build time.

=head3 month-name

The month of the date, as a string. This depends on the date's current
locale.

=head3 month-abbr

The abbreviated month of the date.

Depending on  the locale,  it may be  a 3-char string,  a 2-char  or a
short code  of variable length.  Please refer to the  documentation of
C<Date::Names> for the availability of C<mon3>, C<mon2> and C<mona>.

=head3 day-name

The name of the day within the  week. It depends on the date's current
locale.

=head3 day-abbr

The abbreviated day name of the date.

Depending on the locale, it may be a 3-char string, a 2-char string or
a short code of variable length.  Please refer to the documentation of
C<Date::Names> for the availability of C<dow3>, C<dow2> and C<dowa>.

=head3 day-of-week

The day of the week, as a number (1 for Monday, 7 for Sunday).

=head3 week-number

The number of the week within the year, 1 to 52 or 1 to 53. Similar to
the "ISO  date" as defined  for Gregorian date.  Week number 1  is the
Mon→Sun span that contains the first Thursday of the year, week number
2 is  the Mon→Sun span that  contains the second Thursday  of the year
and so on.

=head3 week-year

Mostly similar  to the C<year>  attribute. Yet,  the last days  of the
year  and  the  first  days  of the  following  year  can  be  sort-of
transferred  to the  other year.  The C<week-year>  attribute reflects
this transfer.  While the real year  always begins on 1st  January and
ends on  the 31st December,  the C<week-year> always begins  on Monday
and it always ends on Sunday.

=head3 day-of-year

How many  days since  the beginning of  the year. 1  to 365  on normal
years, 1 to 366 on leap years.

=head3 daycount

The Modified Julian Day Number (a day-only scheme based on 17 November
1858).

=head2 Other Methods

=head3 to-date

Clones  the   date  into   a  core  class   C<Date>  object   or  some
C<Date::Calendar::>R<xxx> compatible calendar  class. The target class
name is given  as a positional parameter. This  parameter is optional,
the default value is C<"Date"> for the Gregorian calendar.

To convert a date from a  calendar to another, you have two conversion
styles,  a "push"  conversion and  a "pull"  conversion. For  example,
while  converting  "1st February  2020"  to  the French  Revolutionary
calendar, you can code:

=begin code :lang<raku>

use Date::Calendar::Julian;
use Date::Calendar::FrenchRevolutionary;

my  Date::Calendar::Julian              $d-orig;
my  Date::Calendar::FrenchRevolutionary $d-dest-push;
my  Date::Calendar::FrenchRevolutionary $d-dest-pull;

$d-orig .= new(year  => 2020
             , month =>    2
             , day   =>    1);
$d-dest-push  = $d-orig.to-date("Date::Calendar::FrenchRevolutionary");
$d-dest-pull .= new-from-date($d-orig);
say $d-orig, ' ', $d-dest-push, ' ', $d-dest-pull;
# --> "2020-02-01 0228-05-26 0228-05-26"

=end code

And the dates C<$d-dest-push> and C<$d-dest-pull> are identical.

When converting  I<from> the core  class C<Date>, use the  pull style.
When converting I<to> the core class C<Date>, use the push style. When
converting from  any class other  than the  core class C<Date>  to any
other  class other  than the  core class  C<Date>, use  the style  you
prefer.   This   includes   the   class   C<Date::Calendar::Gregorian>
inheriting from C<Date> and implementing the Gregorian calendar.

Even  if both  calendars use  a C<locale>  attribute, when  a date  is
created by  the conversion  of another  date, it  is created  with the
default  locale. If  you  want the  locale to  be  transmitted in  the
conversion, you should add a line such as:

=begin code :lang<raku>

$d-dest-pull.locale = $d-orig.locale;

=end code

=head3 strftime

This method is  very similar to the homonymous functions  you can find
in several  languages (C, shell, etc).  It also takes some  ideas from
C<printf>-similar functions. For example

=begin code :lang<raku>

$df.strftime("%04d blah blah blah %-25B")

=end code

will give  the day number  padded on  the left with  2 or 3  zeroes to
produce a 4-digit substring, plus the substring C<" blah blah blah ">,
plus the month name, padded on the right with enough spaces to produce
a 25-char substring. Thus, the whole  string will be at least 42 chars
long.

A C<strftime> specifier consists of:

=item A percent sign,

=item An  optional minus sign, to  indicate on which side  the padding
occurs. If the minus sign is present, the value is aligned to the left
and the padding spaces are added to the right. If it is not there, the
value is aligned to the right and the padding chars (spaces or zeroes)
are added to the left.

=item  An  optional  zero  digit,  to  choose  the  padding  char  for
right-aligned values.  If the  zero char is  present, padding  is done
with zeroes. Else, it is done wih spaces.

=item An  optional length, which  specifies the minimum length  of the
result substring.

=item  An optional  C<"E">  or  C<"O"> modifier.  On  some older  UNIX
system,  these  were used  to  give  the I<extended>  or  I<localized>
version  of  the date  attribute.  Here,  they rather  give  alternate
variants of the date attribute. Not used with the Julian calendar.

=item A mandatory type code.

The allowed type codes are:

=defn %a

The day of week name, abbreviated to 3 chars.

=defn %A

The full day of week name.

=defn %b

The abbreviated month name.

=defn %B

The full month name.

=defn %d

The day of the month as a decimal number (range 01 to 31).

=defn %e

Like C<%d>, the  day of the month  as a decimal number,  but a leading
zero is replaced by a space.

=defn %f

The month as a decimal number (1  to 12). Unlike C<%m>, a leading zero
is replaced by a space.

=defn %F

Equivalent to %Y-%m-%d (the ISO 8601 date format)

=defn %G

The "week year"  as a decimal number. Mostly similar  to C<%Y>, but it
may differ  on the very  first days  of the year  or on the  very last
days. Analogous to the year number  in the so-called "ISO date" format
for Gregorian dates.

=defn %j

The day of the year as a decimal number (range 001 to 366).

=defn %L

Redundant with C<%Y> and strongly discouraged: the year number.

Since  2024 and  the release  of C<Date::Calendar::Strfrtime>  version
C<0.0.4>, this strftime specifier is deprecated.

=defn %m

The month as a two-digit decimal  number (range 01 to 12), including a
leading zero if necessary.

=defn %n

A newline character.

=defn %Ep

Gives a 1-char string representing the day part:

=item C<☾> or C<U+263E> before sunrise,
=item C<☼> or C<U+263C> during daylight,
=item C<☽> or C<U+263D> after sunset.

Rationale: in  C or in  other programming languages,  when C<strftime>
deals with a date-time object, the day is split into two parts, before
noon and  after noon. The  C<%p> specifier  reflects this by  giving a
C<"AM"> or C<"PM"> string.

The  3-part   splitting  in   the  C<Date::Calendar::>R<xxx>   may  be
considered as  an alternate  splitting of  a day.  To reflect  this in
C<strftime>, we use an alternate version of C<%p>, therefore C<%Ep>.

=defn %t

A tab character.

=defn %u

The day of week as a 1..7 number.

=defn %V

The week  number as defined above,  similar to the week  number in the
so-called "ISO date" format for Gregorian dates.

=defn %Y

The year as a decimal number.

=defn %%

A literal C<`%'> character.

=head1 PROBLEMS AND KNOWN ISSUES

=head2 Security issues

As explained in  the C<Date::Calendar::Strftime> documentation, please
ensure that format-string  passed to C<strftime> comes  from a trusted
source. Failing  that, the untrusted  source can include  a outrageous
length in  a C<strftime> specifier and  this will drain your  PC's RAM
very fast.

=head2 Relations with :ver<0.0.x> classes and with core class Date

Version 0.1.0 (and API 1) was  introduced to ease the conversions with
other calendars  in which the  day is defined as  sunset-to-sunset. If
all C<Date::Calendar::>R<xxx> classes use version 0.1.x and API 1, the
conversions  will be  correct. But  if some  C<Date::Calendar::>R<xxx>
classes use version 0.0.x and API 0, there might be problems.

A date from a 0.0.x class has no C<daypart> attribute. But when "seen"
from  a  0.1.x class,  the  0.0.x  date  seems  to have  a  C<daypart>
attribute equal to C<daylight>. When converted from a 0.1.x class to a
0.0.x  class,  the  date  may  just  shift  from  C<after-sunset>  (or
C<before-sunrise>) to C<daylight>, or it  may shift to the C<daylight>
part of  the prior (or  next) date. This  means that a  roundtrip with
cascade conversions  may give the  starting date,  or it may  give the
date prior or after the starting date.

If you install C<<Date::Calendar::Julian:ver<0.1.1>>>, why would you
refrain from upgrading other C<Date::Calendar::>R<xxxx> classes? So
actually, this issue applies mainly to the core class C<Date>, because
you may prefer avoiding the installation of
C<Date::Calendar::Gregorian>.

=head2 Time

This module  and the C<Date::Calendar::>R<xxx> associated  modules are
still date  modules, they are not  date-time modules. The user  has to
give  the C<daypart>  attribute  as a  value among  C<before-sunrise>,
C<daylight> or C<after-sunset>. There is no provision to give a HHMMSS
time and convert it to a C<daypart> parameter.

=head1 SEE ALSO

=head2 Raku Software

L<Date::Names|https://raku.land/zef:tbrowder/Date::Names>
or L<https://github.com/tbrowder/Date-Names>

L<Date::Calendar::Strftime|https://raku.land/zef:jforget/Date::Calendar::Strftime>
or L<https://github.com/jforget/raku-Date-Calendar-Strftime>

L<Date::Calendar::Gregorian|https://raku.land/zef:jforget/Date::Calendar::Gregorian>
or L<https://github.com/jforget/raku-Date-Calendar-Gregorian>

L<Date::Calendar::Hebrew|https://raku.land/zef:jforget/Date::Calendar::Hebrew>
or L<https://github.com/jforget/raku-Date-Calendar-Hebrew>

L<Date::Calendar::Hijri|https://raku.land/zef:jforget/Date::Calendar::Hijri>
or L<https://github.com/jforget/raku-Date-Calendar-Hijri>

L<Date::Calendar::CopticEthiopic|https://raku.land/zef:jforget/Date::Calendar::CopticEthiopic>
or L<https://github.com/jforget/raku-Date-Calendar-CopticEthiopic>

L<Date::Calendar::MayaAztec|https://raku.land/zef:jforget/Date::Calendar::MayaAztec>
or L<https://github.com/jforget/raku-Date-Calendar-MayaAztec>

L<Date::Calendar::FrenchRevolutionary|https://raku.land/zef:jforget/Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/raku-Date-Calendar-FrenchRevolutionary>

L<Date::Calendar::Persian|https://raku.land/zef:jforget/Date::Calendar::Persian>
or L<https://github.com/jforget/raku-Date-Calendar-Persian>

L<Date::Calendar::Bahai|https://raku.land/zef:jforget/Date::Calendar::Bahai>
or L<https://github.com/jforget/raku-Date-Calendar-Bahai>

=head2 Perl 5 Software

L<DateTime|https://metacpan.org/pod/DateTime>

L<DateTime::Calendar::Julian|https://metacpan.org/pod/DateTime::Calendar::Julian>

L<Date::Convert|https://metacpan.org/pod/Date::Convert>

L<Date::Julian::Simple|https://metacpan.org/pod/Date::Julian::Simple>

L<Date::Converter|https://metacpan.org/pod/Date::Converter>

=head2 Other Software

date(1), strftime(3)

C<calendar/cal-julian.el>  in emacs or xemacs.

L<https://pypi.org/project/convertdate/>
or L<https://convertdate.readthedocs.io/en/latest/modules/julian.html>

CALENDRICA 4.0 -- Common Lisp, which can be download in the "Resources" section of
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>
(Actually, I have used the 3.0 version which is not longer available)

=head2 Internet

L<https://www.fourmilab.ch/documents/calendar/>
or its French-speaking versions
L<https://www.patricklecoq.fr/convert/cnv_calendar.html>
and L<https://louis-aime.github.io/fourmilab_calendar_upgraded/index-fr.html>

L<https://www.ephemeride.com/calendrier/autrescalendriers/21/autres-types-de-calendriers.html>
(in French)

=head2 Books

Calendrical Calculations (Third or Fourth Edition) by Nachum Dershowitz and
Edward M. Reingold, Cambridge University Press, see
L<http://www.calendarists.com>
or L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>.

I<La saga des calendriers>, by Jean Lefort, published by I<Belin> (I<Pour la Science>), ISBN 2-90929-003-5
See L<https://www.belin-editeur.com/la-saga-des-calendriers>
(site not longer responding).

I<Le Calendrier>, by Paul Couderc, published by I<Presses universitaires de France> (I<Que sais-je ?>), ISBN 2-13-036266-4
See L<https://catalogue.bnf.fr/ark:/12148/cb329699661>.

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2020, 2021, 2024, 2025 Jean Forget

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
