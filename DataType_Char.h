












#define CHAR(value) [@#value characterAtIndex:0]

#define CHAR_0     [@"\0" characterAtIndex:0]
#define CHAR_T     [@"\t" characterAtIndex:0]
#define CHAR_N     [@"\n" characterAtIndex:0]
#define CHAR_R     [@"\r" characterAtIndex:0]


#define CHAR_CM     [@"," characterAtIndex:0]
#define CHAR_DQ     [@"\"" characterAtIndex:0]
#define CHAR_LP     [@"(" characterAtIndex:0]
#define CHAR_RP     [@")" characterAtIndex:0]
#define CHAR_SP     [@" " characterAtIndex:0]




Char Char_lower(Char value);
Char Char_upper(Char value);


Bool Char_isDigit(Char value);
Bool Char_isAlphabet(Char value);



Char Char_decimalSeparator(void);


NS_INLINE NubleBool Char_isSmallerXY(Char x, Char y) { if (x == y) return Bool_nuble(); else return Bool_toNuble(x < y); }
	
	
	

void Char_selfTest(void);









