#
# Checking the getters
#
use v6.c;
use Test;
use Date::Calendar::Julian::AUC;

plan 26;

my Date::Calendar::Julian::AUC $d .= new(year => 2020, month => 2, day => 3);
# ... which is 1267-02-03 AD Julian, or 1267-02-10 AD Gregorian

is($d.month,   2);
is($d.day,     3);
is($d.year, 2020);
is($d.gist       , '2020-02-03 AUC');
is($d.locale     , 'en');
is($d.month-abbr , 'Feb');
is($d.month-name , 'February');
is($d.day-of-week, 4);
is($d.day-name   , 'Thursday');
is($d.day-of-year, 34);
is($d.day-abbr   , 'Thu');

$d.locale = 'it';
is($d.locale    , 'it');
is($d.month-name, 'Febbraio');
is($d.day-name  , 'giovedì');
is($d.month-abbr, Nil);
is($d.day-abbr  , Nil);

$d.locale = 'es';
is($d.locale    , 'es');
is($d.month-name, 'febrero');
is($d.day-name  , 'jueves');
is($d.month-abbr, 'feb');
is($d.day-abbr  , 'jue');

$d.locale = 'fr';
is($d.locale    , 'fr');
is($d.month-name, 'février');
is($d.day-name  , 'jeudi');
is($d.month-abbr, 'FR');
is($d.day-abbr  , 'jeu');


done-testing;
