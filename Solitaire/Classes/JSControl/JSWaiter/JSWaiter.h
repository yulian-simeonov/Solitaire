//
//  JSWaiter.h
//  PhotoSauce
//
//  Created by ZhXingli on 1/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface JSWaiter : NSObject<MBProgressHUDDelegate>
{

}

+(void)ShowWaiter:(UIViewController*)parent title:(NSString*)text type:(int)typ;
+(void)ShowWaiter:(SEL)method parentViewController:(UIViewController*)parent title:(NSString*)text type:(int)typ withObject:(NSDictionary*)param;
+(void)ShowWaiter:(SEL)method parentViewController:(UIViewController*)parent title:(NSString*)text type:(int)typ;
+(void)HideWaiter;
@end
