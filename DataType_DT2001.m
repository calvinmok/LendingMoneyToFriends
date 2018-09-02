







#import "DataType.h"





NSCalendar* DT2001_gregorian(void);
NSCalendar* DT2001_gregorian(void)
{
	static NSCalendar* gregorian = nil;	
	if (gregorian == nil)
		gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	return gregorian;
}



NSDate* DT2001_toNSDate(DT2001 value)
{
	return [NSDate dateWithTimeIntervalSinceReferenceDate:value];
}

DT2001 DT2001_fromNSDate(NSDate* value)
{
	return [value timeIntervalSinceReferenceDate];
}




#define NSYearMonthDayCalendarUnit     (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
#define NSHourMinuteSecondCalendarUnit (NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
#define NSYMDHMSCalendarUnit           (NSYearMonthDayCalendarUnit | NSHourMinuteSecondCalendarUnit)

Int DT2001_year(DT2001 value)
{
	NSDate* date = DT2001_toNSDate(value);
	NSDateComponents* components = [DT2001_gregorian() components:NSYMDHMSCalendarUnit fromDate:date];
	return [components year];
}

Int DT2001_month(DT2001 value)
{
	NSDate* date = DT2001_toNSDate(value);
	NSDateComponents* components = [DT2001_gregorian() components:NSYMDHMSCalendarUnit fromDate:date];
	return [components month];
}

Int DT2001_day(DT2001 value)
{
	NSDate* date = DT2001_toNSDate(value);
	NSDateComponents* components = [DT2001_gregorian() components:NSYMDHMSCalendarUnit fromDate:date];
	return [components day];
}

Int DT2001_hour(DT2001 value)
{
	NSDate* date = DT2001_toNSDate(value);
	NSDateComponents* components = [DT2001_gregorian() components:NSYMDHMSCalendarUnit fromDate:date];
	return [components hour];
}

Int DT2001_minute(DT2001 value)
{
	NSDate* date = DT2001_toNSDate(value);
	NSDateComponents* components = [DT2001_gregorian() components:NSYMDHMSCalendarUnit fromDate:date];
	return [components minute];
}

Int DT2001_second(DT2001 value)
{
	NSDate* date = DT2001_toNSDate(value);
	NSDateComponents* components = [DT2001_gregorian() components:NSYMDHMSCalendarUnit fromDate:date];
	return [components second];
}



DT2001 DT2001_createYMD(Int year, Int month, Int day)
{
	NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
	[components setYear:year];
	[components setMonth:month];
	[components setDay:day];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	
	NSDate* date = [DT2001_gregorian() dateFromComponents:components];
	return [date timeIntervalSinceReferenceDate];
}

DT2001 DT2001_createYMDHM(Int year, Int month, Int day, Int hour, Int minute)
{
	while (minute <  00) { minute += 60; hour -= 1; }
	while (minute >= 60) { minute -= 60; hour += 1; }

	while (hour <  00) { hour += 24; day -= 1; }
	while (hour >= 24) { hour -= 24; day += 1; }

	NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
	[components setYear:year];
	[components setMonth:month];
	[components setDay:day];
	[components setHour:hour];
	[components setMinute:minute];
	[components setSecond:0];
	
	NSDate* date = [DT2001_gregorian() dateFromComponents:components];
	return [date timeIntervalSinceReferenceDate];
}

DT2001 DT2001_createYMDHMS(Int year, Int month, Int day, Int hour, Int minute, Int second)
{
	while (second <  00) { second += 60; minute -= 1; }
	while (second >= 60) { second -= 60; minute += 1; }
	
	while (minute <  00) { minute += 60; hour -= 1; }
	while (minute >= 60) { minute -= 60; hour += 1; }

	while (hour <  00) { hour += 24; day -= 1; }
	while (hour >= 24) { hour -= 24; day += 1; }

	NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
	[components setYear:year];
	[components setMonth:month];
	[components setDay:day];
	[components setHour:hour];
	[components setMinute:minute];
	[components setSecond:second];
	
	NSDate* date = [DT2001_gregorian() dateFromComponents:components];
	return [date timeIntervalSinceReferenceDate];
}





DT2001 DT2001_createNow(void)
{
	return [NSDate timeIntervalSinceReferenceDate];
}







NubleDT2001 DT2001_parse(String* value)
{
	SELFTEST_START
	
	DT2001_assert(DT2001_parse(STR(@"1999-03-04")).vd, 1999, 3, 4, 0, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"1999-03-04 13:0:0")).vd, 1999, 3, 4, 13, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"1999-03-04 17:0:2")).vd, 1999, 3, 4, 17, 0, 2);

	DT2001_assert(DT2001_parse(STR(@"1-03-04")).vd, 2001, 3, 4, 0, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"01-03-04")).vd, 2001, 3, 4, 0, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"01-03-4")).vd, 2001, 3, 4, 0, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"01-3-4")).vd, 2001, 3, 4, 0, 0, 0);

	DT2001_assert(DT2001_parse(STR(@"01-1-32")).vd, 2001, 2, 1, 0, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"01-1-32 12:60:0")).vd, 2001, 2, 1, 13, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"01-1-32 24:0:0")).vd, 2001, 2, 2, 0, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"01-1-32 24:60:0")).vd, 2001, 2, 2, 1, 0, 0);
	 
	DT2001_assert(DT2001_parse(STR(@"1999-0304")).vd, 1999, 3, 4, 0, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"1999-112")).vd, 1999, 11, 2, 0, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"1-112")).vd, 2001, 11, 2, 0, 0, 0);

	DT2001_assert(DT2001_parse(STR(@"1999-03-04 12:34:56")).vd, 1999, 3, 4, 12, 34, 56);
	DT2001_assert(DT2001_parse(STR(@"1999-03-04 12:04:06")).vd, 1999, 3, 4, 12, 4, 6);
	DT2001_assert(DT2001_parse(STR(@"1999-03-04 12:4:6")).vd, 1999, 3, 4, 12, 4, 6);
	DT2001_assert(DT2001_parse(STR(@"1999-03-04 2:4:6")).vd, 1999, 3, 4, 2, 4, 6);
	
	DT2001_assert(DT2001_parse(STR(@"19990304123456")).vd, 1999, 3, 4, 12, 34, 56);
	DT2001_assert(DT2001_parse(STR(@"199903041234")).vd, 1999, 3, 4, 12, 34, 0);
	DT2001_assert(DT2001_parse(STR(@"1999030412")).vd, 1999, 3, 4, 12, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"199903040")).vd, 1999, 3, 4, 0, 0, 0);
	DT2001_assert(DT2001_parse(STR(@"19990304")).vd, 1999, 3, 4, 0, 0, 0);
	
	SELFTEST_END



	if (value.length == 0)
		return DT2001_nuble();
		
		
	NubleInt yearIdx = Int_nuble(), monthIdx = Int_nuble(), dayIdx = Int_nuble();
	NubleInt hourIdx = Int_nuble(), minuteIdx = Int_nuble(), secondIdx = Int_nuble();
	
	Int yearLen = 1, monthLen = 1, dayLen = 1, hourLen = 1, minuteLen = 1, secondLen = 1;
		
		
	Char lastChar = CHAR(-);

	ForEachIndex(i, value)
	{
		Char c = [value charAt:i];
		Bool tuning  = (Char_isDigit(c) && Char_isDigit(lastChar) == NO);

		lastChar = c;
		
		if (tuning)
		{
			IF (yearIdx.hasVar == NO) yearIdx = Int_toNuble(i);
			EF (monthIdx.hasVar == NO) monthIdx = Int_toNuble(i);
			EF (dayIdx.hasVar == NO) dayIdx = Int_toNuble(i);
			EF (hourIdx.hasVar == NO) hourIdx = Int_toNuble(i);
			EF (minuteIdx.hasVar == NO) minuteIdx = Int_toNuble(i);
			EF (secondIdx.hasVar == NO) secondIdx = Int_toNuble(i);
		}
		else if (Char_isDigit(c))
		{
			IF (secondIdx.hasVar) 
			{
				if (secondLen < 2) { secondLen += 1; if (secondLen == 2) lastChar = CHAR(-); }
			}
			EF (minuteIdx.hasVar)
			{
				if (minuteLen < 2) { minuteLen += 1; if (minuteLen == 2) lastChar = CHAR(-); }
			}
			EF (hourIdx.hasVar) 
			{
				if (hourLen < 2) { hourLen += 1; if (hourLen == 2) lastChar = CHAR(-); }
			}
			EF (dayIdx.hasVar) 
			{	
				if (dayLen < 2) { dayLen += 1; if (dayLen == 2) lastChar = CHAR(-); }
			}
			EF (monthIdx.hasVar)
			{	
				if (monthLen < 2) { monthLen += 1; if (monthLen == 2) lastChar = CHAR(-); }
			}
			EF (yearIdx.hasVar) 
			{	
				if (yearLen < 4)
				{	
					yearLen += 1;
					if (yearLen == 4) lastChar = CHAR(-);
				}
			}
		}
	}
	
	
	if (yearIdx.hasVar == No || monthIdx.hasVar == No || dayIdx.hasVar == No)
		return DT2001_nuble();
		
	NubleInt year = Int_parse([value substring :yearIdx.vd :yearLen]);
	NubleInt month = Int_parse([value substring :monthIdx.vd :monthLen]);
	NubleInt day = Int_parse([value substring :dayIdx.vd :dayLen]);
	
	if (year.hasVar == No || month.hasVar == No || day.hasVar == No)
		return DT2001_nuble();
		
		
	if (year.vd < 1000 && yearLen <= 2)
		year = Int_toNuble(year.vd + 2000);
	
	
	NubleInt hour = Int_nuble(), minute = Int_nuble(), second = Int_nuble();
	
	if (hourIdx.hasVar) hour = Int_parse([value substring :hourIdx.vd :hourLen]);
	if (minuteIdx.hasVar) minute = Int_parse([value substring :minuteIdx.vd :minuteLen]);
	if (secondIdx.hasVar) second = Int_parse([value substring :secondIdx.vd :secondLen]);
	
	return DT2001_toNuble(DT2001_createYMDHMS(year.vd, month.vd, day.vd, hour.vd, minute.vd, second.vd));
}








String* DT2001_printYMD(DT2001 value)
{
	SELFTEST_START
		[DT2001_printYMD(DT2001_createYMD(2001, 2, 3)) assert:@"2001-02-03"];
		[DT2001_printYMD(DT2001_createYMD(2001, 12, 13)) assert:@"2001-12-13"];
	SELFTEST_END
	
	MutableString* result = [MutableString create:10];
	[result append:Int_printPadding(DT2001_year(value), 4)];
	[result append:STR(@"-")];
	[result append:Int_printPadding(DT2001_month(value), 2)];
	[result append:STR(@"-")];
	[result append:Int_printPadding(DT2001_day(value), 2)];
	return [result seal];
}

String* DT2001_printYMDHM(DT2001 value)
{
	SELFTEST_START
		[DT2001_printYMDHM(DT2001_createYMDHM(2001, 2, 3, 4, 5)) assert:@"2001-02-03 04:05"];
		[DT2001_printYMDHM(DT2001_createYMDHM(2001, 12, 13, 14, 15)) assert:@"2001-12-13 14:15"];
	SELFTEST_END

	MutableString* result = [MutableString create:16];
	[result append:Int_printPadding(DT2001_year(value), 4)];
	[result append:STR(@"-")];
	[result append:Int_printPadding(DT2001_month(value), 2)];
	[result append:STR(@"-")];
	[result append:Int_printPadding(DT2001_day(value), 2)];
	[result append:STR(@" ")];
	[result append:Int_printPadding(DT2001_hour(value), 2)];
	[result append:STR(@":")];
	[result append:Int_printPadding(DT2001_minute(value), 2)];
	return [result seal];
}

String* DT2001_printYMDHMS(DT2001 value)
{
	SELFTEST_START
		[DT2001_printYMDHMS(DT2001_createYMDHMS(2001, 2, 3, 4, 5, 6)) assert:@"2001-02-03 04:05:06"];
		[DT2001_printYMDHMS(DT2001_createYMDHMS(2001, 12, 13, 14, 15, 16)) assert:@"2001-12-13 14:15:16"];
	SELFTEST_END

	MutableString* result = [MutableString create:19];
	[result append:Int_printPadding(DT2001_year(value), 4)];
	[result append:STR(@"-")];
	[result append:Int_printPadding(DT2001_month(value), 2)];
	[result append:STR(@"-")];
	[result append:Int_printPadding(DT2001_day(value), 2)];
	[result append:STR(@" ")];
	[result append:Int_printPadding(DT2001_hour(value), 2)];
	[result append:STR(@":")];
	[result append:Int_printPadding(DT2001_minute(value), 2)];
	[result append:STR(@":")];
	[result append:Int_printPadding(DT2001_second(value), 2)];
	return [result seal];
}


String* DT2001_printHM(DT2001 value)
{
	SELFTEST_START
		[DT2001_printHM(DT2001_createYMDHM(2006, 2, 3, 4, 5)) assert:@"04:05"];
		[DT2001_printHM(DT2001_createYMDHM(2006, 12, 13, 14, 15)) assert:@"14:15"];
	SELFTEST_END

	MutableString* result = [MutableString create:5];
	[result append:Int_printPadding(DT2001_hour(value), 2)];
	[result append:STR(@":")];
	[result append:Int_printPadding(DT2001_minute(value), 2)];	
	return [result seal];
}





















