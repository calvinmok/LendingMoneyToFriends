





#import "DataType.h"


/*
    

@interface DecDoubleImpl : DecDouble
    {
    @private
        double Coefficient;
		Int Precision;
    }
    
    + (DecDoubleImpl*) create:(double)coefficient :(Int)precision;


@end

@implementation DecDoubleImpl


    + (DecDoubleImpl*) create:(double)coefficient :(Int)precision
    {
        DecDoubleImpl* result = [[[DecDoubleImpl alloc] init] autorelease];
        result->Coefficient = coefficient;
		result->Precision = precision;
        return result;
    }
    
    
    
    - (double) coefficient
    {
        return self->Coefficient;
    }
    
    - (Int) precision
    {
        return self->Precision;
    }
        

@end



@implementation DecDouble

	- (double) coefficient { ASSERT(NO); return 0.0; }
    
    - (Int) precision { ASSERT(NO); return 0; }
	
	- (double) value { return self.coefficient / pow10(self.precision); }
	

@end


@implementation DecDouble (_)


	+ (DecDouble*) zero
	{
        static DecDouble* value = nil;
        if (value == nil) value = [[DecDoubleImpl create:0.0 :0] retain];
		return value;
	}
	
	+ (DecDouble*) one
	{
        static DecDouble* value = nil;
        if (value == nil) value = [[DecDoubleImpl create:1.0 :0] retain];
		return value;
	}
	
	
	
    + (DecDouble*) createWithInt:(Int)value
    {
        return [DecDoubleImpl create:(double)value :0];
    }
	
	+ (DecDouble*) createWithUInt:(UInt)value
	{
        return [DecDoubleImpl create:(double)value :0];
	}
	
	
	
	+ (DecDouble*) createWithDouble:(double)value :(Int)precision
	{
		double coefficient = value * pow10(precision);
		return [DecDoubleImpl create:coefficient :precision];
	}
	
	

    + (DecDouble*) parse:(String*)value or:(DecDouble*)def
    {
		if (value.length == 0)
			return def;
	
        Bool isNegative = NO;
        Int index = value.firstIndex;
        
        if ([value charAt:index] == CHAR(-))
            isNegative = YES;

        if ([value charAt:index] == CHAR(+) || [value charAt:index] == CHAR(-))
            index++;

        double coefficient = 0.0;
        Int precision = -1;
		
        for (; index < value.length; index++)
        {
            unichar ch = [value charAt:index];
            
            if (ch == CHAR_SP)
                return def;
                
            if (ch == CHAR(.))
            {
                precision = 0;
            }
            else
            {
                NubleInt digit = Int_parseChar(ch);
                if (digit.hasVar == NO)
                    return def;
                
                if (precision >= 0)
                    precision += 1;
                    
                coefficient *= 10.0;
                coefficient += digit.vd;
            }
        }
        
        if (precision == -1)
            precision = 0;
		
		if (isNegative)
			coefficient *= -1.0;
           
        return [DecDoubleImpl create:coefficient :precision];
    }
	
	
	
	
	+ (DecDouble*) parseOrNil:(String*)value
	{
		return [DecDouble parse:value or:nil];
	}

	
    
    
    + (DecDouble*) parseNS:(NSString*)value or:(DecDouble*)def
    {
        return [DecDouble parse:[String create:value] or:def];
    }
	
	+ (DecDouble*) parseNSOrNil:(NSString*)value
    {
        return [DecDouble parse:[String create:value] or:nil];
    }

	
    
    + (DecDouble*) parse:(String*)value
    {
        DecDouble* result = [DecDouble parse:value or:nil];
		ASSERT(result != nil);
		return result;
    }
	
	+ (DecDouble*) parseNS:(NSString*)value
    {
        DecDouble* result = [DecDouble parseNS:value or:nil];
		ASSERT(result != nil);
		return result;
    }


	- (DecDouble*) morePrecise:(Int)offset
	{
		if (offset == 0)
			return self;
			
		Int p = self.precision + offset;
		double c = self.coefficient * pow10(offset);
		return [DecDoubleImpl create:c :p];		
	}
	
	- (DecDouble*) lessPrecise:(Int)offset
	{
		return [self morePrecise:-offset];
	}
	
	- (DecDouble*) changePrecisionTo:(Int)p
	{
		return [self morePrecise:p - self.precision];
	}


	


    - (NSNumber*) nsNumber
    {
        return [NSNumber numberWithDouble:self.value];
    }
    

    

  	- (Bool) isEqualToDecDouble:(DecDouble*)other
    {
		Int p = Int_max(self.precision, other.precision);
		double x = [self changePrecisionTo:p].coefficient;
		double y = [other changePrecisionTo:p].coefficient;
        return (fabs(intpart(x) - intpart(y)) < 0.5);
    }


    
	
	
	
	- (SealedString*) representation
	{
		MutableString* result = [MutableString create];
				
		for (double v = fabs(intpart(self.value)); YES ; v /= 10.0)
		{
			Double r = fmod(v, 10.0);
			
			Char ch = Double_printChar(r).vd;
			[result insertChar:ch];
			
			v -= r;
			if (v == 0.0)
				break;
		}
		
		
		BOOL intpartIsZero = NO;
		
		if (result.length == 0)
		{
			[result appendChar:CHAR(0)];
			intpartIsZero = YES;
		}
		

		if (self.precision > 0)
		{
			[result appendChar:CHAR(.)];
			
			UInt index = result.lastIndex + 1;
			
			Double c = fabs(self.coefficient);
			
			for (Int p = self.precision; p > 0; --p)
			{
				Double r = fmod(c, 10.0);
				
				c -= r;
				
				Char ch = Double_formatChar(r).vd;
				[result insertCharAt :index :ch];
				
				c /= 10.0;
			}
		}
		
		if ([result eq:STR(@"0")] == NO)
		{
			if (intpartIsZero == NO && self.coefficient < 0.0)
				[result insertChar:CHAR(-)];
		}

		return [result seal];
	}
	
	
	
   
    
    + (DecDouble*) add:(DecDouble*)x :(DecDouble*)y
    {
		Int p = Int_max(x.precision, y.precision);
		x = [x changePrecisionTo:p];
		y = [y changePrecisionTo:p];
		return [DecDoubleImpl create:x.coefficient + y.coefficient: p];
    }
	    
    + (DecDouble*) subtract:(DecDouble*)x :(DecDouble*)y
    {
		Int p = Int_max(x.precision, y.precision);
		x = [x changePrecisionTo:p];
		y = [y changePrecisionTo:p];
        return [DecDoubleImpl create:x.coefficient - y.coefficient :p];
    }

    + (DecDouble*) multiply:(DecDouble*)x :(DecDouble*)y
    {
		Int p = Int_max(x.precision, y.precision);
		x = [x changePrecisionTo:p];
		y = [y changePrecisionTo:p];
        return [DecDoubleImpl create:x.coefficient * y.coefficient :p * 2];
    }

    + (DecDouble*) divide:(DecDouble*)x :(DecDouble*)y
    {
		return nil;
    }


	
	- (DecDouble*) sqrt
	{
		Double coeff = sqrt(self.coefficient) * sqrt(pow10(self.precision));
		return [DecDoubleImpl create:coeff :self.precision];
	}
	
	
	- (DecDouble*) exp { return [DecDouble createWithDouble:exp(self.value) :self.precision]; }
	- (DecDouble*) exp2 { return [DecDouble createWithDouble:exp2(self.value) :self.precision]; }

	- (DecDouble*) log { return [DecDouble createWithDouble:log(self.value) :self.precision]; }
	- (DecDouble*) log10 { return [DecDouble createWithDouble:log10(self.value) :self.precision]; }
	

	- (DecDouble*) sin { return [DecDouble createWithDouble:sin(self.value) :self.precision]; }
	- (DecDouble*) cos { return [DecDouble createWithDouble:cos(self.value) :self.precision]; }
	- (DecDouble*) tan { return [DecDouble createWithDouble:tan(self.value) :self.precision]; }
	- (DecDouble*) sinh { return [DecDouble createWithDouble:sinh(self.value) :self.precision]; }
	- (DecDouble*) cosh { return [DecDouble createWithDouble:cosh(self.value) :self.precision]; }
	- (DecDouble*) tanh { return [DecDouble createWithDouble:tanh(self.value) :self.precision]; }
	- (DecDouble*) asin { return [DecDouble createWithDouble:asin(self.value) :self.precision]; }
	- (DecDouble*) acos { return [DecDouble createWithDouble:acos(self.value) :self.precision]; }
	- (DecDouble*) atan { return [DecDouble createWithDouble:atan(self.value) :self.precision]; }
	- (DecDouble*) asinh { return [DecDouble createWithDouble:asinh(self.value) :self.precision]; }
	- (DecDouble*) acosh { return [DecDouble createWithDouble:acosh(self.value) :self.precision]; }
	- (DecDouble*) atanh { return [DecDouble createWithDouble:atanh(self.value) :self.precision]; }




	- (void) assert:(double)value
	{
        ASSERT(self.value == value);
	}
	- (void) assert:(double)coefficient :(Int)precision
	{
		ASSERT([self isEqualToDecDouble:[DecDoubleImpl create:coefficient :precision]]);
	}
	



	
	+ (void) selfTest
	{
		DecDouble* zero = [DecDouble zero];
		DecDouble* one = [DecDouble one];
	
		[[DecDouble createWithInt:0] assert:0.0];
		[[DecDouble createWithInt:4] assert:4.0];
		[[DecDouble createWithInt:-4] assert:-4.0];
		
		[[DecDouble createWithUInt:0] assert:0.0];
		[[DecDouble createWithUInt:4] assert:4.0];
		
		[[DecDouble createWithDouble:0.425532 :0] assert:0.425532];
		
		[[DecDouble add:zero :zero] assert:0.0];
		[[DecDouble add:zero :one] assert:1.0];
		[[DecDouble add:one :zero] assert:1.0];
		[[DecDouble add:one :one] assert:2.0];
		
		[[DecDouble subtract:zero :zero] assert:0.0];
		[[DecDouble subtract:zero :one] assert:-1.0];
		[[DecDouble subtract:one :zero] assert:1.0];
		[[DecDouble subtract:one :one] assert:0.0];

		[[DecDouble multiply:zero :zero] assert:0.0];
		[[DecDouble multiply:zero :one] assert:0.0];
		[[DecDouble multiply:one :zero] assert:0.0];
		[[DecDouble multiply:one :one] assert:1.0];
		
		[[DecDouble divide:zero :one] assert:0.0];
		[[DecDouble divide:one :one] assert:1.0];
				
		[[DecDouble createWithDouble:0.0 :0].representation assert:@"0"];
		[[DecDouble createWithDouble:3.0 :0].representation assert:@"3"];
		[[DecDouble createWithDouble:37.0 :0].representation assert:@"37"];
		[[DecDouble createWithDouble:-3.0 :0].representation assert:@"-3"];
		[[DecDouble createWithDouble:-37.0 :0].representation assert:@"-37"];
		
		[[DecDouble createWithDouble:0.425532 :0].representation assert:@"0"];
		[[DecDouble createWithDouble:425532.0 :0].representation assert:@"425532"];
		[[DecDouble createWithDouble:-0.425532 :0].representation assert:@"0"];
		[[DecDouble createWithDouble:-425532.0 :0].representation assert:@"-425532"];
		
		[[DecDouble createWithDouble:0.0 :2].representation assert:@"0.00"];
		[[DecDouble createWithDouble:0.421532 :2].representation assert:@"0.42"];
		[[DecDouble createWithDouble:0.425532 :2].representation assert:@"0.43"];
		[[DecDouble createWithDouble:425532 :2].representation assert:@"425532.00"];

		[[DecDouble createWithDouble:-0.0 :2].representation assert:@"0.00"];
		[[DecDouble createWithDouble:-0.421532 :2].representation assert:@"-0.42"];
		[[DecDouble createWithDouble:-0.425532 :2].representation assert:@"-0.43"];
		[[DecDouble createWithDouble:-425532 :2].representation assert:@"-425532.00"];


		
		ASSERT([DecDouble parseNSOrNil:@""] == nil);
		ASSERT([DecDouble parseNSOrNil:@"   "] == nil);
		ASSERT([DecDouble parseNSOrNil:@"gfyugfyuyg"] == nil);
		ASSERT([DecDouble parseNSOrNil:@"g  fyug   fyuy g"] == nil);
				
		ASSERT([DecDouble parseNSOrNil:@"   0"] == nil);
		
		[[DecDouble parseNS:@"0"] assert:0.0 :0];
		[[DecDouble parseNS:@"0."] assert:0.0 :0];
		[[DecDouble parseNS:@"0.0"] assert:0.0 :1];
		[[DecDouble parseNS:@"0.00"] assert:0.0 :2];
		
		[[DecDouble parseNS:@"1"] assert:1.0 :0];
		[[DecDouble parseNS:@"1."] assert:1.0 :0];
		[[DecDouble parseNS:@"1.0"] assert:10 :1];
		[[DecDouble parseNS:@"1.00"] assert:100 :2];

		[[DecDouble parseNS:@"-1"] assert:-1.0 :0];
		[[DecDouble parseNS:@"-1."] assert:-1.0 :0];
		[[DecDouble parseNS:@"-1.0"] assert:-10 :1];
		[[DecDouble parseNS:@"-1.00"] assert:-100 :2];

		
		[[DecDouble parseNS:@"5466"] assert:5466.0 :0];
		[[DecDouble parseNS:@"5466."] assert:5466.0 :0];
		[[DecDouble parseNS:@"5466.0"] assert:54660 :1];
		[[DecDouble parseNS:@"5466.2"] assert:54662 :1];
		[[DecDouble parseNS:@"5466.00"] assert:546600 :2];
		[[DecDouble parseNS:@"5466.20"] assert:546620 :2];
		[[DecDouble parseNS:@"5466.02"] assert:546602 :2];

		[[DecDouble parseNS:@"-5466"] assert:-5466.0 :0];
		[[DecDouble parseNS:@"-5466."] assert:-5466.0 :0];
		[[DecDouble parseNS:@"-5466.0"] assert:-54660 :1];
		[[DecDouble parseNS:@"-5466.00"] assert:-546600 :2];
		[[DecDouble parseNS:@"-5466.00"] assert:-546600 :2];
		[[DecDouble parseNS:@"-5466.20"] assert:-546620 :2];
		[[DecDouble parseNS:@"-5466.02"] assert:-546602 :2];

		[[[DecDouble parseNS:@"5466.00"] lessPrecise:2] assert:5466 :0];
		[[[DecDouble parseNS:@"5466.00"] lessPrecise:1] assert:54660 :1];
		[[[DecDouble parseNS:@"5466.00"] lessPrecise:0] assert:546600 :2];
		[[[DecDouble parseNS:@"5466.00"] morePrecise:0] assert:546600 :2];
		[[[DecDouble parseNS:@"5466.00"] morePrecise:1] assert:5466000 :3];
		[[[DecDouble parseNS:@"5466.00"] morePrecise:2] assert:54660000 :4];

		[[[DecDouble parseNS:@"20."] sqrt] assert:4 :0];
		[[[DecDouble parseNS:@"20.0"] sqrt] assert:44 :1];
		[[[DecDouble parseNS:@"20.00"] sqrt] assert:447 :2];
		[[[DecDouble parseNS:@"20.000"] sqrt] assert:4472 :3];
		[[[DecDouble parseNS:@"20.0000"] sqrt] assert:44721 :4];

		
	}
    
    
    
	
	
@end










*/

















