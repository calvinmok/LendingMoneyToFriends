















/*


@interface ObjectSetItem : ObjectBase
	
	@property(readonly) id item;
	@property(readonly) Int hash;
	@property(readonly) ObjectSetItem* next;
	
	- (ObjectSetItem*) lastSibling;
	
@end

NUBLE_OBJECT_TEMPLATE(ObjectSetItem)





@interface Set : ObjectBase


	- (NubleID) at :(Int)hash :(Int)index;
	
	
	@property(readonly) Int lastEntryIndex;

	- (NubleObjectSetItem) entryAt:(Int)entryIndex;
	
@end


@interface SealedSet : ObjectSet

@end

@interface MutableSet : ObjectSet

	+ (ObjectMutableSet*) create :(Int)capacity;

	- (void) append :(Int)hash :(id)item;
	
@end









#define SET_INTERFACE_TEMPLATE(NAME, ITEM, KEY) \
\
	@class NAME##Set; \
	@class NAME##MutableSet; \
\
	typedef KEY (^NAME##Set_getKey)(ITEM*); \
\
	typedef Int (^NAME##Set_getHash)(KEY); \
\
	typedef Bool (^NAME##Set_isEqual)(KEY, KEY); \
\
\
	@interface NAME##Set : ObjectBase \
		{ \
        @public \
			ObjectHashSet* my_subject; \
\
			NAME##Set_getKey my_getKey;  \
			NAME##Set_getHash my_getHash;  \
			NAME##Set_isEqual my_isEqual;  \
		} \
\
		- (Bool) contain:(KEY)key; \
\
		- (ITEM*) at:(KEY)key; \
		- (Nuble##ITEM) at_:(KEY)key; \
\
		@property (readonly) Int count; \
\
	@end \
\
\
	@interface NAME##MutableSet : NAME##Set \
		{ \
        @public \
			ObjectMutableHashSet* my_mutableSubject; \
		} \
\
		- (void) append:(ITEM)item; \
\
\
	@end \





#define SET_IMPLEMENTATION_TEMPLATE(ITEM, KEY) \
\
	@implementation NAME##Set \
\
		- (Bool) contain:(KEY)key \
		{ \
			Int hash = my_getHash(key); \
			for (Int i = 0; ; i++) \
			{ \
				NubleID item = [my_subject at :hash :i]; \
				if (item.hasVar == NO) return NO; \
				if (my_isEqual(key, my_getKey(item)) return YES; \
			} \
		} \
\
		- (Nuble##ITEM) at_:(KEY)key \
		{ \
			Int hash = my_getHash(key); \
			Int count = [my_subject itemCount:hash]; \
\
			for (Int i = 0; i < count; i++) \
			{ \
				if (my_isEqual(key, my_getKey([my_subject at :hast :i]))) \
					return Nuble##ITEM_toNuble(item); \
			} \
\
			return ITEM##_nuble(); \
		} \
\
		@property (readonly) Int count; \
\
	@end \
\
\
	@implementation ITEM##MutableHashSet \
\
		- (void) append:(ITEM)item \
		{ \
		} \
\
		- (void) remove:(KEY)key \
		{ \
		} \
\
	@end \








*/





























