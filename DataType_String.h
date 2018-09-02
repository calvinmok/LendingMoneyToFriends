









#define STR(value)  [String create:value]





@interface String : ListBase 

    + (SealedString*) create:(NSString*)str;
		
	+ (SealedString*) createChar:(Char)ch;
	

    - (SealedString*) toSealed;

    
    @property (readonly) NSString* ns;
    @property (readonly) Int length;

    - (Char) charAt:(Int)index;
    
    - (SealedString*) substring :(Int)start :(Int)length;
	
	- (SealedString*) replacement :(Int)start :(Int)length :(String*)value;
	

@end








@interface SealedString : String

    + (SealedString*) create:(NSString*)str;
	
	+ (SealedString*) createChar:(Char)ch;
	
@end





@interface MutableString : String

    + (MutableString*) create:(Int)capacity;
    + (MutableString*) createWithString:(String*)capacity;
	+ (MutableString*) createNSString:(NSString*)value;
	


    - (SealedString*) seal;
		


    - (void) setCharAt :(Int)index :(Char)value;
    
    - (void) appendNS:(NSString*)value;
    
    - (void) insertAtNS :(Int)index :(NSString*)value;
    
	- (void) removeRange:(Int)index :(Int)length;
	
	- (Int) replaceNS :(NSString*)target :(NSString*)substitution;
		
    		
	- (void) replace :(Int)start :(Int)length :(String*)substitution;
		
		
@end























