


#import "DataType.h"



#define ALPHABET_COUNT 26
#define UPPER_ALPHABET @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define LOWER_ALPHABET @"abcdefghijklmnopqrstuvwxyz"





Char Char_lower(Char value)
{
	SELFTEST_START
	
	ASSERT(Char_lower(CHAR(t)) == CHAR(t));
	ASSERT(Char_lower(CHAR(T)) == CHAR(t));
	ASSERT(Char_lower(CHAR($)) == CHAR($));

	SELFTEST_END
	
	
    for (UInt i = 0; i < ALPHABET_COUNT; i++) 
        if (value == [UPPER_ALPHABET characterAtIndex:i])
            return [LOWER_ALPHABET characterAtIndex:i]; 
       
    return value;
}





Char Char_upper(Char value)
{
	SELFTEST_START

	ASSERT(Char_upper(CHAR(t)) == CHAR(T));
	ASSERT(Char_upper(CHAR(T)) == CHAR(T));
	ASSERT(Char_upper(CHAR($)) == CHAR($));
			
	SELFTEST_END
	
	
    for (UInt i = 0; i < ALPHABET_COUNT; i++) 
        if (value == [LOWER_ALPHABET characterAtIndex:i])
            return [UPPER_ALPHABET characterAtIndex:i]; 
       
    return value;
}






	
Bool Char_isDigit(Char value)
{
	SELFTEST_START

	ASSERT(Char_isDigit(CHAR(1)) == YES);
	ASSERT(Char_isDigit(CHAR(R)) == NO);

	SELFTEST_END
	

	for (UInt i = 0; i <= 9; i++) 
		if (value == [@"0123456789" characterAtIndex:i])
			return YES;
			
	return NO;
}

Bool Char_isAlphabet(Char value)
{
	SELFTEST_START

	ASSERT(Char_isAlphabet(CHAR(1)) == NO);
	ASSERT(Char_isAlphabet(CHAR(R)) == YES);

	SELFTEST_END
	
	
	for (UInt i = 0; i < ALPHABET_COUNT; i++) 
		if (value == [LOWER_ALPHABET characterAtIndex:i] || value == [UPPER_ALPHABET characterAtIndex:i])
			return YES;
			
	return NO;
}
	



Char Char_decimalSeparator(void)
{
    NSLocale* locale = [NSLocale currentLocale];
	Char result = CHAR(.);
	String* str = STR([locale objectForKey:NSLocaleDecimalSeparator]);
	
	if (str.length == 1)
		result = [str charAt:0];
	
	return result;
}

	
	


void Char_selfTest(void)
{

	Char_lower(CHAR_SP);
	Char_upper(CHAR_SP);
		
	Char_isDigit(CHAR_SP);
	Char_isAlphabet(CHAR_SP);




}
	






