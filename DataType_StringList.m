






#import "DataType.h"




OBJECT_LIST_IMPLEMENTATION_TEMPLATE(String)
OBJECT_LIST_IMPLEMENTATION_TEMPLATE(SealedString)
OBJECT_LIST_IMPLEMENTATION_TEMPLATE(MutableString)






@implementation StringList (_)


	- (Bool) containString:(String*)value
	{
		ForEachIndex(i, self)
		{
			if ([value eq:[self at:i]])
				return Yes;			
		}
		
		return No;
	}
	
	- (NubleInt) firstIndexOfString:(String*)value
	{
		ForEachIndex(i, self)
		{
			if ([value eq:[self at:i]])
				return Int_toNuble(i);			
		}
		
		return Int_nuble();
	}
	
	- (NubleInt) lastIndexOfString:(String*)value
	{
		ForEachIndexInRev(i, self)
		{
			if ([value eq:[self at:i]])
				return Int_toNuble(i);			
		}
		
		return Int_nuble();	
	}
	
	
	- (String*) debugInfo
	{
		MutableString* result = [MutableString create:10];
		
		ForEachIndex(i, self)
		{
			if (result.length > 0)
				[result append:STR(@",")];
			
			[result append:[self at:i]];
		}
		
		return result;
	}


	- (void) assert:(String*)stringList
	{
		StringList* list = [stringList split:STR(@",")];		
		
		ASSERT(list.count == self.count);
		
		ForEachIndex(i, list)
		{
			ASSERT([[self at:i] eq:[list at:i]]);
		}
	}

@end




StringMutableList* StringMutableList_fromStringList(String* stringList)
{
	return [stringList split:STR(@",")];
}













