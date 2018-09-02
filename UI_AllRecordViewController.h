


#import <Foundation/Foundation.h>




#import "Person.h"


@protocol AllRecordViewController_Observer_

	- (NubleUIImage) AllRecordViewController_getThumbnail :(Record*)record;

				

	- (void) AllRecordViewController_recordSelected :(Record*)record;


	- (void) AllRecordViewController_recordCreating;
	
	- (void) AllRecordViewController_recordDeleting :(Record*)record;
	
	
@end

typedef NSObject<AllRecordViewController_Observer_> AllRecordViewController_Observer;




@interface AllRecordViewController : UITableViewController 
	{
		AllRecordViewController_Observer* my_observer;
		
		NublePerson my_person;
	
		UIBarButtonItem* my_editBarButtonItem;
		UIBarButtonItem* my_doneBarButtonItem;		
		
		RecordMutableList* my_allRecord;
	}
	
	
	+ (AllRecordViewController*) create :(AllRecordViewController_Observer*)observer;
	- (void) _creating :(AllRecordViewController_Observer*)observer;
	
	
	@property(readonly) NublePerson person;
	- (void) setPerson :(NublePerson)value :(NameFormat)nameFormat;
	

	@property(readonly) RecordList* allRecord;

	
	- (void) updateAllRecord :(RecordList*)allRecord;

	- (void) insertSingleRecord :(Record*)record;
	- (void) modifySingleRecord :(Record*)record;
	- (void) deleteSingleRecord :(Record*)record;
	
	
	- (void) _edit;
	- (void) _done;
	
	
	- (void) _setUITableViewCell :(UITableViewCell*)cell :(Record*)record;

@end










