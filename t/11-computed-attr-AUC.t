#
# Checking the computed attributes
#
use v6.c;
use Test;
use Date::Calendar::Julian::AUC;


my @data = test-data;
plan 5 × @data.elems;

for @data -> $datum {
  my ($y, $m, $d, $doy, $mjd, $dow, $wy, $wn) = $datum;
  my Date::Calendar::Julian::AUC $d-jul .= new(year => $y, month => $m, day => $d);
  my $gist = $d-jul.gist;
  is($d-jul.day-of-year, $doy, "$gist: day of year");
  is($d-jul.daycount,    $mjd, "$gist: daycount");
  is($d-jul.day-of-week, $dow, "$gist: day of week");
  is($d-jul.week-year,   $wy , "$gist: week year");
  is($d-jul.week-number, $wn , "$gist: week number");
}


done-testing;

sub test-data {
  return   ((2773, 12, 18, 353, 59214, 4, 2773, 51)
          , (2773, 12, 18, 353, 59214, 4, 2773, 51)
          , (2653,  3,  4,  64, 15095, 6, 2653,  9)
          , (2654,  3,  4,  63, 15460, 7, 2654,  9)
          , (2773, 12, 18, 353, 59214, 4, 2773, 51)
          , (2773, 12, 31, 366, 59227, 3, 2774,  1)
          );
}
