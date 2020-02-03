use v6.c;
use Date::Calendar::Strftime;
use Date::Names;

unit class Date::Calendar::Julian:ver<0.0.1>:auth<cpan:JFORGET>
      does Date::Calendar::Strftime;

has Int $.year  where { $_ ≥ 1 };
has Int $.month where { 1 ≤ $_ ≤ 12 };
has Int $.day   where { 1 ≤ $_ ≤ 31 };
has Int $.daycount;
has Int $.day-of-year;
has Int $.day-of-week;
has Int $.week-number;
has Int $.week-year;

method BUILD(Int:D :$year, Int:D :$month, Int:D :$day) {
  $._chek-build-args($year, $month, $day);
  $._build-from-args($year, $month, $day);
}

method _chek-build-args(Int $year, Int $month, Int $day) {
  unless 1 ≤ $month ≤ 12 {
    X::OutOfRange.new(:what<Month>, :got($month), :range<1..12>).throw;
  }
  if $month == 4 | 6 | 9 | 11 {
    unless 1 ≤ $day ≤ 30 {
      X::OutOfRange.new(:what<Day>, :got($day), :range("1..30 for this month")).throw;
    }
  }
  elsif $month != 2 {
    unless 1 ≤ $day ≤ 31 {
      X::OutOfRange.new(:what<Day>, :got($day), :range("1..31 for this month")).throw;
    }
  }
  elsif $year %% 4 {
    unless 1 ≤ $day ≤ 29 {
      X::OutOfRange.new(:what<Day>, :got($day), :range("1..29 for February in a leap year")).throw;
    }
  }
  else {
    unless 1 ≤ $day ≤ 28 {
      X::OutOfRange.new(:what<Day>, :got($day), :range("1..28 for February in a normal year")).throw;
    }
  }

}

method _build-from-args(Int $year, Int $month, Int $day) {
  $!year   = $year;
  $!month  = $month;
  $!day    = $day;
}

method gist {
  sprintf("%04d-%02d-%02d", $.year, $.month, $.day);
}



=begin pod

=head1 NAME

Date::Calendar::Julian - Converting from / to the Julian calendar

=head1 SYNOPSIS

Converting a Gregorian date (e.g. 10 August 2020) into Julian

=begin code :lang<perl6>

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
say 

=end code

Converting a Julian date (e.g. 1st August 2020) into Gregorian

=begin code :lang<perl6>
use Date::Calendar::Julian;
my Date::Calendar::Julian $TPRC-Amsterdam-jul;
my Date                   $TPRC-Amsterdam-grg;

$TPRC-Amsterdam-jul .= new(year  => 2020
                         , month =>    8
                         , day   =>    1);
$TPRC-Amsterdam-grg = $TPRC-Amsterdam-jul.to-date;

say "The Perl and Raku conference ends on ", $TPRC-Amsterdam-grg;
# --> The Perl and Raku conference ends on 2020-08-14
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

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright © 2020 Jean Forget

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
