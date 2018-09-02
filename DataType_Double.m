




#import "DataType.h"


STRUCT_LIST_IMPLEMENTATION_TEMPLATE(Double)



Double Double_mod(Double numerator, Double denominator)
{
	SELFTEST_START
	
	ASSERT(Double_mod(10.0, 3.0) == 1.0);
	ASSERT(Double_mod(10.0, 3.0) == 1.0);
	ASSERT(Double_mod(400.0, 10.0) == 0.0);
	
	ASSERT(Double_mod(0.0, 3.0) == 0.0);
	ASSERT(Double_mod(0.0, 3.2343) == 0.0);

	SELFTEST_END
	
	if (Double_aEqual(denominator, 0.0))
		return 0.0;
	
	return fmod(numerator, denominator);
	
}



Int Double_digit(Double value, Int point)
{
	SELFTEST_START
	
	ASSERT(Double_digit(321.123, 7) == 0);
	ASSERT(Double_digit(321.123, 6) == 0);
	ASSERT(Double_digit(321.123, 5) == 0);
	ASSERT(Double_digit(321.123, 4) == 0);
	ASSERT(Double_digit(321.123, 3) == 3);
	ASSERT(Double_digit(321.123, 2) == 2);
	ASSERT(Double_digit(321.123, 1) == 1);
	ASSERT(Double_digit(321.123, -1) == 1);
	ASSERT(Double_digit(321.123, -2) == 2);
	ASSERT(Double_digit(321.123, -3) == 3);
	ASSERT(Double_digit(321.123, -4) == 0);
	ASSERT(Double_digit(321.123, -5) == 0);
	ASSERT(Double_digit(321.123, -6) == 0);
	ASSERT(Double_digit(321.123, -7) == 0);
	
	ASSERT(Double_digit(0.0, -2) == 0);
	ASSERT(Double_digit(0.0, -1) == 0);
	ASSERT(Double_digit(0.0, +1) == 0);
	ASSERT(Double_digit(0.0, +2) == 0);
	
	SELFTEST_END
	
	ASSERT(point != 0);
	
	if (point > 0)
		point = point - 1;
		
	Double pow10 = Double_pow10(point);
	Double round = Double_roundAsDouble(value / pow10);
	Double mod = Double_mod(round, 10.0);
	return Double_toInt(mod);
}


Int Double_numberOfDigitAfterDecimalPoint(Double value, Int limit)
{
	SELFTEST_START
	
	ASSERT(Double_numberOfDigitAfterDecimalPoint(0.12300, 10) == 3);
	ASSERT(Double_numberOfDigitAfterDecimalPoint(0.10000, 10) == 1);
	ASSERT(Double_numberOfDigitAfterDecimalPoint(0.00300, 10) == 3);
	ASSERT(Double_numberOfDigitAfterDecimalPoint(123, 10) == 0);
	
	ASSERT(Double_numberOfDigitAfterDecimalPoint(0.1234567, 3) == 3);
	ASSERT(Double_numberOfDigitAfterDecimalPoint(0.0, 3) == 0);
	ASSERT(Double_numberOfDigitAfterDecimalPoint(0.00000001, 3) == 0);

	ASSERT(Double_numberOfDigitAfterDecimalPoint(0.0, 0) == 0);
	ASSERT(Double_numberOfDigitAfterDecimalPoint(0.1234567, 0) == 0);

	SELFTEST_END
	
	
	ASSERT(limit >= 0);


	for (Int i = -limit; i < 0; i++)
	{
		Int digit = Double_digit(value, i);
		if (digit != 0)
			return -i;
	}
	
	return 0;	
}




NubleChar Double_printChar(Double value)
{
	SELFTEST_START

	ASSERT(Double_printChar(-0.51000).hasVar == NO);
	ASSERT(Double_printChar(-0.50000).vd == CHAR(0));
	ASSERT(Double_printChar(-0.49999).vd == CHAR(0));
	ASSERT(Double_printChar(0.000000).vd == CHAR(0));
	ASSERT(Double_printChar(0.100000).vd == CHAR(0));
	ASSERT(Double_printChar(0.499999).vd == CHAR(0));
	
	ASSERT(Double_printChar(0.500000).vd == CHAR(1));
	ASSERT(Double_printChar(2.499999).vd == CHAR(2));
	ASSERT(Double_printChar(2.500000).vd == CHAR(3));

	ASSERT(Double_printChar(9.499999).vd == CHAR(9));
	ASSERT(Double_printChar(9.500000).hasVar == NO);

	SELFTEST_END
	
			
	if (value >= -0.5) 
	{
		value += 0.5;
		value = Double_intpart(value);

		if (value < 0.5) return Char_toNuble(CHAR(0));
		if (value < 1.5) return Char_toNuble(CHAR(1));
		if (value < 2.5) return Char_toNuble(CHAR(2));
		if (value < 3.5) return Char_toNuble(CHAR(3));
		if (value < 4.5) return Char_toNuble(CHAR(4));
		if (value < 5.5) return Char_toNuble(CHAR(5));
		if (value < 6.5) return Char_toNuble(CHAR(6));
		if (value < 7.5) return Char_toNuble(CHAR(7));
		if (value < 8.5) return Char_toNuble(CHAR(8));
		if (value < 9.5) return Char_toNuble(CHAR(9));
	}

	return Char_nuble();
}


NubleDouble Double_parse(String* str)
{
	return Double_parseWithDecimalSeperator(str, Char_decimalSeparator());
}

NubleDouble Double_parseWithDecimalSeperator(String* str, Char decimalSeparator)
{
	SELFTEST_START
	
	Char ds = CHAR(.);
	
	ASSERT(Double_parseWithDecimalSeperator(STR(@"0"), ds).hasVar);
	ASSERT(Double_parseWithDecimalSeperator(STR(@"0"), ds).vd == 0.0);
	ASSERT(Double_parseWithDecimalSeperator(STR(@"0.0"), ds).hasVar);
	ASSERT(Double_parseWithDecimalSeperator(STR(@"0.0"), ds).vd == 0.0);
	ASSERT(Double_parseWithDecimalSeperator(STR(@"0.00"), ds).hasVar);
	ASSERT(Double_parseWithDecimalSeperator(STR(@"0.00"), ds).vd == 0.0);

	ASSERT(Double_parseWithDecimalSeperator(STR(@"-1"), ds).vd == -1.0);
	ASSERT(Double_parseWithDecimalSeperator(STR(@"-1.0"), ds).vd == -1.0);
	
	ASSERT(Double_parseWithDecimalSeperator(STR(@"1"), ds).vd == 1.0);
	ASSERT(Double_parseWithDecimalSeperator(STR(@"1.0"), ds).vd == 1.0);

	ASSERT(Double_parseWithDecimalSeperator(STR(@"+1"), ds).vd == 1.0);
	ASSERT(Double_parseWithDecimalSeperator(STR(@"+1.0"), ds).vd == 1.0);

	ASSERT(Double_parseWithDecimalSeperator(STR(@"-566"), ds).vd == -566.0);
	ASSERT(Double_parseWithDecimalSeperator(STR(@"-566.566"), ds).vd == -566.566);

	ASSERT(Double_parseWithDecimalSeperator(STR(@"566"), ds).vd == 566.0);
	ASSERT(Double_parseWithDecimalSeperator(STR(@"566.566"), ds).vd == 566.566);

	ASSERT(Double_parseWithDecimalSeperator(STR(@"86800"), ds).vd == 86800.0);
	ASSERT(Double_parseWithDecimalSeperator(STR(@"323.000"), ds).vd == 323);
	
	SELFTEST_END
	

	if (str.length == 0)
		return Double_nuble();
	

	Int index = str.firstIndex;
		
	NubleBool isNegative = Bool_nuble();
	
	Double coefficient = 0.0;
	Int precision = -1;
		
	for (; index < str.length; index++)
	{
		Char ch = [str charAt:index];
		
		if (isNegative.hasVar == No)
		{
			if (ch == CHAR(+)) isNegative = nubleNo(); 
			if (ch == CHAR(-)) isNegative = nubleYes(); 
			
			if (isNegative.hasVar)
				continue;
		}
                            
		if (ch == decimalSeparator)
		{
			precision = 0;
		}
		else
		{
			NubleInt digit = Int_parseChar(ch);
			if (digit.hasVar == NO)
				continue;
                
			if (precision >= 0)
				precision += 1;
                    
			coefficient *= 10.0;
			coefficient += digit.vd;
		}
	}
        
	if (precision == -1)
		precision = 0;
		
	if (isNegative.hasVar && isNegative.vd)
		coefficient *= -1.0;
		
	return Double_toNuble(coefficient / Double_pow10(precision));
}










String* Double_print(Double value, Int precision, DoublePrintSetting setting)
{
	SELFTEST_START
	
	DoublePrintSetting setting = DoublePrintSetting_create2(DoublePrintType_Fixed, CHAR(.));
	 
	[Double_print(-1.0, 0, setting) assert:@"-1"];
	[Double_print(-1.0, 1, setting) assert:@"-1.0"];
	[Double_print(-1.0, 2, setting) assert:@"-1.00"];
	[Double_print(-1.0, 3, setting) assert:@"-1.000"];
	[Double_print(-1.0, 4, setting) assert:@"-1.0000"];

	[Double_print(0.0, 0, setting) assert:@"0"];
	[Double_print(0.0, 1, setting) assert:@"0.0"];
	[Double_print(0.0, 2, setting) assert:@"0.00"];
	[Double_print(0.0, 3, setting) assert:@"0.000"];
	[Double_print(0.0, 4, setting) assert:@"0.0000"];
	
	[Double_print(0.1, 0, setting) assert:@"0"];
	[Double_print(0.1, 1, setting) assert:@"0.1"];
	[Double_print(0.1, 2, setting) assert:@"0.10"];
	[Double_print(0.1, 3, setting) assert:@"0.100"];
	[Double_print(0.1, 4, setting) assert:@"0.1000"];
	
	[Double_print(0.01, 0, setting) assert:@"0"];
	[Double_print(0.01, 1, setting) assert:@"0.0"];
	[Double_print(0.01, 2, setting) assert:@"0.01"];
	[Double_print(0.01, 3, setting) assert:@"0.010"];
	[Double_print(0.01, 4, setting) assert:@"0.0100"];
	
	[Double_print(0.36, 0, setting) assert:@"0"];
	[Double_print(0.36, 1, setting) assert:@"0.4"];
	[Double_print(0.36, 2, setting) assert:@"0.36"];
	[Double_print(0.36, 3, setting) assert:@"0.360"];
	[Double_print(0.36, 4, setting) assert:@"0.3600"];

	[Double_print(1.0, 0, setting) assert:@"1"];
	[Double_print(1.0, 1, setting) assert:@"1.0"];
	[Double_print(1.0, 2, setting) assert:@"1.00"];
	[Double_print(1.0, 3, setting) assert:@"1.000"];
	[Double_print(1.0, 4, setting) assert:@"1.0000"];



	[Double_print(-1000, 0, setting) assert:@"-1000"];
	[Double_print(-1000, 1, setting) assert:@"-1000.0"];
	[Double_print(-1000, 2, setting) assert:@"-1000.00"];
	[Double_print(-1000, 3, setting) assert:@"-1000.000"];
	[Double_print(-1000, 4, setting) assert:@"-1000.0000"];

	[Double_print(1000, 0, setting) assert:@"1000"];
	[Double_print(1000, 1, setting) assert:@"1000.0"];
	[Double_print(1000, 2, setting) assert:@"1000.00"];
	[Double_print(1000, 3, setting) assert:@"1000.000"];
	[Double_print(1000, 4, setting) assert:@"1000.0000"];



	[Double_print(-566.0, 0, setting) assert:@"-566"];
	[Double_print(-566.0, 1, setting) assert:@"-566.0"];
	[Double_print(-566.0, 2, setting) assert:@"-566.00"];
	[Double_print(-566.0, 3, setting) assert:@"-566.000"];
	[Double_print(-566.0, 4, setting) assert:@"-566.0000"];
	

	[Double_print(566.0, 0, setting) assert:@"566"];
	[Double_print(566.0, 1, setting) assert:@"566.0"];
	[Double_print(566.0, 2, setting) assert:@"566.00"];
	[Double_print(566.0, 3, setting) assert:@"566.000"];
	[Double_print(566.0, 4, setting) assert:@"566.0000"];
	
	
	
	[Double_print(-92345.7545, 0, setting) assert:@"-92346"];
	[Double_print(-92345.7545, 1, setting) assert:@"-92345.8"];
	[Double_print(-92345.7545, 2, setting) assert:@"-92345.75"];
	[Double_print(-92345.7545, 3, setting) assert:@"-92345.755"];
	[Double_print(-92345.7545, 4, setting) assert:@"-92345.7545"];

	[Double_print(92345.7545, 0, setting) assert:@"92346"];
	[Double_print(92345.7545, 1, setting) assert:@"92345.8"];
	[Double_print(92345.7545, 2, setting) assert:@"92345.75"];
	[Double_print(92345.7545, 3, setting) assert:@"92345.755"];
	[Double_print(92345.7545, 4, setting) assert:@"92345.7545"];
	
	[Double_print(0.44444, 1, setting) assert:@"0.4"];
	[Double_print(0.44449, 1, setting) assert:@"0.4"];
	
	SELFTEST_END


	if (setting.printType == DoublePrintType_Floating && Double_aEqual(value, 0.0))
		return STR(@"0");
		
		
	MutableString* result = [MutableString create:10];
	
	if (Double_aEqual(value, 0.0))
	{
		[result appendChar:CHAR(0)];
		
		if (precision > 0)
		{
			[result appendChar:setting.decimalSeparator];
			
			for (Int p = 0; p < precision; p++)
				[result appendChar:CHAR(0)];
		}
	}
	else 
	{
		Double v1 = value * Double_pow10(precision);
		Double v2 = round(fabs(v1));
	
		for (Double v = v2; YES; v /= 10.0)
		{
			Double r = fmod(v, 10.0);
		
			Char ch = Double_printChar(Double_intpart(r)).vd;
			[result insertChar:ch];
			
			v -= r;
			if (v == 0.0)
				break;		
		}
		
		while (result.length < precision + 1)
			[result insertChar:CHAR(0)];
	
		if (precision > 0)
		{
			Int index = result.lastIndex - precision + 1;
			[result insertCharAt :index :setting.decimalSeparator];
			
			if (index == 0)
				[result insertCharAt :index :CHAR(0)];
		}

		if (value < 0.0)
			[result insertChar:CHAR(-)];
	}
	
	if (setting.printType == DoublePrintType_Floating)
	{
		for (Int i = result.length - 1; i >= 0; --i)
		{
			if ([result charAt:i] == CHAR(0))
				[result removeAt:i];
			else 
				break;
		}
	
		if ([result charAt:result.length - 1] == setting.decimalSeparator)
			[result removeAt:result.length - 1];	
	}
	
	return [result seal];
}








Int Double_round(Double value)
{
	if (Double_aEqual(value, 0.0))
		return 0;
		
	Int sign = (value < 0.0) ? -1 : 1;
	Int result = (Int)round(fabs(value));
	return result * sign;
}

Double Double_roundAsDouble(Double value)
{
	if (Double_aEqual(value, 0.0))
		return 0;
		
	Double sign = (value < 0.0) ? -1.0 : 1.0;
	Double result = round(fabs(value));
	return result * sign;
}




Int Double_ceil(Double value)
{
	SELFTEST_START
	
	ASSERT(Double_ceil(-1.9) == -1);
	ASSERT(Double_ceil(-0.9) == 0);
	ASSERT(Double_ceil(-0.3) == 0);
	ASSERT(Double_ceil(0.0) == 0);
	ASSERT(Double_ceil(0.3) == 1);
	ASSERT(Double_ceil(0.9) == 1);
	ASSERT(Double_ceil(1.9) == 2);
	
	SELFTEST_END
	
	return (Int)ceil(value);	
}

Int Double_floor(Double value)
{
	SELFTEST_START
	
	ASSERT(Double_floor(-1.9) == -2);
	ASSERT(Double_floor(-0.9) == -1);
	ASSERT(Double_floor(-0.3) == -1);
	ASSERT(Double_floor(0.0) == 0);
	ASSERT(Double_floor(0.3) == 0);
	ASSERT(Double_floor(0.9) == 0);
	ASSERT(Double_floor(1.9) == 1);
	
	SELFTEST_END
	
	return (Int)floor(value);	
}


Int Double_toInt(Double value)
{
	SELFTEST_START

	Double_ceil(0.0);
	Double_floor(0.0);
	
	SELFTEST_END
	
	return (value >= 0.0) ? Double_floor(value) : Double_ceil(value);
}




DoubleMutableList* Double_parseList(String* value)
{
	DoubleMutableList* result = [DoubleMutableList create:10];
	
	StringMutableList* list = [value split:STR(@",")];
	
	for (Int i = 0; i < list.count; i++)
	{
		String* str = [[list at:i] replacement :STR(@" ") :STR(@"")];
		
		NubleDouble value = Double_parse(str);
		if (value.hasVar)
			[result append:value.vd];
	}
	
	return result;
}


String* Double_printList(DoubleList* list, Int precision)
{
	MutableString* result = [MutableString create:10];
	ForEachIndex(i, list)
	{		
		if (result.length > 0)
			[result append:STR(@", ")];
		
		String* str = Double_printFloating([list at:i], precision);
		[result append:str];
	}
	
	return [result seal];
}










void Double_round_selfTest(void);
void Double_round_selfTest(void)
{
	ASSERT(Double_round(-1.0) == -1);
	ASSERT(Double_round(0.0) == 0);
	ASSERT(Double_round(1.0) == 1);

	
	ASSERT(Double_round(0.1) == 0);
	ASSERT(Double_round(0.4) == 0);
	ASSERT(Double_round(0.49) == 0);
	ASSERT(Double_round(0.5) == 1);
	ASSERT(Double_round(0.9) == 1);


	ASSERT(Double_round(-0.1) == 0);
	ASSERT(Double_round(-0.4) == 0);
	ASSERT(Double_round(-0.49) == 0);
	ASSERT(Double_round(-0.5) == -1);
	ASSERT(Double_round(-0.9) == -1);

	
	ASSERT(Double_round(543.1) == 543);
	ASSERT(Double_round(543.4) == 543);
	ASSERT(Double_round(543.49) == 543);
	ASSERT(Double_round(543.5) == 544);
	ASSERT(Double_round(543.9) == 544);


	ASSERT(Double_round(-543.1) == -543);
	ASSERT(Double_round(-543.4) == -543);
	ASSERT(Double_round(-543.49) == -543);
	ASSERT(Double_round(-543.5) == -544);
	ASSERT(Double_round(-543.9) == -544);




}







void Double_selfTest(void)
{
	Double_parse(String_empty());
	Double_print(0.0, 1, DoublePrintSetting_create(DoublePrintType_Fixed));
	
	Double_round_selfTest();
	
	Double_toInt(0.0);
}









