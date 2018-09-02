






NS_INLINE Bool compareLastIndex(Int i, NubleInt lastIndex) { return (lastIndex.hasVar && i <= lastIndex.vd); }

NS_INLINE Bool compareFirstIndex(Int i, NubleInt firstIndex) { return (firstIndex.hasVar && i >= firstIndex.vd); }



#define ForEachIndex(VAR, LIST) \
	for (Int VAR = Int_varOr(LIST.firstIndex_, Int_Max); VAR != Int_Max && compareLastIndex(VAR, LIST.lastIndex_); VAR++)

#define ForEachIndexInRev(VAR, LIST) \
	for (Int VAR = Int_varOr(LIST.lastIndex_, Int_Min); VAR != Int_Min && compareFirstIndex(VAR, LIST.firstIndex_); --VAR)







@interface ListBase : ObjectBase

	@property (readonly) Int count;

@end

@interface ListBase (_)

	@property (readonly) ListIndexEnumerator* eachIndex;
	@property (readonly) ListIndexEnumerator* reversedEachIndex;

	- (Bool) isValidIndex:(Int)index;

	@property (readonly) Int firstIndex;
	@property (readonly) Int lastIndex;
	@property (readonly) NubleInt firstIndex_;
	@property (readonly) NubleInt lastIndex_;

	@property (readonly) Int nextIndex;

@end










#define ForEach(TypeName, VarName, Expr) \
	for (TypeName##Enumerator* VarName = Expr; [VarName next];  )



@interface ListEnumeratorBase : ObjectBase

	- (BOOL) next;

	@property (readonly) Int index;

@end


@interface ListIndexEnumerator : ListEnumeratorBase

	+ (ListIndexEnumerator*) create:(ListBase*)list;
	+ (ListIndexEnumerator*) createReversed:(ListBase*)list;

@end











typedef struct
{	
	BOOL isReversed;		
	Int pointer;
}
ListIndexData;


NS_INLINE ListIndexData ListIndexData_create(BOOL isReversed)
{
	ListIndexData result = { isReversed, 0 };
	return result;
};

NS_INLINE Bool ListIndexData_next(ListIndexData* data, NubleInt lastIndex)
{
	if (lastIndex.hasVar && data->pointer <= lastIndex.vd)
	{
		data->pointer += 1;
		return YES;
	}
	
	return NO;
};

NS_INLINE Int ListIndexData_index(const ListIndexData data, NubleInt lastIndex)
{
	ASSERT(lastIndex.hasVar && (data.pointer - 1) <= lastIndex.vd);
	
	return (data.isReversed) ? lastIndex.vd - (data.pointer - 1) : (data.pointer - 1);
};










typedef struct 
{
	Bool found;
	Int  index;
}
BinarySearchResult;

NS_INLINE BinarySearchResult BinarySearchResult_create(Bool foundMatch, Int index) { 
	BinarySearchResult result = { foundMatch, index }; return result; }

NS_INLINE void BinarySearchResult_assert(BinarySearchResult value, Bool found, Int index)
	{ ASSERT(value.found == found && value.index == index); }














