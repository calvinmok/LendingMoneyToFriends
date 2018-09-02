





#import <Foundation/Foundation.h>


#import "Person.h"



typedef enum 
{
	RecordItemType_None,
	RecordItemType_Name,
	RecordItemType_Amount
}
RecordItemType;



@protocol RecordItemViewController_Observer_

	- (void) RecordItemViewController_submit :(RecordItemType)type :(String*)item;
		
    - (void) RecordItemViewController_itemDeleted :(RecordItemType)type :(String*)item;
	
	- (void) RecordItemViewController_cancel;

@end

typedef NSObject<RecordItemViewController_Observer_> RecordItemViewController_Observer;





@interface RecordItemViewController : UITableViewController 
	{
		RecordItemViewController_Observer* my_observer;
		
		RecordItemType my_recordItemType;
		StringMutableList* my_allItem;
		
		UIBarButtonItem* my_editBarButtonItem;
		UIBarButtonItem* my_doneBarButtonItem;		
	}
	
	+ (RecordItemViewController*) create:(RecordItemViewController_Observer*)observer;
	- (void) _creating:(RecordItemViewController_Observer*)observer;

	
	- (void) setAllItem :(RecordItemType)type :(StringList*)allItem;
	

	- (void) _edit;
	- (void) _done;
    - (void) _cancel;

@end













