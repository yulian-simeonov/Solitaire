//
//  JSFBManager.m
//  PhotoSauce
//
//  Created by ZhXingli on 1/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "JSFBManager.h"
#import "AppDelegate.h"

@implementation JSFBManager

-(id)init
{
    if (self = [super init])
    {
        m_message = nil;
        m_filePath = nil;
    }
    return self;
}

-(void)dealloc
{

}

- (void)UpdateMyInfo
{
    FBRequest *request =[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                  graphPath:@"me"
                                                 parameters:nil
                                                 HTTPMethod:nil];
    
	request.session = FBSession.activeSession;
	[request
	 startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         if (error)
         {
             if ([_delegate respondsToSelector:@selector(CompletedMyInfo:)])
                 [_delegate CompletedMyInfo:nil];
         }
         else
         {
             if ([_delegate respondsToSelector:@selector(CompletedMyInfo:)])
                 [_delegate CompletedMyInfo:(NSDictionary*)result];
         }
     }];
}

- (void)UpdateFriendsList
{
    FBRequest *request =[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                  graphPath:@"me/friends"
                                                 parameters:nil
                                                 HTTPMethod:@"GET"];
    
	request.session = FBSession.activeSession;
	[request
	 startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {

         if (error)
         {
             if ([_delegate respondsToSelector:@selector(CompletedMyFriends:)])
                 [_delegate CompletedMyFriends:nil];
         }
         else
         {
             NSDictionary* responseDictionary = (NSDictionary*)result;
             NSArray* friends = [responseDictionary objectForKey:@"data"];
             if ([_delegate respondsToSelector:@selector(CompletedMyFriends:)])
                 [_delegate CompletedMyFriends:friends];
         }
     }];
}

-(BOOL)CheckConnectedFB
{
    if (FBSession.activeSession.state == FBSessionStateOpen ||
        FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
        return true;
    else
        return false;
}

-(void)OpenSession
{
    // Initialize a session object
    FBSession *session = [[FBSession alloc] init];
    // Set the active session
    [FBSession setActiveSession:session];
    // Open the session
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
            if (status == FBSessionStateOpen)
            {
                if ([_delegate respondsToSelector:@selector(OpendSession:)])
                    [_delegate OpendSession:true];
            }
            else
            {
                if ([_delegate respondsToSelector:@selector(OpendSession:)])
                    [_delegate OpendSession:false];
            }
    }];
}

-(void)CloseSession
{
    [[FBSession activeSession] closeAndClearTokenInformation];
}

-(void)GetMyInfo
{
    if (![self CheckConnectedFB])
    {
        // Initialize a session object
        FBSession *session = [[FBSession alloc] init];
        // Set the active session
        [FBSession setActiveSession:session];
        // Open the session
        [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
                completionHandler:^(FBSession *session,
                                    FBSessionState status,
                                    NSError *error) {
                    if (status == FBSessionStateOpen)
                        [self UpdateMyInfo];
                }];
    }
    else
        [self UpdateMyInfo];
}

-(void)GetMyFriends
{
    if (![self CheckConnectedFB])
    {
        // Initialize a session object
        FBSession *session = [[FBSession alloc] init];
        // Set the active session
        [FBSession setActiveSession:session];
        // Open the session
        [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
                completionHandler:^(FBSession *session,
                                    FBSessionState status,
                                    NSError *error) {
                    if (status == FBSessionStateOpen)
                        [self UpdateFriendsList];
                }];
    }
    else
        [self UpdateFriendsList];
}

- (void)SubmitLink:(NSString*)message
{
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:APPLINK];
    params.name = @"4 cards solitaire";
    params.caption = @"4 cards solitaire";
    params.picture = nil;
    params.description = message;
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              [APP HandleError:error];
                                          } else {
                                              // Success
                                              [[[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Shared successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                          }
                                      }];
    } else {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"4 cards solitaire", @"name",
                                       message, @"caption",
                                       message, @"description",
                                       APPLINK, @"link",
                                       @"", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          [APP HandleError:error];
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  [[[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Shared successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
@end
