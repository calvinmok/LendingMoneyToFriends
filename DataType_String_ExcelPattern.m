



#import "DataType.h"





typedef enum 
{
	ExcelPatternItemType_Char,
	ExcelPatternItemType_AnyChar,
	ExcelPatternItemType_AnyString	
}
ExcelPatternItemType;




typedef struct
{
	ExcelPatternItemType type;
	Char value;
}
ExcelPatternItem;




NS_INLINE ExcelPatternItem ExcelPatternItem_create(ExcelPatternItemType type, Char value) 
{ 
	ExcelPatternItem result = { type, value }; 
	return result; 
}


NUBLE_STRUCT_TEMPLATE(ExcelPatternItem)
STRUCT_BLOCK(ExcelPatternItem)

STRUCT_LIST_INTERFACE_TEMPLATE(ExcelPatternItem)
STRUCT_LIST_IMPLEMENTATION_TEMPLATE(ExcelPatternItem)




ExcelPatternItemList* ExcelPatternItem_createList(String* pattern);
ExcelPatternItemList* ExcelPatternItem_createList(String* pattern)
{
	ExcelPatternItemMutableList* result = [ExcelPatternItemMutableList create];
		
	Bool isEscaped = NO;
	
	ForEachIndex(i, pattern)
	{
		Char ch = [pattern charAt:i];
		
		if (isEscaped)
		{
			[result append:ExcelPatternItem_create(ExcelPatternItemType_Char, ch)];
			isEscaped = NO;
		}
		else 
		{
			if (ch == CHAR(~))
			{
				isEscaped = YES;			
			}
			else 
			{
				if (ch == CHAR(*))
					[result append:ExcelPatternItem_create(ExcelPatternItemType_AnyString, CHAR_0)];
				else if (ch == CHAR(?))
					[result append:ExcelPatternItem_create(ExcelPatternItemType_AnyChar, CHAR_0)];
				else 
					[result append:ExcelPatternItem_create(ExcelPatternItemType_Char, ch)];
			}				
		}
	}
	
	return [result seal];
}




Bool String_matchExcelPattern_search(String* str, Int strIdx, ExcelPatternItemList* pattern, Int patternIdx);
Bool String_matchExcelPattern_search(String* str, Int strIdx, ExcelPatternItemList* pattern, Int patternIdx)
{
	if ([pattern isValidIndex:patternIdx] == NO)
	{
		return (str.length == 0 || strIdx > str.lastIndex);
	}
	
	ExcelPatternItem item = [pattern at:patternIdx];

	if (item.type == ExcelPatternItemType_AnyString)
	{
		if (str.length == 0 || strIdx > str.lastIndex)
			return (patternIdx == pattern.lastIndex);

		Bool result1 = String_matchExcelPattern_search(str, strIdx + 1, pattern, patternIdx);
		if (result1)
			return YES;
		
		Bool result2 = String_matchExcelPattern_search(str, strIdx, pattern, patternIdx + 1);
		if (result2)
			return YES;

		return NO;		
	}
	else if (item.type == ExcelPatternItemType_AnyChar)
	{
		if (str.length == 0 || strIdx > str.lastIndex)
			return NO;
		
		return String_matchExcelPattern_search(str, strIdx + 1, pattern, patternIdx + 1);
	}
	else
	{
		if (str.length == 0 || strIdx > str.lastIndex)
			return NO;
				
		if (item.value != [str charAt:strIdx])
			return NO;
		
		if (strIdx == str.lastIndex && patternIdx == pattern.lastIndex)
			return YES;
		
		return String_matchExcelPattern_search(str, strIdx + 1, pattern, patternIdx + 1);
	}
}








@implementation String (ExcelPattern)

	

	- (Bool) matchExcelPattern:(String*)pattern
	{
		SELFTEST_START
			
			ASSERT([STR(@"") matchExcelPattern :STR(@"")] == YES);
			ASSERT([STR(@"a") matchExcelPattern :STR(@"")] == NO);

			ASSERT([STR(@"") matchExcelPattern :STR(@"a")] == NO);
			ASSERT([STR(@"") matchExcelPattern :STR(@"?")] == NO);
			ASSERT([STR(@"") matchExcelPattern :STR(@"*")] == YES);

			ASSERT([STR(@"a") matchExcelPattern :STR(@"*a")] == YES);
			ASSERT([STR(@"a") matchExcelPattern :STR(@"*b")] == NO);
			ASSERT([STR(@"a") matchExcelPattern :STR(@"a*")] == YES);
			ASSERT([STR(@"a") matchExcelPattern :STR(@"b*")] == NO);
			ASSERT([STR(@"a") matchExcelPattern :STR(@"?")] == YES);
			ASSERT([STR(@"a") matchExcelPattern :STR(@"??")] == NO);

			ASSERT([STR(@"ab") matchExcelPattern :STR(@"*a")] == NO);
			ASSERT([STR(@"ab") matchExcelPattern :STR(@"*b")] == YES);
			ASSERT([STR(@"ab") matchExcelPattern :STR(@"a*")] == YES);
			ASSERT([STR(@"ab") matchExcelPattern :STR(@"b*")] == NO);
			ASSERT([STR(@"ab") matchExcelPattern :STR(@"?")] == NO);
			ASSERT([STR(@"ab") matchExcelPattern :STR(@"??")] == YES);
	
			ASSERT([STR(@"*") matchExcelPattern :STR(@"~*")] == YES);
			ASSERT([STR(@"?") matchExcelPattern :STR(@"~?")] == YES);
			ASSERT([STR(@"~") matchExcelPattern :STR(@"~~")] == YES);
			ASSERT([STR(@"~b") matchExcelPattern :STR(@"~~b")] == YES);

		SELFTEST_END
		

		if (pattern.length == 0)
			return (self.length == 0);
			
		return String_matchExcelPattern_search(self, 0, ExcelPatternItem_createList(pattern), 0);
	}

	
	
	
@end







