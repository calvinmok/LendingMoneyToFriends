




#import <Foundation/Foundation.h>

#import "Person.h"



@protocol WindowObserver_

	- (void) Window_shake;
	
@end

typedef NSObject<WindowObserver_> WindowObserver;

NUBLE_OBJECT_TEMPLATE(WindowObserver)


@interface Window : UIWindow
	{
		NubleWindowObserver my_observer;
		
	}
	
	
	- (void) setObserver :(WindowObserver*)observer;
	

@end
