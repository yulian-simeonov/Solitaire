//
//  JSFBManager.h
//  PhotoSauce
//
//  Created by ; on 1/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "JSWaiter.h"
#import "JSWebManager.h"

@protocol JSFBManagerDelegate <NSObject>
@optional
-(void)CompletedMyInfo:(NSDictionary*)myInfo;
-(void)CompletedMyFriends:(NSArray*)friends;
-(void)OpendSession:(BOOL)success;
@end

@interface JSFBManager : NSObject
{
    NSString*               m_filePath;
    NSString*               m_message;
}

@property (nonatomic, retain) id<JSFBManagerDelegate> delegate;
-(void)GetMyFriends;
-(void)GetMyInfo;
-(BOOL)CheckConnectedFB;
-(void)OpenSession;
-(void)CloseSession;
- (void)SubmitLink:(NSString*)message;
@end
