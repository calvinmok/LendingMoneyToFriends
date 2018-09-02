





#import "UI_SingleRecordViewController.h"



#define UIViewAutoresizingFlexibleWidthAndHeight \
	UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight

#define UIViewAutoresizingFlexibleBottomRightMargin \
	UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin

#define UIViewAutoresizingFlexibleBottomMarginAndWidth \
	UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth




@implementation SingleRecordViewController


	+ (UIImage*) createDefaultPhotoImage
	{
		NSString* str = @"Image";
		UIFont* font = [UIFont systemFontOfSize:60.0];
		CGSize strSize = [str sizeWithFont:font];
		CGSize contextSize = CGSizeMake(strSize.width + strSize.height, strSize.width + strSize.height);

		UIGraphicsBeginImageContext(contextSize);
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGFloatMutableList* list = [CGFloatMutableList create:12];
		[list append :204.0f / 255.0f :224.0f / 255.0f :244.0f / 255.0f :255.0f / 255.0f];
		[list append :029.0f / 255.0f :156.0f / 255.0f :215.0f / 255.0f :255.0f / 255.0f];
		[list append :204.0f / 255.0f :224.0f / 255.0f :244.0f / 255.0f :255.0f / 255.0f];
		[list append :029.0f / 255.0f :156.0f / 255.0f :215.0f / 255.0f :255.0f / 255.0f];
		[list append :204.0f / 255.0f :224.0f / 255.0f :244.0f / 255.0f :255.0f / 255.0f];
			
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();		
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, list.mutableBytes, NULL, list.count / 4);
		
		CGPoint endPoint = CGPointMake(contextSize.width, contextSize.height);	
		CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0f, 0.0f), endPoint, 0);
		
		CGGradientRelease(gradient);
		CGColorSpaceRelease(colorSpace);
		
		CGFloat x = (contextSize.width - strSize.width) / 2.0f;
		CGFloat y = (contextSize.height - strSize.height) / 2.0f;		
		[str drawInRect:CGRectMake(x, y, strSize.width, strSize.height) withFont:font];
		
		UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();	
		
		return result;
	}



	- (UILabel*) _createLabel :(NSString*)text
	{
		UILabel* result = [[[UILabel alloc] init] autorelease];
		result.backgroundColor = [UIColor clearColor];
		result.text = text;
		result.font = my_font;	
		return result;
	}

	- (UITextField*) _createStringTextField :(UIKeyboardType)keyboardType
	{
		UITextField* result = [[[UITextField alloc] init] autorelease];
		result.delegate = self;
		result.borderStyle = UITextBorderStyleRoundedRect;
		result.clearButtonMode = UITextFieldViewModeWhileEditing;
		result.keyboardType = keyboardType;
		return result;
	}
	
	- (UIButton*) _createCacheButton :(SEL)action
	{
		UIButton* result = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		[result addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
		return result;
	}
	
	- (UITextField*) _createDateTimeTextField :(UIDatePicker*)datePicker
	{
		UITextField* result = [[[UITextField alloc] init] autorelease];
		result.delegate = self;
		result.borderStyle = UITextBorderStyleRoundedRect;
		result.inputView = datePicker;
		return result;
	}
	
	- (UIDatePicker*) _createDatePicker :(UIDatePickerMode)mode :(SEL)action
	{
		UIDatePicker* result = [[[UIDatePicker alloc] initWithFrame:CGRectZero] autorelease];
		result.datePickerMode = mode;
		[result addTarget:self action:action forControlEvents:UIControlEventValueChanged];
		return result;
	}
	
	
	- (void) _setupUIView
	{
		my_rootScrollView  = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
		my_rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidthAndHeight;
		my_rootScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];

		my_defaultPhotoImage = [[SingleRecordViewController createDefaultPhotoImage] retain];
								
		my_imageView = [[UIImageView alloc] init];
		my_imageView.userInteractionEnabled = YES;
		my_imageView.contentMode = UIViewContentModeScaleAspectFit;
		my_imageView.image = my_defaultPhotoImage;
			
		UITapGestureRecognizer* tapGR = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_imageTapped)] autorelease];
		tapGR.numberOfTapsRequired = 1;
		[my_imageView addGestureRecognizer:tapGR];
		
		my_deleteImage = [[UIImage imageNamed:@"deleteImage1.png"] retain];

		my_deleteImageButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		my_deleteImageButton.backgroundColor = [UIColor clearColor];
		[my_deleteImageButton setImage:my_deleteImage forState:UIControlStateNormal];
		[my_deleteImageButton addTarget:self action:@selector(_deleteImageButtonTapped) forControlEvents:UIControlEventTouchUpInside];
		
		my_nameLabel = [self _createLabel:@"Name"];
		my_nameTextField = [[self _createStringTextField:UIKeyboardTypeDefault] retain];		
		my_nameButton = [[self _createCacheButton:@selector(_nameButtonClicked)] retain];

		my_amountLabel = [self _createLabel:@"Amt."];
		my_amountTextField = [[self _createStringTextField:UIKeyboardTypeNumbersAndPunctuation] retain];
		my_amountButton = [[self _createCacheButton:@selector(_amountButtonClicked)] retain];
		
		my_dateTimeLabel = [self _createLabel:@"Date"];
		my_datePicker = [[self _createDatePicker :UIDatePickerModeDate :@selector(_datePickerChanged:)] retain];
		my_timePicker = [[self _createDatePicker :UIDatePickerModeTime :@selector(_datePickerChanged:)] retain];		
		my_dateTextField = [[self _createDateTimeTextField:my_datePicker] retain];
		my_timeTextField = [[self _createDateTimeTextField:my_timePicker] retain];
		

		[my_rootScrollView addSubview:my_imageView];
		[my_rootScrollView addSubview:my_deleteImageButton];
		
		[my_rootScrollView addSubview:my_nameLabel];
		[my_rootScrollView addSubview:my_nameTextField];
		[my_rootScrollView addSubview:my_nameButton];
		
		[my_rootScrollView addSubview:my_amountLabel];
		[my_rootScrollView addSubview:my_amountTextField];
		[my_rootScrollView addSubview:my_amountButton];
		
		[my_rootScrollView addSubview:my_dateTimeLabel];
		[my_rootScrollView addSubview:my_dateTextField];
		[my_rootScrollView addSubview:my_timeTextField];
	}
	
	
	
	
	

	+ (SingleRecordViewController*) create :(SingleRecordViewController_Observer*)observer
	{
		SingleRecordViewController* result = [[[SingleRecordViewController alloc] init] autorelease];
		[result _creating :observer];
		return result;
	}
	
	- (void) _creating :(SingleRecordViewController_Observer*)observer
	{
		my_observer = observer;
		
		my_record = Record_nuble();
		
		my_imageChanged = No;
		
		
		self.title = @"Record";
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_cancel)] 
			autorelease];

		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_done)] 
			autorelease];
		
		my_font = [[UIFont systemFontOfSize:[UIFont labelFontSize]] retain];		
				
		[self _setupUIView];

		NSNotificationCenter* dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];			
		[dnc addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
			
		my_cancelAlertView = [[UIAlertView alloc] 
			initWithTitle:@"" message:@"Do you want to cancel the change you have made?"
			delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
																									
		my_removeImageAlertView = [[UIAlertView alloc] 
			initWithTitle:@"" message:@"The image will be removed. Are you sure?"
			delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
	}
	
	- (void) dealloc
	{
		Record_release(my_record);
		UIImage_release(my_my_original);
		UIImage_release(my_my_thumbnail);
		
		[my_defaultPhotoImage release];
		[my_imageView release];
		
		[my_deleteImage release];
		[my_deleteImageButton release];
		
		[my_nameLabel release];
		[my_nameTextField release];
		[my_nameButton release];
		
		[my_amountLabel release];
		[my_amountTextField release];
		[my_amountButton release];
		
		[my_dateTimeLabel release];
		[my_datePicker release];
		[my_timePicker release];
		[my_dateTextField release];
		[my_timeTextField release];		

		[my_rootScrollView release];
		
		[my_font release];
		
		[my_cancelAlertView release];
		[my_removeImageAlertView release];

		[super dealloc];
	}
		
	- (void) loadView
	{		
		CGSize nameLabelSize = [my_nameLabel.text sizeWithFont:my_font];
		CGSize amountLabelSize = [my_amountLabel.text sizeWithFont:my_font];
		CGSize dateTimeLabelSize = [my_dateTimeLabel.text sizeWithFont:my_font];

		CGFloat labelH = MAX(nameLabelSize.height, MAX(amountLabelSize.height, dateTimeLabelSize.height)) + 8.f;
		CGFloat labelW = MAX(nameLabelSize.width, MAX(amountLabelSize.width, dateTimeLabelSize.width)) + (labelH/4.f);
		
		CGFloat padding = labelH;
		
		CGRect imageViewFrame = CGRectMake(padding, padding, 64.f, 64.f);
		CGRect deleteImageButtonFrame = CGRectMake(padding + imageViewFrame.size.width - (24.f/2.f), padding - (24.f/2.f), 24.f, 24.f);

		CGFloat nameY = padding + imageViewFrame.size.height + (padding/2.f);
		CGFloat amountY = nameY + labelH + (padding/2.f);
		CGFloat dateTimeY = amountY + labelH + (padding/2.f);
		
		CGFloat buttonWidth = labelH;
		CGFloat textFieldW = my_rootScrollView.frame.size.width - padding - (padding/2.f) - labelW - buttonWidth;

		CGRect nameLabelFrame = CGRectMake(padding, nameY, labelW, labelH);
		CGRect amountLabelFrame = CGRectMake(padding, amountY, labelW, labelH);
		CGRect dateTimeLabelFrame = CGRectMake(padding, dateTimeY, labelW, labelH);
		
		CGRect nameTextFrame = CGRectMake(padding + labelW, nameY, textFieldW, labelH);
		CGRect amountTextFrame = CGRectMake(padding + labelW, amountY, textFieldW, labelH);
		CGRect dateTextFrame = CGRectMake(padding + labelW, dateTimeY, textFieldW * (2.f/3.f), labelH);		
		CGRect timeTextFrame = CGRectMake(padding + labelW + dateTextFrame.size.width, dateTimeY, textFieldW * (1.f/3.f), labelH);		
		
		CGRect nameButtonFrame = CGRectMake(nameTextFrame.origin.x + nameTextFrame.size.width, nameY, buttonWidth, labelH);
		CGRect amountButtonFrame = CGRectMake(amountTextFrame.origin.x + amountTextFrame.size.width, amountY, buttonWidth, labelH);			

		CGFloat scrollViewHeight = dateTimeY + labelH + padding;
		
		my_rootScrollView.contentSize = CGSizeMake(my_rootScrollView.frame.size.width, scrollViewHeight);

		my_imageView.frame = imageViewFrame;
		my_deleteImageButton.frame = deleteImageButtonFrame;
		
		my_nameLabel.frame = nameLabelFrame;		
		my_nameTextField.frame = nameTextFrame;
		my_nameTextField.placeholder = my_nameLabel.text;
		my_nameButton.frame = nameButtonFrame;
			
		my_amountLabel.frame = amountLabelFrame;		
		my_amountTextField.frame = amountTextFrame;
		my_amountTextField.placeholder = my_amountLabel.text;		
		my_amountButton.frame = amountButtonFrame;

		my_dateTimeLabel.frame = dateTimeLabelFrame;
		my_dateTextField.frame = dateTextFrame;
		my_timeTextField.frame = timeTextFrame;

		self.view = my_rootScrollView;
	}
	
	
	
	
	
	- (Bool) _resignFirstResponder
	{
		if ([my_amountTextField isFirstResponder])
		{
			[my_amountTextField resignFirstResponder];
			return YES;
		}
		
		if ([my_nameTextField isFirstResponder])
		{
			[my_nameTextField resignFirstResponder];
			return YES;
		}
		
		if ([my_dateTextField isFirstResponder])
		{
			[my_dateTextField resignFirstResponder];
			return YES;
		}
				
		if ([my_timeTextField isFirstResponder])
		{
			[my_timeTextField resignFirstResponder];
			return YES;
		}
		
		return NO;
	}
	
	
	
	
	- (NubleRecord) record
	{
		return my_record;
	}
	
	- (void) setRecord:(NubleRecord)value
	{
		[self _resignFirstResponder];
	
		Record_autorelease(my_record);
		my_record = value;
		Record_retain(my_record);
		
        
        [self setOriginal:UIImage_nuble()];
        
        
		if (my_record.hasVar)
		{
			self.title = my_record.vd.name.ns;
			
			if (my_record.vd.hasImage)
			{
				NubleUIImage image = [my_observer SingleRecordViewController_readThumbnail :my_record.vd];
				[self setThumbnail:image];
			}
            else
            {
                [self setThumbnail:UIImage_nuble()];
            }
			
			my_nameTextField.text = my_record.vd.name.ns;
			my_amountTextField.text = Double_printFloating(my_record.vd.amount, currencyPrecision()).ns;
			my_dateTextField.text = DT2001_printYMD(my_record.vd.dateTime).ns;
			my_timeTextField.text = DT2001_printHM(my_record.vd.dateTime).ns;
		}
		else
		{
			self.title = @"New";
			
			[self setThumbnail:UIImage_nuble()];
			
			my_nameTextField.text = @"";
			my_amountTextField.text = @"";
			my_dateTextField.text = DT2001_printYMD(DT2001_createNow()).ns;
			my_timeTextField.text = DT2001_printHM(DT2001_createNow()).ns;
		}
		
		my_imageChanged = NO;
	}
	
	
	
	- (void) setThumbnail :(NubleUIImage)thumbnail
	{
        UIImage_autorelease(my_my_thumbnail);
		my_my_thumbnail = thumbnail;		
		UIImage_retain(my_my_thumbnail);
		
		my_imageView.image = UIImage_varOr(self.thumbnail, my_defaultPhotoImage);
		
		my_imageChanged = YES;
		
		my_deleteImageButton.hidden = (self.thumbnail.hasVar == No);
	}
    
    - (NubleUIImage) thumbnail { return my_my_thumbnail; }
    
    - (void) setOriginal :(NubleUIImage)original
    {
        UIImage_autorelease(my_my_original);
		my_my_original = original;		
		UIImage_retain(my_my_original);
    }
    
    - (NubleUIImage) original { return my_my_original; }
    
	
	- (void) setName:(String*)name
	{
		my_nameTextField.text = name.ns;
	}
	
	- (void) setAmount:(Double)amount
	{
		my_amountTextField.text = Double_printFloating(amount, currencyPrecision()).ns;
	}
	

	- (void) _cancel
	{
		Bool changed = my_imageChanged;
		
		if (changed == NO)
		{
			String* uiName = STR(my_nameTextField.text);
			String* uiAmount = STR(my_amountTextField.text);

			if (my_record.hasVar)
			{
				if ([my_record.vd.name eq:uiName] == NO) 
					changed = YES;
				
				if (Double_parseEqual(uiAmount, my_record.vd.amount) == NO) 
					changed = YES;
					
				if (changed == NO)
				{
					String* uiDate = STR(my_dateTextField.text);
					String* uiTime = STR(my_timeTextField.text);
					NubleDT2001 uiDT = DT2001_parse(String_concat3(uiDate, STR(@" "), uiTime));
				
					if (uiDT.hasVar)
						changed = (uiDT.vd != my_record.vd.dateTime);
					else
						changed = YES;
				}
			}
			else
			{
				if (uiName.length > 0)
					changed = YES;

				if (uiAmount.length > 0)
					changed = YES;
			}
		}
	
		if (changed)
		{
			[my_cancelAlertView show];
			return;					
		}
		
		[my_observer SingleRecordViewController_cancel];
	}

	- (void) _done
	{
		if ([self _resignFirstResponder])
			return;
		

		NubleDouble amount = Double_toNuble(0.0);
		if (STR(my_amountTextField.text).length > 0)
		{
			amount = Double_parse(STR(my_amountTextField.text));
		}

		if (amount.hasVar == No)
		{
			UIAlertView* alert = [[[UIAlertView alloc] 
				initWithTitle:			@"" 
				message:				@"Please enter a number value in the amount field."
				delegate:				nil 
				cancelButtonTitle:		@"OK" 
				otherButtonTitles:		nil] autorelease];
				
			[alert show];
			
			return;
		}
					
		    
		String* amountStr = Double_printFloating(amount.vd, currencyPrecision());
		if ([amountStr eq:STR(my_amountTextField.text)] == NO)
		{
			my_amountTextField.text = amountStr.ns;
			return;
		}
		
		
		NubleDT2001 dateTime = DT2001_parse(String_concat(STR(my_dateTextField.text), STR(my_timeTextField.text)));
		
		if (dateTime.hasVar == No)
		{
			UIAlertView* alert = [[[UIAlertView alloc] 
				initWithTitle:			@"" 
				message:				@"Please enter a date time value in the datetime field."
				delegate:				nil 
				cancelButtonTitle:		@"OK" 
				otherButtonTitles:		nil] autorelease];
				
			[alert show];
			
			return;		
		}		

		
		String* name = STR(my_nameTextField.text);
		
		[my_observer SingleRecordViewController_submitted 
            :self.record 
            :my_imageChanged :self.original :self.thumbnail 
            :name :amount.vd :dateTime.vd];
	}
	
	
	
	- (void) _imageTapped
	{
		[self _resignFirstResponder];
        
        if (self.thumbnail.hasVar)
        {
            if (self.original.hasVar == No)
            {
                NubleRecord r = self.record;
                if (r.hasVar == NO) 
                    return;
                    
                NubleUIImage image = [my_observer SingleRecordViewController_readOriginal:r.vd];
                if (image.hasVar == NO)
                    return;               
                
                [self setOriginal :image];
            }
            
            if (self.original.hasVar)
            {
                [my_observer SingleRecordViewController_imageTapped];
            }
        }
        else
        {
            [my_observer SingleRecordViewController_imageTapped];
        }        
	}

	
	- (void) _deleteImageButtonTapped
	{
		if (self.thumbnail.hasVar)
			[my_removeImageAlertView show];
	}
	
	- (void) _datePickerChanged:(id)sender
	{
		if (sender == my_datePicker)
			my_dateTextField.text = DT2001_printYMD(DT2001_fromNSDate(my_datePicker.date)).ns;
		
		if (sender == my_timePicker)
			my_timeTextField.text = DT2001_printHM(DT2001_fromNSDate(my_timePicker.date)).ns;
	}
	
	
	
	
	
	- (void) _nameButtonClicked
	{
		[self _resignFirstResponder];	
		[my_observer SingleRecordViewController_nameButtonDidClick];
	}
	
	- (void) _amountButtonClicked
	{
		[self _resignFirstResponder];
		[my_observer SingleRecordViewController_amountButtonDidClick];
	}
		
	
	
	
	
	
	- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
	{
		if (alertView == my_cancelAlertView)
		{
			if (buttonIndex != alertView.cancelButtonIndex)
            {
				[my_observer SingleRecordViewController_cancel];
            }
		}
		else if (alertView == my_removeImageAlertView)
		{
			if (buttonIndex != alertView.cancelButtonIndex)
            {
				[self setThumbnail:UIImage_nuble()];
				[self setOriginal:UIImage_nuble()];
            }
		}
	}
	
	

	- (void)keyboardDidShow:(NSNotification*)notification
	{
		NSDictionary* info = [notification userInfo];
		CGSize keybroadSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
			
		UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, keybroadSize.height, 0);
		my_rootScrollView.contentInset = contentInsets;
		my_rootScrollView.scrollIndicatorInsets = contentInsets;	
		
		CGFloat offset = my_rootScrollView.contentSize.height + keybroadSize.height - my_rootScrollView.frame.size.height;
		[my_rootScrollView setContentOffset:CGPointMake(0, offset) animated:NO];
	}
	
	- (void)keyboardDidHide:(NSNotification*)notification
	{
		UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
		my_rootScrollView.contentInset = contentInsets;
		my_rootScrollView.scrollIndicatorInsets = contentInsets;		
	}
			
	


	- (void)textFieldDidBeginEditing:(UITextField *)textField
	{
		if (textField == my_dateTextField)
		{
			NubleDT2001 dateTime = DT2001_parse(STR(my_dateTextField.text));
			if (dateTime.hasVar)		
				my_datePicker.date = DT2001_toNSDate(dateTime.vd);
		}
		
		if (textField == my_timeTextField)
		{
			NubleDT2001 dateTime = DT2001_parse(String_concat(STR(@"2000-01-01 "), STR(my_timeTextField.text)));
			if (dateTime.hasVar)		
				my_timePicker.date = DT2001_toNSDate(dateTime.vd);
		}		
	}
		
	- (BOOL)textFieldShouldReturn:(UITextField *)textField
	{
		[textField resignFirstResponder];
		return YES;
	}	
	
	
	
	
@end






