//
//  WebManager.m
//  WebTest
//
//  Created by ZhiXing Li on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSWebManager.h"

@implementation JSWebManager
@synthesize delegate;

-(id)initWithAsyncOption:(BOOL)isAsync
{
    if (self = [super init])
    {
        m_jsonManager = [[JSONManager alloc] initWithAsyncOption:isAsync];
        [m_jsonManager setDelegate:self];
        m_url = @"http://appdeen.com/Solitaire/index.php";
        m_isAsync = isAsync;
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [m_jsonManager release];
}

-(void)CancelRequest
{
    [m_jsonManager RequestCancel];
}

-(void)JSONRequestFinished:(ASIHTTPRequest*)request
{
    if (delegate)
        [delegate ReceivedValue:request];
}

-(void)JSONRequestFailed:(NSError*)error
{
    if (delegate != nil)
    {
        [delegate WebManagerFailed:error];
    }
}

-(BOOL)PublishMyScore:(NSString*)userId score:(int)scr
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"PutHighScore", @"action",
                            userId, @"user_id",
                            [NSString stringWithFormat:@"%d", scr], @"score",
                            nil];
    ASIHTTPRequest* req = [m_jsonManager JSONRequest:m_url params:params requestMethod:POST];
    if (req)
        return true;
    else
        return false;
}

-(NSString*)GetFriendScore:(NSString*)friendId
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"GetFriendScore", @"action",
                            friendId, @"friend_id",
                            nil];
    ASIHTTPRequest* req = [m_jsonManager JSONRequest:m_url params:params requestMethod:GET];
    if (req)
        return req.responseString;
    else
        return nil;
}

-(void)fileDownload:(NSString*)link saveName:(NSString*)savePath
{
    [m_jsonManager DownloadFile:link SavePath:savePath];
}
@end
