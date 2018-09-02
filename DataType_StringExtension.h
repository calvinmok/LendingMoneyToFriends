





SealedString* String_empty(void);

SealedString* String_concat(String* x, String* y);
SealedString* String_concat3(String* s1, String* s2, String* s3);

NubleBool String_isSmallerXY(String* x, String* y);



Bool String_isValidSubstringArg(Int selfLength, Int start, Int length);








@interface String (_)

	- (Char) firstChar;	
	- (Char) lastChar;	
	
	- (NubleChar) firstChar_;		
	- (NubleChar) lastChar_;	
	
	
	- (NubleChar) charAt_:(Int)index;
	
	
	- (Bool) eq :(String*)other;
	- (Bool) eq :(String*)other :(Int)start :(Int)length;
	
	- (Bool) eqNS :(NSString*)other;
	- (Bool) eqNS :(NSString*)other :(Int)start :(Int)length;
	
	
	- (NubleBool) localizedIsSmallerThan:(String*)other;



	- (Bool) startWith:(String*)value;
	- (Bool) startWithNS:(NSString*)value;
	
	- (Bool) endWith:(String*)value;
	- (Bool) endWithNS:(NSString*)value;
	
	
    

	- (Bool) isValidArg_Substring :(Int)start :(Int)length;


	

	- (SealedString*) front:(Int)length;
	- (SealedString*) back:(Int)length;
	
	- (SealedString*) cutFront:(Int)length;	
	- (SealedString*) cutBack:(Int)length;	
	
	
	- (SealedString*) startAt:(Int)index;
	- (SealedString*) endAt:(Int)index;
	
    - (SealedString*) startEndAt :(Int)start :(Int)end;



	
	- (void) getAllCharacter:(Char*)buffer;
	
	
	
    
    
    - (SealedString*) replacement:(String*)target :(String*)substitution;

	
	
    - (NubleInt) indexOfChar :(Char)value;
	- (NubleInt) indexOfChar :(Char)value from:(Int)begin;
	
	
	
	- (Bool) isValidArg_indexOf :(String*)value :(Int)begin;
	
	- (NubleInt) indexOf :(String*)value;
	- (NubleInt) indexOf :(String*)value :(Int)begin;
	
	- (Bool) contain :(String*)value;
	
	
	
	- (Int) countChar:(Char)value;
	
	
	
	
	- (SealedString*) lower;
	- (SealedString*) upper;


	- (StringMutableList*) split:(String*)separator;
	 

	
	
	+ (String*) toBase64:(NSData*)data;
	+ (NSData*) fromBase64:(String*)data;
	
	
	
	
	- (void) assert:(NSString*)value;

    
@end




@interface SealedString (_)

@end




@interface MutableString (_)


	- (void) append:(String*)value;
    - (void) appendChar:(Char)value;

    - (void) insert:(String*)value;
    - (void) insertAt :(Int)index :(String*)value;
    
    - (void) insertChar:(Char)value;
    - (void) insertCharAt :(Int)index :(Char)value;
    

	- (void) removeAt:(Int)index;

	- (void) replace :(String*)target :(String*)substitution;

	
@end





void MutableString_selfTest(void);

void String_selfTest(void);






