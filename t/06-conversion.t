#
# Checking the conversion with Gregorian
#
use v6.c;
use Test;
use Date::Calendar::Julian;
use Date::Calendar::Julian::AUC;

my @data = load-data();

plan 4 × @data.elems;

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

for @data -> $datum {
  my ($yg, $mg, $dg, $yj, $mj, $dj, $yauc, $mauc, $dauc) = $datum;
  my Date::Calendar::Julian::AUC $d-jul .= new(year => $yauc, month => $mauc, day => $dauc);
  my Date $computed  = $d-jul.to-date;
  my Date $expected .= new($yg, $mg, $dg);
  is($computed.gist, $expected.gist, "conversion of Julian {$d-jul.gist} AUC to Gregorian $expected");
}

for @data -> $datum {
  my ($yg, $mg, $dg, $yj, $mj, $dj, $yauc, $mauc, $dauc) = $datum;
  my Date $orig .= new($yg, $mg, $dg);
  my Date::Calendar::Julian::AUC $expected .= new(year => $yauc, month => $mauc, day => $dauc);
  my Date::Calendar::Julian::AUC $computed .= new-from-date($orig);
  is($computed.gist, $expected.gist, "conversion of Gregorian {$orig.gist} to Julian {$expected.gist} AUC");
}


done-testing;

sub load-data {
  return (
        # data from Perl's Date::Converter (BC year fixed because of change of year zero convention)
          (-586,  7, 24, -586,  7, 30,  167,  7, 30)
        , (-168, 12,  5, -168, 12,  8,  585, 12,  8)
        , (  70,  9, 24,   70,  9, 26,  823,  9, 26)
        , ( 135, 10,  2,  135, 10,  3,  888, 10,  3)
        , ( 470,  1,  8,  470,  1,  7, 1223,  1,  7)
        , ( 576,  5, 20,  576,  5, 18, 1329,  5, 18)
        , ( 694, 11, 10,  694, 11,  7, 1447, 11,  7)
        , (1013,  4, 25, 1013,  4, 19, 1766,  4, 19)
        , (1096,  5, 24, 1096,  5, 18, 1849,  5, 18)
        , (1190,  3, 23, 1190,  3, 16, 1943,  3, 16)
        , (1240,  3, 10, 1240,  3,  3, 1993,  3,  3)
        , (1288,  4,  2, 1288,  3, 26, 2041,  3, 26)
        , (1298,  4, 27, 1298,  4, 20, 2051,  4, 20)
        , (1391,  6, 12, 1391,  6,  4, 2144,  6,  4)
        , (1436,  2,  3, 1436,  1, 25, 2189,  1, 25)
        , (1492,  4,  9, 1492,  3, 31, 2245,  3, 31)
        , (1553,  9, 19, 1553,  9,  9, 2306,  9,  9)
        , (1560,  3,  5, 1560,  2, 24, 2313,  2, 24)
        , (1648,  6, 10, 1648,  5, 31, 2401,  5, 31)
        , (1680,  6, 30, 1680,  6, 20, 2433,  6, 20)
        , (1716,  7, 24, 1716,  7, 13, 2469,  7, 13)
        , (1768,  6, 19, 1768,  6,  8, 2521,  6,  8)
        , (1819,  8,  2, 1819,  7, 21, 2572,  7, 21)
        , (1839,  3, 27, 1839,  3, 15, 2592,  3, 15)
        , (1903,  4, 19, 1903,  4,  6, 2656,  4,  6)
        , (1929,  8, 25, 1929,  8, 12, 2682,  8, 12)
        , (1941,  9, 29, 1941,  9, 16, 2694,  9, 16)
        , (1943,  4, 19, 1943,  4,  6, 2696,  4,  6)
        , (1943, 10,  7, 1943,  9, 24, 2696,  9, 24)
        , (1992,  3, 17, 1992,  3,  4, 2745,  3,  4)
        , (1996,  2, 25, 1996,  2, 12, 2749,  2, 12)
        , (2038, 11, 10, 2038, 10, 28, 2791, 10, 28)
        , (2094,  7, 18, 2094,  7,  5, 2847,  7,  5)
        # epochs
        , (   0, 12, 29,    0, 12, 31,  753, 12, 31)
        , (   0, 12, 30,    1,  1,  1,  754,  1,  1)
        , (   0, 12, 31,    1,  1,  2,  754,  1,  2)
        , (   1,  1,  1,    1,  1,  3,  754,  1,  3)
        , (1582, 10, 15, 1582, 10,  5, 2335, 10,  5)
        , (1858, 11, 16, 1858, 11,  4, 2611, 11,  4)
        , (1858, 11, 17, 1858, 11,  5, 2611, 11,  5)
        , (1858, 11, 18, 1858, 11,  6, 2611, 11,  6)
        # values that crash with version 0.0.1, plus a few other values to be sure
        , ( 202,  1,  1,  202,  1,  1,  955,  1,  1)
        , ( 280,  1,  1,  280,  1,  1, 1033,  1,  1)
        , (2017,  1, 13, 2016, 12, 31, 2769, 12, 31)
        , (2017,  1, 14, 2017,  1,  1, 2770,  1,  1)
        , (2018,  1, 13, 2017, 12, 31, 2770, 12, 31)
        , (2018,  1, 14, 2018,  1,  1, 2771,  1,  1)
        , (2019,  1, 13, 2018, 12, 31, 2771, 12, 31)
        , (2019,  1, 14, 2019,  1,  1, 2772,  1,  1)
        , (2020,  1, 13, 2019, 12, 31, 2772, 12, 31)
        , (2020,  1, 14, 2020,  1,  1, 2773,  1,  1)
        );
}
