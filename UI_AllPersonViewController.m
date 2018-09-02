




#import "UI_AllPersonViewController.h"


@implementation AllPersonViewController


	+ (AllPersonViewController*) create :(AllPersonViewController_Observer*)observer
	{
		AllPersonViewController* result = [[[AllPersonViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];		
		[result _creating :observer];
		return result;
	}
	
	- (void) _creating :(AllPersonViewController_Observer*)observer
	{
		my_observer = observer;
		my_allPersonSetting = AllPersonSetting_create(PersonSorting_NameAndBalance, No);
		
		self.title = @"People";
        
        
        /*
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(_clear)] 
			autorelease];
        */
				        
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(_action)] 
			autorelease];
				
		my_originAllPerson = [[PersonMutableList create] retain];
		my_workingAllPerson = [[PersonMutableList create] retain];
		
		my_allBalance = [[BalanceMutableList create] retain];
	}
	
	- (void) dealloc
	{
		[my_originAllPerson release];
		[my_workingAllPerson release];
		
		[my_allBalance release];
		
		[super dealloc];
	}




	- (void) _clear
	{
		[my_observer AllPersonViewController_clear];
	}
	- (void) _action
	{
		[my_observer AllPersonViewController_settingClicked];
	}


	- (void) _updateWorkingAllPerson
	{
		[my_workingAllPerson removeAll];
		
		ForEachIndex(i, my_originAllPerson)
		{
			Person* person = [my_originAllPerson at:i];
			
			if (my_allPersonSetting.excludeNoRecord)
			{
				NubleBalance balance = [my_allBalance findFirstByPRID:person.prID];
				if (balance.hasVar == NO || balance.vd.hasRecord == NO)
					continue;
			}
			
			[my_workingAllPerson append:person];
		}
		
		[my_workingAllPerson mergeSort:^(Person* x, Person* y)
		{
			if (my_allPersonSetting.personSorting == PersonSorting_BalanceAndName)
			{
				NubleDouble xBalance = [my_allBalance findFirstValueByPRID:x.prID];
				NubleDouble yBalance = [my_allBalance findFirstValueByPRID:y.prID];
				
				NubleBool b = Double_isSmaller(Double_varOr(xBalance, 0), Double_varOr(yBalance, 0));
				if (b.hasVar) return nubleNot(b);
				
				if (my_nameSetting.nameSorting == NameSorting_FirstNameAndLastName)
				{
					NubleBool f = [x.firstName localizedIsSmallerThan :y.firstName];
					if (f.hasVar) return f;
				
					NubleBool l = [x.lastName localizedIsSmallerThan :y.lastName];
					if (l.hasVar) return l;
				}
				else if (my_nameSetting.nameSorting == NameSorting_LastNameAndFirstName)
				{
					NubleBool l = [x.lastName localizedIsSmallerThan :y.lastName];
					if (l.hasVar) return l;

					NubleBool f = [x.firstName localizedIsSmallerThan :y.firstName];
					if (f.hasVar) return f;				
				}
			}
			else
			{
				if (my_nameSetting.nameSorting == NameSorting_FirstNameAndLastName)
				{
					NubleBool f = [x.firstName localizedIsSmallerThan :y.firstName];
					if (f.hasVar) return f;
				
					NubleBool l = [x.lastName localizedIsSmallerThan :y.lastName];
					if (l.hasVar) return l;
				}
				else if (my_nameSetting.nameSorting == NameSorting_LastNameAndFirstName)
				{
					NubleBool l = [x.lastName localizedIsSmallerThan :y.lastName];
					if (l.hasVar) return l;

					NubleBool f = [x.firstName localizedIsSmallerThan :y.firstName];
					if (f.hasVar) return f;				
				}
				
				NubleDouble xBalance = [my_allBalance findFirstValueByPRID:x.prID];
				NubleDouble yBalance = [my_allBalance findFirstValueByPRID:y.prID];
				
				NubleBool b = Double_isSmaller(Double_varOr(xBalance, 0), Double_varOr(yBalance, 0));
				if (b.hasVar) return nubleNot(b);
			}
			
			return Bool_nuble();
		}];
	}
	
	
	- (void) _setAllUITableViewCell
	{
		ForEachIndex(i, my_workingAllPerson)
		{
			Person* person = [my_workingAllPerson at:i];
			
			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
			UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
			
			[self _setUITableViewCell :cell :person];
		}
	}
	
	- (void) _setUITableViewCell :(UITableViewCell*)cell :(Person*)person
	{
		Double balance = Double_varOr([my_allBalance findFirstValueByPRID:person.prID], 0.0);
		String* balanceStr = Double_printFixed(balance, my_allBalance.numberOfDigitAfterDecimalPoint);
		
		cell.textLabel.text = [person name:my_nameSetting.nameFormat].ns;
		cell.detailTextLabel.text = balanceStr.ns;
		cell.imageView.image = UIImage_varOr(person.image, nil);
	}



	- (void) updateAllPerson :(PersonList*)allPerson 
	{
		[my_originAllPerson replaceAll:allPerson];
		[self _updateWorkingAllPerson];		
		[self.tableView reloadData];
	}
	
	- (void) updateAllPersonAndBalance :(PersonList*)allPerson :(BalanceList*)allBalance
	{
		[my_originAllPerson replaceAll:allPerson];
		[my_allBalance replaceAll:allBalance];
		[self _updateWorkingAllPerson];		
		[self.tableView reloadData];
	}
	
	
	- (void) setSingleBalance :(Balance*)balance
	{        
		NubleInt index = [my_allBalance findFirstIndexByPRID:balance.prID];
		if (index.hasVar)
            [my_allBalance modifyAt :index.vd :balance];
        else
            [my_allBalance append :balance];			

		[self _updateWorkingAllPerson];		
		[self.tableView reloadData];		
	}
	
		

	
	- (Int) originAllPersonCount
	{
		return my_originAllPerson.count;
	}
	
	- (NublePerson) findPersonByPRID :(Int)prID
	{
		return [my_originAllPerson findByPRID:prID];
	}




	- (NameSetting) nameSetting
	{
		return my_nameSetting;
	}
	
	- (void) setSetting :(AllPersonSetting)allPerson
	{
		[self setSetting :allPerson :my_nameSetting];
	}
	
	- (void) setSetting :(AllPersonSetting)allPerson :(NameSetting)name
	{
		my_allPersonSetting = allPerson;
		my_nameSetting = name;
		
		[self _updateWorkingAllPerson];	
		[self.tableView reloadData];
	}




	- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView 
	{
		return 1;
	}


	- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
	{
		return my_workingAllPerson.count;
	}
	
	
	- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
	{
		static NSString* MyIdentifier = @"UI_AllPersonViewController";
	
		UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			cell.detailTextLabel.textColor = [UIColor blackColor];
		}
		
		if ([my_workingAllPerson isValidIndex:indexPath.row])
		{
			Person* person = [my_workingAllPerson at:indexPath.row];			
			[self _setUITableViewCell :cell :person];
		}
	
		return cell;
	}
	

	- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
	{
		Person* person = [my_workingAllPerson at:indexPath.row];
		[my_observer AllPersonViewController_personSelected:person];
	}


@end
















