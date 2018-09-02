





#import "DataType.h"





	
STRUCT_LIST_IMPLEMENTATION_TEMPLATE(Int)
STRUCT_LIST_IMPLEMENTATION_TEMPLATE(UInt)



@implementation IntMutableList (_)

	- (void) addAt :(Int)index :(Int)value
	{
		Int newValue = [self at:index] + value;		
		[self modifyAt :index :newValue];		
	}
	
@end





Int Int_mod(Int x, Int y)
{
	ASSERT(x >= 0 && y > 0);

	SELFTEST_START

	ASSERT(Int_mod(0, 3) == 0);
	ASSERT(Int_mod(1, 3) == 1);
	ASSERT(Int_mod(2, 3) == 2);
	ASSERT(Int_mod(3, 3) == 0);
	ASSERT(Int_mod(4, 3) == 1);
	ASSERT(Int_mod(5, 3) == 2);
	ASSERT(Int_mod(6, 3) == 0);

	SELFTEST_END
	
	return x % y;
}





Bool Int_isEven(Int value)
{
	SELFTEST_START

	ASSERT(Int_isEven(-3) == NO);
	ASSERT(Int_isEven(-2) == YES);
	ASSERT(Int_isEven(-1) == NO);
	ASSERT(Int_isEven(0) == YES);
	ASSERT(Int_isEven(1) == NO);
	ASSERT(Int_isEven(2) == YES);
	ASSERT(Int_isEven(3) == NO);
	
	SELFTEST_END
		
	return ((Int_abs(value) % 2) == 0);
}

Bool Int_isOdd(Int value)
{
	SELFTEST_START
	
	ASSERT(Int_isEven(-3) == YES);
	ASSERT(Int_isEven(-2) == NO);
	ASSERT(Int_isEven(-1) == YES);
	ASSERT(Int_isEven(0) == NO);
	ASSERT(Int_isEven(1) == YES);
	ASSERT(Int_isEven(2) == NO);
	ASSERT(Int_isEven(3) == YES);
	
	SELFTEST_END
	
	return ((Int_abs(value) % 2) == 1);
}




NubleChar Int_toChar(Int value)
{
	SELFTEST_START
	
	ASSERT(Int_toChar(32).vd == CHAR_SP);
	ASSERT(Int_toChar(65).vd == CHAR(A));

	SELFTEST_END
	
	return (Char_Min <= value && value <= Char_Max) ? Char_toNuble((Char)value) : Char_nuble();
}
	
	
	
	
	
	




NubleInt Int_parseChar(Char value)
{
	SELFTEST_START
	
	ASSERT(Int_parseChar(CHAR(0)).vd == 0);
	ASSERT(Int_parseChar(CHAR(1)).vd == 1);
	ASSERT(Int_parseChar(CHAR(2)).vd == 2);
	ASSERT(Int_parseChar(CHAR(3)).vd == 3);
	ASSERT(Int_parseChar(CHAR(4)).vd == 4);
	ASSERT(Int_parseChar(CHAR(5)).vd == 5);
	ASSERT(Int_parseChar(CHAR(6)).vd == 6);
	ASSERT(Int_parseChar(CHAR(7)).vd == 7);
	ASSERT(Int_parseChar(CHAR(8)).vd == 8);
	ASSERT(Int_parseChar(CHAR(9)).vd == 9);
	ASSERT(Int_parseChar(CHAR($)).hasVar == NO);
	
	SELFTEST_END


    for (UInt i = 0; i <= 9; i++) 
        if ([@"0123456789" characterAtIndex:i] == value)
			return Int_toNuble(toInt(i));
		
	return Int_nuble();
}

NubleUInt UInt_parseChar(Char value)
{
    for (UInt i = 0; i <= 9; i++) 
        if ([@"0123456789" characterAtIndex:i] == value)
			return UInt_toNuble(i);
		
	return UInt_nuble();
}
	

	
NubleChar Int_printChar(Int value)
{
	SELFTEST_START
	
	ASSERT(Int_printChar(0).vd == CHAR(0));
	ASSERT(Int_printChar(1).vd == CHAR(1));
	ASSERT(Int_printChar(2).vd == CHAR(2));
	ASSERT(Int_printChar(3).vd == CHAR(3));
	ASSERT(Int_printChar(4).vd == CHAR(4));
	ASSERT(Int_printChar(5).vd == CHAR(5));
	ASSERT(Int_printChar(6).vd == CHAR(6));
	ASSERT(Int_printChar(7).vd == CHAR(7));
	ASSERT(Int_printChar(8).vd == CHAR(8));
	ASSERT(Int_printChar(9).vd == CHAR(9));
	ASSERT(Int_printChar(100).hasVar == NO);
	
	SELFTEST_END
	

    for (UInt i = 0; i <= 9; i++) 
        if (value == toInt(i))
			return Char_toNuble([@"0123456789" characterAtIndex:i]);
		
	return Char_nuble();
}

NubleChar UInt_printChar(UInt value)
{
	SELFTEST_START
	SELFTEST_END

    for (UInt i = 0; i <= 9; i++) 
        if (value == i)
			return Char_toNuble([@"0123456789" characterAtIndex:i]);
		
	return Char_nuble();
}






	
NubleInt Int_parse(String* value)
{
	SELFTEST_START
	
	ASSERT(Int_var(Int_parse(STR(@"-76"))) == -76);
	ASSERT(Int_var(Int_parse(STR(@"-1"))) == -1);
	ASSERT(Int_var(Int_parse(STR(@"0"))) == 0);
	ASSERT(Int_var(Int_parse(STR(@"1"))) == 1);
	ASSERT(Int_var(Int_parse(STR(@"76"))) == 76);
	
	SELFTEST_END
	
	
	if (value.length == 0)
		return Int_nuble();

	Int result = 0;
	
	Int i = 0;
	
	BOOL isNegative = NO;
	if ([value charAt:i] == CHAR(-))
	{
		i++;
		isNegative = YES;
	}
	
	for (; i < value.length; i++)
	{
		if ([value charAt:i] != '0')
			break;
	}
	
	for (; i < value.length; i++)
	{
		NubleInt n = Int_parseChar([value charAt:i]);
		if (n.hasVar == NO)
			return Int_nuble();
		
		result *= 10;
		result += n.vd;
	}
	
	if (isNegative)
		result *= -1;
	
	return Int_toNuble(result);
}

NubleUInt UInt_parse(String* value)
{
	SELFTEST_START
	
	ASSERT(UInt_var(UInt_parse(STR(@"0"))) == 0);
	ASSERT(UInt_var(UInt_parse(STR(@"1"))) == 1);
	ASSERT(UInt_var(UInt_parse(STR(@"76"))) == 76);
	
	SELFTEST_END
	
	
	if (value.length == 0)
		return UInt_nuble();

	UInt result = 0;
	
	Int i = 0;
	
	for ( ; Yes; i++)
	{
		if ([value charAt:i] != '0')
			break;
	}
		
	for (; i < value.length; i++)
	{
		NubleUInt n = UInt_parseChar([value charAt:i]);
		if (n.hasVar == NO)
			return UInt_nuble();
		
		result *= 10;
		result += n.vd;
	}
	
	return UInt_toNuble(result);
}






	

String* Int_print(Int value)
{
	return Int_printPadding(value, 0);
}

String* UInt_print(UInt value)
{
	SELFTEST_START
	
	[UInt_print(0) assert:@"0"];
	[UInt_print(1) assert:@"1"];
	[UInt_print(76) assert:@"76"];
	
	SELFTEST_END
	
	
	MutableString* result = [MutableString create:10];
	
	if (value == 0) 
		[result insertChar:CHAR(0)];
	
	while (value > 0)
	{
		UInt n = value % 10;
		[result insertChar:UInt_printChar(n).vd];
		
		value -= n;
		value /= 10;
	}
	
	return [result seal];  
}
	
	
	

String* Int_printPadding(Int value, Int padding)
{
	SELFTEST_START
	
	[Int_print(-76) assert:@"-76"];
	[Int_print(-1) assert:@"-1"];
	[Int_print(0) assert:@"0"];
	[Int_print(1) assert:@"1"];
	[Int_print(76) assert:@"76"];
	
	[Int_printPadding(0, 0) assert:@"0"];
	[Int_printPadding(0, 1) assert:@"0"];
	[Int_printPadding(0, 2) assert:@"00"];
	[Int_printPadding(3, 0) assert:@"3"];
	[Int_printPadding(3, 1) assert:@"3"];
	[Int_printPadding(3, 2) assert:@"03"];
	[Int_printPadding(76, 0) assert:@"76"];
	[Int_printPadding(76, 1) assert:@"76"];
	[Int_printPadding(76, 2) assert:@"76"];
	[Int_printPadding(76, 3) assert:@"076"];
	
	SELFTEST_END
	
	
	MutableString* result = [MutableString create:(value < 10) ? 1 : 2];

	if (value == 0) 
		[result insertChar:CHAR(0)];
	
	BOOL isNegative = (value < 0);
	
	if (isNegative) value = -value;
	
	while (value > 0)
	{
		Int n = value % 10;
		[result insertChar:Int_printChar(n).vd];
		
		value -= n;
		value /= 10;
	}
	
	if (isNegative)
		[result insertChar:CHAR(-)];
	
			
	while (result.length < padding)
	{
		[result insertChar:CHAR(0)];
	}

	return [result seal];
}







