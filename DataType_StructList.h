





@interface StructListEnumerator : ListEnumeratorBase

    - (void) var:(void*)buffer;

@end








@interface StructList : ListBase
    
	@property (readonly) size_t size;
	
    - (void) at :(Int)index :(void*)buffer;
	
/*
    - (NubleBool) isSmaller :(ConstPntr_IsSmallerTarget)isSmaller :(Int)index;
	- (NubleBool) isSmaller :(ConstPntr_IsSmallerXY)isSmaller :(Int)xIndex :(Int)yIndex;
*/	
	- (StructSealedList*) toSealed;
    
@end


@interface StructList (_)

	- (void) at:(Int)index or:(void*)def :(void*)buffer;
	
	@property (readonly) StructListEnumerator* each;
	@property (readonly) StructListEnumerator* reversedEach;


/*
    - (Bool) findValue:(ConstPntr)value;

    - (Int) findFirstIndexOfValue:(ConstPntr)value;
	- (Int) findFirstIndexOfValue:(ConstPntr)value :(Int)defIndex;
	- (NubleInt) findFirstIndexOfValue_:(ConstPntr)value;
*/	
    
    - (void) first:(Pntr)buffer;
    - (void) first:(ConstPntr)def :(Pntr)buffer;

    - (void) last:(Pntr)buffer;	
    - (void) last:(ConstPntr)def :(Pntr)buffer;
	
	
	- (BinarySearchResult) binarySearch :(ConstPntr_IsSmallerTarget)isSmaller;	
	- (BinarySearchResult) binarySearch :(ConstPntr_IsSmallerTarget)isSmaller :(Int)start :(Int)end;
			
			
@end






@interface StructSealedList : StructList

	+ (StructSealedList*) createEmpty:(size_t)size;

@end





@interface StructMutableList : StructList

    + (StructMutableList*) create:(size_t)size;
	+ (StructMutableList*) create:(size_t)size :(Int)capacity;
	
	
	- (StructSealedList*) seal;
	
	
	@property (readonly) void* mutableBytes;
	
	
	- (void) insertZeroAt :(Int)index;
	
	- (void) insertAt :(Int)index :(const void*)value;
    
    - (void) modifyAt :(Int)index :(const void*)value;


	- (void) removeAll;

	- (void) removeAt:(Int)index;
	
	
	
	- (void) appendFrom :(StructList*)fromList :(Int)fromIndex;
	- (void) insertAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex;
	- (void) modifyAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex;
	
@end


@interface StructMutableList (_)

    - (void) append :(const void*)value1;
	- (void) append :(const void*)value1 :(const void*)value2;
	- (void) append :(const void*)value1 :(const void*)value2 :(const void*)value3;
	- (void) append :(const void*)value1 :(const void*)value2 :(const void*)value3 :(const void*)value4;

	- (void) removeFirst;
	- (void) removeLast;

	- (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY;
	- (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY :(Int)start :(Int)end;
	- (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY :(Int)start :(Int)end :(StructMutableList*)helper;

@end



@interface StructList (selfTest)

	+ (void) selfTest;

@end








#define STRUCT_LIST_INTERFACE_TEMPLATE(TYPE) \
\
	NS_INLINE TYPE TYPE##_fromPntr(ConstPntr ptr) { TYPE result; result = *((const TYPE*)ptr); return result; } \
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
			StructList* my_subject; \
		} \
\
		- (TYPE##SealedList*) toSealed; \
\
		- (TYPE) at:(Int)index; \
		- (TYPE) at:(Int)index or:(TYPE)def; \
\
		@property (readonly) TYPE first; \
		@property (readonly) TYPE last; \
\
		- (TYPE) first:(TYPE)def; \
		- (TYPE) last:(TYPE)def; \
\
		@property (readonly) TYPE##ListEnumerator* each; \
		@property (readonly) TYPE##ListEnumerator* reversedEach; \
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
			StructSealedList* my_sealedSubject; \
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
			StructMutableList* my_mutableSubject; \
		} \
\
		+ (TYPE##MutableList*) create; \
		+ (TYPE##MutableList*) create:(Int)capacity; \
\
\
		- (TYPE##SealedList*) seal; \
\
		@property (readonly) void* mutableBytes; \
\
		- (void) insertAt :(Int)index :(TYPE)value; \
\
		- (void) modifyAt :(Int)index :(TYPE)value; \
\
		- (void) append :(TYPE)value1; \
		- (void) append :(TYPE)value1 :(TYPE)value2; \
		- (void) append :(TYPE)value1 :(TYPE)value2 :(TYPE)value3; \
		- (void) append :(TYPE)value1 :(TYPE)value2 :(TYPE)value3 :(TYPE)value4; \
\
\
		- (void) removeAll; \
		- (void) removeAt:(Int)index; \
		- (void) removeFirst; \
		- (void) removeLast; \
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
				StructListEnumerator* my_subject; \
		} \
\
		+ (TYPE##ListEnumerator*) create:(StructListEnumerator*)subject; \
\
		- (Bool) next; \
		@property (readonly) Int index; \
		@property (readonly) TYPE var; \
\
	@end \
\
\



 


#define STRUCT_LIST_IMPLEMENTATION_TEMPLATE(TYPE) \
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
        - (TYPE) at:(Int)index \
		{ \
			TYPE result; \
			[my_subject at:index :&result]; \
			return result; \
		} \
\
		- (TYPE) at:(Int)index or:(TYPE)def \
		{ \
			TYPE result; \
			[my_subject at:index or:&def :&result];  \
			return result; \
		} \
\
		- (TYPE) first { return [self at:0]; } \
		- (TYPE) last { return [self at:self.lastIndex]; } \
\
		- (TYPE) first:(TYPE)def { return [self at:0 or:def]; } \
		- (TYPE) last:(TYPE)def { return [self at:self.lastIndex or:def]; } \
\
		- (TYPE##ListEnumerator*) each { return [TYPE##ListEnumerator create:my_subject.each]; } \
		- (TYPE##ListEnumerator*) reversedEach { return [TYPE##ListEnumerator create:my_subject.reversedEach]; } \
\
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller                       { return [my_subject binarySearch:^(ConstPntr p) { return isSmaller(TYPE##_fromPntr(p)); }]; } \
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller :(Int)start :(Int)end { return [my_subject binarySearch:^(ConstPntr p) { return isSmaller(TYPE##_fromPntr(p)); } :start :end]; } \
\
	@end \
\
	@implementation TYPE##SealedList \
\
		+ (TYPE##SealedList*) empty \
		{ \
			static TYPE##SealedList* result = nil;\
\
			if (result == nil) \
			{ \
				result = [[TYPE##SealedList alloc] init]; \
				result->my_subject = [StructSealedList createEmpty:sizeof(TYPE)]; \
			} \
\
			return result;\
		} \
\
	@end \
\
	@implementation TYPE##MutableList \
\
		+ (TYPE##MutableList*) create \
		{ \
			TYPE##MutableList* result = [[[TYPE##MutableList alloc] init] autorelease]; \
			result->my_mutableSubject = [[StructMutableList create:sizeof(TYPE)] retain]; \
			result->my_subject = result->my_mutableSubject; \
			return result; \
		} \
\
		+ (TYPE##MutableList*) create:(Int)capacity \
		{ \
			TYPE##MutableList* result = [[[TYPE##MutableList alloc] init] autorelease]; \
			result->my_mutableSubject = [[StructMutableList create:sizeof(TYPE) :capacity] retain]; \
			result->my_subject = result->my_mutableSubject; \
			return result; \
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
		- (void*) mutableBytes { return my_mutableSubject.mutableBytes; } \
\
		- (void) append :(TYPE)value1 { [my_mutableSubject append :&value1]; } \
		- (void) append :(TYPE)value1 :(TYPE)value2 { [my_mutableSubject append :&value1 :&value2]; } \
		- (void) append :(TYPE)value1 :(TYPE)value2 :(TYPE)value3 { [my_mutableSubject append :&value1 :&value2 :&value3]; } \
		- (void) append :(TYPE)value1 :(TYPE)value2 :(TYPE)value3 :(TYPE)value4 { [my_mutableSubject append :&value1 :&value2 :&value3 :&value4]; } \
\
		- (void) insertAt :(Int)index :(TYPE)value { [my_mutableSubject insertAt :index :&value]; } \
		- (void) modifyAt :(Int)index :(TYPE)value { [my_mutableSubject modifyAt :index :&value]; } \
\
		- (void) removeAll { [my_mutableSubject removeAll]; } \
		- (void) removeAt:(Int)index { [my_mutableSubject removeAt:index]; } \
		- (void) removeFirst { [my_mutableSubject removeFirst]; } \
		- (void) removeLast { [my_mutableSubject removeLast]; } \
\
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller                       { [my_mutableSubject mergeSort :^(ConstPntr x, ConstPntr y) { return isSmaller(TYPE##_fromPntr(x), TYPE##_fromPntr(y)); } ]; } \
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller :(Int)start :(Int)end { [my_mutableSubject mergeSort :^(ConstPntr x, ConstPntr y) { return isSmaller(TYPE##_fromPntr(x), TYPE##_fromPntr(y)); } :start :end]; } \
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
		+ (TYPE##ListEnumerator*) create:(StructListEnumerator*)subject \
		{ \
			TYPE##ListEnumerator* result = [[[TYPE##ListEnumerator alloc] init] autorelease]; \
			result->my_subject = [subject retain]; \
			return result; \
		} \
\
		- (Bool) next { return [my_subject next]; } \
		- (Int) index { return my_subject.index; } \
\
		- (TYPE) var \
		{ \
			TYPE result; \
			[my_subject var:&result];  \
			return result; \
		} \
\
	@end \
\
\



	
	
	
STRUCT_LIST_INTERFACE_TEMPLATE(NubleID)
	
	
	



void StructList_selfTest(void);






NUBLE_STRUCT_TEMPLATE(CGFloat) 
STRUCT_BLOCK(CGFloat) 	
STRUCT_LIST_INTERFACE_TEMPLATE(CGFloat)
	




/*
public class Mergesort {
	private int[] numbers;

	private int number;

	public void sort(int[] values) {
		this.numbers = values;
		number = values.length;

		mergesort(0, number - 1);
	}

	private void mergesort(int low, int high) {
		// Check if low is smaller then high, if not then the array is sorted
		if (low < high) {
			// Get the index of the element which is in the middle
			int middle = (low + high) / 2;
			// Sort the left side of the array
			mergesort(low, middle);
			// Sort the right side of the array
			mergesort(middle + 1, high);
			// Combine them both
			merge(low, middle, high);
		}
	}

	private void merge(int low, int middle, int high) {

		// Helperarray
		int[] helper = new int[number];

		// Copy both parts into the helper array
		for (int i = low; i <= high; i++) {
			helper[i] = numbers[i];
		}

		int i = low;
		int j = middle + 1;
		int k = low;
		// Copy the smallest values from either the left or the right side back
		// to the original array
		while (i <= middle && j <= high) {
			if (helper[i] <= helper[j]) {
				numbers[k] = helper[i];
				i++;
			} else {
				numbers[k] = helper[j];
				j++;
			}
			k++;
		}
		// Copy the rest of the left side of the array into the target array
		while (i <= middle) {
			numbers[k] = helper[i];
			k++;
			i++;
		}
		helper = null;

	}
}
*/

	
	



