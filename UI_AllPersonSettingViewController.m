





#import "UI_AllPersonSettingViewController.h"


@implementation AllPersonSettingViewController

	+ (AllPersonSettingViewController*) create 
		:(AllPersonSettingViewController_Observer*)observer
		:(AllPersonSetting)setting
	{
		AllPersonSettingViewController* result = [[[AllPersonSettingViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];		
		[result _creating :observer :setting];
		return result;
	}
	
	- (void) _creating 
		:(AllPersonSettingViewController_Observer*)observer
		:(AllPersonSetting)setting
	{
		self.title = @"Setting";
		
		my_observer = observer;
		
		my_excludeNoRecordSwitch = [[UISwitch alloc] init];	
		[my_excludeNoRecordSwitch addTarget:self action:@selector(_excludeNoRecordSwitchChanged) forControlEvents:UIControlEventValueChanged];

		my_personSorting = setting.personSorting;
		my_excludeNoRecordSwitch.on = setting.excludeNoRecord;
	}
	
	
	- (void) dealloc
	{
		[my_excludeNoRecordSwitch release];
		[super dealloc];
	}
	
	
	
	- (void) _excludeNoRecordSwitchChanged
	{
		[my_observer AllPersonSettingViewController_propertyChanged];
	}
	




	
	- (AllPersonSetting) allPersonSetting
	{
		AllPersonSetting result;
		result.personSorting = my_personSorting;
		result.excludeNoRecord = my_excludeNoRecordSwitch.on;
		return result;
	}
	
	- (void) flipExcludeNoRecordAnimated
	{
		BOOL b = my_excludeNoRecordSwitch.on;
		[my_excludeNoRecordSwitch setOn:(b == No) animated:YES]; 
	}




	- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView 
	{
		return 2;
	}
	
	- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
	{
		if (section == 0) return @"Sorting";
		if (section == 1) return @"Filter";
		return @"";
	}


	- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
	{
		if (section == 0) return 2;
		if (section == 1) return 1;
		return 0;
	}
	
	
	- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
	{
		static NSString* MyIdentifier = @"UI_AllPersonViewController";
	
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		IF (indexPath.section == 0)
		{
			PersonSorting s = PersonSorting_fromInt(indexPath.row);
			cell.textLabel.text = PersonSorting_labelText(s);			
			cell.accessoryType = (s == my_personSorting) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
		}
		EF (indexPath.section == 1)
		{
			IF (indexPath.row == 0)
			{
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.textLabel.text = @"Exclude No-Record";
				cell.accessoryView = my_excludeNoRecordSwitch;
			}
		}
	
		return cell;
	}	
	

	- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
	{
		if (indexPath.section == 0)
		{
			{
				Int index = PersonSorting_toInt(my_personSorting);
				UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			my_personSorting = PersonSorting_fromInt(indexPath.row);

			{
				UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			
			[my_observer AllPersonSettingViewController_propertyChanged];
		}
		
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}

	

@end









