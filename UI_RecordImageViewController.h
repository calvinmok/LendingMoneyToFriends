



#import <Foundation/Foundation.h>


#import "Person.h"




@protocol RecordImageViewController_Observer_

	- (void) RecordImageViewController_edit;
	- (void) RecordImageViewController_cancel;
	
@end

typedef NSObject<RecordImageViewController_Observer_> RecordImageViewController_Observer;




@interface RecordImageViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
	{
		RecordImageViewController_Observer* my_observer;
		
		UIImageView* my_imageView;
	}

	
	
	+ (RecordImageViewController*) create:(RecordImageViewController_Observer*)observer;
	- (void) _creating:(RecordImageViewController_Observer*)observer;
	
	
	
	- (void) _edit;
	- (void) _cancel;
	

	
	- (void) setImage:(UIImage*)image; 

@end







