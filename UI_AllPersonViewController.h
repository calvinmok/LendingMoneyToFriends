



#import <Foundation/Foundation.h>





#import "Person.h"

#import "UI_AllPersonSettingViewController.h"



@protocol AllPersonViewController_Observer_

	- (void) AllPersonViewController_clear;

	- (void) AllPersonViewController_settingClicked;
	- (void) AllPersonViewController_personSelected :(Person*)selected;
	
@end

typedef NSObject<AllPersonViewController_Observer_> AllPersonViewController_Observer;




@interface AllPersonViewController : UITableViewController 
	{
	@public
		AllPersonViewController_Observer* my_observer;
		
		PersonMutableList* my_originAllPerson;
		PersonMutableList* my_workingAllPerson;
		
		BalanceMutableList* my_allBalance;

		AllPersonSetting my_allPersonSetting;
		NameSetting my_nameSetting;
	}
	
	
	+ (AllPersonViewController*) create :(AllPersonViewController_Observer*)observer;
	
	- (void) _creating :(AllPersonViewController_Observer*)observer;
	

    - (void) _clear;
	- (void) _action;


	- (void) _updateWorkingAllPerson;
	- (void) _setAllUITableViewCell;
	- (void) _setUITableViewCell :(UITableViewCell*)cell :(Person*)person;
	
		
				
	- (void) updateAllPerson :(PersonList*)allPerson;
	- (void) updateAllPersonAndBalance :(PersonList*)allPerson :(BalanceList*)allBalance;
	
	- (void) setSingleBalance :(Balance*)balance;


	@property(readonly) Int originAllPersonCount;
	
	- (NublePerson) findPersonByPRID :(Int)prID;


	@property(readonly) NameSetting nameSetting;



	- (void) setSetting :(AllPersonSetting)allPerson;
	- (void) setSetting :(AllPersonSetting)allPerson :(NameSetting)name;



@end











