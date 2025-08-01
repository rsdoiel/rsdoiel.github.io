---
title: Dates
author: R. S. Doiel
copyrightYear: 2020
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: |
  This module provides minimal date time records and procedures
  for working with dates in YYYY-MM-DD and MM/DD/YYYY format and
  times in H:MM, HH:MM and HH:MM:SS formats.

  ...
dateCreated: '2020-11-27'
dateModified: '2025-07-22'
datePublished: '2020-11-27'
keywords:
  - Oberon-07
series: |
  Mostly Oberon
seriesNo: 24
---

Dates
=====

This module provides minimal date time records and procedures
for working with dates in YYYY-MM-DD and MM/DD/YYYY format and
times in H:MM, HH:MM and HH:MM:SS formats.


Set
: Set a DateTime record providing year, month, day, hour, minute and second as integers and the DateTime record to be populated.

SetDate
: Set the date portion of a DateTime record, leaves the hour, minute and second attributes unmodified. 

SetTime
: Set the time portion of a DateTime record, leaves the year, month, date attributes unmodified.

Copy
: Copy the attributes of one DateTime record into another DateTime record

ToChars
: Given a DateTime record and a format constant, render the DateTime record to an array of CHAR.

LeapYear
: Given a DateTime record check to see if it is a  leap year.

NumOfDays
: Given a year and monoth return the number of days in the month.

IsValid
: Check to see if the all attributes in a DateTime record are valid.

OberonToDateTime
: Convert oberon date and time integer values into a DateTime record

DateTimeToOberon
: Convert a DateTime record into Oberon date and time integer values.

Now
: Set a DateTime record's attributes to the current time, depends of on the implementation of Clock.Mod.

WeekDate
: Given a DateTime record calculates the year, week and weekday as integers values.

Equal
: Checks to DateTime records to see if they have equivalent attribute values.

Compare
: Compare two DateTime records, if t1 < t2 then return -1, if t1 = t2 return 0 else if t1 > t2 return 1.

CompareDate
: Compare the year, month, day attributes of two DateTime records following the approach used in Compare.

CompareTime
: Compare the hour, minute, second attributes of two DateTime records following the approach used in Compare.

TimeDifference
: Take the differ of two DateTime records setting the difference in integer values for days, hours, minutes and seconds.

AddYears
: Add years to a DateTime record. Years is a positive or negative integer.

AddMonths
: Add months to a DateTime record. Months is either a positive or negative integer. Months will propogate to year in the DataTime record.

AddDays
: Add days to a DateTime record. Days can be either a positive or negative integer.  Days will propogate to month and year attributes of the DateTime record.

AddHours
: Add hours to a DateTime record. Hours can be either a positive or negative integer.  Hours will propogate to day, month and year attributes of the DateTime record.

AddMinutes
: Add minutes to a DateTime record. Minutes can be either a positive or negative integer. Minutes will propogate to hour, day, month and year attributes of the DateTime record.

AddSeconds
: Add seconds to a DateTime record. Seconds can be either a positive or negatice integer.  Seconds will propogate to minute, hour, day, month, year attributes of the DateTime record.

IsValidDate
: IsValidDate checks the day, month, year attributes of a DateTime record and validates the values. Returns TRUE if everthing is ok, FALSE otherwise.

IsValidTime
: IsValidTime checks the hour, minute, second attributes of a DateTime record and validates the values. Returns TRUE if everthing is ok, FALSE otherwise.

IsDateString
: Checks to see if an ARRAY OF CHAR is a parsiable date string (e.g. in 2020-11-26 or 11/26/2020). Returns TRUE if the string is parsable, FALSE otherwise. NOTE: It does NOT check to see if the day, month or year values are valid. It only checks the format of the string.

IsTimeString
: Checks to see if an ARRAY OF CHAR is a parsible time string (e.g. 3:32, 14:55, 09:19:22). NOTE: It only checks the format and does not check the hour, minute and second values.

ParseDate
: Parse an ARRAY OF CHAR setting the values if year, month and day. Return TRUE on successful parse and FALSE otherwise.

ParseTime
: Parse an ARRAY OF CHAR setting the values of hour, minute and second. Return TRUE on succesful parse and FALSE otherwise.

Parse
: Parse an ARRAY OF CHAR setting the attributes of a DateTime record. Return TURE on success, FALSE otherwise.

Limitations
-----------

Dates are presumed to be in the YYYY-DD-MM or MM/DD/YYYY formats.
Does not handle dates with spelled out months or weekdays.

Time portion of the date object doesn't include time zone.
This will need to be rectified at some point.



Source code for **Dates.Mod**
-----------------------------

~~~
(* Dates -- this module was inspired by the A2's Dates module, adapted
   for Oberon-07 and a POSIX system. It provides an assortment of procedures
   for working with a simple datetime record.

Copyright (C) 2020 R. S. Doiel

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.


@Author R. S. Doiel, <rsdoiel@gmail.com>
copyright (c) 2020, all rights reserved.
This software is released under the GNU AGPL
See http://www.gnu.org/licenses/agpl-3.0.html
*)
MODULE Dates;
IMPORT Chars, Strings, Clock, Convert := extConvert; (*, Out; **)

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
PROCEDURE Set*(year, month, day, hour, minute, second : INTEGER; VAR dt: DateTime);
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
PROCEDURE ToChars*(dt: DateTime; fmt : INTEGER; VAR src : ARRAY OF CHAR);
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
	RETURN (year > 0) & (year MOD 4 = 0) & (~(year MOD 100 = 0) OR (year MOD 400 = 0))
END LeapYear;

(* NumOfDays -- number of days, returns the number of days in that month *)
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

(* IsValid -- checks if the attributes set in a DateTime record are valid *)
PROCEDURE IsValid*(dt: DateTime): BOOLEAN;
BEGIN
	RETURN ((dt.year > 0) & (dt.month > 0) & (dt.month <= 12) & (dt.day > 0) & (dt.day <= NumOfDays(dt.year, dt.month)) & (dt.hour >= 0) & (dt.hour < 24) & (dt.minute >= 0) & (dt.minute < 60) & (dt.second >= 0) & (dt.second < 60))
END IsValid;

(* IsValidDate -- checks to see if a datetime record has valid day, month and year
attributes *)
PROCEDURE IsValidDate*(dt: DateTime) : BOOLEAN;
BEGIN
	RETURN (dt.year > 0) & (dt.month > 0) & (dt.month <= 12) & (dt.day > 0) & (dt.day <= NumOfDays(dt.year, dt.month))
END IsValidDate;

(* IsValidTime -- checks if the hour, minute, second attributes set in a DateTime record are valid *)
PROCEDURE IsValidTime*(dt: DateTime): BOOLEAN;
BEGIN
	RETURN (dt.hour >= 0) & (dt.hour < 24) & (dt.minute >= 0) & (dt.minute < 60) & (dt.second >= 0) & (dt.second < 60)
END IsValidTime;


(* OberonToDateTime -- convert an Oberon date/time to a DateTime 
structure *)
PROCEDURE OberonToDateTime*(Date, Time: INTEGER; VAR dt : DateTime);
BEGIN
	dt.second := Time MOD 64; Time := Time DIV 64;
	dt.minute := Time MOD 64; Time := Time DIV 64;
	dt.hour := Time MOD 24;
	dt.day := Date MOD 32; Date := Date DIV 32;
	dt.month := (Date MOD 16) + 1; Date := Date DIV 16;
	dt.year := Date;
END OberonToDateTime;

(* DateTimeToOberon -- convert a DateTime structure to an Oberon 
date/time *)
PROCEDURE DateTimeToOberon*(dt: DateTime; VAR date, time: INTEGER);
BEGIN
	IF IsValid(dt) THEN
	date := (dt.year)*512 + dt.month*32 + dt.day;
	time := dt.hour*4096 + dt.minute*64 + dt.second
    ELSE
        date := 0;
        time := 0;
    END;
END DateTimeToOberon;

(* Now -- returns the current date and time as a DateTime record. *)
PROCEDURE Now*(VAR dt: DateTime);
VAR d, t: INTEGER;
BEGIN
	Clock.Get(t, d);
	OberonToDateTime(d, t, dt);
END Now;


(* WeekDate -- returns the ISO 8601 year number, week number &
week day (Monday=1, ....Sunday=7) 
Algorithm is by Rick McCarty, http://personal.ecu.edu/mccartyr/ISOwdALG.txt
*)
PROCEDURE WeekDate*(dt: DateTime; VAR year, week, weekday: INTEGER);
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

		IF (doy <= (8 - jan1)) & (jan1 > 4) THEN (* falls in year-1 ? *)
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

(* Equal -- compare to date records to see if they are equal values *)
PROCEDURE Equal*(t1, t2: DateTime) : BOOLEAN;
BEGIN
	RETURN ((t1.second = t2.second) & (t1.minute = t2.minute) & (t1.hour = t2.hour) & (t1.day = t2.day) & (t1.month = t2.month) & (t1.year = t2.year))
END Equal;

(* compare -- used in Compare only for comparing specific values,
    returning an appropriate -1, 0, 1 *)
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

(* Compare -- returns -1 if (t1 < t2), 0 if (t1 = t2) or 1 if (t1 >  t2) *)
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

(* CompareDate -- compare day, month and year values only *)
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

(* CompareTime -- compare second, minute and hour values only *)
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



(* TimeDifferences -- returns the absolute time difference between 
t1 and t2.

Note that leap seconds are not counted, 
see http://www.eecis.udel.edu/~mills/leap.html *)
PROCEDURE TimeDifference*(t1, t2: DateTime; VAR days, hours, minutes, seconds : INTEGER);
CONST SecondsPerMinute = 60; SecondsPerHour = 3600; SecondsPerDay = 86400;
VAR start, end: DateTime; year, month, second : INTEGER;
BEGIN
	IF (Compare(t1, t2) = -1) THEN 
        start := t1; 
        end := t2; 
    ELSE 
        start := t2; 
        end := t1; 
    END;
	IF (start.year = end.year) & (start.month = end.month) & (start.day = end.day) THEN
		second := end.second - start.second + ((end.minute - start.minute) * SecondsPerMinute) + ((end.hour - start.hour) * SecondsPerHour);
		days := 0;
        hours := 0;
        minutes := 0;
	ELSE
		(* use start date/time as reference point *)
		(* seconds until end of the start.day *)
		second := (SecondsPerDay - start.second) - (start.minute * SecondsPerMinute) - (start.hour * SecondsPerHour);
		IF (start.year = end.year) & (start.month = end.month) THEN
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
				FOR year := start.year + 1 TO end.year - 1 DO (* days between start.years and end.year *)
					IF LeapYear(year) THEN days := days + 366; ELSE days := days + 365; END;
				END;
				FOR month := 1 TO end.month - 1 DO (* days until we reach end.month in end.year *)
					days := days + NumOfDays(end.year, month);
				END;
			END;
			(* days in end.month until reaching end.day excluding end.day *)
			days := (days + end.day) - 1;
		END;
		(* seconds in end.day *)
		second := second + end.second + (end.minute * SecondsPerMinute) + (end.hour * SecondsPerHour);
	END;
	days := days + (second DIV SecondsPerDay); second := (second MOD SecondsPerDay);
	hours := (second DIV SecondsPerHour); second := (second MOD SecondsPerHour);
	minutes := (second DIV SecondsPerMinute); second := (second MOD SecondsPerMinute);
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
				days := days - nofDaysLeft - 1; (* -1 because we consume the first day of the next month *)
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
				dt.day := 1; (* otherwise, dt could become an invalid date if the previous month has less days than dt.day *)
				AddMonths(dt, -1);
				dt.day := NumOfDays(dt.year, dt.month);
				days := days - nofDaysLeft - 1; (* -1 because we consume the last day of the previous month *)
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
PROCEDURE ParseDate*(inline : ARRAY OF CHAR; VAR year, month, day : INTEGER) : BOOLEAN;
VAR src, tmp : ARRAY MAXSTR OF CHAR; ok, b : BOOLEAN;
BEGIN
    Chars.Set(inline, src);
    Chars.Clear(tmp);
    ok := FALSE;
	IF IsDateString(src) THEN
        (* FIXME: Need to allow for more than 4 digit years! *)
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
PROCEDURE ParseTime*(inline : ARRAY OF CHAR; VAR hour, minute, second : INTEGER) : BOOLEAN;
VAR src, tmp : ARRAY MAXSTR OF CHAR; ok : BOOLEAN; cur, pos, l : INTEGER;
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
as attributes, e.g. `{"year": 1998, "month": 12, "day": 10,
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