use v6.d;
use Date::Names;
use Date::Calendar::Strftime;
use Date::Calendar::Julian::Common;
use List::MoreUtils <last_index>;

unit class Date::Calendar::Julian::AUC:ver<0.1.1>:auth<zef:jforget>:api<1>
      does Date::Calendar::Julian::Common
      does Date::Calendar::Strftime;

method year-shift {
  753;
}

method gist {
  sprintf("%04d-%02d-%02d AUC", $.year, $.month, $.day);
}


=begin pod

=head1 NAME

Date::Calendar::Julian::AUC - Julian calendar based on the foundation of Rome

=head1 SYNOPSIS

Converting a Gregorian date (e.g. 14 January 2021) into Julian, using the foundation of Rome for the epoch

=begin code :lang<raku>

use Date::Calendar::Julian::AUC;

my Date $jan14-grg;
my Date::Calendar::Julian::AUC $jan14-jul;

$jan14-grg .= new(2021, 1, 14);
$jan14-jul .= new-from-date($jan14-grg);

say $jan14-jul;
# --> 2774-01-01 AUC

$jan14-jul.locale = 'nl';
say $jan14-jul.strftime("%A %e %B %Y");
# --> donderdag  1 januari 2774

=end code

Converting a Julian date (e.g. 1st August 2773 AUC) into Gregorian

=begin code :lang<raku>
use Date::Calendar::Julian::AUC;

my  Date::Calendar::Julian::AUC
        $TPRC-Amsterdam-jul;
my Date $TPRC-Amsterdam-grg;

$TPRC-Amsterdam-jul .= new(year  => 2773
                         , month =>    8
                         , day   =>    1);
$TPRC-Amsterdam-grg = $TPRC-Amsterdam-jul.to-date;

say "The Perl and Raku conference was scheduled to end on ", $TPRC-Amsterdam-grg;
# --> The Perl and Raku conference was scheduled to end on 2020-08-14

=end code

=head1 DESCRIPTION

Date::Calendar::Julian::AUC  is   a  class  representing   the  Julian
calendar, the  forerunner of the  Gregorian calendar. Contrary  to the
C<Date::Calendar::Julian> class, years are  numbered from the foundation
of Rome instead of from the approximate year of the birth of Christ.

I<AUC> is a latin abbreviation for I<Ab Urbe Condita>, that is, "Since
the foundation  of the City"  (the City with  a capital "C"  being, of
course, Rome).

The module allows you to convert Julian dates into other calendars and
to convert other dates into the Julian calendar.

The Julian  differ from the Gregorian  calendar only on the  leap year
rule. For the  Julian calendar, leap years follow a  4-year cycle. For
the AUC variant, leap years are  years following a multiple of 4, such
as 5 or 9. There is no adjustment on a century year.

This  module  adopts a  simplified  point  of  view about  the  Julian
calendar. Except for the leap year  rule and for the epoch, everything
in the module is similar to  the Gregorian calendar. Days are midnight
to midnight, weeks are Monday to Sunday, years are 1st January to 31st
December.  Historically,  the  rules  were   not  as  rigid  as  that,
especially the rule defining the beginning of the year.

Another simplification  is that  there is  a year  zero. With  the AUC
epoch, we  do not usually  consider dates I<before> the  foundation of
Rome. Yet the class allows the creation of dates before the epoch and,
if you count backwards in time, the years are numbered 2, 1, 0, -1, -2
and so on. So the day before 1st January 1 AUC is 31st December 0 AUC.
This is the point of view adopted by this module. And also by the core
module C<Date> (which implements the Gregorian calendar).

=head2 Warning

This module is  NOT an implementation of the early  Roman calendar. It
is an implementation of the Julian  calendar, which was in effect from
45 BC (or -44,  or 709 AUC). The real early Roman  calendar was a very
complicated matter, with a leap month instead of a leap day. The rules
for including the  leap month were mixing astronomy  and politics. The
consuls were  taking office on January  1st and leaving office  on the
following January  1st. So when  the calendar  keepers did not  like a
consul, they would shorten the year even if the astronomical situation
would require adding a leap month.  And when they liked the consul (or
were bribed by him), they would  lengthen the year by including a leap
month, even if the astronomical situation did not require it.

The Julian reform, taking effect on  45 BC, would give years of nearly
equal lengths: 365 or 366 days. But there was still a problem with it.
At first,  leap years were  following a  3-year cycle. This  was fixed
after  a  few  decades,  around  year 12  AD  (765  AUC).  The  module
C<Date::Calendar::Julian::AUC>     (and    its     companion    module
C<Date::Calendar::Julian>) represent the dates I<after> this fix.

The module does not implement  I<Nones>, I<Ides> and I<Calends>. Dates
are given with weekdays from Monday to Sunday.

=head1 METHODS

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

Gives a  short string representing  the date, in  C<YYYY-MM-DD> format
with  an "AUC"  postfix  to  prevent confusion  with  the main  Julian
calendar module.

=head3 year, month, day

The numbers defining the date.

=head3 daycount

The MJD (Modified Julian Date) number for the date.

=head3 daypart

A  number indicating  which part  of the  day. This  number should  be
filled   and   compared   with   the   following   subroutines,   with
self-documenting names:

=item before-sunrise
=item daylight
=item after-sunset

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

Convert  the date  to Modified  Julian Day  Number (a  day-only scheme
based on Gregorian 17 November 1858).

=head2 Other Methods

=head3 to-date

Clones  the   date  into   a  core  class   C<Date>  object   or  some
C<Date::Calendar::>R<xxx> compatible calendar  class. The target class
name is given  as a positional parameter. This  parameter is optional,
the default value is C<"Date"> for the Gregorian calendar.

To convert a date from a  calendar to another, you have two conversion
styles,  a "push"  conversion and  a "pull"  conversion. For  example,
while  converting  "31st October  2777"  to  the French  Revolutionary
calendar, you can code:

=begin code :lang<raku>

use Date::Calendar::Julian::AUC;
use Date::Calendar::FrenchRevolutionary;

my  Date::Calendar::Julian::AUC         $d-orig;
my  Date::Calendar::FrenchRevolutionary $d-dest-push;
my  Date::Calendar::FrenchRevolutionary $d-dest-pull;

$d-orig .= new(year  => 2777
             , month =>   10
             , day   =>   31);
$d-dest-push  = $d-orig.to-date("Date::Calendar::FrenchRevolutionary");
$d-dest-pull .= new-from-date($d-orig);
say $d-orig, ' ', $d-dest-push, ' ', $d-dest-pull;
# --> "2777-10-31 AUC 0233-02-23 0233-02-23"

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

A literal `%' character.

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

L<Date::Calendar::CopticEthiopic|https://raku.land/zef:jforget/Date::Calendar::CopticEthiopic>
or L<https://github.com/jforget/raku-Date-Calendar-CopticEthiopic>

L<Date::Calendar::MayaAztec|https://raku.land/zef:jforget/Date::Calendar::MayaAztec>
or L<https://github.com/jforget/raku-Date-Calendar-MayaAztec>

L<Date::Calendar::FrenchRevolutionary|https://raku.land/zef:jforget/Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/raku-Date-Calendar-FrenchRevolutionary>

L<Date::Calendar::Hijri|https://raku.land/zef:jforget/Date::Calendar::Hijri>
or L<https://github.com/jforget/raku-Date-Calendar-Hijri>

L<Date::Calendar::Persian|https://raku.land/zef:jforget/Date::Calendar::Persian>
or L<https://github.com/jforget/raku-Date-Calendar-Persian>

L<Date::Calendar::Bahai|https://raku.land/zef:jforget/Date::Calendar::Bahai>
or L<https://github.com/jforget/raku-Date-Calendar-Bahai>

=head2 Perl 5 Software

L<DateTime|https://metacpan.org/pod/DateTime>

L<DateTime::Calendar::Julian|https://metacpan.org/pod/DateTime::Calendar::Julian>

L<Date::Converter|https://metacpan.org/pod/Date::Converter>

=head2 Other Software

date(1), strftime(3)

C<calendar/cal-julian.el>  in emacs or xemacs.

CALENDRICA 4.0 -- Common Lisp, which can be download in the "Resources" section of
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>
(Actually, I have used the 3.0 version which is not longer available)

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

Copyright (c) 2021, 2024, 2025 Jean Forget

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
