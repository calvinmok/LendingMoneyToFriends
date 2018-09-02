



/*



@interface DecDouble : ObjectBase 

    @property (readonly) double coefficient;
    @property (readonly) Int precision; // exponent == -precision
	
	@property (readonly) double value; // == coefficient / pow10(precision)

@end


@interface DecDouble (_)

	+ (DecDouble*) zero;
	+ (DecDouble*) one;
		
    + (DecDouble*) createWithInt:(Int)value;
	+ (DecDouble*) createWithUInt:(UInt)value;
	+ (DecDouble*) createWithDouble:(double)value :(Int)precision;
	
    + (DecDouble*) parse:(String*)value;
	+ (DecDouble*) parseNS:(NSString*)value;

    + (DecDouble*) parse:(String*)value or:(DecDouble*)def;
	+ (DecDouble*) parseNS:(NSString*)value or:(DecDouble*)def;
	
	+ (DecDouble*) parseOrNil:(String*)value;
	+ (DecDouble*) parseNSOrNil:(NSString*)value;

    
	
	- (DecDouble*) morePrecise:(Int)offset;
	- (DecDouble*) lessPrecise:(Int)offset;
	- (DecDouble*) changePrecisionTo:(Int)p;
	
    
    @property (readonly) NSNumber* nsNumber;
    @property (readonly) SealedString* representation;



  	- (BOOL) isEqualToDecDouble:(DecDouble*)other;
            	
	
    
    + (DecDouble*) add:(DecDouble*)x :(DecDouble*)y;
    + (DecDouble*) subtract:(DecDouble*)x :(DecDouble*)y;
    + (DecDouble*) multiply:(DecDouble*)x :(DecDouble*)y;
    + (DecDouble*) divide:(DecDouble*)x :(DecDouble*)y;


	- (DecDouble*) sqrt;

	- (DecDouble*) exp;
	- (DecDouble*) exp2;

	- (DecDouble*) log;
	- (DecDouble*) log10;
	
	- (DecDouble*) sin;
	- (DecDouble*) cos;
	- (DecDouble*) tan;
	- (DecDouble*) sinh;
	- (DecDouble*) cosh;
	- (DecDouble*) tanh;
	- (DecDouble*) asin;
	- (DecDouble*) acos;
	- (DecDouble*) atan;
	- (DecDouble*) asinh;
	- (DecDouble*) acosh;
	- (DecDouble*) atanh;
	
	


	- (void) assert:(double)value;
	
	- (void) assert:(double)coefficient :(Int)precision;
	
	
	+ (void) selfTest;
	

@end


*/

