#
# Checking the week-related attributes
#
use v6.c;
use Test;
use Date::Calendar::Julian;

my @tests = test-data;
plan 2 × @tests.elems;

for @tests -> $test {
  my ($y, $m, $d, $doy, $iso) = $test;
  my Date::Calendar::Julian $d-jul .= new(year => $y, month => $m, day => $d);
  is($d-jul.day-of-year          , $doy);
  is($d-jul.strftime('%G-W%V-%u'), $iso);
}

done-testing;

sub test-data {
  return (
              # Year 1996 has 366 days, year 1997 begins on Tuesday
              (1996, 12, 27, 362, '1996-W52-4') # ... Thursday 27 December 1996
            , (1996, 12, 28, 363, '1996-W52-5') #     Friday 28 December 1996
            , (1996, 12, 29, 364, '1996-W52-6') #     Saturday 29 December 1996
            , (1996, 12, 30, 365, '1996-W52-7') # ^^^ Sunday 30 December 1996
            , (1996, 12, 31, 366, '1997-W01-1') # vvv Monday 31 December 1996
            , (1997,  1,  1,   1, '1997-W01-2') #     Tuesday 1 January 1997
            , (1997,  1,  2,   2, '1997-W01-3') #     Wednesday 2 January 1997
            , (1997,  1,  3,   3, '1997-W01-4') # ... Thursday 3 January 1997
            , (1997,  1,  4,   4, '1997-W01-5') #     Friday 4 January 1997
            , (1997,  1,  5,   5, '1997-W01-6') #     Saturday 5 January 1997
            , (1997,  1,  6,   6, '1997-W01-7') # ^^^ Sunday 6 January 1997
              # Year 2000 has 366 days, year 2001 begins on Sunday
            , (2000, 12, 27, 362, '2000-W52-2') #     Tuesday 27 December 2000
            , (2000, 12, 28, 363, '2000-W52-3') #     Wednesday 28 December 2000
            , (2000, 12, 29, 364, '2000-W52-4') # ... Thursday 29 December 2000
            , (2000, 12, 30, 365, '2000-W52-5') #     Friday 30 December 2000
            , (2000, 12, 31, 366, '2000-W52-6') #     Saturday 31 December 2000
            , (2001,  1,  1,   1, '2000-W52-7') # ^^^ Sunday 1 January 2001
            , (2001,  1,  2,   2, '2001-W01-1') # vvv Monday 2 January 2001
            , (2001,  1,  3,   3, '2001-W01-2') #     Tuesday 3 January 2001
            , (2001,  1,  4,   4, '2001-W01-3') #     Wednesday 4 January 2001
            , (2001,  1,  5,   5, '2001-W01-4') # ... Thursday 5 January 2001
            , (2001,  1,  6,   6, '2001-W01-5') #     Friday 6 January 2001
              # Year 2004 has 366 days, year 2005 begins on Friday
            , (2004, 12, 27, 362, '2004-W52-7') # ^^^ Sunday 27 December 2004
            , (2004, 12, 28, 363, '2004-W53-1') # vvv Monday 28 December 2004
            , (2004, 12, 29, 364, '2004-W53-2') #     Tuesday 29 December 2004
            , (2004, 12, 30, 365, '2004-W53-3') #     Wednesday 30 December 2004
            , (2004, 12, 31, 366, '2004-W53-4') # ... Thursday 31 December 2004
            , (2005,  1,  1,   1, '2004-W53-5') #     Friday 1 January 2005
            , (2005,  1,  2,   2, '2004-W53-6') #     Saturday 2 January 2005
            , (2005,  1,  3,   3, '2004-W53-7') # ^^^ Sunday 3 January 2005
            , (2005,  1,  4,   4, '2005-W01-1') # vvv Monday 4 January 2005
            , (2005,  1,  5,   5, '2005-W01-2') #     Tuesday 5 January 2005
            , (2005,  1,  6,   6, '2005-W01-3') #     Wednesday 6 January 2005
              # Year 2008 has 366 days, year 2009 begins on Wednesday
            , (2008, 12, 27, 362, '2008-W52-5') #     Friday 27 December 2008
            , (2008, 12, 28, 363, '2008-W52-6') #     Saturday 28 December 2008
            , (2008, 12, 29, 364, '2008-W52-7') # ^^^ Sunday 29 December 2008
            , (2008, 12, 30, 365, '2009-W01-1') # vvv Monday 30 December 2008
            , (2008, 12, 31, 366, '2009-W01-2') #     Tuesday 31 December 2008
            , (2009,  1,  1,   1, '2009-W01-3') #     Wednesday 1 January 2009
            , (2009,  1,  2,   2, '2009-W01-4') # ... Thursday 2 January 2009
            , (2009,  1,  3,   3, '2009-W01-5') #     Friday 3 January 2009
            , (2009,  1,  4,   4, '2009-W01-6') #     Saturday 4 January 2009
            , (2009,  1,  5,   5, '2009-W01-7') # ^^^ Sunday 5 January 2009
            , (2009,  1,  6,   6, '2009-W02-1') # vvv Monday 6 January 2009
              # Year 2010 has 365 days, year 2011 begins on Friday
            , (2010, 12, 27, 361, '2010-W52-7') # ^^^ Sunday 27 December 2010
            , (2010, 12, 28, 362, '2010-W53-1') # vvv Monday 28 December 2010
            , (2010, 12, 29, 363, '2010-W53-2') #     Tuesday 29 December 2010
            , (2010, 12, 30, 364, '2010-W53-3') #     Wednesday 30 December 2010
            , (2010, 12, 31, 365, '2010-W53-4') # ... Thursday 31 December 2010
            , (2011,  1,  1,   1, '2010-W53-5') #     Friday 1 January 2011
            , (2011,  1,  2,   2, '2010-W53-6') #     Saturday 2 January 2011
            , (2011,  1,  3,   3, '2010-W53-7') # ^^^ Sunday 3 January 2011
            , (2011,  1,  4,   4, '2011-W01-1') # vvv Monday 4 January 2011
            , (2011,  1,  5,   5, '2011-W01-2') #     Tuesday 5 January 2011
            , (2011,  1,  6,   6, '2011-W01-3') #     Wednesday 6 January 2011
              # Year 2011 has 365 days, year 2012 begins on Saturday
            , (2011, 12, 27, 361, '2011-W52-1') # vvv Monday 27 December 2011
            , (2011, 12, 28, 362, '2011-W52-2') #     Tuesday 28 December 2011
            , (2011, 12, 29, 363, '2011-W52-3') #     Wednesday 29 December 2011
            , (2011, 12, 30, 364, '2011-W52-4') # ... Thursday 30 December 2011
            , (2011, 12, 31, 365, '2011-W52-5') #     Friday 31 December 2011
            , (2012,  1,  1,   1, '2011-W52-6') #     Saturday 1 January 2012
            , (2012,  1,  2,   2, '2011-W52-7') # ^^^ Sunday 2 January 2012
            , (2012,  1,  3,   3, '2012-W01-1') # vvv Monday 3 January 2012
            , (2012,  1,  4,   4, '2012-W01-2') #     Tuesday 4 January 2012
            , (2012,  1,  5,   5, '2012-W01-3') #     Wednesday 5 January 2012
            , (2012,  1,  6,   6, '2012-W01-4') # ... Thursday 6 January 2012
              # Year 2012 has 366 days, year 2013 begins on Monday
            , (2012, 12, 27, 362, '2012-W52-3') #     Wednesday 27 December 2012
            , (2012, 12, 28, 363, '2012-W52-4') # ... Thursday 28 December 2012
            , (2012, 12, 29, 364, '2012-W52-5') #     Friday 29 December 2012
            , (2012, 12, 30, 365, '2012-W52-6') #     Saturday 30 December 2012
            , (2012, 12, 31, 366, '2012-W52-7') # ^^^ Sunday 31 December 2012
            , (2013,  1,  1,   1, '2013-W01-1') # vvv Monday 1 January 2013
            , (2013,  1,  2,   2, '2013-W01-2') #     Tuesday 2 January 2013
            , (2013,  1,  3,   3, '2013-W01-3') #     Wednesday 3 January 2013
            , (2013,  1,  4,   4, '2013-W01-4') # ... Thursday 4 January 2013
            , (2013,  1,  5,   5, '2013-W01-5') #     Friday 5 January 2013
            , (2013,  1,  6,   6, '2013-W01-6') #     Saturday 6 January 2013
              # Year 2014 has 365 days, year 2015 begins on Wednesday
            , (2014, 12, 27, 361, '2014-W52-5') #     Friday 27 December 2014
            , (2014, 12, 28, 362, '2014-W52-6') #     Saturday 28 December 2014
            , (2014, 12, 29, 363, '2014-W52-7') # ^^^ Sunday 29 December 2014
            , (2014, 12, 30, 364, '2015-W01-1') # vvv Monday 30 December 2014
            , (2014, 12, 31, 365, '2015-W01-2') #     Tuesday 31 December 2014
            , (2015,  1,  1,   1, '2015-W01-3') #     Wednesday 1 January 2015
            , (2015,  1,  2,   2, '2015-W01-4') # ... Thursday 2 January 2015
            , (2015,  1,  3,   3, '2015-W01-5') #     Friday 3 January 2015
            , (2015,  1,  4,   4, '2015-W01-6') #     Saturday 4 January 2015
            , (2015,  1,  5,   5, '2015-W01-7') # ^^^ Sunday 5 January 2015
            , (2015,  1,  6,   6, '2015-W02-1') # vvv Monday 6 January 2015
              # Year 2015 has 365 days, year 2016 begins on Thursday
            , (2015, 12, 27, 361, '2015-W52-6') #     Saturday 27 December 2015
            , (2015, 12, 28, 362, '2015-W52-7') # ^^^ Sunday 28 December 2015
            , (2015, 12, 29, 363, '2016-W01-1') # vvv Monday 29 December 2015
            , (2015, 12, 30, 364, '2016-W01-2') #     Tuesday 30 December 2015
            , (2015, 12, 31, 365, '2016-W01-3') #     Wednesday 31 December 2015
            , (2016,  1,  1,   1, '2016-W01-4') # ... Thursday 1 January 2016
            , (2016,  1,  2,   2, '2016-W01-5') #     Friday 2 January 2016
            , (2016,  1,  3,   3, '2016-W01-6') #     Saturday 3 January 2016
            , (2016,  1,  4,   4, '2016-W01-7') # ^^^ Sunday 4 January 2016
            , (2016,  1,  5,   5, '2016-W02-1') # vvv Monday 5 January 2016
            , (2016,  1,  6,   6, '2016-W02-2') #     Tuesday 6 January 2016
              # Year 2016 has 366 days, year 2017 begins on Saturday
            , (2016, 12, 27, 362, '2016-W53-1') # vvv Monday 27 December 2016
            , (2016, 12, 28, 363, '2016-W53-2') #     Tuesday 28 December 2016
            , (2016, 12, 29, 364, '2016-W53-3') #     Wednesday 29 December 2016
            , (2016, 12, 30, 365, '2016-W53-4') # ... Thursday 30 December 2016
            , (2016, 12, 31, 366, '2016-W53-5') #     Friday 31 December 2016
            , (2017,  1,  1,   1, '2016-W53-6') #     Saturday 1 January 2017
            , (2017,  1,  2,   2, '2016-W53-7') # ^^^ Sunday 2 January 2017
            , (2017,  1,  3,   3, '2017-W01-1') # vvv Monday 3 January 2017
            , (2017,  1,  4,   4, '2017-W01-2') #     Tuesday 4 January 2017
            , (2017,  1,  5,   5, '2017-W01-3') #     Wednesday 5 January 2017
            , (2017,  1,  6,   6, '2017-W01-4') # ... Thursday 6 January 2017
              # Year 2017 has 365 days, year 2018 begins on Sunday
            , (2017, 12, 27, 361, '2017-W52-2') #     Tuesday 27 December 2017
            , (2017, 12, 28, 362, '2017-W52-3') #     Wednesday 28 December 2017
            , (2017, 12, 29, 363, '2017-W52-4') # ... Thursday 29 December 2017
            , (2017, 12, 30, 364, '2017-W52-5') #     Friday 30 December 2017
            , (2017, 12, 31, 365, '2017-W52-6') #     Saturday 31 December 2017
            , (2018,  1,  1,   1, '2017-W52-7') # ^^^ Sunday 1 January 2018
            , (2018,  1,  2,   2, '2018-W01-1') # vvv Monday 2 January 2018
            , (2018,  1,  3,   3, '2018-W01-2') #     Tuesday 3 January 2018
            , (2018,  1,  4,   4, '2018-W01-3') #     Wednesday 4 January 2018
            , (2018,  1,  5,   5, '2018-W01-4') # ... Thursday 5 January 2018
            , (2018,  1,  6,   6, '2018-W01-5') #     Friday 6 January 2018
              # Year 2018 has 365 days, year 2019 begins on Monday
            , (2018, 12, 27, 361, '2018-W52-3') #     Wednesday 27 December 2018
            , (2018, 12, 28, 362, '2018-W52-4') # ... Thursday 28 December 2018
            , (2018, 12, 29, 363, '2018-W52-5') #     Friday 29 December 2018
            , (2018, 12, 30, 364, '2018-W52-6') #     Saturday 30 December 2018
            , (2018, 12, 31, 365, '2018-W52-7') # ^^^ Sunday 31 December 2018
            , (2019,  1,  1,   1, '2019-W01-1') # vvv Monday 1 January 2019
            , (2019,  1,  2,   2, '2019-W01-2') #     Tuesday 2 January 2019
            , (2019,  1,  3,   3, '2019-W01-3') #     Wednesday 3 January 2019
            , (2019,  1,  4,   4, '2019-W01-4') # ... Thursday 4 January 2019
            , (2019,  1,  5,   5, '2019-W01-5') #     Friday 5 January 2019
            , (2019,  1,  6,   6, '2019-W01-6') #     Saturday 6 January 2019
              # Year 2019 has 365 days, year 2020 begins on Tuesday
            , (2019, 12, 27, 361, '2019-W52-4') # ... Thursday 27 December 2019
            , (2019, 12, 28, 362, '2019-W52-5') #     Friday 28 December 2019
            , (2019, 12, 29, 363, '2019-W52-6') #     Saturday 29 December 2019
            , (2019, 12, 30, 364, '2019-W52-7') # ^^^ Sunday 30 December 2019
            , (2019, 12, 31, 365, '2020-W01-1') # vvv Monday 31 December 2019
            , (2020,  1,  1,   1, '2020-W01-2') #     Tuesday 1 January 2020
            , (2020,  1,  2,   2, '2020-W01-3') #     Wednesday 2 January 2020
            , (2020,  1,  3,   3, '2020-W01-4') # ... Thursday 3 January 2020
            , (2020,  1,  4,   4, '2020-W01-5') #     Friday 4 January 2020
            , (2020,  1,  5,   5, '2020-W01-6') #     Saturday 5 January 2020
            , (2020,  1,  6,   6, '2020-W01-7') # ^^^ Sunday 6 January 2020
              # Year 2020 has 366 days, year 2021 begins on Thursday
            , (2020, 12, 27, 362, '2020-W52-6') #     Saturday 27 December 2020
            , (2020, 12, 28, 363, '2020-W52-7') # ^^^ Sunday 28 December 2020
            , (2020, 12, 29, 364, '2021-W01-1') # vvv Monday 29 December 2020
            , (2020, 12, 30, 365, '2021-W01-2') #     Tuesday 30 December 2020
            , (2020, 12, 31, 366, '2021-W01-3') #     Wednesday 31 December 2020
            , (2021,  1,  1,   1, '2021-W01-4') # ... Thursday 1 January 2021
            , (2021,  1,  2,   2, '2021-W01-5') #     Friday 2 January 2021
            , (2021,  1,  3,   3, '2021-W01-6') #     Saturday 3 January 2021
            , (2021,  1,  4,   4, '2021-W01-7') # ^^^ Sunday 4 January 2021
            , (2021,  1,  5,   5, '2021-W02-1') # vvv Monday 5 January 2021
            , (2021,  1,  6,   6, '2021-W02-2') #     Tuesday 6 January 2021
            );
}
