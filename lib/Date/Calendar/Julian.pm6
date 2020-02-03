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

Date::Calendar::Julian - blah blah blah

=head1 SYNOPSIS

=begin code :lang<perl6>

use Date::Calendar::Julian;

=end code

=head1 DESCRIPTION

Date::Calendar::Julian is ...

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Jean Forget

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
