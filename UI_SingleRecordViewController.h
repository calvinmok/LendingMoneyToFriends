



#import <Foundation/Foundation.h>


#import "Person.h"




@protocol SingleRecordViewController_Observer_

	- (NubleUIImage) SingleRecordViewController_readOriginal :(Record*)record;
	- (NubleUIImage) SingleRecordViewController_readThumbnail :(Record*)record;
	
	
	- (void) SingleRecordViewController_cancel; 
	
	- (void) SingleRecordViewController_submitted 
        :(NubleRecord)oldRecord 
        :(Bool)imageChanged :(NubleUIImage)original :(NubleUIImage)thumbnail
        :(String*)name :(Double)amount :(DT2001)dateTime;
	
	- (void) SingleRecordViewController_imageTapped;
	
	- (void) SingleRecordViewController_nameButtonDidClick;
	- (void) SingleRecordViewController_amountButtonDidClick;
	
@end

typedef NSObject<SingleRecordViewController_Observer_> SingleRecordViewController_Observer;







@interface SingleRecordViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
	{
	@public
		SingleRecordViewController_Observer* my_observer;
		
		NubleRecord my_record;
		NubleUIImage my_my_original;
		NubleUIImage my_my_thumbnail;
        
		
		Bool my_imageChanged;

		
		UIFont* my_font;
	
		UIScrollView* my_rootScrollView;

		UIImage* my_defaultPhotoImage;
		UIImageView* my_imageView;
		
		UIImage* my_deleteImage;
		UIButton* my_deleteImageButton;

	
		UILabel* my_nameLabel;
		UITextField* my_nameTextField;
		UIButton* my_nameButton;
		
		UILabel* my_amountLabel;
		UITextField* my_amountTextField;
		UIButton* my_amountButton;
		
		UILabel* my_dateTimeLabel;
		UIDatePicker* my_datePicker;
		UIDatePicker* my_timePicker;
		UITextField* my_dateTextField;
		UITextField* my_timeTextField;
		
		UIAlertView* my_cancelAlertView;
		UIAlertView* my_removeImageAlertView;
				
		
	}
	
	
	+ (UIImage*) createDefaultPhotoImage;
	
	- (UILabel*) _createLabel :(NSString*)text;
	- (UITextField*) _createStringTextField :(UIKeyboardType)keyboardType;
	- (UIButton*) _createCacheButton :(SEL)action;
	- (UITextField*) _createDateTimeTextField :(UIDatePicker*)datePicker;
	- (UIDatePicker*) _createDatePicker :(UIDatePickerMode)mode :(SEL)action;
	
	- (void) _setupUIView;
	

	+ (SingleRecordViewController*) create:(SingleRecordViewController_Observer*)observer;
	- (void) _creating:(SingleRecordViewController_Observer*)observer;
	
	

	
	
	- (Bool) _resignFirstResponder;
	
	
	@property(readonly) NubleRecord record;
	- (void) setRecord:(NubleRecord)value;

	- (void) setThumbnail :(NubleUIImage)thumbnail;
    @property(readonly) NubleUIImage thumbnail;
    
    - (void) setOriginal :(NubleUIImage)original;
    @property(readonly) NubleUIImage original;
    
	- (void) setName:(String*)name;
	- (void) setAmount:(Double)amount;

	
	
	- (void) _cancel;
	- (void) _done;
	
	- (void) _imageTapped;
	- (void) _deleteImageButtonTapped;
	
	- (void) _datePickerChanged:(id)sender;
	- (void) _nameButtonClicked;
	- (void) _amountButtonClicked;
	
	- (void)keyboardDidShow:(NSNotification*)notification;
	- (void)keyboardDidHide:(NSNotification*)notification;
	


@end

















