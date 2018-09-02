





#import "UI_Window.h"


@implementation Window


	- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
	{
		if (motion == UIEventSubtypeMotionShake)
		{			
			if (my_observer.hasVar)
				[my_observer.vd Window_shake];
		}		
	}

	
	- (void) setObserver :(WindowObserver*)observer
	{
		my_observer = WindowObserver_toNuble(observer);
	}
		

@end
