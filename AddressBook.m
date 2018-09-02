


#import "AddressBook.h"



OBJECT_LIST_IMPLEMENTATION_TEMPLATE(AddressBookPerson)
	






@interface AddressBookImpl : AddressBook
	{
	@public 
		ABAddressBookRef my_subject;
	}
	
	+ (AddressBookImpl*) create;

@end

@interface AddressBookPersonImpl : AddressBookPerson
	{
		ABRecordID my_recordID;
		String* my_firstName;
		String* my_lastName;

		NubleNSData my_imageData;
	}
		
	+ (AddressBookPersonImpl*) create :(ABRecordRef)person;

@end



@implementation AddressBookImpl

	+ (AddressBookImpl*) create
	{
		AddressBookImpl* result = [[[AddressBookImpl alloc] init] autorelease];
		result->my_subject = ABAddressBookCreate();
		return result;
	}
	
	- (void) dealloc
	{
		CFRelease(my_subject);
		[super dealloc];
	}

	- (AddressBookPersonList*) getAllPerson
	{
		NSArray* allPerson = (NSArray*)ABAddressBookCopyArrayOfAllPeople(my_subject);
		[allPerson autorelease];
				
		AddressBookPersonMutableList* result = [AddressBookPersonMutableList create:[allPerson count]];

		for (NSUInteger i = 0; i < [allPerson count]; i++)
		{
            AddressBookPersonImpl* person = [AddressBookPersonImpl create :[allPerson objectAtIndex:i]];
            
            String* f = [person.firstName replacement :STR(@" ") :STR(@"")];
            String* l = [person.lastName replacement :STR(@" ") :STR(@"")];
            if (f.length == 0 && l.length == 0)
                continue;            
            
            [result append:person];
        } 
		
		return [result seal];
	}
	
	
	- (AddressBookPerson*) getPersonByID :(Int)personID
	{
		ABRecordRef person = ABAddressBookGetPersonWithRecordID(my_subject, personID);		
		return [AddressBookPersonImpl create :person];
	}

@end


@implementation AddressBookPersonImpl

	+ (AddressBookPersonImpl*) create :(ABRecordRef)person
	{
		AddressBookPersonImpl* result = [[[AddressBookPersonImpl alloc] init] autorelease];
		
		result->my_recordID = ABRecordGetRecordID(person);
			
		NSString* firstName = [(NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty) autorelease];
		result->my_firstName = [(firstName == nil) ? String_empty() : STR(firstName) retain];
			
		NSString* lastName = [(NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty) autorelease];
		result->my_lastName = [(lastName == nil) ? String_empty() : STR(lastName) retain];
			
		NSData* imageData = (NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
		result->my_imageData = NSData_toNuble(imageData);

		return result;
	}


	- (void) dealloc
	{
		[my_firstName release];
		[my_lastName release];		
		NSData_release(my_imageData);
		[super dealloc];
	}
	
	- (Int) recordID { return my_recordID; }
	- (String*) firstName { return my_firstName; }
	- (String*) lastName { return my_lastName; }
	
	- (NubleNSData) imageData { return my_imageData; }
		
@end





@implementation AddressBook 

	+ (AddressBook*) create
	{
		return [AddressBookImpl create];
	}

	- (AddressBookPersonList*) getAllPerson { ABSTRACT_METHOD_NIL }
	
	- (AddressBookPerson*) getPersonByID :(Int)recordID { ABSTRACT_METHOD_NIL }
	
@end



@implementation AddressBookPerson 

	- (Int) recordID { ABSTRACT_METHOD(Int) }
	- (String*) firstName { ABSTRACT_METHOD_NIL }
	- (String*) lastName { ABSTRACT_METHOD_NIL }	
	- (NubleNSData) imageData { ABSTRACT_METHOD(NubleNSData) }	

@end














