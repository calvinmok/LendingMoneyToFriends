



#import <AddressBook/AddressBook.h> 



#import "DataType.h"
#import "Person.h"




@class AddressBook;
@class AddressBookPerson;



NUBLE_OBJECT_TEMPLATE(AddressBookPerson)
OBJECT_BLOCK(AddressBookPerson)

OBJECT_LIST_INTERFACE_TEMPLATE(AddressBookPerson)
	
	





NS_INLINE NameSorting AddressBook_getNameSorting(void)
{
	ABPersonSortOrdering s = ABPersonGetSortOrdering();
	if (s == kABPersonSortByFirstName) return NameSorting_FirstNameAndLastName;
	if (s == kABPersonSortByLastName) return NameSorting_LastNameAndFirstName;		
	return NameSorting_FirstNameAndLastName;
};

NS_INLINE NameFormat AddressBook_getNameFormat(void)
{
	ABPersonCompositeNameFormat f = ABPersonGetCompositeNameFormat();
	if (f == kABPersonCompositeNameFormatFirstNameFirst) return NameFormat_FirstNameAndLastName;
	if (f == kABPersonCompositeNameFormatLastNameFirst) return NameFormat_LastNameAndFirstName;		
	return NameFormat_FirstNameAndLastName;
};

NS_INLINE NameSetting AddressBook_getNameSetting(void)
{
	NameSetting result;
	result.nameSorting = AddressBook_getNameSorting();
	result.nameFormat = AddressBook_getNameFormat();
	return result;
}



	

@interface AddressBook : ObjectBase

	+ (AddressBook*) create;

	- (AddressBookPersonList*) getAllPerson;
	
	- (AddressBookPerson*) getPersonByID :(Int)personID;
	
@end



@interface AddressBookPerson : ObjectBase

	@property(readonly) Int recordID;

	@property(readonly) String* firstName;
	@property(readonly) String* lastName;
	
	@property(readonly) NubleNSData imageData;

@end














