

#import <AddressBook/AddressBook.h>


#import "DataType.h"




NS_INLINE Int currencyPrecision(void) { return 4; }





typedef enum
{
	NameSorting_FirstNameAndLastName,
	NameSorting_LastNameAndFirstName
}
NameSorting;

typedef enum
{
	NameFormat_FirstNameAndLastName,
	NameFormat_LastNameAndFirstName
}
NameFormat;
NUBLE_STRUCT_TEMPLATE(NameFormat)

typedef struct 
{
	NameSorting nameSorting;
	NameFormat nameFormat;
}
NameSetting;



typedef enum
{
	PersonSorting_NameAndBalance,
	PersonSorting_BalanceAndName
}
PersonSorting;

typedef struct 
{
	PersonSorting personSorting;
	Bool excludeNoRecord;
}
AllPersonSetting;

NS_INLINE AllPersonSetting AllPersonSetting_create(PersonSorting personSorting, Bool excludeNoRecord)
{
	AllPersonSetting result;
	result.personSorting = personSorting;
	result.excludeNoRecord = excludeNoRecord;
	return result;
}

String* AllPersonSetting_toData(AllPersonSetting setting);
AllPersonSetting AllPersonSetting_fromData(String* data);






@interface Balance : ObjectBase
	{
		Int my_prID;
		Double my_value;
		Bool my_hasRecord;
	}

	+ (Balance*) create :(Int)i :(Double)v :(Bool)h;

	@property(readonly) Int prID;
	
	@property(readonly) Double value;	
	
	@property(readonly) Bool hasRecord;

@end

NUBLE_OBJECT_TEMPLATE(Balance)
OBJECT_BLOCK(Balance)
OBJECT_LIST_INTERFACE_TEMPLATE(Balance)

@interface BalanceList(_)


	- (NubleBalance) findFirstByPRID:(Int)prID;
	- (NubleDouble) findFirstValueByPRID:(Int)prID;
	- (NubleInt) findFirstIndexByPRID:(Int)prID;

	@property(readonly) Int numberOfDigitAfterDecimalPoint;
	
@end




@interface Person : ObjectBase
	{
		Int my_prID;
		String* my_firstName;
		String* my_lastName;
		NubleUIImage my_image;
	}
	
	+ (Person*) create :(Int)i :(String*)fn :(String*)ln;
	+ (Person*) create :(Int)i :(String*)fn :(String*)ln :(NubleNSData)imageData;
	
	@property(readonly) Int prID;
	
	@property(readonly) String* firstName;
	@property(readonly) String* lastName;
	
	@property(readonly) NubleUIImage image;
			
	- (String*) name :(NameFormat)nameFormat;
		
	- (Bool) eq:(Person*)other;

@end

NUBLE_OBJECT_TEMPLATE(Person)
OBJECT_BLOCK(Person)
OBJECT_LIST_INTERFACE_TEMPLATE(Person)



@interface PersonList(_)

	- (NublePerson) findByPRID:(Int)prID;
	
	- (NubleInt) findFirstIndexByPRID:(Int)prID;
	
	- (Bool) containPerson:(Person*)person;
	
	@property(readonly) CGFloat maxImageWidth;
	
	
	- (PersonMutableList*) findAll:(Person_Predicate)predicate;
	
@end






@interface Record : ObjectBase
	{
		Int my_key;

		Bool my_hasImage;
		String* my_name;
		Double my_amount;
		DT2001 my_dateTime;
	}

	+ (Record*) create :(Int)key :(String*)n :(Double)a :(DT2001)dt;
	+ (Record*) create :(Int)key :(Bool)i :(String*)n :(Double)a :(DT2001)dt;

	@property(readonly) Int key;
	
	@property(readonly) Bool hasImage;
	@property(readonly) String* name;	
	@property(readonly) Double amount;
	@property(readonly) DT2001 dateTime;

	- (Bool) eq :(Record*)other;

@end

NUBLE_OBJECT_TEMPLATE(Record)
OBJECT_BLOCK(Record)
OBJECT_LIST_INTERFACE_TEMPLATE(Record)

@interface RecordList(_)

	@property(readonly) Double balance;
	@property(readonly) Int newKey;
	
	@property(readonly) Int numberOfDigitAfterDecimalPoint;
	
	- (NubleRecord) findFirstByKey :(Int)key;
	- (NubleInt) findFirstIndexByKey :(Int)key;
	
		
	- (String*) toData :(Int)precision :(NubleRecord)exceptRecord;
	+ (RecordList*) fromData:(String*)data;
	
@end

@interface RecordMutableList(_)

	- (void) sortByDateTimeRevOrder;

@end








