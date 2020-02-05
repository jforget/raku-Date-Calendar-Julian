#
# Checking the computed attributes
#
use v6.c;
use Test;
use Date::Calendar::Julian;


my @data = ((2020,  2,  4,  35, 58896, 1)
          , (2020,  3,  4,  64, 58925, 2)
          , (1900,  3,  4,  64, 15095, 6)
          , (1901,  3,  4,  63, 15460, 7)
          , (2020, 12, 18, 353, 59214, 4)
          , (2020, 12, 31, 366, 59227, 3)
	  );

plan 3 × @data.elems;

for @data -> $datum {
  my ($y, $m, $d, $doy, $mjd, $dow) = $datum;
  my Date::Calendar::Julian $d-jul .= new(year => $y, month => $m, day => $d);
  my $gist = $d-jul.gist;
  is($d-jul.day-of-year, $doy, "$gist: day of year");
  is($d-jul.daycount,    $mjd, "$gist: daycount");
  is($d-jul.day-of-week, $dow, "$gist: day of week");
}


done-testing;
