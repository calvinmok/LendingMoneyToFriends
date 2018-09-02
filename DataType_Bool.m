



#import "DataType.h"







STRUCT_LIST_IMPLEMENTATION_TEMPLATE(Bool)




NubleBool nubleNot(NubleBool value)
{
	if (value.hasVar) 
		return Bool_toNuble(value.vd == NO);

	return Bool_nuble();
}


NubleBool nubleAnd(NubleBool x, NubleBool y)
{
	if (x.hasVar && y.hasVar) return Bool_toNuble(x.vd && y.vd);
	if (x.hasVar) return (x.vd) ? Bool_nuble() : nubleNo();
	if (y.hasVar) return (y.vd) ? Bool_nuble() : nubleNo();
	return Bool_nuble();
}

NubleBool nubleOr(NubleBool x, NubleBool y)
{
	if (x.hasVar && y.hasVar) return Bool_toNuble(x.vd || y.vd);
	if (x.hasVar) return (x.vd) ? nubleYes() : Bool_nuble();
	if (y.hasVar) return (y.vd) ? nubleYes() : Bool_nuble();
	return Bool_nuble();
}

NubleBool nubleXor(NubleBool x, NubleBool y)
{
	if (x.hasVar && y.hasVar) return Bool_toNuble(x.vd ^ y.vd);
	return Bool_nuble();
}




SealedString* Bool_representation(Bool self)
{
	STATIC_OBJECT(SealedString, yesString, STR(@"YES"));
	STATIC_OBJECT(SealedString, noString, STR(@"NO"));
	return self ? yesString : noString;
}





NubleBool Bool_parseTrueFalse(String* str) 
{
	String* l = str.lower; 
	if ([l eqNS:@"true"]) return nubleYes(); 
	if ([l eqNS:@"false"]) return nubleNo(); 
	return Bool_nuble(); 
}





void Bool_assert(NubleBool self, Char value) 
{
	value = Char_upper(value);
	
	if (self.hasVar)
	{
		if (self.vd)
			ASSERT(value == CHAR(Y));
		else
			ASSERT(value == CHAR(N));
	}
	else 
	{
		ASSERT(value == CHAR(?));
	}
}




void Bool_selfTest(void)
{
	NubleBool nuble = Bool_nuble();
	NubleBool nubleYes = Bool_toNuble(Yes);
	NubleBool nubleNo = Bool_toNuble(No);

	Bool_assert(nuble, CHAR(?));
	Bool_assert(nubleYes, CHAR(Y));
	Bool_assert(nubleNo, CHAR(N));

	Bool_assert(nubleNot(nuble), CHAR(?));
	Bool_assert(nubleNot(nubleNo), CHAR(Y));
	Bool_assert(nubleNot(nubleYes), CHAR(N));

	
	Bool_assert(nubleAnd(nuble, nuble), CHAR(?));

	Bool_assert(nubleAnd(nubleYes, nubleYes), CHAR(Y));
	Bool_assert(nubleAnd(nubleYes, nubleNo), CHAR(N));
	Bool_assert(nubleAnd(nubleNo, nubleYes), CHAR(N));
	Bool_assert(nubleAnd(nubleNo, nubleNo), CHAR(N));
	
	Bool_assert(nubleAnd(nuble, nubleYes), CHAR(?));
	Bool_assert(nubleAnd(nuble, nubleNo), CHAR(N));
	Bool_assert(nubleAnd(nubleYes, nuble), CHAR(?));
	Bool_assert(nubleAnd(nubleNo, nuble), CHAR(N));


	Bool_assert(nubleOr(nuble, nuble), CHAR(?));

	Bool_assert(nubleOr(nubleYes, nubleYes), CHAR(Y));
	Bool_assert(nubleOr(nubleYes, nubleNo), CHAR(Y));
	Bool_assert(nubleOr(nubleNo, nubleYes), CHAR(Y));
	Bool_assert(nubleOr(nubleNo, nubleNo), CHAR(N));
	
	Bool_assert(nubleOr(nuble, nubleYes), CHAR(Y));
	Bool_assert(nubleOr(nuble, nubleNo), CHAR(?));
	Bool_assert(nubleOr(nubleYes, nuble), CHAR(Y));
	Bool_assert(nubleOr(nubleNo, nuble), CHAR(?));

	
	Bool_assert(nubleXor(nuble, nuble), CHAR(?));	

	Bool_assert(nubleXor(nubleYes, nubleYes), CHAR(N));
	Bool_assert(nubleXor(nubleYes, nubleNo), CHAR(Y));
	Bool_assert(nubleXor(nubleNo, nubleYes), CHAR(Y));
	Bool_assert(nubleXor(nubleNo, nubleNo), CHAR(N));
	
	Bool_assert(nubleXor(nuble, nubleYes), CHAR(?));
	Bool_assert(nubleXor(nuble, nubleNo), CHAR(?));
	Bool_assert(nubleXor(nubleYes, nuble), CHAR(?));
	Bool_assert(nubleXor(nubleNo, nuble), CHAR(?));

}








