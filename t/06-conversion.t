#
# Checking the conversion with Gregorian
#
use v6.c;
use Test;
use Date::Calendar::Julian;


my @data = load-data();

plan 2 × @data.elems;

for @data -> $datum {
  my ($yg, $mg, $dg, $yj, $mj, $dj) = $datum;
  my Date::Calendar::Julian $d-jul .= new(year => $yj, month => $mj, day => $dj);
  my Date $computed  = $d-jul.to-date;
  my Date $expected .= new($yg, $mg, $dg);
  is($computed.gist, $expected.gist, "conversion of Julian {$d-jul.gist} to Gregorian $expected");
}

for @data -> $datum {
  my ($yg, $mg, $dg, $yj, $mj, $dj) = $datum;
  my Date $orig .= new($yg, $mg, $dg);
  my Date::Calendar::Julian $expected .= new(year => $yj, month => $mj, day => $dj);
  my Date::Calendar::Julian $computed .= new-from-date($orig);
  is($computed.gist, $expected.gist, "conversion of Gregorian {$orig.gist} to Julian {$expected.gist}");
}


done-testing;

sub load-data {
  return (
        # data from Perl's Date::Converter (BC year fixed because of change of year zero convention)
          (-586,  7, 24, -586,  7, 30)
        , (-168, 12,  5, -168, 12,  8)
        , (  70,  9, 24,   70,  9, 26)
        , ( 135, 10,  2,  135, 10,  3)
        , ( 470,  1,  8,  470,  1,  7)
        , ( 576,  5, 20,  576,  5, 18)
        , ( 694, 11, 10,  694, 11,  7)
        , (1013,  4, 25, 1013,  4, 19)
        , (1096,  5, 24, 1096,  5, 18)
        , (1190,  3, 23, 1190,  3, 16)
        , (1240,  3, 10, 1240,  3,  3)
        , (1288,  4,  2, 1288,  3, 26)
        , (1298,  4, 27, 1298,  4, 20)
        , (1391,  6, 12, 1391,  6,  4)
        , (1436,  2,  3, 1436,  1, 25)
        , (1492,  4,  9, 1492,  3, 31)
        , (1553,  9, 19, 1553,  9,  9)
        , (1560,  3,  5, 1560,  2, 24)
        , (1648,  6, 10, 1648,  5, 31)
        , (1680,  6, 30, 1680,  6, 20)
        , (1716,  7, 24, 1716,  7, 13)
        , (1768,  6, 19, 1768,  6,  8)
        , (1819,  8,  2, 1819,  7, 21)
        , (1839,  3, 27, 1839,  3, 15)
        , (1903,  4, 19, 1903,  4,  6)
        , (1929,  8, 25, 1929,  8, 12)
        , (1941,  9, 29, 1941,  9, 16)
        , (1943,  4, 19, 1943,  4,  6)
        , (1943, 10,  7, 1943,  9, 24)
        , (1992,  3, 17, 1992,  3,  4)
        , (1996,  2, 25, 1996,  2, 12)
        , (2038, 11, 10, 2038, 10, 28)
        , (2094,  7, 18, 2094,  7,  5)
        # epochs
        , (   0, 12, 29,    0, 12, 31)
        , (   0, 12, 30,    1,  1,  1)
        , (   0, 12, 31,    1,  1,  2)
        , (   1,  1,  1,    1,  1,  3)
        , (1582, 10, 15, 1582, 10,  5)
        , (1858, 11, 16, 1858, 11,  4)
        , (1858, 11, 17, 1858, 11,  5)
        , (1858, 11, 18, 1858, 11,  6)
        # values that crash with version 0.0.1, plus a few other values to be sure
        , ( 202,  1,  1,  202,  1,  1)
        , ( 280,  1,  1,  280,  1,  1)
        , (2017,  1, 13, 2016, 12, 31)
        , (2017,  1, 14, 2017,  1,  1)
        , (2018,  1, 13, 2017, 12, 31)
        , (2018,  1, 14, 2018,  1,  1)
        , (2019,  1, 13, 2018, 12, 31)
        , (2019,  1, 14, 2019,  1,  1)
        , (2020,  1, 13, 2019, 12, 31)
        , (2020,  1, 14, 2020,  1,  1)
        );
}
