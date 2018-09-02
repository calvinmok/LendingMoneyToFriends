



STRUCT_LIST_INTERFACE_TEMPLATE(Double)




NS_INLINE Bool Double_aEqual(Double x, Double y) { return (-DBL_EPSILON + y <= x && x <= y + DBL_EPSILON); }

//NS_INLINE Int Double_compare(Double x, Double y) { if (Double_aEqual(x, y)) return 0; else return (x < y) ? -1 : 1; }

NS_INLINE NubleBool Double_isSmaller(Double x, Double y) { return (Double_aEqual(x, y)) ? Bool_nuble() : Bool_toNuble(x < y); }




Double Double_mod(Double value, Double denominator);

NS_INLINE Double Double_pow10(Int exponent) { return pow(10.0, (double)exponent); };


NS_INLINE Double Double_intpart(Double value) { double result; modf(value, &result); return result; }
NS_INLINE Double Double_fractional(Double value) { double intpart; return modf(value, &intpart); }

NS_INLINE Bool Double_hasNoFractional(Double value) { return Double_aEqual(Double_fractional(value), 0.0); }









Int Double_digit(Double value, Int point);

Int Double_numberOfDigitAfterDecimalPoint(Double value, Int limit);





NubleChar Double_printChar(Double value);


NubleDouble Double_parse(String* str);
NubleDouble Double_parseWithDecimalSeperator(String* str, Char seperator);


NS_INLINE Double Double_parseOr(String* str, Double def) { return Double_varOr(Double_parse(str), def); };
NS_INLINE Bool Double_parseEqual(String* str, Double value) { NubleDouble d = Double_parse(str); return (d.hasVar) ? Double_aEqual(d.vd, value) : No; };



typedef enum
{
    DoublePrintType_Fixed,
	DoublePrintType_Floating
}
DoublePrintType;

typedef struct
{
	DoublePrintType printType;
	Char decimalSeparator;
}
DoublePrintSetting;

NS_INLINE DoublePrintSetting DoublePrintSetting_create2(DoublePrintType type, Char decimalSeparator) 
	{ DoublePrintSetting result = { type, decimalSeparator }; return result; }

NS_INLINE DoublePrintSetting DoublePrintSetting_create(DoublePrintType type) 
	{ return DoublePrintSetting_create2(type, Char_decimalSeparator()); }




String* Double_print(Double value, Int precision, DoublePrintSetting setting);

NS_INLINE String* Double_printFixed(Double value, Int precision) 
	{ return Double_print(value, precision, DoublePrintSetting_create(DoublePrintType_Fixed)); }
NS_INLINE String* Double_printFloating(Double value, Int precision) 
	{ return Double_print(value, precision, DoublePrintSetting_create(DoublePrintType_Floating)); }
	




Int Double_round(Double value);
Double Double_roundAsDouble(Double value);

Int Double_ceil(Double value);
Int Double_floor(Double value);
Int Double_toInt(Double value);


NS_INLINE NubleInt Double_roundNuble(NubleDouble value) {
	return (value.hasVar) ? Int_toNuble(Double_round(value.vd)) : Int_nuble(); }

NS_INLINE NubleInt Double_toNubleInt(NubleDouble value) {
	return (value.hasVar) ? Int_toNuble(Double_toInt(value.vd)) : Int_nuble(); }





DoubleMutableList* Double_parseList(String* value);

String* Double_printList(DoubleList* list, Int precision);





void Double_selfTest(void);



