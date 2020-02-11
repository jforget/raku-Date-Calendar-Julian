#
# Checking the formatting from strftime
#
use v6.c;
use Test;
use Date::Calendar::Julian;

my @tests = ((2019,  6,  1, 'en', 'zzz',          3, 'zzz')
           , (2019,  6,  1, 'en', '%Y-%m-%d',    10, '2019-06-01')
           , (2019,  6,  1, 'en', '%j',           3, '152')
           , (2019,  6,  1, 'en', '%Oj',          3, '152')
           , (2019,  6,  1, 'en', '%Ej',          3, '152')
           , (2019,  6,  1, 'en', '%EY',          4, '2019')
           , (2019,  6,  1, 'en', '%Ey',          3, '%Ey')
           , (2019,  6,  1, 'en', '%A',           6, 'Friday')
           , (2019,  6,  1, 'en', '%u',           1, '5')
           , (2019,  6,  1, 'en', '%B',           4, 'June')
           , (2019,  6,  1, 'en', '%b',           3, 'Jun')
           , (2020,  7,  1, 'en', '%j',           3, '183')
           , (2020,  7,  1, 'en', '%Y',           4, '2020')
           , (2020,  7,  1, 'en', '%G',           4, '2020')
           , (2020,  7,  1, 'en', '%V',           2, '27')
           , (2020,  7,  1, 'en', '%u',           1, '2')
           , (2020,  7,  1, 'en', '%A',           7, 'Tuesday')
           , (2020,  7,  1, 'en', '%B',           4, 'July')
           , (2020,  3,  1, 'de', '%A %B %a %b', 19, 'Samstag März Sa Mär')
           , (2020,  3,  5, 'es', '%A %a',       13, 'miércoles mié')
           , (2020,  2,  1, 'fr', '%A %B',       16, 'vendredi février')
           , (2020,  3,  2, 'nb', '%A %B %a %b', 17, 'søndag mars %a %b')
           , (2020,  3,  2, 'ru', '%A %B %a %b', 23, 'воскресенье март Вс мар')
             );
plan 2 × @tests.elems;

for @tests -> $test {
  my ($y, $m, $d, $locale, $format, $length, $expected) = $test;
  my Date::Calendar::Julian $d-jul .= new(year => $y, month => $m, day => $d, locale => $locale);
  my $result = $d-jul.strftime($format);

  # Remembering RT ticket 100311 for the Perl 5 module DateTime::Calendar::FrenchRevolutionary
  # Even if the relations between UTF-8 and Perl6 are much simpler than between UTF-8 and Perl5
  # better safe than sorry
  is($result.chars, $length);
  is($result,       $expected);
}

done-testing;
