





#import "DataType.h"





STRUCT_LIST_IMPLEMENTATION_TEMPLATE(NubleID)





@implementation StructListEnumerator

	- (void) var:(void*)buffer { ASSERT(NO); }

@end






@interface StructListEnumeratorImpl : StructListEnumerator
	{
	@public
		StructList* my_list;
		ListIndexData my_data;
	}

	- (StructListEnumeratorImpl*) initWithList:(StructList*)list :(Bool)isReversed;

@end


@implementation StructListEnumeratorImpl

	- (void) dealloc
	{
		[my_list release];
		[super dealloc];
	}


	- (StructListEnumeratorImpl*) initWithList:(StructList*)list :(Bool)isReversed
	{
		my_list = [list retain];
		my_data = ListIndexData_create(isReversed);
		return self;
	}


	- (Bool) next
	{		
		return ListIndexData_next(&my_data, my_list.lastIndex_);
	}

	- (Int) index
	{
		return ListIndexData_index(my_data, my_list.lastIndex_);
	}

	- (void) var:(void*)buffer
	{
		[my_list at:self.index :buffer];
	}

@end












NS_INLINE NSRange StructList_makeNSRange(Int i, size_t s) { return NSMakeRange(toUInt(i) * s, s); }















@implementation StructList (_)

    

    - (void) at:(Int)index or:(void*)def :(void*)buffer
    {
        if ([self isValidIndex:index])
            memmove(buffer, def, self.size);
        else
            [self at:index :buffer];
    }


    - (StructListEnumerator*) each
    {
        return [[[StructListEnumeratorImpl alloc] initWithList:self :NO] autorelease];
    }

    - (StructListEnumerator*) reversedEach
    {
        return [[[StructListEnumeratorImpl alloc] initWithList:self :YES] autorelease];
    }



    /*
     - (Int) findFirstIndexOfValue:(ConstPntr)value
     {
     return Int_var([self findFirstIndexOfValue_:value]);
     }
     - (Int) findFirstIndexOfValue:(ConstPntr)value :(Int)defIndex
     {
     return Int_varOr([self findFirstIndexOfValue_:value], defIndex);
     }
     - (NubleInt) findFirstIndexOfValue_:(ConstPntr)value
     {
     for (Int i = 0; i < self.count; i++)
     if ([self isSmaller:^(ConstPntr p) { return Bool_toNuble(memcmp(p, value, self.size) == 0); } :i])
     return Int_toNuble(i);
     
     return Int_nuble();
     }
     
     - (Bool) findValue:(ConstPntr)value
     {
     return [self findFirstIndexOfValue_:value].hasVar;
     }
     */



    - (void) first:(Pntr)buffer
    {
        ASSERT(self.count > 0);
        [self at:0 :buffer];
    }

    - (void) first:(ConstPntr)def :(Pntr)buffer
    {
        if (self.count > 0)
            [self at:0 :buffer];
        else
            memmove(buffer, def, self.size);
    }


    - (void) last:(Pntr)buffer
    {
        ASSERT(self.count > 0);
        [self at:self.lastIndex :buffer];
    }

    - (void) last:(ConstPntr)def :(Pntr)buffer
    {
        if (self.count > 0)
            [self at:self.lastIndex :buffer];
        else
            memmove(buffer, def, self.size);
    }





    - (BinarySearchResult) binarySearch :(ConstPntr_IsSmallerTarget)isSmaller
    {
        SELFTEST_START
        {
            IntMutableList* list = [IntMutableList create:5];
            [list append :1 :3 :5];
        
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 1); }], Yes, 0);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 2); }], No, 1);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 3); }], Yes, 1);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 4); }], No, 2);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 5); }], Yes, 2);
        }
        {
            IntMutableList* list = [IntMutableList create:1];
            [list append :2];
        
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 1); }], No, 0);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 2); }], Yes, 0);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 3); }], No, 1);			
        }
        {
            IntMutableList* list = [IntMutableList create:0];
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 1); }], No, 0);
        }		
        
        SELFTEST_END
        
        
        if (self.count == 0) 
            return BinarySearchResult_create(No, 0);
        
        return [self binarySearch :isSmaller :self.firstIndex :self.lastIndex];		
    }

    - (BinarySearchResult) binarySearch :(ConstPntr_IsSmallerTarget)isSmaller :(Int)start :(Int)end
    {	
        ASSERT([self isValidIndex:start] && [self isValidIndex:end]);
        
        NSMutableData* data = [NSMutableData dataWithLength:self.size];
        
        while (start <= end)
        {		
            Int position = start + ((end - start) / 2); 
            
            [self at :position :[data mutableBytes]];
            
            NubleBool b = isSmaller([data mutableBytes]);
            
            if (b.hasVar == No)
                {
                return BinarySearchResult_create(Yes, position);
                }
            else
                {
                if (b.vd)
                    start = position + 1;
                else
                    end = position - 1;
                } 
        } 
        
        return BinarySearchResult_create(No, start);
    }


@end




@implementation StructMutableList (_)

    - (void) append:(const void*)value1
    {
        [self insertAt :self.nextIndex :value1];
    }

    - (void) append :(const void*)value1 :(const void*)value2
    {
        [self insertAt :self.nextIndex :value1];
        [self insertAt :self.nextIndex :value2];
    }

    - (void) append :(const void*)value1 :(const void*)value2 :(const void*)value3
    {
        [self insertAt :self.nextIndex :value1];
        [self insertAt :self.nextIndex :value2];
        [self insertAt :self.nextIndex :value3];
    }

    - (void) append :(const void*)value1 :(const void*)value2 :(const void*)value3 :(const void*)value4
    {
        [self insertAt :self.nextIndex :value1];
        [self insertAt :self.nextIndex :value2];
        [self insertAt :self.nextIndex :value3];
        [self insertAt :self.nextIndex :value4];
    }


    - (void) removeFirst
    {
        ASSERT(self.count > 0);
        [self removeAt:0];
    }

    - (void) removeLast
    {
        ASSERT(self.count > 0);
        [self removeAt:self.lastIndex];
    }



    - (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY
    {
        SELFTEST_START		
        {
            DoubleMutableList* list = Double_parseList(STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }
        {
            DoubleMutableList* list = Double_parseList(STR(@"3.1, 3.2, 3.3, 1.1, 1.2, 1.3, 2.1, 2.2, 2.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }
        {
            DoubleMutableList* list = Double_parseList(STR(@"2.1, 2.2, 2.3, 1.1, 1.2, 1.3, 3.1, 3.2, 3.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }
        {
            DoubleMutableList* list = Double_parseList(STR(@"1.1, 1.2, 2.1, 1.3, 2.2, 3.1, 2.3, 3.2, 3.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }
        {
            DoubleMutableList* list = Double_parseList(STR(@"3.1, 3.2, 1.1, 3.3, 1.2, 2.1, 1.3, 2.2, 2.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }
        {
            DoubleMutableList* list = Double_parseList(STR(@"2.1, 2.2, 1.1, 2.3, 1.2, 3.1, 1.3, 3.2, 3.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }		
        SELFTEST_END
        
        
        if (self.count > 1) 
            [self mergeSort :isSmallerXY :self.firstIndex :self.lastIndex]; 
    }

    - (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY :(Int)start :(Int)end
    {
        if (self.count <= 1) 
            return; 
        
        ASSERT([self isValidIndex:start] && [self isValidIndex:end]); 
        
        StructMutableList* helper = [StructMutableList create:self.size]; 
        ForEachIndex(i, self)
        [helper appendFrom :self :i];
        
        [self mergeSort :isSmallerXY :start :end :helper]; 
    }

    - (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY :(Int)start :(Int)end :(StructMutableList*)helper
    {
        if (start >= end) 
            return;
        
        NSMutableData* leftData = [NSMutableData dataWithLength:self.size];
        NSMutableData* rightData = [NSMutableData dataWithLength:self.size];
        
        Int middle = (start + end) / 2;
        
        [self mergeSort :isSmallerXY :start :middle :helper];
        [self mergeSort :isSmallerXY :middle + 1 :end :helper];
        
        for (Int i = start; i <= end; i++)
            [helper modifyAtFrom :i :self :i];
        
        Int left = start;
        Int right = middle + 1;
        Int index = start;
        
        while (left <= middle && right <= end)
        {
            [helper at :left :[leftData mutableBytes]];
            [helper at :right :[rightData mutableBytes]];
            
            if (varOrYes(isSmallerXY([leftData mutableBytes], [rightData mutableBytes])))
                [self modifyAtFrom :index++ :helper :left++];
            else
                [self modifyAtFrom :index++ :helper :right++];
        }
        
        for ( ; left <= middle; left++)
            [self modifyAtFrom :index++ :helper :left];
        
        for ( ; right <= end; right++)
            [self modifyAtFrom :index++ :helper :right];
    }



@end











@interface StructSealedListImpl : StructSealedList
	{
	@public
		Int my_count;
		size_t my_size;
		NSData* my_subject;
	}
    
    + (StructSealedListImpl*) create:(Int)count :(size_t)size :(NSData*)subject;
    
    + (StructSealedListImpl*) seal:(Int)count :(size_t)size :(NSMutableData*)subject;
    
@end

@implementation StructSealedListImpl

    - (void) dealloc
    {
        [my_subject release];
        [super dealloc];
    }
    
    + (StructSealedListImpl*) create:(Int)count :(size_t)size :(NSData*)subject
    {
        StructSealedListImpl* result = [[[StructSealedListImpl alloc] init] autorelease];
        result->my_count = count;
		result->my_size = size;
        result->my_subject = [[NSData alloc] initWithData:subject];
        return result;
    }
    
    + (StructSealedListImpl*) seal:(Int)count :(size_t)size :(NSMutableData*)subject
    {
        StructSealedListImpl* result = [[[StructSealedListImpl alloc] init] autorelease];
        result->my_count = count;
		result->my_size = size;
        result->my_subject = [subject retain];
        return result;
    }
    
    
    
    - (Int) count { return my_count; }
    
	- (size_t) size { return my_size; }

	
    - (StructSealedList*) toSealed
    {
        return self;
    }
    
	
    - (void) at:(Int)index :(void*)buffer
    {
        NSRange range = StructList_makeNSRange(index, my_size);
		[my_subject getBytes:buffer range:range];
    }

/*
    - (NubleBool) isSmaller :(ConstPntr_IsSmallerTarget)isSmaller :(Int)index
    {
        ConstPntr p = [my_subject bytes] + StructList_makeNSRange(index, my_size).location;
        return isSmaller(p);
    }

    - (NubleBool) isSmaller :(ConstPntr_IsSmallerXY)isSmaller :(Int)xIndex :(Int)yIndex
	{
		ConstPntr x = [my_subject bytes] + StructList_makeNSRange(xIndex, my_size).location;
		ConstPntr y = [my_subject bytes] + StructList_makeNSRange(yIndex, my_size).location;
		return isSmaller(x, y);
	}
*/


@end







@interface StructMutableListImpl : StructMutableList
	{
	@public
		Int my_count;
        size_t my_size;
		NSMutableData* my_subject;
	}
    
    + (StructMutableListImpl*) create:(size_t)size :(Int)capacity;
	
@end

@implementation StructMutableListImpl

    - (void) dealloc
    {
        [my_subject release];
        [super dealloc];
    }
    
    + (StructMutableListImpl*) create:(size_t)size :(Int)capacity
    {
        StructMutableListImpl* result = [[[StructMutableListImpl alloc] init] autorelease];
        result->my_count = 0;
		result->my_size = size;
        result->my_subject = [[NSMutableData alloc] initWithCapacity:capacity * size];
        return result;
    }
    
    
    
    - (Int) count { return my_count; }
	
	- (size_t) size { return my_size; }
	
    
    - (StructSealedList*) toSealed
    {
        return [StructSealedListImpl create:my_count :my_size :my_subject];
    }
    



    - (void) at:(Int)index :(void*)buffer
    {
		ASSERT(0 <= index && index <= self.lastIndex);
	
        NSRange range = StructList_makeNSRange(index, my_size);
		[my_subject getBytes:buffer range:range];
    }
	
/*
    - (NubleBool) isSmaller :(ConstPntr_IsSmallerTarget)isSmaller :(Int)index
    {
        ConstPntr p = [my_subject bytes] + StructList_makeNSRange(index, my_size).location;
        return isSmaller(p);
    }
	
	- (NubleBool) isSmaller :(ConstPntr_IsSmallerXY)isSmaller :(Int)xIndex :(Int)yIndex
	{
		ConstPntr x = [my_subject bytes] + StructList_makeNSRange(xIndex, my_size).location;
		ConstPntr y = [my_subject bytes] + StructList_makeNSRange(yIndex, my_size).location;
		return isSmaller(x, y);
	}
*/

	- (StructSealedList*) seal
    {
        StructSealedList* result = [StructSealedListImpl seal:my_count :my_size :[my_subject autorelease]];
        my_count = 0;
        my_subject = nil;
        return result;
    }
    
	
	
	
	- (void*) mutableBytes
	{
		return [my_subject mutableBytes];
	}
	
	
	- (void) insertZeroAt :(Int)index
	{
		ASSERT(index <= self.nextIndex);
		
		UInt requiredLength = toUInt((my_count + 1) * my_size);
        
        if ([my_subject length] == 0)
            [my_subject setLength:requiredLength * 2];
        else if ([my_subject length] < requiredLength)
            [my_subject setLength:[my_subject length] * 2];
        		
		NSRange range = StructList_makeNSRange(index, my_size);
		
		void* ptr = [my_subject mutableBytes] + range.location;
        size_t s = [my_subject length] - ((index + 1) * range.length);
		memmove(ptr + range.length, ptr, s);
		
		memset(ptr, 0, range.length);
        
		my_count += 1;	
	}
	

	- (void) insertAt :(Int)index :(const void*)value 
	{
		ASSERT(index <= self.nextIndex);
		
		UInt requiredLength = (my_count + 1) * my_size;
        
        if ([my_subject length] == 0)
            [my_subject setLength:requiredLength * 2];
        else if ([my_subject length] < requiredLength)
            [my_subject setLength:[my_subject length] * 2];
        		
		NSRange range = StructList_makeNSRange(index, my_size);
		
		void* ptr = [my_subject mutableBytes] + range.location;
        size_t s = [my_subject length] - ((index + 1) * range.length);
		memmove(ptr + range.length, ptr, s);
		
		[my_subject replaceBytesInRange:range withBytes:value];
        
		my_count += 1;
	}
	
    
    - (void) modifyAt :(Int)index :(const void*)value 
    {
		NSRange range = StructList_makeNSRange(index, my_size);
		[my_subject replaceBytesInRange:range withBytes:value];
    }    



	- (void) removeAll
	{
		[my_subject setLength:0];
	}


	- (void) removeAt:(Int)index 
    {
		NSRange range = StructList_makeNSRange(index, my_size);
		void* ptr = [my_subject mutableBytes] + range.location;
		memmove(ptr, ptr + range.length, [my_subject length] - ((index + 1) * range.length));
        
        my_count -= 1;
	}    



	- (void) appendFrom :(StructList*)fromList :(Int)fromIndex
	{
		[self insertAtFrom :self.nextIndex :fromList :fromIndex];
	}

	- (void) insertAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex
	{
		ASSERT(self.size == fromList.size);
				
		[self insertZeroAt :atIndex];
		[self modifyAtFrom :atIndex :fromList :fromIndex];
	}
		    
	- (void) modifyAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex
	{
		ASSERT(self.size == fromList.size);
		
		NSRange range = StructList_makeNSRange(atIndex, my_size);
		
		void* ptr = [my_subject mutableBytes] + range.location;
				
		[fromList at :fromIndex :ptr];		
	}
		    
    
@end































@implementation StructList

    - (Int) count { ABSTRACT_METHOD(Int) }

    - (size_t) size { ABSTRACT_METHOD(size_t) }

    - (void) at:(Int)index :(void*)buffer { ABSTRACT_METHOD_VOID }


    // - (NubleBool) isSmaller :(ConstPntr_IsSmallerXY)isSmaller :(Int)xIndex :(Int)yIndex { ABSTRACT_METHOD(NubleBool) }

    - (StructSealedList*) toSealed { ABSTRACT_METHOD_NIL }

@end


@implementation StructSealedList

    + (StructSealedList*) createEmpty:(size_t)size
    {
        static StructSealedList* result = nil;
        
        if (result == nil)
            result = [[StructSealedListImpl create:0 :size :[NSData data]] retain];
        
        return result;
    }

@end


@implementation StructMutableList 

    + (StructMutableList*) create:(size_t)size
    {
        return [StructMutableList create:size :10];
    }

    + (StructMutableList*) create:(size_t)size :(Int)capacity 
    {
        return [StructMutableListImpl create:size :capacity];
    }

    - (StructSealedList*) seal { ABSTRACT_METHOD_NIL }

    - (void*) mutableBytes { ABSTRACT_METHOD_NIL; }


    - (void) insertZeroAt :(Int)index { ABSTRACT_METHOD_VOID }

    - (void) insertAt :(Int)index :(const void*)value { ABSTRACT_METHOD_VOID }

    - (void) modifyAt :(Int)index :(const void*)value { ABSTRACT_METHOD_VOID }


    - (void) removeAll { ABSTRACT_METHOD_VOID }

    - (void) removeAt:(Int)index { ABSTRACT_METHOD_VOID }    


    - (void) appendFrom :(StructList*)fromList :(Int)fromIndex { ABSTRACT_METHOD_VOID }
    - (void) insertAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex { ABSTRACT_METHOD_VOID }
    - (void) modifyAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex { ABSTRACT_METHOD_VOID }

@end













void UIntList_assertStringList(UIntList* self, NSString* value);
void UIntList_assertStringList(UIntList* self, NSString* value)
{
	ASSERT(UInt_isSmallerXYI(self.count, [value length]).hasVar == No);

	for (NSUInteger i = 0; i < [value length]; i++)
	{
		NubleUInt u = UInt_parseChar([value characterAtIndex:i]);
		ASSERT(u.hasVar && u.vd == [self at:toInt(i)]);
	}
}


	
	

void StructList_selfTest(void)
{
	{
		UIntMutableList* list = [UIntMutableList create];
		UIntList_assertStringList(list, @"");

		[list append:5];
		UIntList_assertStringList(list, @"5");

		[list append:6];
		[list append:7];
		UIntList_assertStringList(list, @"567");

		[list insertAt :0 :4];
		UIntList_assertStringList(list, @"4567");

		[list insertAt :4 :8];
		UIntList_assertStringList(list, @"45678");

		[list removeAt:2];
		UIntList_assertStringList(
		list, @"4578");

		[list removeAt:3];
		UIntList_assertStringList(list, @"457");

		[list removeAt:0];
		UIntList_assertStringList(list, @"57");
	}
	

	
	
	
}




STRUCT_LIST_IMPLEMENTATION_TEMPLATE(CGFloat)


