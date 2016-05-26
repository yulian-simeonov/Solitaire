//
//  JSTwitterManager.m
//  PhotoSauce
//
//  Created by ZhXingli on 1/16/13.
//  Copyright (c) 2013 ZhXingli. All rights reserved.
//

#import "JSTwitterManager.h"

@implementation JSTwitterManager

-(id)init
{
    if(self = [super init])
    {
        m_twitter = [[TWTweetComposeViewController alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [m_twitter release];
    [super dealloc];
}

-(void)Upload:(NSString*)message FilePath:(NSString*)imgPath ParentViewController:(UIViewController*)parent
{
    [m_twitter setInitialText:message];
    if (imgPath)
        [m_twitter addImage:[UIImage imageWithContentsOfFile:imgPath]];
    
    [parent presentViewController:m_twitter animated:YES completion:NULL];
    
    m_twitter.completionHandler = ^(TWTweetComposeViewControllerResult res)
    {
        if(res == TWTweetComposeViewControllerResultDone)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"The Tweet was posted successfully." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        else if(res == TWTweetComposeViewControllerResultCancelled)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cancelled" message:@"You Cancelled posting the Tweet." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        [m_twitter dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)finishedSharing:(BOOL)shared {
    NSString* message = nil;
    if (shared)
        message = @"Shared Successfully!";
    else
        message = @"Failed Sharing!";
    
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:NULL message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] autorelease];
    [alertView show];
    [alertView release];
}
@end
