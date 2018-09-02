






#import <Foundation/Foundation.h>




#define IF if
#define EF else if
#define EL else




typedef id ID;

typedef void* Pntr;
typedef const void* ConstPntr;



typedef BOOL Bool;

#define Yes YES
#define No  NO




typedef u_int8_t Byte;

#define Byte_Min  0
#define Byte_Max  255




typedef unichar Char;

#define Char_Null '\0'

#define Char_Min 0
#define Char_Max USHRT_MAX




typedef NSInteger Int;

#define Int_Min NSIntegerMin
#define Int_Max NSIntegerMax




typedef NSUInteger UInt;

#define UInt_Min 0
#define UInt_Max NSUIntegerMax




typedef double Double;




@class String;
@class SealedString;
@class MutableString;




void ASSERT(Bool value);

Int BREAK(void);
Int BREAK_IF(Bool);


#define ABSTRACT_METHOD_VOID  { ASSERT(NO); }
#define ABSTRACT_METHOD_NIL   { ASSERT(NO); return nil; }
#define ABSTRACT_METHOD(TYPE) { ASSERT(NO); TYPE r; memset(&r,0,sizeof(TYPE)); return r; }

#define STATIC_OBJECT(TYPE, NAME, INIT) static TYPE* NAME = nil; if (NAME == nil) NAME = [INIT retain];

#define STATIC_O(Type, Name, INIT) static Type* Name = nil; if (Name == nil) Name = [INIT retain];

#define RETURN_STATIC_OBJECT(TYPE, INIT) static TYPE* v = nil; if (v == nil) v = [INIT retain]; return v;

#define SELFTEST_START { static BOOL selfTestCompleted = NO; if (selfTestCompleted == NO) { selfTestCompleted = YES;
#define SELFTEST_END   } }







#import "DataType_Nuble.h"



#define OBJECT_BLOCK(TYPE) \
	typedef Bool (^TYPE##_Predicate)(TYPE*); \
	typedef Bool (^TYPE##_IsEqual)(TYPE* x, TYPE* y); \
	typedef NubleBool (^TYPE##_IsSmallerXY)(TYPE* x, TYPE* y); \
	typedef NubleBool (^TYPE##_IsSmallerTarget)(TYPE* item); \
	\
	typedef Bool (^Nuble##TYPE##_Predicate)(Nuble##TYPE); \
	typedef Bool (^Nuble##TYPE##_IsEqual)(Nuble##TYPE x, Nuble##TYPE y); \
	typedef NubleBool (^Nuble##TYPE##_IsSmallerXY)(Nuble##TYPE x, Nuble##TYPE y); \
	typedef NubleBool (^Nuble##TYPE##_IsSmallerTarget)(Nuble##TYPE item); \


#define STRUCT_BLOCK(TYPE) \
	typedef Bool (^TYPE##_Predicate)(TYPE); \
	typedef Bool (^TYPE##_IsEqual)(TYPE x, TYPE y); \
	typedef NubleBool (^TYPE##_IsSmallerXY)(TYPE x, TYPE y); \
	typedef NubleBool (^TYPE##_IsSmallerTarget)(TYPE item); \
	\
	typedef Bool (^Nuble##TYPE##_Predicate)(Nuble##TYPE); \
	typedef Bool (^Nuble##TYPE##_IsEqual)(Nuble##TYPE x, Nuble##TYPE y); \
	typedef NubleBool (^Nuble##TYPE##_IsSmallerXY)(Nuble##TYPE x, Nuble##TYPE y); \
	typedef NubleBool (^Nuble##TYPE##_IsSmallerTarget)(Nuble##TYPE item); \



NUBLE_STRUCT_TEMPLATE(Bool)
STRUCT_BLOCK(Bool)


 



NUBLE_STRUCT_TEMPLATE(ID)
STRUCT_BLOCK(ID)

NUBLE_STRUCT_TEMPLATE(Pntr)
STRUCT_BLOCK(Pntr)

NUBLE_STRUCT_TEMPLATE(ConstPntr)
STRUCT_BLOCK(ConstPntr)


NUBLE_STRUCT_TEMPLATE(Int)
STRUCT_BLOCK(Int)

NUBLE_STRUCT_TEMPLATE(UInt)
STRUCT_BLOCK(UInt)

NUBLE_STRUCT_TEMPLATE(Byte)
STRUCT_BLOCK(Byte)

NUBLE_STRUCT_TEMPLATE(Char)
STRUCT_BLOCK(Char)

NUBLE_STRUCT_TEMPLATE(Double)
STRUCT_BLOCK(Double)




NUBLE_OBJECT_TEMPLATE(String) 
OBJECT_BLOCK(String) 

NUBLE_OBJECT_TEMPLATE(SealedString) 
OBJECT_BLOCK(SealedString) 

NUBLE_OBJECT_TEMPLATE(MutableString) 
OBJECT_BLOCK(MutableString) 




#import "DataType_ObjectBase.h"







@class ListBase;
@class ListEnumeratorBase;
@class ListIndexEnumerator;


@class StructList;
@class StructSealedList;
@class StructMutableList;
@class StructListEnumerator;


@class ObjectList;
@class ObjectSealedList;
@class ObjectMutableList;
@class ObjectListEnumerator;




#import "DataType_List.h"
#import "DataType_StructList.h"
#import "DataType_ObjectList.h"


#import "DataType_Char.h"
#import "DataType_Byte.h"

#import "DataType_StringList.h"
#import "DataType_String.h"
#import "DataType_StringExtension.h"
#import "DataType_String_ExcelPattern.h"

#import "DataType_Bool.h"
#import "DataType_Int.h"
#import "DataType_Double.h"
#import "DataType_DecDouble.h"


#import "DataType_DT2001.h"












NUBLE_OBJECT_TEMPLATE(NSData) 
OBJECT_BLOCK(NSData) 



NUBLE_OBJECT_TEMPLATE(UIImage) 
OBJECT_BLOCK(UIImage) 






