---
title: "Dates & Clock"
series: "Mostly Oberon"
number: 14
author: "rsdoiel@gmail.com (R. S. Doiel)"
date: "2020-11-27"
keywords: [ "Oberon-07", "C-shared", "obnc" ]
copyright: "copyright (c) 2020, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/"
---


Dates and Clock
===============

By R. S. Doiel, 2020-11-27

The [Oakwood](http://www.edm2.com/index.php/The_Oakwood_Guidelines_for_Oberon-2_Compiler_Developers#The_Oakwood_Guidelines)
guidelines specified a common set of modules for Oberon-2 for writing
programs outside of an Oberon System. A missing module from the Oakwood
guidelines is modules for working with dates and the system clock.
Fortunately the A2 Oberon System[^1] provides a template for that
functionality. In this article I am exploring implementing the
[Dates](Dates.Mod) and [Clock](Clock.Mod) modules for Oberon-07. I
also plan to go beyond the A2 implementations and provide additional
functionality such as parsing procedures and the ability to work with
either the date or time related attributes separately in the
`Dates.DateTime` record.

[^1]: A2 information can be found in the [Oberon wikibook](https://en.wikibooks.org/wiki/Oberon#In_A2)

Divergences
-----------

One of the noticeable differences between Oberon-07 and Active Oberon
is the types that functional procedures can return. We cannot return
an Object in Oberon-07. This is not much of a handicap as we have
variable procedure parameters.  Likewise Active Oberon provides
a large variety of integer number types. In Oberon-07 we have only
INTEGER. Where I've create new procedures I've used the Oberon idiom
of read only input parameters followed by variable parameters with
side effects and finally parameters for the target record or values
to be updated.


Similarities
------------

In spite of the divergence I have split the module into two.
The [Dates](Dates.html) module is the one you would include in your
program, it provides a DateTime record type which holds the integer
values for year, month, day, hour, minute and second. It provides the
means of parsing a date or time string, comparison, difference and addition
of dates.  The second module [Clock](Clock.html) provides a mechanism
to retrieve the real time clock value from the host system and map the
C based time object into our own DateTime record.  Clock is specific to
OBNC method of interfacing to the C standard libraries of the host system.
If you were to use a different Oberon compiled such as the Oxford
Oberon Compiler you would need to re-implement Clock. Dates itself
should be system independent and work with Oberon-07 compilers generally.

Clock
-----

The Clock module is built from a skeleton in Oberon-07 describing the
signatures of the procedure and an implementation in [C](Clock.c) that
is built using the technique for discussed in my post
[Combining Oberon-07 and C with OBNC](../../05/01/Combining-Oberon-and-C.html). In that article I outline Karl's three step process to create a
module that will be an interface to C code.  In Step one I create
the Oberon module. Normally I'd leave all procedures empty and
develop them in C. In this specific case I went ahead and wrote
the procedure called `Get` in Oberon and left the procedure `GetRtcTime`
blank. This allowed OBNC to generate the C code for `Get` saving
me some time and create the skeleton for `GetRtcTime` which does
the work interfacing with the system clock via C library calls.

The interface Oberon module looked like this:

~~~{.oberon}

MODULE Clock;

PROCEDURE GetRtcTime*(VAR second, minute, hour, day, month, year : INTEGER);
BEGIN
END GetRtcTime;

PROCEDURE Get*(VAR time, date : INTEGER);
VAR
    second, minute, hour, day, month, year : INTEGER;
BEGIN
	GetRtcTime(second, minute, hour, day, month, year);
	time = ((hour * 4096) + (minute * 64)) + second;
	date = ((year * 512) + (month * 32)) + day;
END Get;

END Clock.

~~~

I wrote the `Get` procedure code in Oberon-07 is the OBNC
compiler will render the Oberon as C during the
compilation process. I save myself writing some C code
in by leveraging OBNC.


Step two was to write [ClockTest.Mod](ClockTest.Mod) in Oberon-07.

~~~{.oberon}

MODULE ClockTest;

IMPORT Tests, Chars, Clock; (* , Out; *)

CONST
    MAXSTR = Chars.MAXSTR;

VAR
    title : ARRAY MAXSTR OF CHAR;
    success, errors : INTEGER;

PROCEDURE TestGetRtcTime() : BOOLEAN;
VAR second, minute, hour, day, month, year : INTEGER; 
    test, expected, result: BOOLEAN;
BEGIN
    test := TRUE;
    second := 0; minute := 0; hour := 0;
    day := 0; month := 0; year := 0;
    expected := TRUE;
    Clock.GetRtcTime(second, minute, hour, day, month, year);


    result := (year > 1900);
    Tests.ExpectedBool(expected, result, 
          "year should be greater than 1900", test);
    result := (month >= 0) & (month <= 11);
    Tests.ExpectedBool(expected, result,
          "month should be [0, 11]", test);
    result := (day >= 1) & (day <= 31);
    Tests.ExpectedBool(expected, result,
          "day should be non-zero", test);

    result := (hour >= 0) & (hour <= 23);
    Tests.ExpectedBool(expected, result,
          "hour should be [0, 23]", test);
    result := (minute >= 0) & (minute <= 59);
    Tests.ExpectedBool(expected, result, 
          "minute should be [0, 59]", test);
    result := (second >= 0) & (second <= 60);
    Tests.ExpectedBool(expected, result,
          "second year should be [0,60]", test);
    RETURN test
END TestGetRtcTime;

PROCEDURE TestGet() : BOOLEAN;
VAR time, date : INTEGER; 
    test, expected, result : BOOLEAN;
BEGIN
    test := TRUE;
    time := 0;
    date := 0;
    Clock.Get(time, date);
    expected := TRUE;
    result := (time > 0);
    Tests.ExpectedBool(expected, result,
        "time should not be zero", test);
    result := (date > 0);
    Tests.ExpectedBool(expected, result,
        "date should not be zero", test);

    RETURN test
END TestGet;

BEGIN
    Chars.Set("Clock module test", title);
    success := 0; errors := 0;
    Tests.Test(TestGetRtcTime, success, errors);
    Tests.Test(TestGet, success, errors);
    Tests.Summarize(title, success, errors);
END ClockTest.

~~~

ClockTest is a simple test module for [Clock.Mod](Clock.Mod).
It also serves the role when compiled with OBNC to create the
template C code for [Clock.c](Clock.c). Here's the steps we
take to generate `Clock.c` with OBNC:

~~~{.shell}

obnc ClockTest.Mod
mv .obnc/Clock.c ./
vi Clock.c

~~~

After compiling `.obnc/Clock.c` I then moved `.obnc/Clock.c`
to my working directory. Filled in the C version of
`GetRtcTime` function and modified my [Clock.Mod](Clock.Mod)
to contain my empty procedure.

The finally version of Clock.c looks like (note how we need to
include "Clock.h" in the head of the our C source file).

~~~{.c}

/*GENERATED BY OBNC 0.16.1*/

#include ".obnc/Clock.h"
#include <obnc/OBNC.h>
#include <time.h>

#define OBERON_SOURCE_FILENAME "Clock.Mod"

void Clock__GetRtcTime_(OBNC_INTEGER *second_, OBNC_INTEGER *minute_,
     OBNC_INTEGER *hour_, OBNC_INTEGER *day_,
     OBNC_INTEGER *month_, OBNC_INTEGER *year_)
{
    time_t now;
    struct tm *time_info;
    now = time(NULL);
    time_info = localtime(&now);
    *second_ = time_info->tm_sec;
    *minute_ = time_info->tm_min;
    *hour_ = time_info->tm_hour;
    *day_ = time_info->tm_mday;
    *month_ = time_info->tm_mon;
    *year_ = (time_info->tm_year) + 1900;
}


void Clock__Get_(OBNC_INTEGER *time_, OBNC_INTEGER *date_)
{
	OBNC_INTEGER second_, minute_, hour_, day_, month_, year_;

	Clock__GetRtcTime_(&second_, &minute_, 
                       &hour_, &day_, &month_, &year_);
	(*time_) = ((hour_ * 4096) + (minute_ * 64)) + second_;
	(*date_) = ((year_ * 512) + (month_ * 32)) + day_;
}


void Clock__Init(void)
{
}

~~~

The final version of Clock.Mod looks like

~~~{.oberon}

MODULE Clock;

PROCEDURE GetRtcTime*(VAR second, minute, 
                      hour, day, month, year : INTEGER);
BEGIN
END GetRtcTime;

PROCEDURE Get*(VAR time, date : INTEGER);
BEGIN
END Get;

END Clock.

~~~


Step three was to re-compile `ClockTest.Mod` and run the tests.

~~~{.shell}

    obnc ClockTest.Mod
    ./ClockTest

~~~

Dates
-----

The dates module provides a rich variety of
procedures for working with dates. This includes parsing
date strings into `DateTime` records, testing strings for
supported date formats, setting dates or time in a `DateTime`
record as well as comparison, difference and addition
(both addition and subtraction) of dates. Tests for the Dates
module is implemented in [DatesTest.Mod](DatesTest.Mod).

~~~{.oberon}

MODULE Dates;
IMPORT Chars, Strings, Clock, Convert := extConvert;

CONST
    MAXSTR = Chars.MAXSTR;
    SHORTSTR = Chars.SHORTSTR;

    YYYYMMDD* = 1; (* YYYY-MM-DD format *)
    MMDDYYYY* = 2; (* MM/DD/YYYY format *)
    YYYYMMDDHHMMSS* = 3; (* YYYY-MM-DD HH:MM:SS format *)

TYPE
    DateTime* = RECORD
        year*, month*, day*, hour*, minute*, second* : INTEGER
    END;

VAR
    (* Month names, January = 0, December = 11 *)
    Months*: ARRAY 23 OF ARRAY 10 OF CHAR;
    (* Days of week, Monday = 0, Sunday = 6 *)
    Days*: ARRAY 7 OF ARRAY 10 OF CHAR;
    DaysInMonth: ARRAY 12 OF INTEGER;


(* Set -- initialize a date record year, month and day values *)
PROCEDURE Set*(year, month, day, hour, minute, second : INTEGER; 
               VAR dt: DateTime);
BEGIN
    dt.year := year;
    dt.month := month;
    dt.day := day;
    dt.hour := hour;
    dt.minute := minute;
    dt.second := second;
END Set;

(* SetDate -- set a Date record's year, month and day attributes *)
PROCEDURE SetDate*(year, month, day : INTEGER; VAR dt: DateTime);
BEGIN
    dt.year := year;
    dt.month := month;
    dt.day := day;
END SetDate;

(* SetTime -- set a Date record's hour, minute, second attributes *)
PROCEDURE SetTime*(hour, minute, second : INTEGER; VAR dt: DateTime);
BEGIN
    dt.hour := hour;
    dt.minute := minute;
    dt.second := second;
END SetTime;

(* Copy -- copy the values from one date record to another *)
PROCEDURE Copy*(src : DateTime; VAR dest : DateTime);
BEGIN
    dest.year := src.year;
    dest.month := src.month;
    dest.day := src.day;
    dest.hour := src.hour;
    dest.minute := src.minute;
    dest.second := src.second;
END Copy;

(* ToChars -- converts a date record into an array of chars using
the format constant. Formats supported are YYYY-MM-DD HH:MM:SS
or MM/DD/YYYY HH:MM:SS. *)
PROCEDURE ToChars*(dt: DateTime; fmt : INTEGER;
                   VAR src : ARRAY OF CHAR);
VAR ok : BOOLEAN;
BEGIN
    Chars.Clear(src);
    IF fmt = YYYYMMDD THEN
        Chars.AppendInt(dt.year, 4, "0", src);
        ok := Chars.AppendChar("-", src);
        Chars.AppendInt(dt.month, 2, "0", src);
        ok := Chars.AppendChar("-", src);
        Chars.AppendInt(dt.day, 2, "0", src);
    ELSIF fmt = MMDDYYYY THEN
        Chars.AppendInt(dt.month, 2, "0", src);
        ok := Chars.AppendChar("/", src);
        Chars.AppendInt(dt.day, 2, "0", src);
        ok := Chars.AppendChar("/", src);
        Chars.AppendInt(dt.year, 4, "0", src);
    ELSIF fmt = YYYYMMDDHHMMSS THEN
        Chars.AppendInt(dt.year, 4, "0", src);
        ok := Chars.AppendChar("-", src);
        Chars.AppendInt(dt.month, 2, "0", src);
        ok := Chars.AppendChar("-", src);
        Chars.AppendInt(dt.day, 2, "0", src);
        ok := Chars.AppendChar(" ", src);
        Chars.AppendInt(dt.hour, 2, "0", src);
        ok := Chars.AppendChar(":", src);
        Chars.AppendInt(dt.minute, 2, "0", src);
        ok := Chars.AppendChar(":", src);
        Chars.AppendInt(dt.second, 2, "0", src);
    END;
END ToChars;

(*
 * Date and Time functions very much inspired by A2 but
 * adapted for use in Oberon-07 and OBNC compiler.
 *)

(* LeapYear -- returns TRUE if 'year' is a leap year *)
PROCEDURE LeapYear*(year: INTEGER): BOOLEAN;
BEGIN
	RETURN (year > 0) & (year MOD 4 = 0) & 
           (~(year MOD 100 = 0) OR (year MOD 400 = 0))
END LeapYear;

(* NumOfDays -- number of days, returns the number of 
days in that month *)
PROCEDURE NumOfDays*(year, month: INTEGER): INTEGER;
VAR result : INTEGER;
BEGIN
    result := 0;
	DEC(month);
	IF ((month >= 0) & (month < 12)) THEN
	    IF (month = 1) & LeapYear(year) THEN
            result := DaysInMonth[1]+1;
	    ELSE
            result := DaysInMonth[month];
	    END;
    END;
    RETURN result
END NumOfDays;

(* IsValid -- checks if the attributes set in a 
DateTime record are valid *)
PROCEDURE IsValid*(dt: DateTime): BOOLEAN;
BEGIN
	RETURN ((dt.year > 0) & (dt.month > 0) &
           (dt.month <= 12) & (dt.day > 0) &
           (dt.day <= NumOfDays(dt.year, dt.month)) &
           (dt.hour >= 0) & (dt.hour < 24) & (dt.minute >= 0) &
           (dt.minute < 60) & (dt.second >= 0) & (dt.second < 60))
END IsValid;

(* IsValidDate -- checks to see if a datetime record 
has valid day, month and year attributes *)
PROCEDURE IsValidDate*(dt: DateTime) : BOOLEAN;
BEGIN
	RETURN (dt.year > 0) & (dt.month > 0) &
           (dt.month <= 12) & (dt.day > 0) &
           (dt.day <= NumOfDays(dt.year, dt.month))
END IsValidDate;

(* IsValidTime -- checks if the hour, minute, second
attributes set in a DateTime record are valid *)
PROCEDURE IsValidTime*(dt: DateTime): BOOLEAN;
BEGIN
	RETURN (dt.hour >= 0) & (dt.hour < 24) &
           (dt.minute >= 0) & (dt.minute < 60) &
           (dt.second >= 0) & (dt.second < 60)
END IsValidTime;


(* OberonToDateTime -- convert an Oberon date/time 
to a DateTime structure *)
PROCEDURE OberonToDateTime*(Date, Time: INTEGER; 
                            VAR dt : DateTime);
BEGIN
	dt.second := Time MOD 64; Time := Time DIV 64;
	dt.minute := Time MOD 64; Time := Time DIV 64;
	dt.hour := Time MOD 24;
	dt.day := Date MOD 32; Date := Date DIV 32;
	dt.month := (Date MOD 16) + 1; Date := Date DIV 16;
	dt.year := Date;
END OberonToDateTime;

(* DateTimeToOberon -- convert a DateTime structure
to an Oberon date/time *)
PROCEDURE DateTimeToOberon*(dt: DateTime;
                            VAR date, time: INTEGER);
BEGIN
	IF IsValid(dt) THEN
	date := (dt.year)*512 + dt.month*32 + dt.day;
	time := dt.hour*4096 + dt.minute*64 + dt.second
    ELSE
        date := 0;
        time := 0;
    END;
END DateTimeToOberon;

(* Now -- returns the current date and time as a
DateTime record. *)
PROCEDURE Now*(VAR dt: DateTime);
VAR d, t: INTEGER;
BEGIN
	Clock.Get(t, d);
	OberonToDateTime(d, t, dt);
END Now;


(* WeekDate -- returns the ISO 8601 year number,
week number & week day (Monday=1, ....Sunday=7)
Algorithm is by Rick McCarty, 
http://personal.ecu.edu/mccartyr/ISOwdALG.txt
*)
PROCEDURE WeekDate*(dt: DateTime; 
                    VAR year, week, weekday: INTEGER);
VAR doy, i, yy, c, g, jan1: INTEGER; leap: BOOLEAN;
BEGIN
	IF IsValid(dt) THEN
		leap := LeapYear(dt.year);
		doy := dt.day; i := 0;
		WHILE (i < (dt.month - 1)) DO
            doy := doy + DaysInMonth[i];
            INC(i);
        END;
		IF leap & (dt.month > 2) THEN
            INC(doy);
        END;
		yy := (dt.year - 1) MOD 100;
        c := (dt.year - 1) - yy;
        g := (yy + yy) DIV 4;
		jan1 := 1 + (((((c DIV 100) MOD 4) * 5) + g) MOD 7);

		weekday := 1 + (((doy + (jan1 - 1)) - 1) MOD 7);
        (* does doy fall in year-1 ? *)
		IF (doy <= (8 - jan1)) & (jan1 > 4) THEN 
			year := dt.year - 1;
			IF (jan1 = 5) OR ((jan1 = 6) & LeapYear(year)) THEN
                week := 53;
			ELSE
                week := 52;
			END;
		ELSE
			IF leap THEN
                i := 366;
            ELSE
                i := 365;
            END;
			IF ((i - doy) < (4 - weekday)) THEN
				year := dt.year + 1;
				week := 1;
			ELSE
				year := dt.year;
				i := doy + (7-weekday) + (jan1-1);
				week := i DIV 7;
				IF (jan1 > 4) THEN
                    DEC(week);
                END;
			END;
		END;
	ELSE
		year := -1; week := -1; weekday := -1;
	END;
END WeekDate;

(* Equal -- compare to date records to see if they 
are equal values *)
PROCEDURE Equal*(t1, t2: DateTime) : BOOLEAN;
BEGIN
	RETURN ((t1.second = t2.second) &
            (t1.minute = t2.minute) & (t1.hour = t2.hour) &
            (t1.day = t2.day) & (t1.month = t2.month) &
            (t1.year = t2.year))
END Equal;

(* compare -- used in Compare only for comparing
specific values, returning an appropriate -1, 0, 1 *)
PROCEDURE compare(t1, t2 : INTEGER) : INTEGER;
VAR result : INTEGER;
BEGIN
	IF (t1 < t2) THEN
        result := -1;
	ELSIF (t1 > t2) THEN
        result := 1;
	ELSE
        result := 0;
	END;
	RETURN result
END compare;

(* Compare -- returns -1 if (t1 < t2), 
0 if (t1 = t2) or 1 if (t1 >  t2) *)
PROCEDURE Compare*(t1, t2: DateTime) : INTEGER;
VAR result : INTEGER;
BEGIN
	result := compare(t1.year, t2.year);
	IF (result = 0) THEN
		result := compare(t1.month, t2.month);
		IF (result = 0) THEN
			result := compare(t1.day, t2.day);
			IF (result = 0) THEN
				result := compare(t1.hour, t2.hour);
				IF (result = 0) THEN
					result := compare(t1.minute, t2.minute);
					IF (result = 0) THEN
						result := compare(t1.second, t2.second);
					END;
				END;
			END;
		END;
	END;
	RETURN result
END Compare;

(* CompareDate -- compare day, month and year
values only *)
PROCEDURE CompareDate*(t1, t2: DateTime) : INTEGER;
VAR result : INTEGER;
BEGIN
	result := compare(t1.year, t2.year);
	IF (result = 0) THEN
		result := compare(t1.month, t2.month);
		IF (result = 0) THEN
			result := compare(t1.day, t2.day);
		END;
	END;
	RETURN result
END CompareDate;

(* CompareTime -- compare second, minute and
hour values only *)
PROCEDURE CompareTime*(t1, t2: DateTime) : INTEGER;
VAR result : INTEGER;
BEGIN
	result := compare(t1.hour, t2.hour);
	IF (result = 0) THEN
		result := compare(t1.minute, t2.minute);
		IF (result = 0) THEN
			result := compare(t1.second, t2.second);
		END;
	END;
	RETURN result
END CompareTime;



(* TimeDifferences -- returns the absolute time
difference between
t1 and t2.

Note that leap seconds are not counted,
see http://www.eecis.udel.edu/~mills/leap.html *)
PROCEDURE TimeDifference*(t1, t2: DateTime;
              VAR days, hours, minutes, seconds : INTEGER);
CONST 
    SecondsPerMinute = 60; 
    SecondsPerHour = 3600; 
    SecondsPerDay = 86400;
VAR start, end: DateTime; year, month, second : INTEGER;
BEGIN
	IF (Compare(t1, t2) = -1) THEN
        start := t1;
        end := t2;
    ELSE
        start := t2;
        end := t1;
    END;
	IF (start.year = end.year) & (start.month = end.month) &
       (start.day = end.day) THEN
		second := end.second - start.second + 
                  ((end.minute - start.minute) * SecondsPerMinute) +
                  ((end.hour - start.hour) * SecondsPerHour);
		days := 0;
        hours := 0;
        minutes := 0;
	ELSE
		(* use start date/time as reference point *)
		(* seconds until end of the start.day *)
		second := (SecondsPerDay - start.second) -
                  (start.minute * SecondsPerMinute) -
                  (start.hour * SecondsPerHour);
		IF (start.year = end.year) &
           (start.month = end.month) THEN
			(* days between start.day and end.day *)
			days := (end.day - start.day) - 1;
		ELSE
			(* days until start.month ends excluding start.day *)
			days := NumOfDays(start.year, start.month) - start.day;
			IF (start.year = end.year) THEN
				(* months between start.month and end.month *)
				FOR month := start.month + 1 TO end.month - 1 DO
					days := days + NumOfDays(start.year, month);
				END;
			ELSE
				(* days until start.year ends (excluding start.month) *)
				FOR month := start.month + 1 TO 12 DO
					days := days + NumOfDays(start.year, month);
				END;
                (* days between start.years and end.year *)
				FOR year := start.year + 1 TO end.year - 1 DO
					IF LeapYear(year) THEN days := days + 366; 
                    ELSE days := days + 365; END;
				END;
                (* days until we reach end.month in end.year *)
				FOR month := 1 TO end.month - 1 DO
					days := days + NumOfDays(end.year, month);
				END;
			END;
			(* days in end.month until reaching end.day excluding end.day *)
			days := (days + end.day) - 1;
		END;
		(* seconds in end.day *)
		second := second + end.second +
                  (end.minute * SecondsPerMinute) +
                  (end.hour * SecondsPerHour);
	END;
	days := days + (second DIV SecondsPerDay); 
    second := (second MOD SecondsPerDay);
	hours := (second DIV SecondsPerHour); 
    second := (second MOD SecondsPerHour);
	minutes := (second DIV SecondsPerMinute);
    second := (second MOD SecondsPerMinute);
	seconds := second;
END TimeDifference;

(* AddYear -- Add/Subtract a number of years to/from date *)
PROCEDURE AddYears*(VAR dt: DateTime; years : INTEGER);
BEGIN
	ASSERT(IsValid(dt));
	dt.year := dt.year + years;
	ASSERT(IsValid(dt));
END AddYears;

(* AddMonths -- Add/Subtract a number of months to/from date.
This will adjust date.year if necessary *)
PROCEDURE AddMonths*(VAR dt: DateTime; months : INTEGER);
VAR years : INTEGER;
BEGIN
	ASSERT(IsValid(dt));
	years := months DIV 12;
	dt.month := dt.month + (months MOD 12);
	IF (dt.month > 12) THEN
		dt.month := dt.month - 12;
		INC(years);
	ELSIF (dt.month < 1) THEN
		dt.month := dt.month + 12;
		DEC(years);
	END;
	IF (years # 0) THEN AddYears(dt, years); END;
	ASSERT(IsValid(dt));
END AddMonths;

(* AddDays --  Add/Subtract a number of days to/from date.
This will adjust date.month and date.year if necessary *)
PROCEDURE AddDays*(VAR dt: DateTime; days : INTEGER);
VAR nofDaysLeft : INTEGER;
BEGIN
	ASSERT(IsValid(dt));
	IF (days > 0) THEN
		WHILE (days > 0) DO
			nofDaysLeft := NumOfDays(dt.year, dt.month) - dt.day;
			IF (days > nofDaysLeft) THEN
				dt.day := 1;
				AddMonths(dt, 1);
                (* -1 because we consume the first day 
                    of the next month *)
				days := days - nofDaysLeft - 1;
			ELSE
				dt.day := dt.day + days;
				days := 0;
			END;
		END;
	ELSIF (days < 0) THEN
		days := -days;
		WHILE (days > 0) DO
			nofDaysLeft := dt.day - 1;
			IF (days > nofDaysLeft) THEN
                (* otherwise, dt could become an invalid 
                   date if the previous month has less 
                   days than dt.day *)
				dt.day := 1; 
				AddMonths(dt, -1);
				dt.day := NumOfDays(dt.year, dt.month);
                (* -1 because we consume the last day 
                   of the previous month *)
				days := days - nofDaysLeft - 1;
			ELSE
				dt.day := dt.day - days;
				days := 0;
			END;
		END;
	END;
	ASSERT(IsValid(dt));
END AddDays;

(* AddHours -- Add/Subtract a number of hours to/from date.
This will adjust date.day, date.month and date.year if necessary *)
PROCEDURE AddHours*(VAR dt: DateTime; hours : INTEGER);
VAR days : INTEGER;
BEGIN
	ASSERT(IsValid(dt));
	dt.hour := dt.hour + hours;
	days := dt.hour DIV 24;
	dt.hour := dt.hour MOD 24;
	IF (dt.hour < 0) THEN
		dt.hour := dt.hour + 24;
		DEC(days);
	END;
	IF (days # 0) THEN AddDays(dt, days); END;
	ASSERT(IsValid(dt));
END AddHours;

(* AddMinutes -- Add/Subtract a number of minutes to/from date.
This will adjust date.hour, date.day, date.month and date.year
if necessary *)
PROCEDURE AddMinutes*(VAR dt: DateTime; minutes : INTEGER);
VAR hours : INTEGER;
BEGIN
	ASSERT(IsValid(dt));
	dt.minute := dt.minute + minutes;
	hours := dt.minute DIV 60;
	dt.minute := dt.minute MOD 60;
	IF (dt.minute < 0) THEN
		dt.minute := dt.minute + 60;
		DEC(hours);
	END;
	IF (hours # 0) THEN AddHours(dt, hours); END;
	ASSERT(IsValid(dt));
END AddMinutes;

(* AddSeconds -- Add/Subtract a number of seconds to/from date.
This will adjust date.minute, date.hour, date.day, date.month and
date.year if necessary *)
PROCEDURE AddSeconds*(VAR dt: DateTime; seconds : INTEGER);
VAR minutes : INTEGER;
BEGIN
	ASSERT(IsValid(dt));
	dt.second := dt.second + seconds;
	minutes := dt.second DIV 60;
	dt.second := dt.second MOD 60;
	IF (dt.second < 0) THEN
		dt.second := dt.second + 60;
		DEC(minutes);
	END;
	IF (minutes # 0) THEN AddMinutes(dt, minutes); END;
	ASSERT(IsValid(dt));
END AddSeconds;


(* IsDateString -- return TRUE if the ARRAY OF CHAR is 10 characters
long and is either in the form of YYYY-MM-DD or MM/DD/YYYY where
Y, M and D are digits.
NOTE: is DOES NOT check the ranges of the digits. *)
PROCEDURE IsDateString*(inline : ARRAY OF CHAR) : BOOLEAN;
VAR
    test : BOOLEAN; i, pos : INTEGER;
    src : ARRAY MAXSTR OF CHAR;
BEGIN
    Chars.Set(inline, src);
    Chars.TrimSpace(src);
    test := FALSE;
    IF Strings.Length(src) = 10 THEN
        pos := Strings.Pos("-", src, 0);
        IF pos > 0 THEN
            IF (src[4] = "-") & (src[7] = "-") THEN
                test := TRUE;
                FOR i := 0 TO 9 DO
                    IF (i # 4) & (i # 7) THEN
                       IF Chars.IsDigit(src[i]) = FALSE THEN
                           test := FALSE;
                       END;
                    END;
                END;
            ELSE
                test := FALSE;
            END;
        END;
        pos := Strings.Pos("/", src, 0);
        IF pos > 0 THEN
            IF (src[2] = "/") & (src[5] = "/") THEN
                test := TRUE;
                FOR i := 0 TO 9 DO
                    IF (i # 2) & (i # 5) THEN
                        IF Chars.IsDigit(src[i]) = FALSE THEN
                            test := FALSE;
                        END;
                    END;
                END;
            ELSE
                test := FALSE;
            END;
        END;
    END;
    RETURN test
END IsDateString;

(* IsTimeString -- return TRUE if the ARRAY OF CHAR has 4 to 8
characters in the form of H:MM, HH:MM, HH:MM:SS where H, M and S
are digits. *)
PROCEDURE IsTimeString*(inline : ARRAY OF CHAR) : BOOLEAN;
VAR
    test : BOOLEAN;
    l : INTEGER;
    src : ARRAY MAXSTR OF CHAR;
BEGIN
    Chars.Set(inline, src);
    Chars.TrimSpace(src);
    (* remove any trailing am/pm suffixes *)
    IF Chars.EndsWith("m", src) THEN
        IF Chars.EndsWith("am", src) THEN
            Chars.TrimSuffix("am", src);
        ELSE
            Chars.TrimSuffix("pm", src);
        END;
        Chars.TrimSpace(src);
    ELSIF Chars.EndsWith("M", src) THEN
        Chars.TrimSuffix("AM", src);
        Chars.TrimSuffix("PM", src);
        Chars.TrimSpace(src);
    ELSIF Chars.EndsWith("p", src) THEN
        Chars.TrimSuffix("p", src);
        Chars.TrimSpace(src);
    ELSIF Chars.EndsWith("P", src) THEN
        Chars.TrimSuffix("P", src);
        Chars.TrimSpace(src);
    ELSIF Chars.EndsWith("a", src) THEN
        Chars.TrimSuffix("a", src);
        Chars.TrimSpace(src);
    ELSIF Chars.EndsWith("A", src) THEN
        Chars.TrimSuffix("A", src);
        Chars.TrimSpace(src);
    END;
    Strings.Extract(src, 0, 8, src);
    test := FALSE;
    l := Strings.Length(src);
    IF (l = 4) THEN
        IF Chars.IsDigit(src[0]) & (src[1] = ":") &
            Chars.IsDigit(src[2]) & Chars.IsDigit(src[3]) THEN
            test := TRUE;
        ELSE
            test := FALSE;
        END;
    ELSIF (l = 5) THEN
        IF Chars.IsDigit(src[0]) & Chars.IsDigit(src[1]) &
            (src[2] = ":") &
            Chars.IsDigit(src[3]) & Chars.IsDigit(src[4]) THEN
            test := TRUE;
        ELSE
            test := FALSE;
        END;
    ELSIF (l = 8) THEN
        IF Chars.IsDigit(src[0]) & Chars.IsDigit(src[1]) &
            (src[2] = ":") &
            Chars.IsDigit(src[3]) & Chars.IsDigit(src[4]) &
            (src[5] = ":") &
            Chars.IsDigit(src[6]) & Chars.IsDigit(src[7]) THEN
            test := TRUE;
        ELSE
            test := FALSE;
        END;
    ELSE
        test := FALSE;
    END;
    RETURN test
END IsTimeString;

(* ParseDate -- parses a date string in YYYY-MM-DD or
MM/DD/YYYY format. *)
PROCEDURE ParseDate*(inline : ARRAY OF CHAR;
                     VAR year, month, day : INTEGER) : BOOLEAN;
VAR src, tmp : ARRAY MAXSTR OF CHAR; ok, b : BOOLEAN;
BEGIN
    Chars.Set(inline, src);
    Chars.Clear(tmp);
    ok := FALSE;
	IF IsDateString(src) THEN
        (* LIMITATION: Need to allow for more than 4 digit years! *)
        IF (src[2] = "/") & (src[5] = "/") THEN
            ok := TRUE;
            Strings.Extract(src, 0, 2, tmp);
            Convert.StringToInt(tmp, month, b);
            ok := ok & b;
            Strings.Extract(src, 4, 2, tmp);
            Convert.StringToInt(tmp, day, b);
            ok := ok & b;
            Strings.Extract(src, 6, 4, tmp);
            Convert.StringToInt(tmp, year, b);
            ok := ok & b;
        ELSIF (src[4] = "-") & (src[7] = "-") THEN
            ok := TRUE;
            Strings.Extract(src, 0, 4, tmp);
            Convert.StringToInt(tmp, year, b);
            ok := ok & b;
            Strings.Extract(src, 5, 2, tmp);
            Convert.StringToInt(tmp, month, b);
            ok := ok & b;
            Strings.Extract(src, 8, 2, tmp);
            Convert.StringToInt(tmp, day, b);
            ok := ok & b;
        ELSE
            ok := FALSE;
        END;
    END;
    RETURN ok
END ParseDate;

(* ParseTime -- procedure for parsing time strings into hour,
minute, second. Returns TRUE on successful parse, FALSE otherwise *)
PROCEDURE ParseTime*(inline : ARRAY OF CHAR;
                     VAR hour, minute, second : INTEGER) : BOOLEAN;
VAR src, tmp : ARRAY MAXSTR OF CHAR;
    ok : BOOLEAN; cur, pos, l : INTEGER;
BEGIN
    Chars.Set(inline, src);
    Chars.Clear(tmp);
	IF IsTimeString(src) THEN
        ok := TRUE;
        cur := 0; pos := 0;
        pos := Strings.Pos(":", src, cur);
        IF pos > 0 THEN
        (* Get Hour *)
            Strings.Extract(src, cur, pos - cur, tmp);
            Convert.StringToInt(tmp, hour, ok);
            IF ok THEN
                (* Get Minute *)
                cur := pos + 1;
                Strings.Extract(src, cur, 2, tmp);
                Convert.StringToInt(tmp, minute, ok);
                IF ok THEN
                    (* Get second, optional, default to zero *)
                    pos := Strings.Pos(":", src, cur);
                    IF pos > 0 THEN
                        cur := pos + 1;
                        Strings.Extract(src, cur, 2, tmp);
                        Convert.StringToInt(tmp, second, ok);
                        cur := cur + 2;
                    ELSE
                        second := 0;
                    END;
                    (* Get AM/PM, optional, adjust hour if PM *)
                    l := Strings.Length(src);
                    WHILE (cur < l) & Chars.IsSpace(src[cur]) DO
                        cur := cur + 1;
                    END;
                    Strings.Extract(src, cur, 2, tmp);
                    Chars.TrimSpace(tmp);
                    IF Chars.Equal(tmp, "PM") OR Chars.Equal(tmp, "pm") THEN
                        hour := hour + 12;
                    END;
                ELSE
                    ok := FALSE;
                END;
            END;
        ELSE
            ok := FALSE;
        END;
    ELSE
        ok := FALSE;
    END;
    IF ok THEN
        ok := ((hour >= 0) & (hour <= 23)) &
            ((minute >= 0) & (minute <= 59)) &
                ((second >= 0) & (second <= 59));
    END;
    RETURN ok
END ParseTime;


(* Parse accepts a date array of chars in either dates, times
or dates and times separate by spaces. Date formats supported
include YYYY-MM-DD, MM/DD/YYYY. Time formats include
H:MM, HH:MM, H:MM:SS, HH:MM:SS with 'a', 'am', 'p', 'pm'
suffixes.  Dates and times can also be accepted as JSON
expressions with the individual time compontents are specified
as attributes, e.g. {"year": 1998, "month": 12, "day": 10,
"hour": 11, "minute": 4, "second": 3}.
Parse returns TRUE on successful parse, FALSE otherwise.

BUG: Assumes a 4 digit year.
*)
PROCEDURE Parse*(inline : ARRAY OF CHAR; VAR dt: DateTime) : BOOLEAN;
VAR src, ds, ts, tmp : ARRAY SHORTSTR OF CHAR; ok, okDate, okTime : BOOLEAN;
    pos, year, month, day, hour, minute, second : INTEGER;
BEGIN
    dt.year := 0;
    dt.month := 0;
    dt.day := 0;
    dt.hour := 0;
    dt.minute := 0;
    dt.second := 0;
    Chars.Clear(tmp);
    Chars.Set(inline, src);
    Chars.TrimSpace(src);
    (* Split into Date and Time components *)
    pos := Strings.Pos(" ", src, 0);
    IF pos >= 0 THEN
        Strings.Extract(src, 0, pos, ds);
        pos := pos + 1;
        Strings.Extract(src, pos, Strings.Length(src) - pos, ts);
    ELSE
        Chars.Set(src, ds);
        Chars.Set(src, ts);
    END;
    ok := FALSE;
    IF IsDateString(ds) THEN
        ok := TRUE;
        okDate := ParseDate(ds, year, month, day);
        SetDate(year, month, day, dt);
        ok := ok & okDate;
    END;
    IF IsTimeString(ts) THEN
        ok := ok OR okDate;
        okTime := ParseTime(ts, hour, minute, second);
        SetTime(hour, minute, second, dt);
        ok := ok & okTime;
    END;
    RETURN ok
END Parse;

BEGIN
    Chars.Set("January", Months[0]);
    Chars.Set("February", Months[1]);
    Chars.Set("March", Months[2]);
    Chars.Set("April", Months[3]);
    Chars.Set("May", Months[4]);
    Chars.Set("June", Months[5]);
    Chars.Set("July", Months[6]);
    Chars.Set("August", Months[7]);
    Chars.Set("September", Months[8]);
    Chars.Set("October", Months[9]);
    Chars.Set("November", Months[10]);
    Chars.Set("December", Months[11]);

    Chars.Set("Sunday", Days[0]);
    Chars.Set("Monday", Days[1]);
    Chars.Set("Tuesday", Days[2]);
    Chars.Set("Wednesday", Days[3]);
    Chars.Set("Thursday", Days[4]);
    Chars.Set("Friday", Days[5]);
    Chars.Set("Saturday", Days[6]);

    DaysInMonth[0] := 31; (* January *)
    DaysInMonth[1] := 28; (* February *)
    DaysInMonth[2] := 31; (* March *)
    DaysInMonth[3] := 30; (* April *)
    DaysInMonth[4] := 31; (* May *)
    DaysInMonth[5] := 30; (* June *)
    DaysInMonth[6] := 31; (* July *)
    DaysInMonth[7] := 31; (* August *)
    DaysInMonth[8] := 30; (* September *)
    DaysInMonth[9] := 31; (* October *)
    DaysInMonth[10] := 30; (* November *)
    DaysInMonth[11] := 31; (* December *)

END Dates.

~~~

Postscript: In this article I included a reference to the module
**[Chars](Chars.html)**. This is a non-standard module I wrote
for Oberon-07. Here is a link to [Chars](Chars.Mod). RSD, 2021-05-06

### Next, Previous

+ Next [Beyond Oakwood, Modules and Aliases](/blog/2021/05/16/Beyond-Oakwood-Modules-and-Aliases.html)
+ Previous [Assemble Pages](/blog/2020/10/19/Assemble-pages.html)

