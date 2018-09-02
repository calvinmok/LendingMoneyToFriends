



#import "UI_RecordImageViewController.h"


@implementation RecordImageViewController




	+ (RecordImageViewController*) create:(RecordImageViewController_Observer*)observer
	{
		RecordImageViewController* result = [[[RecordImageViewController alloc] init] autorelease];
		[result _creating :observer];
		return result;		
	}
	
	- (void) _creating:(RecordImageViewController_Observer*)observer
	{
		self.title = @"Image";
		
		my_observer = observer;
		
		my_imageView = [[UIImageView alloc] init];
		my_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		my_imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_cancel)] 
			autorelease];

		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(_edit)] 
			autorelease];
	}
	
	- (void) dealloc
	{
		[my_imageView release];
		[super dealloc];
	}
	
	- (void) loadView
	{
		self.view = my_imageView;
	}
	
			
	
	- (void) _edit
	{
        my_imageView.image = nil;
		[my_observer RecordImageViewController_edit];
	}
	
    - (void) _cancel
    {
        my_imageView.image = nil;
        [my_observer RecordImageViewController_cancel];
    }
		

	- (void) setImage:(UIImage*)image
	{
		my_imageView.image = image;
	}
	
	
@end










