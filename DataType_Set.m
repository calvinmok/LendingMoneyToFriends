




#import "DataType.h"


#import "DataType_Set.h"

/*


@interface ObjectSetItemImpl : ObjectSetItem
	{
	@private	
		id my_item;
		Int my_hash;

		ObjectSetItemImpl* my_next;
	}


	+ (ObjectSetItemImpl*) create :(id)item :(Int)hash;

	
	@property(readonly) ObjectSetItemImpl* next_;	
	- (void) setNext :(ObjectSetItemImpl*)next;
		
	- (ObjectSetItemImpl*) lastSibling_;
	
@end


NUBLE_OBJECT_TEMPLATE(ObjectSetItemImpl)

OBJECT_LIST_INTERFACE_TEMPLATE(ObjectSetItemImpl)
OBJECT_LIST_IMPLEMENTATION_TEMPLATE(ObjectSetItemImpl)


ObjectSetItemImpl* ObjectSetItem_nullEntry(void);
ObjectSetItemImpl* ObjectSetItem_nullEntry(void)
{
	static ObjectSetItemImpl* result = nil; 
	
	if (result == nil) 
		result = [[ObjectSetItemImpl alloc] init];
		
	return result;
}


@implementation ObjectSetItemImpl

	+ (ObjectSetItemImpl*) create :(id)item :(Int)hash
	{
		ObjectSetItemImpl* result = [[[ObjectSetItemImpl alloc] init] autorelease];
		result->my_item = [item retain];
		result->my_hash = hash;
		result->my_next = [ObjectSetItem_nullEntry() retain];
		return result;
	}
	
	- (void) dealloc
	{
		[my_item release];
		[my_next release];
		[super dealloc];
	}	
	
	
	- (id) item { return my_item; }
	- (Int) hash { return my_hash; }
	- (ObjectSetItem*) next { return my_next; }
	
	
	- (ObjectSetItemImpl*) next_ { return my_next; }
	
	- (void) setNext :(ObjectSetItemImpl*)next
	{
		[my_next autorelease];
		my_next = [next retain];
	}
	
	
	- (ObjectSetItem*) lastSibling
	{
		return (self.next == ObjectSetItem_nullEntry()) ? self : self.next.lastSibling;
	}
	
	- (ObjectSetItemImpl*) lastSibling_
	{
		return (self.next_ == ObjectSetItem_nullEntry()) ? self : self.next_.lastSibling_;
	}
			
@end




@implementation ObjectSetItem

	
	- (id) item { ABSTRACT_METHOD_AS_NIL }
	- (Int) hash { ABSTRACT_METHOD_AS(Int) }
	- (ObjectSetItem*) next { ABSTRACT_METHOD_AS_NIL }
	
	- (ObjectSetItem*) lastSibling  { ABSTRACT_METHOD_AS_NIL }
	
@end






void ObjectSetItemImplMutableList_addEntry(ObjectSetItemImplMutableList* list, ObjectSetItemImpl* item);
void ObjectSetItemImplMutableList_addEntry(ObjectSetItemImplMutableList* list, ObjectSetItemImpl* item)
{
	if (item.next_ != ObjectSetItem_nullEntry())
	{
		ObjectSetItemImplMutableList_addEntry(list, item.next_);
		[item setNext :ObjectSetItem_nullEntry()];
	}	

	Int entryIndex = Int_mod(item.hash, list.count);
	
	ObjectSetItemImpl* entry = [list at:entryIndex];
		
	if (entry != ObjectSetItem_nullEntry())
		[entry.lastSibling_ setNext :item];
	else 
		[list modifyAt :entryIndex :item];	
}







@interface ObjectMutableSetImpl : ObjectMutableSet
	{
	@private
		Int my_count;
		ObjectSetItemImplMutableList* my_allEntry;
	}	


	+ (ObjectMutableSetImpl*) create :(Int)capacity;


	- (void) rehash;

@end



@implementation ObjectMutableSetImpl


	+ (ObjectMutableSetImpl*) create :(Int)capacity 
	{
		ObjectMutableSetImpl* result = [[[ObjectMutableSetImpl alloc] init] autorelease];
		result->my_count = 0;
		result->my_allEntry = [[ObjectSetItemImplMutableList create:capacity] retain];
		
		for (Int i = 0; i < capacity; i++)
			[result->my_allEntry append :ObjectSetItem_nullEntry()];
		
		return result;		
	}

	- (void) dealloc
	{
		[my_allEntry release];
		[super dealloc];
	}
	
	
	

	- (id) atOrNil :(Int)hash :(Int)index
	{
		Int entryIndex = Int_mod(hash, my_allEntry.count);
		
		ObjectSetItemImpl* setItem = [my_allEntry at:entryIndex];	
		
		Int count = 0;
		
		while (setItem != ObjectSetItem_nullEntry())
		{
			if (setItem.hash == hash)
			{
				if (count == index)
					return setItem.item;
					
				count += 1;
			}
		}
		
		return nil;
	}
	
	- (Int) lastEntryIndex
	{
		return my_allEntry.lastIndex;
	}
	
	- (NubleObjectSetItem) entryAt:(Int)entryIndex
	{
		ObjectSetItemImpl* setItem = [my_allEntry at:entryIndex];	
		
		if (setItem != ObjectSetItem_nullEntry())
			return ObjectSetItem_nuble();
		else 
			return ObjectSetItem_toNuble(setItem);
	}
	
			
	
	
	- (void) rehash
	{
		Int newCapacity = my_allEntry.count * 2 + 1;
		
		ObjectSetItemImplMutableList* newAllEntry = [ObjectSetItemImplMutableList create:newCapacity];
		for (Int i = 0; i < newCapacity; i++)
			[newAllEntry append :ObjectSetItem_nullEntry()];
		
		ForEachIndex(i, my_allEntry)
		{
			ObjectSetItemImpl* setItem = [my_allEntry at:i];		
					
			ObjectSetItemImplMutableList_addEntry(newAllEntry, setItem);
			[my_allEntry modifyAt :i :ObjectSetItem_nullEntry()];
		}
		
		[my_allEntry release];		
		my_allEntry = [newAllEntry retain];
	}
	

	- (void) append :(Int)hash :(id)item;
	{
		ObjectSetItemImpl* setItem = [ObjectSetItemImpl create :item :hash];
		ObjectSetItemImplMutableList_addEntry(my_allEntry, setItem);
		
		my_count += 1;
		
		if (my_count >= my_allEntry.count / 4 * 3)
			[self rehash];
	}
	
	

@end









@implementation ObjectSet 

	- (id) atOrNil :(Int)hash :(Int)index { ABSTRACT_METHOD_AS_NIL }
	
	- (Int) lastEntryIndex { ABSTRACT_METHOD_AS(Int) }

	- (NubleObjectSetItem) entryAt:(Int)entryIndex { ABSTRACT_METHOD_AS(NubleObjectSetItem) }
	
@end


@implementation SealedSet 

@end


@implementation ObjectMutableSet 

	
	+ (ObjectMutableSet*) create :(Int)capacity
	{
		return [ObjectMutableSetImpl create:capacity]; 
	}


	- (void) append :(Int)hash :(id)item { ABSTRACT_METHOD }
	
@end




*/











