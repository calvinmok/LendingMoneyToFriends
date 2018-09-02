



#import "UI_UI.h"

#import <MobileCoreServices/UTCoreTypes.h>


NS_INLINE NSString* titleTakePicture(void) { return @"Take a Picture"; }
NS_INLINE NSString* titleSelectPicture(void) { return @"Select a Picture"; }


@implementation UI
	
	
	+ (UI*) create :(UI_Observer*)observer :(AllPersonSetting)setting
	{
		UI* result = [[[UI alloc] init] autorelease];		
		[result _creating :observer :setting];
		return result;
	}


	- (void) _creating :(UI_Observer*)observer :(AllPersonSetting)setting
	{
		my_observer = observer;
        
			
		my_cameraActionSheet = [[UIActionSheet alloc] 
			initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" 
            destructiveButtonTitle:nil 
            otherButtonTitles:titleTakePicture(), titleSelectPicture(), nil];
		
		
		my_allPersonVC = [[AllPersonViewController create :self] retain];
		my_allPersonSettingVC = [[AllPersonSettingViewController create :self :setting] retain];
		my_allRecordVC = [[AllRecordViewController create:self] retain];
		my_singleRecordVC = [[SingleRecordViewController create:self] retain];
		my_recordImageVC = [[RecordImageViewController create:self] retain];
		my_recordItemVC = [[RecordItemViewController create:self] retain];

		my_navigationController = [[NavigationController alloc] initWithRootViewController:my_allPersonVC];
		my_navigationController.delegate = self;
		my_navigationController.navigationBar.barStyle = UIBarStyleBlack;

		CGRect mainBounds = [[UIScreen mainScreen] bounds];
		my_window = [[Window alloc] initWithFrame:mainBounds];
		my_window.backgroundColor = [UIColor blackColor];

		[my_window setObserver:self];		

	    [my_window addSubview:my_navigationController.view];
		[my_window makeKeyAndVisible];
	}
		
	- (void) dealloc
	{
        [my_cameraActionSheet release];
        
		[my_allPersonVC release];
		[my_allPersonSettingVC release];
		[my_allRecordVC release];
		[my_singleRecordVC release];
		[my_recordImageVC release];
		[my_recordItemVC release];
		
		[my_navigationController release];
		[my_window release];
		
		[super dealloc];
	}
	


    - (void)
        navigationController:(UINavigationController *)navigationController 
        didShowViewController:(UIViewController *)viewController 
        animated:(BOOL)animated
    {
		if (viewController == my_recordImageVC)
        {
            NubleUIImage image = my_singleRecordVC.original;
            if (image.hasVar)            
                [my_recordImageVC setImage:image.vd];
        }
    }

	- (void) 
		navigationController:(UINavigationController *)navigationController 
		willShowViewController:(UIViewController *)viewController 
		animated:(BOOL)animated
	{
		if (viewController == my_allPersonVC)
		{			
			if (my_lastVC == my_allRecordVC)
			{
				NublePerson person = my_allRecordVC.person;
		
				[my_allRecordVC setPerson :Person_nuble() :my_allPersonVC.nameSetting.nameFormat];
				[my_singleRecordVC setRecord:Record_nuble()];

				if (person.hasVar)
					[my_observer UI_personUnselected];
			}
			else if (my_lastVC == my_allPersonSettingVC)
			{
				AllPersonSetting allPersonSetting = my_allPersonSettingVC.allPersonSetting;
				[my_allPersonVC setSetting:allPersonSetting];
			}
		}
		else if (viewController == my_allRecordVC)
		{
			[my_singleRecordVC setRecord:Record_nuble()];
 		}
		
		my_lastVC = viewController;
	}




	- (void) Window_shake
	{
	}	




	- (void) AllPersonSettingViewController_propertyChanged
	{
		AllPersonSetting allPersonSetting = my_allPersonSettingVC.allPersonSetting;
		[my_observer UI_allPersonSettingChanged:allPersonSetting];				
	}




	- (void) AllPersonViewController_clear
	{
		[my_observer UI_clear];		
	}

	
	- (void) AllPersonViewController_settingClicked
	{
		[my_navigationController pushViewController:my_allPersonSettingVC animated:YES];		
	}
	

	- (void) AllPersonViewController_personSelected :(Person*)person
	{		
		[my_allRecordVC setPerson:Person_toNuble(person) :my_allPersonVC.nameSetting.nameFormat];
		[my_observer UI_personSelected];
		[my_navigationController pushViewController:my_allRecordVC animated:YES];
	}
	
	
	
    
	- (NubleUIImage) AllRecordViewController_getThumbnail :(Record*)record
	{
		NublePerson person = my_allRecordVC.person;
		return [my_observer UI_readThumbnail :person.vd :record];
	}

	- (void) AllRecordViewController_recordSelected :(Record*)selected
	{		
		[my_singleRecordVC setRecord:Record_toNuble(selected)];
		[my_navigationController pushViewController:my_singleRecordVC animated:YES];
	}
	
	- (void) AllRecordViewController_recordCreating
	{
		[my_singleRecordVC setRecord:Record_nuble()];
		[my_navigationController pushViewController:my_singleRecordVC animated:YES];
	}

	- (void) AllRecordViewController_recordDeleting :(Record*)record
	{
		[my_observer UI_recordDeleting :record];		
	}
	
	
	

	- (NubleUIImage) SingleRecordViewController_readOriginal :(Record*)record
	{
		NublePerson person = my_allRecordVC.person;
		return [my_observer UI_readOriginal :person.vd :record];
	}

	- (NubleUIImage) SingleRecordViewController_readThumbnail :(Record*)record
	{
		NublePerson person = my_allRecordVC.person;
		return [my_observer UI_readThumbnail :person.vd :record];
	}
	
	
	- (void) SingleRecordViewController_cancel
	{
		[my_navigationController popViewControllerAnimated:YES];
	}
		
	- (void) SingleRecordViewController_submitted 
		:(NubleRecord)oldRecord 
        :(Bool)imageChanged :(NubleUIImage)original :(NubleUIImage)thumbnail 
        :(String*)name :(Double)amount :(DT2001)dateTime
	{
		[my_observer UI_recordSubmitted :oldRecord :imageChanged :original :thumbnail :name :amount :dateTime];
		[my_navigationController popViewControllerAnimated:YES];
	}
	
	- (void) SingleRecordViewController_imageTapped 
    {
		if (my_singleRecordVC.original.hasVar)
		{
            NubleUIImage image = my_singleRecordVC.thumbnail;
            if (image.hasVar)            
                [my_recordImageVC setImage:image.vd];        
        
			[my_navigationController pushViewController:my_recordImageVC animated:YES];	
		}
		else
		{
			[self _showImagePicker];
		}
	}
	
	- (void) SingleRecordViewController_nameButtonDidClick
	{
		StringList* allNameItem = [my_observer UI_getAllNameItem];
		[my_recordItemVC setAllItem :RecordItemType_Name :allNameItem];
		[my_navigationController pushViewController:my_recordItemVC animated:YES];
	}
	
	- (void) SingleRecordViewController_amountButtonDidClick
	{
		StringList* allAmountItem = [my_observer UI_getAllAmountItem];
		[my_recordItemVC setAllItem :RecordItemType_Amount :allAmountItem];		
		[my_navigationController pushViewController:my_recordItemVC animated:YES];
	}
		
	
	
	- (void) RecordImageViewController_edit
	{
		[my_navigationController popViewControllerAnimated:YES];
		[self _showImagePicker];
	}
    
    - (void) RecordImageViewController_cancel
    {
        [my_navigationController popViewControllerAnimated:YES];
    }
	
	
	- (void) RecordItemViewController_submit :(RecordItemType)type :(String*)item
	{
		if (type == RecordItemType_Name)
			[my_singleRecordVC setName:item];
		
		if (type == RecordItemType_Amount)
		{
			NubleDouble d = Double_parse(item);
			if (d.hasVar)			
				[my_singleRecordVC setAmount:d.vd];
		}
		
		[my_navigationController popViewControllerAnimated:YES];
	}
	
	- (void) RecordItemViewController_itemDeleted :(RecordItemType)type :(String*)item
	{
		[my_observer UI_itemDeleted :type :item];
	}
    
    - (void) RecordItemViewController_cancel
    {
        [my_navigationController popViewControllerAnimated:YES];
    }
			
	
					
	- (Int) originAllPersonCount
	{
		return [my_allPersonVC originAllPersonCount];
	}

	- (NublePerson) findPersonByPRID :(Int)prID;
	{
		return [my_allPersonVC findPersonByPRID :prID];
	}
	
	- (NublePerson) selectedPerson
	{
		return my_allRecordVC.person; 
	}
	
	- (NubleRecord) selectedRecord
	{
		return my_singleRecordVC.record;
	}
	
	
	- (RecordList*) allRecord
	{
		return my_allRecordVC.allRecord;
	}
	
	
	- (void) setNameSetting :(NameSetting)nameSetting
	{
		AllPersonSetting allPersonSetting = my_allPersonSettingVC.allPersonSetting;
		[my_allPersonVC setSetting :allPersonSetting :nameSetting];
	}
	
	
	
		
	
	- (void) updateAllPerson :(PersonList*)allPerson
	{
		[my_allPersonVC updateAllPerson:allPerson];
	}

	- (void) updateAllPersonAndBalance :(PersonList*)allPerson :(BalanceList*)allBalance
	{
		[my_allPersonVC updateAllPersonAndBalance :allPerson :allBalance];
	}
		
	- (void) setSingleBalance :(Balance*)balance
	{
		[my_allPersonVC setSingleBalance:balance];
	}
	
			
	- (void) updateAllRecord :(RecordList*)allRecord
	{
		[my_allRecordVC updateAllRecord:allRecord];
	}
	
	- (void) modifySingleRecordWithoutModifySingleRecordViewController :(Record*)record
	{
		[my_allRecordVC modifySingleRecord:record];
	}
	
	- (void) insertSingleRecord :(Record*)record
	{
		[my_allRecordVC insertSingleRecord:record];
	}
	
	- (void) deleteSingleRecord :(Record*)record
	{
		[my_allRecordVC deleteSingleRecord:record];
		
		NubleRecord selectedRecord = my_singleRecordVC.record;
		if (selectedRecord.hasVar && selectedRecord.vd.key == record.key)
			[my_singleRecordVC setRecord:Record_nuble()];
	}





	
	
	
	- (void) _showImagePicker
	{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [my_cameraActionSheet showInView:my_navigationController.view];
        }
        else
        {
            UIImagePickerController* imagePicker = [[[UIImagePickerController alloc] init] autorelease];
            imagePicker.delegate = self;
		
            [my_navigationController presentModalViewController:imagePicker animated:YES];
        }        
	}

	
    - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        if (actionSheet == my_cameraActionSheet)
        {
            String* title = STR([my_cameraActionSheet buttonTitleAtIndex:buttonIndex]);
            
            UIImagePickerController* imagePicker = [[[UIImagePickerController alloc] init] autorelease];
            imagePicker.delegate = self;
            
            IF ([title eqNS:titleTakePicture()])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;                
                [my_navigationController presentModalViewController:imagePicker animated:YES];
            }
            EF ([title eqNS:titleSelectPicture()])
            {
                [my_navigationController presentModalViewController:imagePicker animated:YES];
            }
            EL
            {
            }
        }
    }

	
	- (void)
		imagePickerController:(UIImagePickerController*)picker 
		didFinishPickingMediaWithInfo: (NSDictionary *) info  
	{
        NSString* mediaType = [info objectForKey: UIImagePickerControllerMediaType];    
        
        if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
        {
            UIImage* original = [info objectForKey:UIImagePickerControllerEditedImage];
            
            if (original == nil)
                original = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            if (original != nil)
            {
                CGFloat maxLenght = 128.0;
                CGSize size = original.size;
                
                if (size.width > size.height)
                    size = CGSizeMake(maxLenght, (size.height * maxLenght) / size.width);
                else
                    size = CGSizeMake((size.width * maxLenght) / size.height, maxLenght);
                
                UIGraphicsBeginImageContext(size);
                [original drawInRect:CGRectMake(0, 0, size.width, size.height)];
                UIImage* thumbnail = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                                
                [my_singleRecordVC setOriginal:UIImage_toNuble(original)];
                [my_singleRecordVC setThumbnail:UIImage_toNuble(thumbnail)];
            }
        }
    
		[my_navigationController dismissModalViewControllerAnimated:YES];
	}

	- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker 
	{	
		[my_navigationController dismissModalViewControllerAnimated:YES];		
	}
	
    
    
    

@end












