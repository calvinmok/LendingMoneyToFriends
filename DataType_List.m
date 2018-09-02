









#import "DataType.h"






@implementation ListEnumeratorBase

	- (Bool) next { ASSERT(NO); return 0; }

	- (Int) index { ASSERT(NO); return 0; }

@end










@interface ListIndexEnumeratorImpl : ListIndexEnumerator
	{
	@public
		ListBase* List;
		ListIndexData Data;
	}

	- (ListIndexEnumeratorImpl*) initWithList:(ListBase*)list :(Bool)isReversed;

@end

@implementation ListIndexEnumeratorImpl

	- (void) dealloc
	{
		[List release];
		[super dealloc];
	}


	- (ListIndexEnumeratorImpl*) initWithList:(ListBase*)list :(Bool)isReversed
	{
		self = [super init];
		if (self) 	
		{
			self->List = [list retain];
			self->Data = ListIndexData_create(isReversed);
		}
		
		return self;
	}


	- (Bool) next
	{
		return ListIndexData_next(&self->Data, self->List.lastIndex_);
	}

	- (Int) index
	{
		return ListIndexData_index(self->Data, self->List.lastIndex_);
	}

@end






@implementation ListIndexEnumerator

	+ (ListIndexEnumerator*) create:(ListBase*)list
	{
		return [[[ListIndexEnumeratorImpl alloc] initWithList:list :NO] autorelease];
	}

	+ (ListIndexEnumerator*) createReversed:(ListBase*)list
	{
		return [[[ListIndexEnumeratorImpl alloc] initWithList:list :YES] autorelease];
	}
	
@end











@implementation ListBase 
    

	- (Int) count
	{
		[self doesNotRecognizeSelector:_cmd]; return 0;
	}
	
	
@end

@implementation ListBase (_)


	- (ListIndexEnumerator*) eachIndex
	{
		return [ListIndexEnumerator create:self];
	}

	- (ListIndexEnumerator*) reversedEachIndex
	{
		return [ListIndexEnumerator createReversed:self];
	}



	- (Bool) isValidIndex:(Int)index
	{
		return (0 <= index && index <= self.count - 1);
	}
	
	
    - (Int) firstIndex
	{
		return Int_var(self.firstIndex_);
	}

    - (Int) lastIndex
	{
		return Int_var(self.lastIndex_);
	}
	
    - (NubleInt) firstIndex_
	{
        return (self.count > 0) ? Int_toNuble(0) : Int_nuble();
	}
	
    - (NubleInt) lastIndex_
	{
		Int c = self.count;
        return (c > 0) ? Int_toNuble(c - 1) : Int_nuble();
	}
	
	
	
	- (Int) nextIndex
	{
		return self.count;
	}

    
@end














