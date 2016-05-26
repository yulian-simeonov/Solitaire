//
//  WebManager.h
//  WebTest
//
//  Created by ZhiXing Li on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONManager.h"

@protocol JSWebManagerDelegate <NSObject>
@required
-(void)WebManagerFailed:(NSError*)error;
-(void)ReceivedValue:(ASIHTTPRequest*)req;
@end

@interface JSWebManager : NSObject
{
    id<JSWebManagerDelegate> delegate;
@public
    JSONManager* m_jsonManager;
    NSString* m_url;
    BOOL                m_isAsync;
}

@property (nonatomic, retain) id   delegate;

-(id)initWithAsyncOption:(BOOL)isAsync;
-(void)CancelRequest;
-(BOOL)PublishMyScore:(NSString*)userId score:(int)scr;
-(NSString*)GetFriendScore:(NSString*)friendId;
-(void)fileDownload:(NSString*)link saveName:(NSString*)savePath;
@end
