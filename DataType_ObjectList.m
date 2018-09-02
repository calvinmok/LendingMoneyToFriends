





#import "DataType.h"








@implementation ObjectListEnumerator

	- (id) var { ABSTRACT_METHOD_NIL; }
	- (Int) listCount { ABSTRACT_METHOD(Int); }


	- (ObjectMutableList*) getAll
	{	
		ObjectMutableList* result = [ObjectMutableList create:self.listCount];
		
		while ([self next])
			[result append:self.var];
		
		return result;
	}

@end



@interface ObjectListEnumeratorImpl : ObjectListEnumerator
	{
	@public
		ObjectList* my_list;
		ListIndexData my_data;
	}

	- (ObjectListEnumeratorImpl*) initWithList:(ObjectList*)list :(Bool)isReversed;

@end


@implementation ObjectListEnumeratorImpl

	- (void) dealloc
	{
		[my_list release];
		[super dealloc];
	}


	- (ObjectListEnumeratorImpl*) initWithList:(ObjectList*)list :(Bool)isReversed
	{
		my_list = [list retain];
		my_data = ListIndexData_create(isReversed);
		return self;
	}


	- (Bool) next { return ListIndexData_next(&my_data, my_list.lastIndex_); }

	- (Int) index { return ListIndexData_index(my_data, my_list.lastIndex_); }

	- (id) var { return [my_list at:self.index]; }

	- (Int) listCount { return my_list.count; }

@end






@implementation ObjectListFilteredEnumerator

	- (Int) i { ABSTRACT_METHOD(Int); }

@end

@interface ObjectListFilteredEnumeratorImpl : ObjectListFilteredEnumerator
	{
	@public
		ObjectList* my_list;
		ListIndexData my_data;
		
		ID_Predicate my_predicate;
		Int my_count;
	}
	
	- (ObjectListFilteredEnumeratorImpl*) initWithList :(ObjectList*)list :(Bool)isReversed :(ID_Predicate)predicate;

@end


@implementation ObjectListFilteredEnumeratorImpl

	- (void) dealloc
	{
		[my_list release];
		[super dealloc];
	}


	- (ObjectListFilteredEnumeratorImpl*) initWithList :(ObjectList*)list :(Bool)isReversed :(ID_Predicate)predicate
	{
		my_list = [list retain];
		my_data = ListIndexData_create(isReversed);
		my_predicate = predicate;
		my_count = 0;
		return self;
	}


	- (Bool) next 
	{ 
		while (ListIndexData_next(&my_data, my_list.lastIndex_))
		{
			if (my_predicate(self.var))
			{
				my_count += 1;
				return Yes;
			}
		} 
		
		return No;
	}

	- (Int) index { return ListIndexData_index(my_data, my_list.lastIndex_); }

	- (id) var { return [my_list at:self.index]; }
	
	- (Int) i { return my_count; }

@end























@interface ObjectSealedListImpl : ObjectSealedList
	{
	@public
		NSArray* my_subject;
	}
    
    + (ObjectSealedListImpl*) create:(NSArray*)data;

    + (ObjectSealedListImpl*) seal:(NSMutableArray*)data;
	
@end




@interface ObjectMutableListImpl : ObjectMutableList
	{
	@public
		NSMutableArray* my_subject;
	}

    + (ObjectMutableListImpl*) create:(Int)capacity;

@end
















@implementation ObjectSealedListImpl 

    - (void) dealloc
    {
        [my_subject release];
        [super dealloc];
    }
    
    + (ObjectSealedListImpl*) create:(NSArray*)data;
    {
        ObjectSealedListImpl* result = [[[ObjectSealedListImpl alloc] init] autorelease];
        result->my_subject = [[NSArray alloc] initWithArray:data];
        return result;
    }
	
	
    + (ObjectSealedListImpl*) seal:(NSMutableArray*)data
	{
        ObjectSealedListImpl* result = [[[ObjectSealedListImpl alloc] init] autorelease];
        result->my_subject = [data retain];
        return result;
	}
	
	



	- (Int) count
	{
		return [my_subject count];
	}
	
	- (id) at:(Int)index
	{
		return [my_subject objectAtIndex:index];
	}

	
	
	- (ObjectSealedList*) toSealed
	{
		return self;
	}

@end










@implementation ObjectMutableListImpl 

    - (void) dealloc
    {
        [my_subject release];
        [super dealloc];
    }
    
    
    
    
    
    + (ObjectMutableListImpl*) create:(Int)capacity
    {     
        ObjectMutableListImpl* result = [[[ObjectMutableListImpl alloc] init] autorelease];
        result->my_subject = [[NSMutableArray alloc] initWithCapacity:toUInt(capacity)];
        return result;
    }


	- (ObjectSealedList*) seal
	{
        ObjectSealedList* result = [ObjectSealedListImpl seal:[my_subject autorelease]];
        my_subject = nil;
        return result;
	}
	
	- (ObjectSealedList*) toSealed
	{
		return [ObjectSealedListImpl create:my_subject];
	}


	- (Int) count
	{
		return toInt([my_subject count]);
	}
	
	- (id) at:(Int)index
	{
		ASSERT([my_subject count] > 0); 
		ASSERT(toUInt(index) <= [my_subject count] - 1);
		return [my_subject objectAtIndex:toUInt(index)];
	}
		
	
	
	

	- (void) insertAt :(Int)index :(id)item 
	{
		[my_subject insertObject:item atIndex:toUInt(index)];
	}
	- (void) append:(id)item
	{
		[my_subject addObject:item];
	}
	
	
	- (void) modifyAt :(Int)index :(id)item 
	{
		[[[self at:index] retain] autorelease];
		[my_subject replaceObjectAtIndex:toUInt(index) withObject:item];
	}
	
	- (void) swap :(Int)x :(Int)y
	{
		[my_subject exchangeObjectAtIndex:toUInt(x) withObjectAtIndex:toUInt(y)];
	}
	
	
		
	- (void) removeAll 
	{ 
		ForEachIndex(i, self)
			[[[self at:i] retain] autorelease];
		
		[my_subject removeAllObjects];
	}
	
	- (void) removeAt:(Int)index
	{
		[[[self at:index] retain] autorelease];

		[my_subject removeObjectAtIndex:toUInt(index)];
	}
	
	- (void) removeEvery:(id)item
	{
		for (Int i = self.count; i > 0; --i)
		{
			if ([self at:i - 1] == item)
				[self removeAt:i - 1];
		}
	}

	

@end














@implementation ObjectList

	- (Int) count { ABSTRACT_METHOD(Int) }
	
	- (id) at:(Int)index          { ABSTRACT_METHOD_NIL }
	- (id) at:(Int)index :(id)def { ABSTRACT_METHOD_NIL }

	- (ObjectSealedList*) toSealed { ABSTRACT_METHOD_NIL }
	
@end
	
    
    
    
@implementation ObjectSealedList
 
	+ (ObjectSealedList*) empty
	{
		static ObjectSealedList* result = nil;
		
		if (result == nil)
			result = [[ObjectSealedListImpl create:[NSArray array]] retain];

		return result;
	}

@end




@implementation ObjectMutableList 
	
    + (ObjectMutableList*) create
    {
        return [ObjectMutableListImpl create:10];
    }
    
	+ (ObjectMutableList*) create:(Int)capacity
    {
        return [ObjectMutableListImpl create:capacity];
    }
    
    
	- (ObjectSealedList*) seal { ABSTRACT_METHOD_NIL; }
	
    
    - (void) insertAt :(Int)index :(id)item { ABSTRACT_METHOD_VOID; }
	
	- (void) append:(id)item { ABSTRACT_METHOD_VOID; }
    
    
    - (void) modifyAt :(Int)index :(id)item { ABSTRACT_METHOD_VOID; }
    
	- (void) swap :(Int)x :(Int)y { ABSTRACT_METHOD_VOID; }
		
	
	- (void) removeAll { ABSTRACT_METHOD_VOID; }
		
	- (void) removeAt:(Int)index { ABSTRACT_METHOD_VOID; }
		
	- (void) removeEvery:(id)item { ABSTRACT_METHOD_VOID; }
	
	
@end












@implementation ObjectList (_)

	- (id) at:(Int)index :(id)def
	{
		return [self isValidIndex:index] ? [self at:index] : def;
	}
	
	
	- (Bool) findOfObject:(id)item
	{
		ForEachIndex(i, self)
			if ([self at:i] == item)
				return Yes;
		
		return No;	
	}

    - (Int) findCountOfObject:(id)item
    {
        Int result = 0;
        
        for (Int i = 0; i < self.count; i++)
        {
            if ([self at:i] == item)
                result++;
        }
        
        return result;
    }


	- (NubleInt) findFirstIndexOfObject:(id)item
	{
		ForEachIndex(i, self)
			if ([self at:i] == item)
				return Int_toNuble(i);
		
		return Int_nuble();
	}
	
	- (NubleInt) findLastIndexOfObject:(id)item
	{
		ForEachIndexInRev(i, self)
			if ([self at:i] == item)
				return Int_toNuble(i);
		
		return Int_nuble();
	}	
	
	
	
	
	- (Bool) find:(ID_Predicate)predicate
	{
		ForEachIndex(i, self)
		{
			if (predicate([self at:i]))
				return YES;
		}
		
		return NO;
	}
	
	- (Int) findCount:(ID_Predicate)predicate
	{
		Int result = 0;
		ForEachIndex(i, self)
			result += predicate([self at:i]) ? 1 : 0;
			
		return result;
	}

	- (NubleID) findFirst:(ID_Predicate)predicate
	{
		ForEachIndex(i, self)
		{
			id item = [self at:i];
			if (predicate(item))
				return ID_toNuble(item);
		}
		
		return ID_nuble();
	}
	
	- (NubleID) findLast:(ID_Predicate)predicate
	{
		ForEachIndexInRev(i, self)
		{
			id item = [self at:i];
			if (predicate(item))
				return ID_toNuble(item);
		}
		
		return ID_nuble();	
	}
	
	
	- (NubleInt) findFirstIndex:(ID_Predicate)predicate
	{
		ForEachIndex(i, self)
		{
			id item = [self at:i];
			if (predicate(item))
				return Int_toNuble(i);
		}
		
		return Int_nuble();
	}
	
	- (NubleInt) findLastIndex:(ID_Predicate)predicate
	{
		ForEachIndexInRev(i, self)
		{
			id item = [self at:i];
			if (predicate(item))
				return Int_toNuble(i);
		}
		
		return Int_nuble();	
	}
		

	- (ObjectMutableList*) findAll:(ID_Predicate)predicate
	{
		ObjectMutableList* result = [ObjectMutableList create:10];
		
		ForEachIndex(i, self)
		{
			id item = [self at:i];
			if (predicate(item))
				[result append:item];
		}
		
		return result;
	}
	
	
	
	
	


	- (BinarySearchResult) binarySearch :(ID_IsSmallerTarget)isSmaller
	{
		SELFTEST_START
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@"a,c,e"));
			
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"a")); }], Yes, 0);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"b")); }], No, 1);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"c")); }], Yes, 1);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"d")); }], No, 2);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"e")); }], Yes, 2);
		}
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@"b"));
			
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"a")); }], No, 0);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"b")); }], Yes, 0);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"c")); }], No, 1);
		}
		{
			StringMutableList* list = [StringMutableList create:0];
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"a")); }], No, 0);
		}		
		
		SELFTEST_END
	
			
		if (self.count == 0) 
			return BinarySearchResult_create(No, 0);
			
		return [self binarySearch :isSmaller :self.firstIndex :self.lastIndex];		
	}
	
	- (BinarySearchResult) binarySearch :(ID_IsSmallerTarget)isSmaller :(Int)start :(Int)end
	{	
		ASSERT([self isValidIndex:start] && [self isValidIndex:end]);

		while (start <= end)
		{		
			Int position = start + ((end - start) / 2); 
			
			NubleBool b = isSmaller([self at:position]);
			
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




	- (ObjectListEnumerator*) each
	{
		SELFTEST_START
		
		{
			StringMutableList* allItem = [StringMutableList create];
			[allItem append:STR(@"a")];
			[allItem append:STR(@"b")];
			[allItem append:STR(@"c")];
			
			Int count = 0;
			ForEach(StringList, item, allItem.each)
			{
				if (count == 0) ASSERT(item.index == 0 && [item.var eq:STR(@"a")]);
				if (count == 1) ASSERT(item.index == 1 && [item.var eq:STR(@"b")]);
				if (count == 2) ASSERT(item.index == 2 && [item.var eq:STR(@"c")]);
				count++;
			}
		}
		
		{
			StringMutableList* allItem = [StringMutableList create];

			ForEach(StringList, item, allItem.each)
				ASSERT(No);
		}			
		
		SELFTEST_END
	
		return [[[ObjectListEnumeratorImpl alloc] initWithList :self :No] autorelease];
	}

	- (ObjectListEnumerator*) reversedEach
	{
		return [[[ObjectListEnumeratorImpl alloc] initWithList :self :Yes] autorelease];
	}

	
	- (ObjectListEnumerator*) findAllMatch:(ID_Predicate)predicate
	{
		return [[[ObjectListFilteredEnumeratorImpl alloc] initWithList :self :No :predicate] autorelease];
	}




		
    - (id) first
	{
		ASSERT(self.count > 0);
		return [self at:0];
	}
	- (id) second
	{
		ASSERT(self.count > 0);
		return [self at:1];
	}
	- (id) third
	{
		ASSERT(self.count > 0);
		return [self at:2];
	}
	- (id) fourth
	{
		ASSERT(self.count > 0);
		return [self at:3];
	}
	
	
	
    - (id) last
	{
		ASSERT(self.count > 0);
		return [self at:self.lastIndex];
	}
	
        	
    - (id) firstOrNil
    {
        return (self.count > 0) ? [self at:0] : nil;
    }
    
    - (id) lastOrNil
    {
        return (self.count > 0) ? [self at:self.lastIndex] : nil;
    }

		
@end



@implementation ObjectMutableList (_)


	- (void) insert:(id)item
	{
		[self insertAt :0 :item];
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
	
	
	- (void) removeDuplication:(ID_IsEqual)isEqual
	{
		SELFTEST_START
		
		StringMutableList* list;
		
		list = StringMutableList_fromStringList(STR(@"J,K,L"));
		[list removeDuplication:^(String* x, String* y) { return [x eq:y]; } ];
		[list assert:STR(@"J,K,L")];

		list = StringMutableList_fromStringList(STR(@"J,K,L,J"));
		[list removeDuplication:^(String* x, String* y) { return [x eq:y]; } ];
		[list assert:STR(@"J,K,L")];

		list = StringMutableList_fromStringList(STR(@"J,K,J,J,L,L,L,K"));
		[list removeDuplication:^(String* x, String* y) { return [x eq:y]; } ];
		[list assert:STR(@"J,K,L")];

		SELFTEST_END
		
		
		ForEachIndex(i, self)
		{
			id x = [self at:i];
			
			ForEachIndexInRev(j, self)
			{
				if (j <= i) break;
				
				if (isEqual(x, [self at:j]))
					[self removeAt:j];
			}
		}
	}
	
	- (void) removeMatch:(ID_Predicate)predicate
	{
		ForEachIndex(i, self)
		{
			if (predicate([self at:i]))
			{
				[self removeAt:i];
				i--;
			}
		}
	}
	
	
	- (void) replaceAll :(ObjectList*)allItem
	{
		[self removeAll];
		
		ForEachIndex(i, allItem)
			[self append:[allItem at:i]];
	}
	
	
	
	
	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY
	{
		SELFTEST_START
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@""));
			[list mergeSort:^(String* x, String* y) { return Char_isSmallerXY(x.firstChar, y.firstChar); }];
			[list.debugInfo assert:@""];
		}
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@"b,a"));
			[list mergeSort:^(String* x, String* y) { return Char_isSmallerXY(x.firstChar, y.firstChar); }];
			[list.debugInfo assert:@"a,b"];
		}	
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@"d,b,c,a"));
			[list mergeSort:^(String* x, String* y) { return Char_isSmallerXY(x.firstChar, y.firstChar); }];
			[list.debugInfo assert:@"a,b,c,d"];
		}	
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@"a,b,c,d"));
			[list mergeSort:^(String* x, String* y) { return Char_isSmallerXY(x.firstChar, y.firstChar); }];
			[list.debugInfo assert:@"a,b,c,d"];
		}	
		
		SELFTEST_END
		
	
		if (self.count > 1) 
			[self mergeSort :isSmallerXY :self.firstIndex :self.lastIndex]; 
	}
	
	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY :(Int)start :(Int)end
	{
		if (self.count <= 1) 
			return; 

		ASSERT([self isValidIndex:start] && [self isValidIndex:end]); 
		
		ObjectMutableList* helper = [ObjectMutableList create:self.count]; 
		ForEachIndex(i, self)
			[helper append:[self at:i]]; 
				
		[self mergeSort :isSmallerXY :start :end :helper]; 
	}
	
	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY :(Int)start :(Int)end :(ObjectMutableList*)helper
	{
		if (start >= end) 
			return;

		Int middle = (start + end) / 2;

		[self mergeSort :isSmallerXY :start :middle :helper];
		[self mergeSort :isSmallerXY :middle + 1 :end :helper];

		for (Int i = start; i <= end; i++)
			[helper modifyAt :i :[self at:i]];

		Int left = start;
		Int right = middle + 1;
		Int index = start;
			
		while (left <= middle && right <= end)
		{
			if (varOrYes(isSmallerXY([helper at:left], [helper at:right])))
				[self modifyAt :index++ :[helper at:left++]];
			else
				[self modifyAt :index++ :[helper at:right++]];
		}
	
		for ( ; left <= middle; left++)
			[self modifyAt :index++ :[helper at:left]];

		for ( ; right <= end; right++)
			[self modifyAt :index++ :[helper at:right]];
	}
		
@end

















void ObjectList_selfTest(void)
{
	{
		StringMutableList* list = [StringMutableList create];

		[list append:STR(@"J")];
		[list assert:STR(@"J")];
				
		[list append:STR(@"K")];
		[list append:STR(@"L")];
		[list assert:STR(@"J,K,L")];
		
		[list insertAt :0 :STR(@"I")];
		[list assert:STR(@"I,J,K,L")];
		
		[list insertAt :0 :STR(@"H")];
		[list assert:STR(@"H,I,J,K,L")];
		
		[list removeFirst];
		[list assert:STR(@"I,J,K,L")];

		[list removeLast];
		[list assert:STR(@"I,J,K")];
		
		[list removeAt:1];
		[list assert:STR(@"I,K")];
		
		[list seal];
	}
	{
		StringMutableList* list = StringMutableList_fromStringList(STR(@"J,K,L"));
		
		ASSERT([list find:^(String* str) { return [str eqNS:@"J"]; }]);
		ASSERT([list find:^(String* str) { return [str eqNS:@"K"]; }]);
		ASSERT([list find:^(String* str) { return [str eqNS:@"L"]; }]);
		ASSERT([list find:^(String* str) { return [str eqNS:@"382095"];}] == NO);
	}
	
	
	
	
	
}




