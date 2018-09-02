







@interface ObjectListEnumerator : ListEnumeratorBase

	@property (readonly) id var;
	@property (readonly) Int listCount;
	
	
	- (ObjectMutableList*) getAll;

@end


@interface ObjectListFilteredEnumerator : ObjectListEnumerator

	@property (readonly) Int i;
	
@end











@interface ObjectList : ListBase

	- (id) at:(Int)index;
	
	- (ObjectSealedList*) toSealed;
	
	
@end


@interface ObjectList (_)

	- (id) at:(Int)index :(id)def;

	- (Bool) findOfObject:(id)item;
    - (Int) findCountOfObject:(id)item;
    - (NubleInt) findFirstIndexOfObject:(id)item;
	- (NubleInt) findLastIndexOfObject:(id)item;

	- (Bool) find:(ID_Predicate)predicate;
	- (Int) findCount:(ID_Predicate)predicate;

	- (NubleID) findFirst:(ID_Predicate)predicate;
	- (NubleID) findLast:(ID_Predicate)predicate;
	
	
	- (NubleInt) findFirstIndex:(ID_Predicate)predicate;
	- (NubleInt) findLastIndex:(ID_Predicate)predicate;
	

	- (ObjectMutableList*) findAll:(ID_Predicate)predicate;
	
    
	@property (readonly) ObjectListEnumerator* each;
	@property (readonly) ObjectListEnumerator* reversedEach;
	
	- (ObjectListEnumerator*) findAllMatch:(ID_Predicate)predicate;

	
    @property (readonly) id first;
	@property (readonly) id second;
	@property (readonly) id third;
	@property (readonly) id fourth;
	
    @property (readonly) id last;

		
    @property (readonly) id firstOrNil;
    @property (readonly) id lastOrNil;
    

	- (BinarySearchResult) binarySearch :(ID_IsSmallerTarget)isSmaller;	
	- (BinarySearchResult) binarySearch :(ID_IsSmallerTarget)isSmaller :(Int)start :(Int)end;
	
		
	
@end



@interface ObjectSealedList : ObjectList

	+ (ObjectSealedList*) empty;
	
@end



@interface ObjectMutableList : ObjectList
	
    + (ObjectMutableList*) create;
	+ (ObjectMutableList*) create:(Int)capacity;
	
	- (ObjectSealedList*) seal;
	
	- (void) insertAt :(Int)index :(id)item;
	- (void) append:(id)item;
	
	- (void) modifyAt :(Int)index :(id)item;
	
	- (void) swap :(Int)x :(Int)y;
	
	
	- (void) removeAll;
	
	
	- (void) removeAt:(Int)index;
	
	- (void) removeEvery:(id)item;
	
	
	
@end

@interface ObjectMutableList (_)

	- (void) insert:(id)item;

	- (void) removeFirst;
	- (void) removeLast;
	
	- (void) removeDuplication:(ID_IsEqual)isEqual;

	- (void) removeMatch:(ID_Predicate)predicate;
	
	
	- (void) replaceAll :(ObjectList*)allItem;
	
	
	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY;
	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY :(Int)start :(Int)end;
	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY :(Int)start :(Int)end :(ObjectMutableList*)helper;

@end















#define OBJECT_LIST_INTERFACE_TEMPLATE(TYPE) \
\
	@class TYPE##List; \
	@class TYPE##SealedList; \
	@class TYPE##MutableList; \
	@class TYPE##ListEnumerator; \
\
\
	@interface TYPE##List : ListBase \
		{ \
        @public \
			ObjectList* my_subject; \
		} \
\
		- (TYPE##SealedList*) toSealed; \
\
		- (TYPE*) at:(Int)index; \
		- (TYPE*) at:(Int)index :(TYPE*)def; \
\
		@property (readonly) TYPE* first; \
		@property (readonly) TYPE* second; \
		@property (readonly) TYPE* third; \
		@property (readonly) TYPE* fourth; \
		@property (readonly) TYPE* last; \
\
		- (TYPE*) firstOr:(TYPE*)def; \
		- (TYPE*) lastOr:(TYPE*)def; \
\
		@property (readonly) TYPE##ListEnumerator* each; \
		@property (readonly) TYPE##ListEnumerator* reversedEach; \
		- (TYPE##ListEnumerator*) findAllMatch:(TYPE##_Predicate)predicate; \
\
		- (Bool) findOfObject:(TYPE*)item;  \
		- (NubleInt) findFirstIndexOfObject:(TYPE*)item;  \
		- (NubleInt) findLastIndexOfObject:(TYPE*)item;  \
\
		- (Bool) find:(TYPE##_Predicate)predicate; \
		- (Int) findCount:(TYPE##_Predicate)predicate; \
\
		- (Nuble##TYPE) findFirst:(TYPE##_Predicate)predicate; \
		- (Nuble##TYPE) findLast:(TYPE##_Predicate)predicate; \
\
		- (TYPE##MutableList*) findAll:(TYPE##_Predicate)predicate; \
\
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller; \
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller :(Int)start :(Int)end;  \
\
	@end \
\
\
	@interface TYPE##SealedList : TYPE##List \
		{ \
        @public \
			ObjectSealedList* my_sealedSubject; \
		} \
\
		+ (TYPE##SealedList*) empty; \
\
	@end \
\
\
	@interface TYPE##MutableList : TYPE##List \
		{ \
        @public \
			ObjectMutableList* my_mutableSubject; \
		} \
\
		+ (TYPE##MutableList*) createWithSubject:(ObjectMutableList*)subject; \
\
		+ (TYPE##MutableList*) create; \
		+ (TYPE##MutableList*) create:(Int)capacity; \
\
\
		- (TYPE##SealedList*) seal; \
\
		- (void) insert :(TYPE*)value; \
		- (void) insertAt :(Int)index :(TYPE*)value; \
\
		- (void) modifyAt :(Int)index :(TYPE*)value; \
\
		- (void) append:(TYPE*)value; \
\
		- (void) removeAll;\
		- (void) removeAt:(Int)index; \
		- (void) removeFirst; \
		- (void) removeLast; \
		- (void) removeEvery:(TYPE*)value; \
\
		- (void) removeDuplication :(TYPE##_IsEqual)isEqual; \
		- (void) removeMatch :(TYPE##_Predicate)predicate; \
\
		- (void) replaceAll :(TYPE##List*)allItem; \
\
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller; \
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller :(Int)start :(Int)end; \
\
	@end \
\
\
	@interface TYPE##ListEnumerator : ObjectBase \
		{ \
		@public \
			ObjectListEnumerator* my_subject; \
		} \
\
		+ (TYPE##ListEnumerator*) create:(ObjectListEnumerator*)subject; \
\
		- (Bool) next; \
		@property (readonly) Int index; \
		@property (readonly) TYPE* var; \
\
	@end \
\
\







 


#define OBJECT_LIST_IMPLEMENTATION_TEMPLATE(TYPE) \
\
	@implementation TYPE##List \
\
		- (void) dealloc \
		{ \
			[my_subject release]; \
			[super dealloc]; \
		} \
\
		- (TYPE##SealedList*) toSealed \
		{ \
			TYPE##SealedList* result = [[[TYPE##SealedList alloc] init] autorelease]; \
			result->my_sealedSubject = [[my_subject toSealed] retain]; \
			result->my_subject = result->my_sealedSubject; \
			return result; \
		} \
\
		- (Int) count { return my_subject.count; } \
\
        - (TYPE*) at:(Int)index             { return [my_subject at:index]; } \
		- (TYPE*) at:(Int)index :(TYPE*)def { return [my_subject at:index :def]; } \
\
		- (TYPE*) first { return my_subject.first; } \
		- (TYPE*) second { return my_subject.second; } \
		- (TYPE*) third { return my_subject.third; } \
		- (TYPE*) fourth { return my_subject.fourth; } \
		- (TYPE*) last { return my_subject.last; } \
\
		- (TYPE*) firstOrNil { return my_subject.firstOrNil; } \
		- (TYPE*) lastOrNil { return my_subject.lastOrNil; } \
\
		- (TYPE*) firstOr:(TYPE*)def { return [self at:0 :def]; } \
		- (TYPE*) lastOr:(TYPE*)def { return [self at:self.lastIndex :def]; } \
\
		- (TYPE##ListEnumerator*) each { return [TYPE##ListEnumerator create:my_subject.each]; } \
		- (TYPE##ListEnumerator*) reversedEach { return [TYPE##ListEnumerator create:my_subject.reversedEach]; } \
		- (TYPE##ListEnumerator*) findAllMatch:(TYPE##_Predicate)predicate { return [TYPE##ListEnumerator create: [my_subject findAllMatch: ^(id value) { return predicate((TYPE*)value); } ]];  } \
\
		- (Bool) findOfObject:(TYPE*)item { return [my_subject findOfObject:item]; } \
		- (NubleInt) findFirstIndexOfObject:(TYPE*)item { return [my_subject findFirstIndexOfObject:item]; } \
		- (NubleInt) findLastIndexOfObject:(TYPE*)item; { return [my_subject findLastIndexOfObject:item]; } \
\
		- (Bool) find:(TYPE##_Predicate)predicate { return [my_subject find:^(id value) { return predicate((TYPE*)value); } ]; } \
		- (Int) findCount:(TYPE##_Predicate)predicate { return [my_subject findCount:^(id value) { return predicate((TYPE*)value); } ]; } \
\
		- (Nuble##TYPE) findFirst:(TYPE##_Predicate)predicate { NubleID r = [my_subject findFirst:^(id value) { return predicate(value); } ]; return TYPE##_createNuble(r.hasVar, r.vd); } \
		- (Nuble##TYPE) findLast:(TYPE##_Predicate)predicate; { NubleID r = [my_subject findLast:^(id value) { return predicate(value); } ]; return TYPE##_createNuble(r.hasVar, r.vd); } \
\
		- (TYPE##MutableList*) findAll:(TYPE##_Predicate)predicate { return [TYPE##MutableList createWithSubject:[my_subject findAll:^(id value) { return predicate(value); } ] ]; } \
\
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller                       { return [my_subject binarySearch:^(id i) { return isSmaller(i); }]; } \
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller :(Int)start :(Int)end { return [my_subject binarySearch:^(id i) { return isSmaller(i); } :start :end]; } \
\
	@end \
\
	@implementation TYPE##SealedList \
\
		+ (TYPE##SealedList*) empty \
		{ \
			static TYPE##SealedList* result = nil; \
\
			if (result == nil) \
			{ \
				result = [[TYPE##SealedList alloc] init]; \
				result->my_subject = [ObjectSealedList empty]; \
			} \
\
			return result; \
		} \
\
	@end \
\
	@implementation TYPE##MutableList \
\
		+ (TYPE##MutableList*) createWithSubject:(ObjectMutableList*)subject \
		{ \
			TYPE##MutableList* result = [[[TYPE##MutableList alloc] init] autorelease]; \
			result->my_mutableSubject = [subject retain]; \
			result->my_subject = result->my_mutableSubject; \
			return result; \
		} \
\
		+ (TYPE##MutableList*) create \
		{ \
			return [TYPE##MutableList createWithSubject:[ObjectMutableList create]]; \
		} \
\
		+ (TYPE##MutableList*) create:(Int)capacity \
		{ \
			return [TYPE##MutableList createWithSubject:[ObjectMutableList create:capacity]]; \
		} \
\
		- (TYPE##SealedList*) seal \
		{ \
			TYPE##SealedList* result = [[[TYPE##SealedList alloc] init] autorelease]; \
			result->my_sealedSubject = [[my_mutableSubject seal] retain]; \
			result->my_subject = result->my_sealedSubject; \
			return result; \
		} \
\
		- (void) append:(TYPE*)item { [my_mutableSubject append:item]; } \
\
		- (void) insert :(TYPE*)item { [my_mutableSubject insert :item]; } \
		- (void) insertAt :(Int)index :(TYPE*)item { [my_mutableSubject insertAt :index :item]; } \
		- (void) modifyAt :(Int)index :(TYPE*)item { [my_mutableSubject modifyAt :index :item]; } \
\
		- (void) removeAll { [my_mutableSubject removeAll]; }  \
		- (void) removeAt:(Int)index { [my_mutableSubject removeAt:index]; } \
		- (void) removeFirst { [my_mutableSubject removeFirst]; } \
		- (void) removeLast { [my_mutableSubject removeLast]; } \
		- (void) removeEvery:(TYPE*)value { [my_mutableSubject removeEvery:value]; } \
\
		- (void) removeDuplication:(TYPE##_IsEqual)isEqual { [my_mutableSubject removeDuplication:^(id x, id y) { return isEqual(x, y); } ]; } \
		- (void) removeMatch :(TYPE##_Predicate)predicate  { [my_mutableSubject removeMatch:^(id value) { return predicate(value); } ]; } \
\
		- (void) replaceAll :(TYPE##List*)allItem { [my_mutableSubject replaceAll:allItem->my_subject]; } \
\
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller                       { [my_mutableSubject mergeSort :^(id x, id y) { return isSmaller(x, y); }]; } \
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller :(Int)start :(Int)end { [my_mutableSubject mergeSort :^(id x, id y) { return isSmaller(x, y); } :start :end]; } \
\
	@end \
\
\
	@implementation TYPE##ListEnumerator \
\
		- (void) dealloc \
		{ \
			[my_subject release]; \
			[super dealloc]; \
		} \
\
		+ (TYPE##ListEnumerator*) create:(ObjectListEnumerator*)subject \
		{ \
			TYPE##ListEnumerator* result = [[[TYPE##ListEnumerator alloc] init] autorelease]; \
			result->my_subject = [subject retain]; \
			return result; \
		} \
\
		- (Bool) next { return [my_subject next]; } \
		- (Int) index { return my_subject.index; } \
		- (TYPE*) var { return (TYPE*)my_subject.var; } \
\
	@end \
\
\











void ObjectList_selfTest(void);





















