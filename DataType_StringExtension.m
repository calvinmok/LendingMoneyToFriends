




#import "DataType.h"




Bool _String_isValidSubstringArg(Int selfLength, Int start, Int length);
Bool _String_isValidSubstringArg(Int selfLength, Int start, Int length)
{	
	if (length == 0)
		return YES;
		
	if (start < 0 || length < 0) 
		return NO;
		
	if (selfLength == 0)
		return (start == 0 && length == 0);
			
	if (start > (selfLength - 1))
		return NO;
			
	if (length == 0)
		return (start <= (selfLength - 1));
			
	return (start + length - 1 <= (selfLength - 1));
}

Bool String_isValidSubstringArg(Int selfLength, Int start, Int length)
{	
	Bool result = _String_isValidSubstringArg(selfLength, start, length);
	
//	BREAK_IF(result == NO);
	
	return result;
}







SealedString* String_empty(void)
{
	static SealedString* value = nil;
	if (value == nil) value = [[SealedString create:@""] retain];
	return value;
}



SealedString* String_concat(String* x, String* y)
{
	SELFTEST_START
	
	[String_concat(STR(@""), STR(@"bbb")) assert:@"bbb"];
	[String_concat(STR(@"aaa"), STR(@"")) assert:@"aaa"];
	[String_concat(STR(@"aaa"), STR(@"bbb")) assert:@"aaabbb"];
	
	SELFTEST_END
	
	
	MutableString* result = [MutableString create:10];
	[result append:x];
	[result append:y];
	return [result seal];
}

SealedString* String_concat3(String* s1, String* s2, String* s3)
{
	MutableString* result = [MutableString create:10];
	[result append:s1];
	[result append:s2];
	[result append:s3];
	return [result seal];
}

NubleBool String_isSmallerXY(String* x, String* y)
{
	for (Int i = 0; i < Int_min(x.length, y.length); i++)
	{
		NubleBool b = Char_isSmallerXY([x charAt:i], [y charAt:i]);
		if (b.hasVar)
			return b;
	}
	
	return Int_isSmallerXY(x.length, y.length);	
}






@implementation String (_)
    
			
	- (Char) firstChar { return [self charAt:self.firstIndex]; }
	- (Char) lastChar { return [self charAt:self.lastIndex]; }
	
	- (NubleChar) firstChar_ { NubleInt i = self.firstIndex_; return (i.hasVar) ? [self charAt_:i.vd] : Char_nuble(); }
	- (NubleChar) lastChar_ { NubleInt i = self.lastIndex_; return (i.hasVar) ? [self charAt_:i.vd] : Char_nuble(); }
	

	- (NubleChar) charAt_:(Int)index { return [self isValidIndex:index] ? Char_toNuble([self charAt:index]) : Char_nuble(); }
        
		
		
	
	- (Bool) eq :(String*)other
	{
		return [self eq :other :0 :other.length];
	}
	
	- (Bool) eq :(String*)other :(Int)start :(Int)length
	{
		if (self == other)
			return YES;
		
		if (length != self.length)
			return NO;
		
		for (Int i = 0; i < length; i++)
		{
			Char ch1 = [self charAt:i];
			Char ch2 = [other charAt:start + i];
			
			if (ch1 != ch2)
				return NO;
		}
		
		return YES;	
	}
	
	
	- (Bool) eqNS :(NSString*)other
	{
		return [self eqNS :other :0 :other.length];
	}
	
	- (Bool) eqNS :(NSString*)other :(Int)start :(Int)length
	{
		if (length != self.length)
			return NO;
				
		for (Int i = 0; i < length; i++)
		{
			Char ch1 = [self charAt:i];
			Char ch2 = [other characterAtIndex:toUInt(start + i)];
			
			if (ch1 != ch2)
				return NO;
		}
		
		return YES;	
	}

	- (NubleBool) localizedIsSmallerThan:(String*)other
	{
		NSComparisonResult result = [self.ns localizedCompare:other.ns];
		
		if (result == NSOrderedAscending) return nubleYes();
		if (result == NSOrderedDescending) return nubleNo();
		return Bool_nuble();
	}
	
	
	
	
    

	- (Bool) startWith:(String*)value
	{		
		if (value.length > self.length)
			return NO;
	
		for (Int i = 0; i < value.length; i++)
			if ([self charAt:i] != [value charAt:i])
				return NO;
	
		return YES;
	}
	
	- (Bool) startWithNS:(NSString*)value
	{
		if (value.length > toUInt(self.length))
			return NO;
	
		for (UInt i = 0; i < value.length; i++)
			if ([self charAt:toInt(i)] != [value characterAtIndex:i])
				return NO;
	
		return YES;
	}
	
	
	- (Bool) endWith:(String*)value
	{
		if (value.length > self.length)
			return NO;
	
		for (Int i = 0; i < value.length; i++)
			if ([self charAt:self.lastIndex - i] != [value charAt:value.lastIndex - i])
				return NO;
	
		return YES;
	}

	- (Bool) endWithNS:(NSString*)value
	{
		if (value.length > toUInt(self.length))
			return NO;
	
		for (UInt i = 0; i < value.length; i++)
			if ([self charAt:toInt(self.lastIndex - i)] != [value characterAtIndex:value.length - 1 - i])
				return NO;
	
		return YES;
	}
	
	
	
	
 	- (Bool) isValidArg_Substring :(Int)start :(Int)length
	{
		return String_isValidSubstringArg(self.length, start, length);
	}
   
	     
	
	
	- (SealedString*) front:(Int)length { return [self substring :0 :length]; }
	- (SealedString*) back:(Int)length { return [self startAt :self.lastIndex - length + 1]; }
	
	- (SealedString*) cutFront:(Int)length { return [self back :self.length - length]; }
	- (SealedString*) cutBack:(Int)length { return [self front :self.length - length]; }


	- (SealedString*) startEndAt :(Int)start :(Int)end 
	{
		ASSERT(start <= end); return [self substring :start :end - start + 1];
	}

	- (SealedString*) startAt:(Int)index { return [self substring :index :self.lastIndex - index + 1]; }
	- (SealedString*) endAt:(Int)index { return [self substring :0 :index + 1]; }

    
	
	
	- (void) getAllCharacter:(Char*)buffer
	{
		for (Int i = 0; i < self.length; i++)
			buffer[i] = [self charAt:i];
	}
	
	
   
    
    	
	- (SealedString*) replacement:(String*)target :(String*)substitution
	{
		MutableString* result = [MutableString createWithString:self];
		[result replace :target :substitution];
		return [result seal];
	}
    
    
    
    
    
	- (NubleInt) indexOfChar :(Char)value
	{
		SELFTEST_START
			ASSERT([STR(@"abcdef") indexOfChar:CHAR(b)].vd == 1);
			ASSERT([STR(@"abcdef") indexOfChar:CHAR(z)].hasVar == NO);
		SELFTEST_END
		
		return [self indexOfChar:value from:0];
	}
	- (NubleInt) indexOfChar :(Char)value from:(Int)begin
	{
		for (Int i = begin; i < self.length; i++)
			if ([self charAt:i] == value)
				return Int_toNuble(i);
		
		return Int_nuble();
	}



	- (Bool) isValidArg_indexOf :(String*)value :(Int)begin
	{
		if (begin < 0) 
			return NO;

		if (self.length == 0 || value.length == 0) 
			return YES;
				
		if (value.length > self.length) 
			return NO;		
			
		return (begin + value.length - 1 <= self.lastIndex);
	}

	- (NubleInt) indexOf :(String*)value
	{
		return [self indexOf :value :0];
	}
	- (NubleInt) indexOf :(String*)value :(Int)begin
	{
		SELFTEST_START
			ASSERT([STR(@"") indexOf :STR(@"") :3].vd == 3);

			ASSERT([STR(@"abcabc") indexOf :STR(@"") :0].vd == 0);
			ASSERT([STR(@"abcabc") indexOf :STR(@"") :3].vd == 3);

			ASSERT([STR(@"abcabc") indexOf :STR(@"a") :0].vd == 0);
			ASSERT([STR(@"abcabc") indexOf :STR(@"abc") :0].vd == 0);		
			ASSERT([STR(@"abcabc") indexOf :STR(@"c") :0].vd == 2);
			ASSERT([STR(@"abcabc") indexOf :STR(@"cabc") :0].vd == 2);
			
			ASSERT([STR(@"abcabc") indexOf :STR(@"a") :1].vd == 3);
			ASSERT([STR(@"abcabc") indexOf :STR(@"abc") :1].vd == 3);		

			ASSERT([STR(@"abcabc") indexOf :STR(@"a") :3].vd == 3);
			ASSERT([STR(@"abcabc") indexOf :STR(@"abc") :3].vd == 3);		
		SELFTEST_END
		

		ASSERT([self isValidArg_indexOf :value :begin]);
		
		if (value.length == 0)
			return Int_toNuble(begin);
		
		Int index = 0;
		
		for (Int i = begin; i < self.length; i++)
		{
			if ([self charAt:i] == [value charAt:index])
			{
				if (index == value.lastIndex)
					return Int_toNuble(i - index);
					
				index++;
			}
		}
		
		return Int_nuble();
	}

	- (Bool) contain :(String*)value
	{
		return [self indexOf:value].hasVar;
	}



	- (Int) countChar:(Char)value
	{
		Int result = 0;
		
		ForEachIndex(i, self)
		{
			if ([self charAt:i] == value)
				result += 1;
		}
		
		return result;		
	}



	
	- (SealedString*) lower
    {
		SELFTEST_START
			[[[String create:@"aBc"] lower] assert:@"abc"];
		SELFTEST_END

        MutableString* result = nil;
        
        for (Int i = 0; i < self.length; i++)
        {
            Char ch = [self charAt:i];
            Char lower = Char_lower(ch);
            
            if (lower != ch)
            {
                if (result == nil)
                    result = [MutableString createWithString:self];
                    
                [result setCharAt :i :lower];
            }
        }
        
		if (result != nil)
            return [result seal];
        else
            return [self toSealed];
    }
    
	- (SealedString*) upper
    {
		SELFTEST_START
			[[[String create:@"aBc"] upper] assert:@"ABC"];
		SELFTEST_END
			
        MutableString* result = nil;
        
        for (Int i = 0; i < [self length]; i++)
        {
            Char ch = [self charAt:i];
            Char upper = Char_upper(ch);
            
            if (upper != ch)
            {
                if (result == nil)
                    result = [MutableString createWithString:self];

                [result setCharAt :i :upper];
            }
        }		
        
        if (result != nil)
            return [result seal];
        else
            return [self toSealed];
    }
    
    

	- (StringMutableList*) split:(String*)separator
	{
		ASSERT(separator.length > 0);
				
		StringMutableList* result = [StringMutableList create];
		
		SealedString* s = [self toSealed];
		
		while (Yes)
		{
			NubleInt i = [s indexOf:separator];
			
			if (i.hasVar == No) 
			{
				[result append:s];
				break;
			}
				
			[result append:[[s endAt:i.vd] cutBack:1]];
			
			s = [[s startAt:i.vd] cutFront:separator.length];
			
			if (s.length < separator.length)
			{
				[result append:s];
				break;
			}
		}
				
		return result;
	}
	

    
		
	
	
	
	

	
	+ (String*) toBase64:(NSData*)data
	{
		String* base64Str = STR(@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/");
	
		MutableString* result = [MutableString create:(data.length / 3) * 2];
		
		for (NSUInteger i = 0; i < data.length; i+= 3)
		{
			Byte* bytes = (Byte*)data.bytes;
			NubleByte byte0 = Byte_nuble();
			NubleByte byte1 = Byte_nuble();
			NubleByte byte2 = Byte_nuble();
			
			if (i + 0 <= data.length - 1) byte0 = Byte_toNuble(bytes[i + 0]);
			if (i + 1 <= data.length - 1) byte1 = Byte_toNuble(bytes[i + 1]);
			if (i + 2 <= data.length - 1) byte2 = Byte_toNuble(bytes[i + 2]);
			
			if (byte0.hasVar)
			{
				Byte bR = Byte_range(byte0.vd, 2, 6);
				[result appendChar:[base64Str charAt:bR]];
			}
			
			if (byte0.hasVar && byte1.hasVar)
			{
				Byte b0 = Byte_range(byte0.vd, 0, 2);
				Byte b1 = Byte_range(byte1.vd, 4, 4);
				Byte bR = Byte_shift(b0, 4) + b1;
				[result appendChar:[base64Str charAt:bR]];
			}
			
			if (byte0.hasVar && byte1.hasVar && byte2.hasVar)
			{
				{
					Byte b0 = Byte_range(byte1.vd, 0, 4);
					Byte b1 = Byte_range(byte2.vd, 6, 2);
					Byte bR = Byte_shift(b0, 2) + b1;
					[result appendChar:[base64Str charAt:bR]];
				}
				{
					Byte bR = Byte_range(byte1.vd, 0, 6);
					[result appendChar:[base64Str charAt:bR]];
				}
			}
		}
		
		return [result seal];		
	}
	
	+ (NSData*) fromBase64:(String*)data
	{
		return nil;
		/*
		Int capacity = Double_toInt(data.length * (3.0 / 4.0)) + 1;
		
		NSMutableData* result = [NSMutableData dataWithCapacity:capacity];
		
		for (Int i = 0; i < data.length; i += 4)
		{
			[result appendData:
		}
	
	
static unsigned char base64DecodeLookup[256] =
{
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 62, xx, xx, xx, 63, 
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, xx, xx, xx, xx, xx, xx, 
    xx,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, xx, xx, xx, xx, xx, 
    xx, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
};	
unsigned char accumulated[BASE64_UNIT_SIZE];
size_t accumulateIndex = 0;
while (i < length)
{
    unsigned char decode = base64DecodeLookup[inputBuffer[i++]];
    if (decode != xx)
    {
        accumulated[accumulateIndex] = decode;
        accumulateIndex++;
         
        if (accumulateIndex == BASE64_UNIT_SIZE)
        {
            break;
        }
    }
}	*/

	}
	
		
		
	
	- (void) assert:(NSString*)value
	{
		NSString* str = self.ns;
		ASSERT([str isEqualToString:value]);
	}
	


@end










@implementation SealedString (_)


	
@end






@implementation MutableString (_)

    
    

    - (void) append:(String*)value
    {
		NSString* v = value.ns;
		
		
        [self appendNS:v];
    }
	- (void) appendChar:(unichar)value
    {
        [self appendNS:[NSString stringWithCharacters:&value length:1]];
    }


    - (void) insert:(String*)value
    {
        [self insertAtNS :0 :value.ns];
    }
    - (void) insertAt :(Int)index :(String*)value
    {
        [self insertAtNS :index :value.ns];
    }
    
    - (void) insertChar:(Char)value 
    {
        [self insertAtNS :0 :[NSString stringWithCharacters:&value length:1]];
    }
    - (void) insertCharAt :(Int)index :(Char)value
    {
        [self insertAtNS :index :[NSString stringWithCharacters:&value length:1]];
    }
    
	
	- (void) removeAt:(Int)index
	{
		[self removeRange:index :1];
	}


	- (void) replace:(String*)target :(String*)substitution
	{
		[self replaceNS :target.ns :substitution.ns];
	}

    
@end











void MutableString_selfTest(void)
{
	MutableString* str = [MutableString createWithString:STR(@"")];
	[str assert:@""];
	
	[str append:[String create:@"111"]];
	[str assert:@"111"];
	
	[str appendNS:@"222"];
	[str assert:@"111222"];
	
	[str insertAtNS :3 :@"abc"];
	[str assert:@"111abc222"];
	
	[str removeAt:3];
	[str assert:@"111bc222"];
	
	[str removeRange:3 :2];
	[str assert:@"111222"];
	
	[str replaceNS:@"222" :@"555"];
	[str assert:@"111555"];
	
	[str setCharAt :1 :CHAR(2)];
	[str assert:@"121555"];
}



void String_selfTest(void)
{

	String* testingStr = [String create:@"testing"];
	
	ASSERT([String create:@""].length == 0);
	ASSERT([String create:@"-"].length == 1);
	ASSERT([String create:@"-"].length == 1);

	ASSERT(String_empty().length == 0);

	[[testingStr startAt:1] assert:@"esting"];
	[[testingStr substring:1 :3] assert:@"est"];
	[[testingStr startEndAt :1 :5] assert:@"estin"];
	

	ASSERT([STR(@"aBc") eqNS :@"--aBc-" :2 :3]);


	[STR(@"   ") indexOf:STR(@" ")];
	[STR(@"   ") replacement :0 :0 :STR(@" ")];
	
	[STR(@"   ") matchExcelPattern :STR(@" ")];
	
		

	MutableString_selfTest();
}








