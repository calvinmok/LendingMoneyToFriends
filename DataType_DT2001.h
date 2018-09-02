





typedef NSTimeInterval DT2001;

NUBLE_STRUCT_TEMPLATE(DT2001)





Int DT2001_year(DT2001 value);
Int DT2001_month(DT2001 value);
Int DT2001_day(DT2001 value);
Int DT2001_hour(DT2001 value);
Int DT2001_minute(DT2001 value);
Int DT2001_second(DT2001 value);






NSDate* DT2001_toNSDate(DT2001 value);
DT2001  DT2001_fromNSDate(NSDate* value);



DT2001 DT2001_createNow(void);

DT2001 DT2001_createYMD(Int year, Int month, Int day);
DT2001 DT2001_createYMDHM(Int year, Int month, Int day, Int hour, Int minute);
DT2001 DT2001_createYMDHMS(Int year, Int month, Int day, Int hour, Int minute, Int second);


NubleDT2001 DT2001_parse(String* value);


String* DT2001_printYMD(DT2001 value);
String* DT2001_printYMDHM(DT2001 value);
String* DT2001_printYMDHMS(DT2001 value);

String* DT2001_printHM(DT2001 value);





NS_INLINE NubleBool DT2001_isSmallerXY(DT2001 x, DT2001 y)
{
	return (x == y) ? Bool_nuble() : Bool_toNuble(x < y);
}



NS_INLINE void DT2001_assert(DT2001 value, Int year, Int month, Int day, Int hour, Int min, Int sec)
{
	ASSERT(DT2001_year(value) == year);
	ASSERT(DT2001_month(value) == month);
	ASSERT(DT2001_day(value) == day);
	ASSERT(DT2001_hour(value) == hour);
	ASSERT(DT2001_minute(value) == min);
	ASSERT(DT2001_second(value) == sec);
}




