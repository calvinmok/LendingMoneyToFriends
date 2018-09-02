






	
STRUCT_LIST_INTERFACE_TEMPLATE(Bool)
	




NS_INLINE Bool Bool_(Bool value) { return value; }

NS_INLINE NubleBool nubleYes() { return Bool_toNuble(Yes); }
NS_INLINE NubleBool nubleNo() { return Bool_toNuble(No); }



NS_INLINE Int Bool_compare(Bool x, Bool y) { if (x == y) return 0; else return (x == No) ? -1 : 1; }
	
	

NS_INLINE Bool varOrYes(NubleBool v) { return (v.hasVar) ? v.vd : Yes; }

NS_INLINE Bool varOrNo(NubleBool v) { return (v.hasVar) ? v.vd : No; }



NubleBool nubleNot(NubleBool value);
NubleBool nubleAnd(NubleBool x, NubleBool y);
NubleBool nubleOr(NubleBool x, NubleBool y);
NubleBool nubleXor(NubleBool x, NubleBool y);



NS_INLINE String* Bool_print(Bool value)
{
	return (value) ? STR(@"Yes") : STR(@"No");
}

NS_INLINE NubleBool Bool_parse(String* value)
{
	if (value.length > 0)
	{		
		Char c = [value charAt:0];
		if (c == CHAR(Y) || c == CHAR(y)) return nubleYes();
		if (c == CHAR(N) || c == CHAR(n)) return nubleNo();
	}
	
	return Bool_nuble();
}



SealedString* Bool_representation(Bool value);



NubleBool Bool_parseTrueFalse(String* str);






void Bool_assert(NubleBool self, Char value);




void Bool_selfTest(void);




