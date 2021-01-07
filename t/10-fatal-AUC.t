#
# Checking the checks
#
use v6.c;
use Test;
use Date::Calendar::Julian::AUC;


my Date::Calendar::Julian::AUC $dt;

plan 24;

# tests on a normal year
lives-ok( { $dt .= new(year => 2020, month =>  4, day =>  3); }, "Month within range");
dies-ok(  { $dt .= new(year => 2020, month =>  0, day =>  3); }, "Month out of range");
dies-ok(  { $dt .= new(year => 2020, month => 13, day =>  3); }, "Month out of range for a normal year");
dies-ok(  { $dt .= new(year => 2020, month => 10, day => 33); }, "Day out of range");
dies-ok(  { $dt .= new(year => 2020, month => 10, day =>  0); }, "Day out of range");
lives-ok( { $dt .= new(year => 2020, month =>  5, day => 31); }, "Day within range");
lives-ok( { $dt .= new(year => 2020, month =>  4, day =>  1); }, "Day within range");
dies-ok(  { $dt .= new(year => 2020, month =>  4, day => 31); }, "Day out of range for April");
lives-ok( { $dt .= new(year => 2020, month =>  2, day => 28); }, "Day within range for February");
dies-ok(  { $dt .= new(year => 2020, month =>  2, day => 29); }, "Day out of range for February");

# tests on a leap year
# remember that for AUC, the leap year rule in not the same as for Julian AD
dies-ok(  { $dt .= new(year => 2021, month => 14, day =>  3); }, "Month out of range");
lives-ok( { $dt .= new(year => 2021, month => 12, day =>  3); }, "Month within range for a leap year");
dies-ok(  { $dt .= new(year => 2021, month =>  0, day =>  3); }, "Month out of range");
dies-ok(  { $dt .= new(year => 2021, month => 10, day => 33); }, "Day out of range");
dies-ok(  { $dt .= new(year => 2021, month => 10, day =>  0); }, "Day out of range");
lives-ok( { $dt .= new(year => 2021, month =>  5, day => 31); }, "Day within range");
lives-ok( { $dt .= new(year => 2021, month =>  4, day =>  1); }, "Day within range");
dies-ok(  { $dt .= new(year => 2021, month =>  4, day => 31); }, "Day out of range for April");
lives-ok( { $dt .= new(year => 2021, month =>  2, day => 29); }, "Day within range for February");
dies-ok(  { $dt .= new(year => 2021, month =>  2, day => 30); }, "Day out of range for February");

# Testing the locale
lives-ok( { $dt .= new(year => 2019, month =>  5, day => 31, locale => 'de'); }, "Correct locale init");
dies-ok(  { $dt .= new(year => 2019, month =>  5, day => 31, locale => 'xx'); },   "Wrong locale init");
lives-ok( { $dt.locale = 'nl'; }, "Correct locale rewrite");
dies-ok(  { $dt.locale = 'xx'; },   "Wrong locale rewrite");
