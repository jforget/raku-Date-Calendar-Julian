#
# Checking the getters
#
use v6.c;
use Test;
use Date::Calendar::Julian;

plan 15;

my Date::Calendar::Julian $d .= new(year => 2020, month => 2, day => 3);

is($d.month,   2);
is($d.day,     3);
is($d.year, 2020);
is($d.gist      , '2020-02-03');
is($d.locale    , 'en');
#is($d.month-abbr, 'Feb');
is($d.month-name , 'February');
is($d.day-of-week, 7);
is($d.day-name   , 'Sunday');
is($d.day-of-year, 34);

$d.locale = 'it';
is($d.locale    , 'it');
is($d.month-name, 'Febbraio');
is($d.day-name  , 'domenica');

$d.locale = 'es';
is($d.locale    , 'es');
is($d.month-name, 'febrero');
is($d.day-name  , 'domingo');


done-testing;
