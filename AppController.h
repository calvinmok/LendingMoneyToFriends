



#import <Foundation/Foundation.h>


#import "AddressBook.h"
#import "FileSys.h"

#import "UI_UI.h"





@interface AppFileSys : NSObject
	{
    @public
		PrivateFileSys* my_fileSys;
		
	}
	
	+ (AppFileSys*) create :(String*)base;
	

	- (void) _writeAllItem :(String*)fileName :(StringList*)allNameItem;
	- (StringMutableList*) _readAllItem :(String*)fileName;
	
	
	
	- (void) writeSetting :(AllPersonSetting)allPersonSetting;
	- (AllPersonSetting) readSetting;
		
		
	- (IntList*) readAllPRID;


	- (void) writeImage :(Int)prID :(Int)recordKey :(UIImage*)original :(UIImage*)thumbnail;
	- (void) removeImage :(Int)prID :(Int)recordKey;

	- (NubleUIImage) readOriginal :(Int)prID :(Int)recordKey;
	- (NubleUIImage) readThumbnail :(Int)prID :(Int)recordKey;
	
	
	- (void) writeAllRecord :(Int)prID :(RecordList*)allRecord :(NubleRecord)exceptRecord;
	- (RecordList*) readAllRecord :(Int)prID;
	
	- (void) removePerson :(Int)prID;
	
	
	- (void) insertNameItem:(String*)item;
	- (void) removeNameItem:(String*)item;
	- (StringMutableList*) readAllNameItem;
	
	- (void) insertAmountItem:(String*)item;
	- (void) removeAmountItem:(String*)item;
	- (StringMutableList*) readAllAmountItem;
		
				
@end




@interface AppController : NSObject<UI_Observer_>
	{
		UI* my_ui;
		AppFileSys* my_fileSys;
	}
	
	+ (AppController*) create;
	
	- (void) _creating;
	
	
	- (void) reloadAddressBook;
	
	- (PersonList*) readAllPersonFromAddressBook;

	
@end





/*

Lending Money to Friends

is an app which allows you to record how much money you have lent to your friends.

Features

	Your friend list is get from your contacts.
	Choosing saved photo as the icon of record.
	Intuitive and Friendly interface.


*/

















