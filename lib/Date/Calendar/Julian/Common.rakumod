use v6.d;
use Date::Names;
use Date::Calendar::Strftime;
use List::MoreUtils <last_index>;

unit role Date::Calendar::Julian::Common:ver<0.1.1>:auth<zef:jforget>:api<1>;

has Int $.year;
has Int $.month where { 1 ≤ $_ ≤ 12 };
has Int $.day   where { 1 ≤ $_ ≤ 31 };
has Int $.daycount;
has Int $.daypart where { before-sunrise() ≤ $_ ≤ after-sunset() };
has Int $.day-of-year;
has Int $.day-of-week;
has Int $.week-number;
has Int $.week-year;
has Str $.locale is rw where { check-locale($_) } = 'en';

has Str         $!instantiated-locale;
has Date::Names $!date-names;

method BUILD(Int:D :$year, Int:D :$month, Int:D :$day, Str :$locale = 'en', Int :$daypart = daylight()) {
  self!check-build-args($year, $month, $day, $locale);
  self!build-from-args( $year, $month, $day, $locale, $daypart);
}

method !check-build-args(Int $year, Int $month, Int $day, Str $locale) {
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
  elsif ($year - $.year-shift) %% 4 {
    unless 1 ≤ $day ≤ 29 {
      X::OutOfRange.new(:what<Day>, :got($day), :range("1..29 for February in a leap year")).throw;
    }
  }
  else {
    unless 1 ≤ $day ≤ 28 {
      X::OutOfRange.new(:what<Day>, :got($day), :range("1..28 for February in a normal year")).throw;
    }
  }

  unless check-locale($locale) {
    X::Invalid::Value.new(:method<BUILD>, :name<locale>, :value($locale)).throw;
  }

}

method !build-from-args(Int $year, Int $month, Int $day, Str $locale, Int $daypart) {
  $!year    = $year;
  $!month   = $month;
  $!day     = $day;
  $!daypart = $daypart;
  $!locale  = $locale;
  $!instantiated-locale = '';

  my $shifted-year = $year - $.year-shift;
  my Int @full-offset = full-offset($shifted-year);
  my Int $doy = @full-offset[$month] + $day;
  my Int $mjd = $doy + (($shifted-year - 1) × 365.25).floor - mjd-bias();
  my Int $dow = ($mjd + 2) % 7 + 1;

  $!day-of-year = $doy;
  $!daycount    = $mjd;
  $!day-of-week = $dow;

  # computing week-related derived attributes
  my Int $doy-thursday = $doy - $dow + 4; # day-of-year value for the nearest Thursday
  my Int $week-year    = $year;
  if $doy-thursday ≤ 0 {
    -- $week-year;
    $doy         += year-days($week-year);
    $doy-thursday = $doy - $dow + 4;
  }
  else {
    my $year-length = year-days($week-year - $.year-shift);
    if $doy-thursday > $year-length {
      $doy         -= $year-length;
      $doy-thursday = $doy - $dow + 4;
      ++ $week-year;
    }
  }
  my Int $week-number = ($doy-thursday / 7).ceiling;

  # storing week-related derived attributes
  $!week-number = $week-number;
  $!week-year   = $week-year;
}

method new-from-date($date) {
  $.new-from-daycount($date.daycount, daypart => $date.?daypart // daylight);
}

method new-from-daycount(Int $count, Int :$daypart = daylight) {
  my Int $biased-count = $count + mjd-bias;
  my Int $y      = 1 + (($biased-count - 0.25) / 365.25).floor;
  my Int $doy    = $biased-count - (365.25 × ($y - 1)).floor;
  my Int @offset = full-offset($y);
  my Int $m      = last_index { $doy > $_ }, @offset;
  my Int $d      = $doy - @offset[$m];
  $.new(year => $y + $.year-shift, month => $m, day => $d, daypart => $daypart);
}

method to-date($class = 'Date') {
  # See "Learning Perl 6" page 177
  my $d = ::($class).new-from-daycount($.daycount, daypart => $.daypart);
  return $d;
}

method month-name {
  self!lazy-instance;
  $!date-names.mon($.month);
}

method day-name {
  self!lazy-instance;
  $!date-names.dow($.day-of-week);
}

sub mjd-bias( --> Int) {
  return 678578;
}

method month-abbr {
  my $locale = $.locale;
  my $index  = $.month - 1;
  my $class  = "Date::Names::$locale";
  return $::($class)::mon3[$index]
      // $::($class)::mon2[$index]
      // $::($class)::mona[$index];
}

method day-abbr {
  my $locale = $.locale;
  my $index  = $.day-of-week - 1;
  my $class  = "Date::Names::$locale";
  return $::($class)::dow3[$index]
      // $::($class)::dow2[$index]
      // $::($class)::dowa[$index];
}

sub year-days (Int $year --> Int) {
  if $year %% 4 {
    return 366;
  }
  else {
    return 365;
  }
}

# computing the offset of each month from the beginning of the year.
# Do not bother about the apparent "off-by-two" error, it is deliberate
sub full-offset(Int $year) {
  my Int @elem-offset = (0, 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30);
  if $year %% 4 {
    ++ @elem-offset[3];
  }
  return [\+] @elem-offset;
}

sub check-locale ($locale) {
  unless grep { $_ eq $locale }, @Date::Names::langs {
    X::Invalid::Value.new(:method<BUILD>, :name<locale>, :value($locale)).throw;
  }
  True;
}

method !lazy-instance {
  if $.locale ne $!instantiated-locale {
    $!date-names = Date::Names.new(lang => $.locale);
    $!instantiated-locale = $.locale;
  }
}

=begin pod

=head1 NAME

Date::Calendar::Julian::Common - Behind-the-scene role for Date::Calendar::Julian and Date::Calendar::Julian::AUC

=head1 DESCRIPTION

This role  is not meant  to be used directly  by user programs.  It is
meant   to    be   used    by   the    C<Date::Calendar::Julian>   and
C<Date::Calendar::Julian::AUC>   classes.  Please   refer  to   theses
classes' documentation.

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2020, 2021, 2024, 2025 Jean Forget

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
