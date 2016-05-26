//
//  JSWaiter.m
//  PhotoSauce
//
//  Created by ZhXingli on 1/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "JSWaiter.h"
static BOOL waiting;

@implementation JSWaiter

+(void)ShowWaiter:(UIViewController*)parent title:(NSString*)text type:(int)typ
{
    JSWaiter* js = [[JSWaiter alloc] init];
    MBProgressHUD* m_hud = [[MBProgressHUD alloc] initWithView:parent.view];
    [m_hud setDelegate:js];
    m_hud.labelText = text;
    m_hud.dimBackground = YES;
    waiting = true;
    [parent.view addSubview:m_hud];
    [m_hud showWhileExecuting:@selector(Waiting) onTarget:js withObject:nil animated:YES];
}

+(void)ShowWaiter:(SEL)method parentViewController:(UIViewController*)parent title:(NSString*)text type:(int)typ withObject:(NSDictionary*)param
{
    JSWaiter* js = [[JSWaiter alloc] init];
    MBProgressHUD* m_hud = [[MBProgressHUD alloc] initWithView:parent.view];
    [m_hud setDelegate:js];
    m_hud.labelText = text;
    m_hud.dimBackground = YES;
    [parent.view addSubview:m_hud];
    [m_hud showWhileExecuting:method onTarget:parent withObject:param animated:YES];
}

+(void)ShowWaiter:(SEL)method parentViewController:(UIViewController*)parent title:(NSString*)text type:(int)typ
{
    JSWaiter* js = [[JSWaiter alloc] init];
    MBProgressHUD* m_hud = [[MBProgressHUD alloc] initWithView:parent.view];
    [m_hud setDelegate:js];
    m_hud.labelText = text;
    m_hud.dimBackground = YES;
    [parent.view addSubview:m_hud];
    [m_hud showWhileExecuting:method onTarget:parent withObject:nil animated:YES];
}

+(void)HideWaiter
{
    waiting = false;
}

-(void)Waiting
{
    while(waiting)
    {
        sleep(0.3f);
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
}
@end
