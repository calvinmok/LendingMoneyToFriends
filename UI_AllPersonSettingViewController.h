





#import <Foundation/Foundation.h>


#import "Person.h"




NS_INLINE Int PersonSorting_toInt(PersonSorting value)
{
	switch (value)
	{
		case PersonSorting_NameAndBalance: return 0;
		case PersonSorting_BalanceAndName: return 1;
	}
	
	ASSERT(NO); return 0;
}

NS_INLINE PersonSorting PersonSorting_fromInt(Int value)
{
	switch (value)
	{
		case 0: return PersonSorting_NameAndBalance;
		case 1: return PersonSorting_BalanceAndName;
	}
	
	ASSERT(NO); return 0;	
}

NS_INLINE NSString* PersonSorting_labelText(PersonSorting value)
{
	switch (value)
	{
		case PersonSorting_NameAndBalance: return @"By Name";
		case PersonSorting_BalanceAndName: return @"By Balance";
	}
	
	ASSERT(NO); return 0;	
}






@protocol AllPersonSettingViewController_Observer_

	- (void) AllPersonSettingViewController_propertyChanged;
	
@end

typedef NSObject<AllPersonSettingViewController_Observer_> AllPersonSettingViewController_Observer;



@interface AllPersonSettingViewController : UITableViewController 
	{
		AllPersonSettingViewController_Observer* my_observer;
		PersonSorting my_personSorting;
		UISwitch* my_excludeNoRecordSwitch;
	}


	+ (AllPersonSettingViewController*) create
		:(AllPersonSettingViewController_Observer*)observer
		:(AllPersonSetting)setting;
	
	- (void) _creating 
		:(AllPersonSettingViewController_Observer*)observer 
		:(AllPersonSetting)setting;


	- (void) _excludeNoRecordSwitchChanged;


	@property(readonly) AllPersonSetting allPersonSetting;

	- (void) flipExcludeNoRecordAnimated;
	
@end









