




#import "UI_RecordItemViewController.h"


@implementation RecordItemViewController



	+ (RecordItemViewController*) create:(RecordItemViewController_Observer*)observer
	{
		RecordItemViewController* result = [[[RecordItemViewController alloc] init] autorelease];
		[result _creating :observer];
		return result;		
	}
	
	- (void) _creating:(RecordItemViewController_Observer*)observer
	{
		my_observer = observer;
		my_recordItemType = RecordItemType_None;
		
		my_allItem = [[StringMutableList create] retain];
        

		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_cancel)] 
			autorelease];

		
		my_editBarButtonItem = [[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(_edit)];
			
		my_doneBarButtonItem = [[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_done)];
			
		self.navigationItem.rightBarButtonItem = my_editBarButtonItem;
	}
	
	- (void) dealloc
	{
		[my_editBarButtonItem release];
		[my_doneBarButtonItem release];
		
		[my_allItem release];

		[super dealloc];
	}
	





	- (void) _edit
	{
		if (self.tableView.isEditing == NO)	
		{		
			[self.tableView setEditing:YES animated:YES];			
			self.navigationItem.rightBarButtonItem = my_doneBarButtonItem;
		}
	}
	
	- (void) _done
	{
		if (self.tableView.isEditing)	
		{		
			[self.tableView setEditing:NO animated:YES];			
			self.navigationItem.rightBarButtonItem = my_editBarButtonItem;
		}
	}
    
    - (void) _cancel
    {
        [self _done];
        [my_observer RecordItemViewController_cancel]; 
    }



	- (void) setAllItem :(RecordItemType)type :(StringList*)allItem
	{
		IF (type == RecordItemType_Name)
			self.title = @"Used Names";
		EF (type == RecordItemType_Amount)
			self.title = @"Used Amounts";
		EL
			self.title = @"";
		
		my_recordItemType = type;
		
		[my_allItem removeAll];
		ForEachIndex(i, allItem)
		{
			[my_allItem append:[allItem at:i]];
		}
		
		[self.tableView reloadData];
		
		[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	}
	
	

	- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView 
	{
		return 1;
	}


	- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
	{
		return my_allItem.count;
	}
	
	
	- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
	{
		static NSString* MyIdentifier = @"UI_AllPersonViewController";
	
		UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier] autorelease];
			cell.detailTextLabel.textColor = [UIColor blackColor];
			
			cell.textLabel.adjustsFontSizeToFitWidth = Yes;
			cell.detailTextLabel.adjustsFontSizeToFitWidth = Yes;
		}
		
		if ([my_allItem isValidIndex:indexPath.row])
		{
			cell.textLabel.text = nil;
			cell.detailTextLabel.text = nil;

			String* item = [my_allItem at:indexPath.row];
			
			if (my_recordItemType == RecordItemType_Name)	
				cell.textLabel.text = item.ns;
				
			if (my_recordItemType == RecordItemType_Amount)			
				cell.detailTextLabel.text = item.ns;
		}
	
		return cell;
	}
	
	

	- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
	{
		return UITableViewCellEditingStyleDelete;
	}
		
	

	- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
	{
		String* item = [my_allItem at:indexPath.row];
		[my_observer RecordItemViewController_submit :my_recordItemType :item];
	}


	- (void) 
		tableView          :(UITableView *)tableView 
		commitEditingStyle :(UITableViewCellEditingStyle)editingStyle 
		forRowAtIndexPath  :(NSIndexPath *)indexPath
	{
		if (editingStyle == UITableViewCellEditingStyleDelete)
		{
			String* item = [my_allItem at:indexPath.row];
			[my_allItem removeAt:indexPath.row];
			
			[my_observer RecordItemViewController_itemDeleted :my_recordItemType :item];
			
			NSArray* indexPaths = [NSArray arrayWithObject:indexPath];			
			[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
		}
	}
	
	
	
		
				
@end
