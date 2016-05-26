//
//  JSTwitterManager.h
//  PhotoSauce
//
//  Created by ZhXingli on 1/16/13.
//  Copyright (c) 2013 ZhXingli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>

@interface JSTwitterManager : NSObject
{
    TWTweetComposeViewController* m_twitter;
}
-(void)Upload:(NSString*)message FilePath:(NSString*)imgPath ParentViewController:(UIViewController*)parent;
@end
