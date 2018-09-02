







STRUCT_LIST_INTERFACE_TEMPLATE(Int)
STRUCT_LIST_INTERFACE_TEMPLATE(UInt)

@interface IntMutableList (_)

	- (void) addAt :(Int)index :(Int)value;
	
@end




Int Int_mod(Int x, Int y);





NS_INLINE NubleBool Int_isSmallerXY(Int x, Int y) { return (x == y) ? Bool_nuble() : Bool_toNuble(x < y); }
NS_INLINE NubleBool UInt_isSmallerXY(UInt x, UInt y) { return (x == y) ? Bool_nuble() : Bool_toNuble(x < y); }



NS_INLINE Int Int_abs(Int z) { return (z >= 0) ? z : -z; }


NS_INLINE Int Int_min(Int x, Int y) { return (x < y) ? x : y; }
NS_INLINE Int Int_max(Int x, Int y) { return (x >= y) ? x : y; }

NS_INLINE UInt UInt_min(UInt x, UInt y) { return (x < y) ? x : y; }
NS_INLINE UInt UInt_max(UInt x, UInt y) { return (x >= y) ? x : y; }




NS_INLINE Int makeLastIndex(Int count)
{
    ASSERT(count > 0);
    return count - 1;
}

NS_INLINE NubleInt makeLastIndexOrNuble(Int count) 
{ 
	return (count > 0) ? Int_toNuble(count - 1) : Int_nuble();
}




NS_INLINE Int toInt(UInt value) { ASSERT(value <= (UInt)Int_Max); return (Int)value; };
NS_INLINE UInt toUInt(Int value) { ASSERT(value >= (Int)UInt_Min); return (UInt)value; };




NS_INLINE NubleBool Int_isSmallerXYU(Int x, UInt y) 
{
	if (x < (Int)UInt_Min || y > (UInt)Int_Max) return nubleYes();
	return UInt_isSmallerXY(toUInt(x), y);   
};

NS_INLINE NubleBool UInt_isSmallerXYI(UInt x, Int y) 
{
	if (x > (UInt)Int_Max || y < (Int)UInt_Min) return nubleNo();
	return Int_isSmallerXY(toInt(x), y);   
};




Bool Int_isEven(Int value);
Bool Int_isOdd(Int value);




NubleChar Int_toChar(Int value);




NubleInt Int_parseChar(Char value);
NubleUInt UInt_parseChar(Char value);
	
NubleChar Int_printChar(Int value);
NubleChar UInt_printChar(UInt value);

	

	
NubleInt Int_parse(String* value);
NubleUInt UInt_parse(String* value);

String* Int_print(Int value);
String* UInt_print(UInt value);	
	
	
String* Int_printPadding(Int value, Int padding);

	
	

	
