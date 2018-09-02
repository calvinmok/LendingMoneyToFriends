






#import "DataType.h"




void ASSERT(Bool value)
{
    if (value == NO)
        [NSException raise:@"" format:@""];
}

Int BREAK(void)
{
	Int i = 0;
	i = rand();
	return i;
}

Int BREAK_IF(Bool value)
{
	if (value)
	{
		return BREAK();
	}
	
	return 0;	
}





