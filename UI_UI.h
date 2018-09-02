






#import "Person.h"
#import "UI_Window.h"
#import "UI_NavigationController.h"
#import "UI_AllPersonViewController.h"
#import "UI_AllRecordViewController.h"
#import "UI_SingleRecordViewController.h"
#import "UI_RecordImageViewController.h"
#import "UI_RecordItemViewController.h"


@protocol UI_Observer_


	- (void) UI_clear;

	- (NubleUIImage) UI_readOriginal :(Person*)person :(Record*)record;
    - (NubleUIImage) UI_readThumbnail :(Person*)person :(Record*)record;
    
	- (StringList*) UI_getAllNameItem;
	- (StringList*) UI_getAllAmountItem;
	

	

	- (void) UI_personSelected;
	- (void) UI_personUnselected;

	- (void) UI_recordSelected;
	- (void) UI_recordUnselected;
	
	- (void) UI_recordSubmitted 
        :(NubleRecord)oldRecord 
        :(Bool)imageChanged :(NubleUIImage)original :(NubleUIImage)thumbnail
        :(String*)name :(Double)amount :(DT2001)dateTime;

        
	- (void) UI_recordDeleting :(Record*)record;
	
	
	- (void) UI_allPersonSettingChanged:(AllPersonSetting)allPersonSetting;
	
		
	- (void) UI_itemDeleted :(RecordItemType)type :(String*)item;
				
@end

typedef NSObject<UI_Observer_> UI_Observer;




#define UI_PROTOCOLS \
	UINavigationControllerDelegate, \
    UIImagePickerControllerDelegate, \
    UIActionSheetDelegate, \
    \
	WindowObserver_, \
	AllPersonViewController_Observer_, \
	AllRecordViewController_Observer_, \
	SingleRecordViewController_Observer_, \
	RecordImageViewController_Observer_, \
	RecordItemViewController_Observer_,  \
	AllPersonSettingViewController_Observer_ \
	

@interface UI : NSObject<UI_PROTOCOLS>
	{
	@private 
		UI_Observer* my_observer;

		Window* my_window;
		
		NavigationController* my_navigationController;
		UIViewController* my_lastVC;

		AllPersonViewController* my_allPersonVC;
		AllPersonSettingViewController* my_allPersonSettingVC;
		AllRecordViewController* my_allRecordVC;
		SingleRecordViewController* my_singleRecordVC;
		RecordImageViewController* my_recordImageVC;
		RecordItemViewController* my_recordItemVC;
        
		UIActionSheet* my_cameraActionSheet;
    }
	
	
	+ (UI*) create :(UI_Observer*)observer :(AllPersonSetting)setting;
	
	- (void) _creating :(UI_Observer*)observer :(AllPersonSetting)setting;
	
	
	@property(readonly) Int originAllPersonCount;
	- (NublePerson) findPersonByPRID :(Int)prID;
	
	@property(readonly) NublePerson selectedPerson;
	@property(readonly) NubleRecord selectedRecord;
	
	@property(readonly) RecordList* allRecord;
	

	- (void) setNameSetting :(NameSetting)nameSetting;


	
	- (void) updateAllPerson :(PersonList*)allPerson;
	- (void) updateAllPersonAndBalance :(PersonList*)allPerson :(BalanceList*)allBalance;
	- (void) setSingleBalance :(Balance*)balance;
	
			
	- (void) updateAllRecord :(RecordList*)allRecord;
	- (void) modifySingleRecordWithoutModifySingleRecordViewController :(Record*)record;
	- (void) insertSingleRecord :(Record*)record;
	- (void) deleteSingleRecord :(Record*)record;


	- (void) _showImagePicker;

@end










