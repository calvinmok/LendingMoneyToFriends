






#import "UI_AllRecordViewController.h"





@implementation AllRecordViewController


	+ (AllRecordViewController*) create :(AllRecordViewController_Observer*)observer
	{
		AllRecordViewController* result = [[[AllRecordViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
		[result _creating:observer];
		return result;
	}
	
	- (void) _creating :(AllRecordViewController_Observer*)observer
	{
		self.title = @"Person";
		
		
		my_observer = observer;

		my_person = Person_nuble();
		
		my_allRecord = [[RecordMutableList create] retain];


		my_editBarButtonItem = [[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(_edit)];
			
		my_doneBarButtonItem = [[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_done)];
			
		self.navigationItem.rightBarButtonItem = my_editBarButtonItem;
	}
	
	- (void) dealloc
	{
		Person_release(my_person);
		[my_editBarButtonItem release];
		[my_doneBarButtonItem release];
		[my_allRecord release];
		[super dealloc];
	}


	- (NublePerson) person
	{
		return my_person;
	}
	
	- (void) setPerson :(NublePerson)person :(NameFormat)nameFormat
	{
		Person_autorelease(my_person);
		my_person = person;
		Person_retain(my_person);
		
		self.title = (my_person.hasVar) ? [person.vd name:nameFormat].ns : @"";
	}
	

	- (RecordList*) allRecord
	{
		return my_allRecord;
	}
	
	

	- (void) updateAllRecord :(RecordList*)allRecord
	{
		[my_allRecord replaceAll:allRecord];		
		[my_allRecord sortByDateTimeRevOrder];
		[self.tableView reloadData];
	}

	
	- (void) insertSingleRecord :(Record*)record
	{
		[my_allRecord append :record];
		[my_allRecord sortByDateTimeRevOrder];
		[self.tableView reloadData];
	}
	
	- (void) modifySingleRecord :(Record*)record
	{
		NubleInt recordIndex = [my_allRecord findFirstIndexByKey :record.key];
		if (recordIndex.hasVar == No)
			return;
	
		[my_allRecord modifyAt :recordIndex.vd :record];
		[my_allRecord sortByDateTimeRevOrder];
		[self.tableView reloadData];
	}
	
	- (void) deleteSingleRecord :(Record*)record
	{
		NubleInt index = [my_allRecord findFirstIndexByKey:record.key];
		if (index.hasVar == No)
			return;
		
		[my_allRecord removeAt:index.vd];	
		[self.tableView reloadData];	
	}
	




	- (void) _edit
	{
		if (self.tableView.isEditing == NO)	
		{		
			[self.tableView setEditing:YES animated:YES];			
			self.navigationItem.rightBarButtonItem = my_doneBarButtonItem;
			
			[self.navigationItem setHidesBackButton:YES animated:YES];
		}
	}
	
	- (void) _done
	{
		if (self.tableView.isEditing)	
		{		
			[self.tableView setEditing:NO animated:YES];			
			self.navigationItem.rightBarButtonItem = my_editBarButtonItem;

			[self.navigationItem setHidesBackButton:NO animated:YES];
		}
	}





	- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView 
	{
		return 2;
	}

	- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
	{
		return @"";
	}

	- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
	{
		if (section == 1)	
			return my_allRecord.count;
		else 
			return 1;
	}
	

	- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
	{		
		UITableViewCell* cell = nil;
		
		if (indexPath.section == 0)
		{
			static NSString* Identifier = @"UI_AllRecordViewController_Section1";
			
			cell = [tableView dequeueReusableCellWithIdentifier:Identifier];	
			if (cell == nil) 
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}

			cell.textLabel.text = @"+ New";
			
			return cell;
		}
		else if (indexPath.section == 1)
		{
			static NSString* Identifier = @"UI_AllRecordViewController_Section2";
			
			cell = [tableView dequeueReusableCellWithIdentifier:Identifier];	
			if (cell == nil) 
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}

			Record* record = [my_allRecord at:indexPath.row];
			[self _setUITableViewCell :cell :record];
						
			return cell;	
		}
		
		return cell;
	}
	
	

	- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
	{
		return (indexPath.section == 0) ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
	}
	

	- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
	{
		if (indexPath.section == 0)
		{
			[my_observer AllRecordViewController_recordCreating];
		}
		else if (indexPath.section == 1)
		{
			UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];			
			
			NubleRecord record = [my_allRecord findFirstByKey:cell.tag];
			if (record.hasVar)
			{
				[my_observer AllRecordViewController_recordSelected:record.vd];
			}
		}		
	}


	- (void) 
		tableView          :(UITableView *)tableView 
		commitEditingStyle :(UITableViewCellEditingStyle)editingStyle 
		forRowAtIndexPath  :(NSIndexPath *)indexPath
	{
		if (indexPath.section == 1)
		{
			if (editingStyle == UITableViewCellEditingStyleDelete)
			{
				UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
				
				NubleRecord record = [my_allRecord findFirstByKey:cell.tag];
				if (record.hasVar)
					[my_observer AllRecordViewController_recordDeleting:record.vd];
			}		
		}
	}
	
	


	- (void) _setUITableViewCell :(UITableViewCell*)cell :(Record*)record
	{
		String* amountStr = Double_printFixed(record.amount, my_allRecord.numberOfDigitAfterDecimalPoint);			
		String* dateStr = DT2001_printYMDHM(record.dateTime);

		cell.textLabel.text = record.name.ns;		
		cell.detailTextLabel.text = dateStr.ns;
		cell.tag = record.key;
		
		UIFont* font = [UIFont systemFontOfSize:[UIFont labelFontSize]];	
		CGSize size = [amountStr.ns sizeWithFont:font];

		UILabel* label = [[[UILabel alloc] init] autorelease];
		label.textAlignment = UITextAlignmentRight;
		label.frame = CGRectMake(0, 0, size.width, size.height);
		label.text = amountStr.ns;		
		cell.accessoryView = label;
				
		NubleUIImage image = UIImage_nuble();
		if (record.hasImage)
			image = [my_observer AllRecordViewController_getThumbnail:record];
		
		cell.imageView.image = UIImage_varOr(image, nil);
	}



@end

















