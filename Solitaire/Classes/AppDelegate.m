//
//  AppDelegate.m
//  Solitaire
//
//  Created by richboy on 2/23/14.
//  Copyright Appdeen 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "MenuScreen.h"
#import "JSChtbstMgr.h"
#import "StateView.h"

@implementation AppDelegate

// 
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// This is the only app delegate method you need to implement when inheriting from CCAppDelegate.
	// This method is a good place to add one time setup code that only runs when your app is first launched.
	
	// Setup Cocos2D with reasonable defaults for everything.
	// There are a number of simple options you can change.
	// If you want more flexibility, you can configure Cocos2D yourself instead of calling setupCocos2dWithOptions:.
    [self ShowAd];
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"0"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"me" forKey:@"0"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    m_fbMgr = [[JSFBManager alloc] init];
    [m_fbMgr setDelegate:self];
    m_twMgr = [[JSTwitterManager alloc] init];
    [[JSStoreManager sharedManager] setDelegate:self];
    
    m_webMgr = [[JSWebManager alloc] initWithAsyncOption:NO];
    m_dbMgr = [[DBManager alloc] init];
    if ([m_fbMgr CheckConnectedFB])
        [self UpdateStates];
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"_hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"_ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"_ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
    [self LoadPVR];
    
	[self setupCocos2dWithOptions:@{
		// Show the FPS and draw call label.
//		CCSetupShowDebugStats: @(YES),
		
		// More examples of options you might want to fiddle with:
		// (See CCAppDelegate.h for more information)
		
		// Use a 16 bit color buffer: 
//		CCSetupPixelFormat: kEAGLColorFormatRGB565,
		// Use a simplified coordinate system that is shared across devices.
//		CCSetupScreenMode: CCScreenModeFixed,
		// Run in portrait mode.
		CCSetupScreenOrientation: CCScreenOrientationPortrait,
		// Run at a reduced framerate.
//		CCSetupAnimationInterval: @(1.0/30.0),
		// Run the fixed timestep extra fast.
//		CCSetupFixedUpdateInterval: @(1.0/180.0),
		// Make iPad's act like they run at a 2x content scale. (iPad retina 4x)
//		CCSetupTabletScale2X: @(YES),
	}];
	
    [self PreloadSound];
    
    if (![self IsPaid])
    {
        bannerView_ = [[GADBannerView alloc] init];
        [self SetBannerViewTopPosition];
        bannerView_.adUnitID = @"a153277a8e9a23f";
        bannerView_.delegate = self;
        [bannerView_ setRootViewController:[CCDirector sharedDirector]];
        [[CCDirector sharedDirector].view addSubview:bannerView_];
        [bannerView_ loadRequest:[self createRequest]];
    }
	return YES;
}

-(void)SetBannerViewBottomPosition
{
    if ([self IsPaid])
        return;
    if (IS_IPHONE_5)
        bannerView_.frame = CGRectMake(0, 518, 320, 50);
    else if (IS_iPAD)
        bannerView_.frame = CGRectMake(0, 924, 768, 100);
    else
        bannerView_.frame = CGRectMake(0, 430, 320, 50);
}

-(void)SetBannerViewTopPosition
{
    if ([self IsPaid])
        return;
    if (IS_IPHONE_5)
        bannerView_.frame = CGRectMake(0, 0, 320, 50);
    else if (IS_iPAD)
        bannerView_.frame = CGRectMake(0, 0, 768, 100);
    else
        bannerView_.frame = CGRectMake(0, 0, 320, 50);
}

-(void)ShowAd
{
    if (![self IsPaid])
    {
        [JSChtbstMgr Show];
    }
    else
    {
        if (bannerView_)
        {
            [bannerView_ removeFromSuperview];
            bannerView_ = nil;
        }
    }
}

-(CCScene *)startScene
{
	// This method should return the very first scene to be run when your app starts.
	return [MenuScreen scene];
}

-(void)LoadPVR
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"game_play.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"main_menu.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"particle.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"help_screen.plist"];
    if (IS_iPAD)
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"background.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu_background.plist"];
    }
}

-(void)PreloadSound
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sound"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sound"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"sound"])
            [[OALSimpleAudio sharedInstance] setEffectsMuted:NO];
        else
            [[OALSimpleAudio sharedInstance] setEffectsMuted:YES];
    }
    [[OALSimpleAudio sharedInstance] preloadEffect:@"congratulation.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"btn_click.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"card_out.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"put_empty_slot.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"spread_card.wav"];
}

-(void)PlayEffect:(NSString*)sound
{
    [[OALSimpleAudio sharedInstance] playEffect:sound];
}

-(void)UpdateStates
{
    NSString* filePath = [NSString stringWithFormat:@"%@/0.png", [JSONManager GetSavePath:@"fb_thumb"]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO])
    {
        [m_webMgr fileDownload:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [[NSUserDefaults standardUserDefaults] objectForKey:@"fb_id"]] saveName:filePath];
    }
    NSString* val = [m_webMgr GetFriendScore:[[NSUserDefaults standardUserDefaults] objectForKey:@"fb_id"]];
    if (val.length > 0 )
    {
        if([val intValue] > [m_dbMgr GetScoreByUserId:@"0"])
            [m_dbMgr UpdateScore:@"0" score:[val intValue]];
        else if ([val intValue] < [m_dbMgr GetScoreByUserId:@"0"])
            [m_webMgr PublishMyScore:[[NSUserDefaults standardUserDefaults] objectForKey:@"fb_id"] score:[m_dbMgr GetScoreByUserId:@"0"]];
    }
    
    [m_fbMgr GetMyFriends];
}

-(void)CompletedMyFriends:(NSArray*)friends
{
    m_friends = friends;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for(NSDictionary* friendInfo in m_friends)
        {
            NSString* val = [m_webMgr GetFriendScore:[friendInfo objectForKey:@"id"]];
            if (val.length > 0)
            {
                NSLog(@"%@, %@", [friendInfo objectForKey:@"id"], [friendInfo objectForKey:@"name"]);
                NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", [JSONManager GetSavePath:@"fb_thumb"], [friendInfo objectForKey:@"id"]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO])
                {
                    [m_webMgr fileDownload:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [friendInfo objectForKey:@"id"]] saveName:filePath];
                }
                [m_dbMgr UpdateScore:[friendInfo objectForKey:@"id"] score:[val intValue]];
                [[NSUserDefaults standardUserDefaults] setObject:[friendInfo objectForKey:@"name"] forKey:[friendInfo objectForKey:@"id"]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    });
}

- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
//    request.testDevices =  @[GAD_SIMULATOR_ID];
    return request;
}

-(void)AddQAView:(MenuScreen*)mnuScreen
{
    NSString* strNibName = nil;
    if (IS_iPAD)
        strNibName = @"StateView_ipad";
    else
        strNibName = @"StateView";
    StateView* vw = [[[NSBundle mainBundle] loadNibNamed:strNibName owner:self options:nil] objectAtIndex:0];
    [vw InitControls:mnuScreen];
    float width, height;
    if (IS_iPAD)
    {
        width = 768;
        height = 1024;
    }
    else if(IS_IPHONE_5)
    {
        width = 320;
        height = 568;
    }
    else
    {
        width = 320;
        height = 480;
    }
    [vw setFrame:CGRectMake(width / 2 - vw.frame.size.width / 2, height / 2 - vw.frame.size.height / 2, vw.frame.size.width, vw.frame.size.height)];
    
    [[CCDirector sharedDirector].view addSubview:vw];
    [[CCDirector sharedDirector].view bringSubviewToFront:vw];
}

#pragma mark GADBannerViewDelegate impl

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

-(BOOL)IsPaid
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:ProductID])
        return true;
    else
        return false;
}

-(void)ShowActionsheet
{
    UIActionSheet *popup = nil;
    if([self IsPaid])
    {
        popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                 @"Share on Facebook",
                 @"Share on Twitter",
                 @"Tell a Friend",
                 @"Rate this App",
                 nil];
    }
    else
    {
        popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                 @"Share on Facebook",
                 @"Share on Twitter",
                 @"Tell a Friend",
                 @"Rate this App",
                 @"Pro version",
                 @"Restore",
                 nil];
    }
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [m_fbMgr SubmitLink:@"This is so interesting and funny card game."];
            break;
        case 1:
            [self SubmitMessageToTwitter:[NSString stringWithFormat:@"This is so interesting and funny card game. \n %@", APPLINK]];
            break;
        case 2:
            [self SendEmail];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPLINK]];
            break;
        case 4:
            if ([self IsPaid])
                 return;
            [JSWaiter ShowWaiter:self.window.rootViewController title:@"Upgrade..." type:0];
            [[JSStoreManager sharedManager] Buy];
            break;
        case 5:
            [JSWaiter ShowWaiter:self.window.rootViewController title:@"Upgrade..." type:0];
            [[JSStoreManager sharedManager] Restore];
            break;
        default:
            break;
    }
}

-(void)SubmitMessageToTwitter:(NSString*)msg
{
    [m_twMgr Upload:msg FilePath:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"] ParentViewController:self.window.rootViewController];
}

-(void)Failed:(NSString*)errMsg
{
    [JSWaiter HideWaiter];
    [[[UIAlertView alloc] initWithTitle:@"Error" message:errMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(void)Successed
{
    [JSWaiter HideWaiter];
    [[[UIAlertView alloc] initWithTitle:nil message:@"Successfully purchased." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(void)SendEmail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Brazil 2014"];
        [mailer addAttachmentData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]] mimeType:@"image/jpeg" fileName:@"logo.png"];
        [mailer setMessageBody:[NSString stringWithFormat:@"Hello, This is so interesting and funny card game. \n Here is the link of the app. \n %@", APPLINK] isHTML:YES];
        [self.window.rootViewController presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the Drafts folder");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
			break;
		default:
			NSLog(@"Mail not sent");
			break;
	}
    
	[self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Parse the incoming URL to look for a target_url parameter
                                      NSString *query = [url fragment];
                                      if (!query) {
                                          query = [url query];
                                      }
                                      NSDictionary *params = [self parseURLParams:query];
                                      // Check if target URL exists
                                      NSString *targetURLString = [params valueForKey:@"target_url"];
                                      if (targetURLString) {
                                          // Show the incoming link in an alert
                                          // Your code to direct the user to the appropriate flow within your app goes here
                                          [[[UIAlertView alloc] initWithTitle:@"Received link:"
                                                                      message:targetURLString
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil] show];
                                      }
                                  }];
    
    return urlWasHandled;
}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

-(void)HandleError:(NSError*)error
{
    NSString *alertText;
    NSString *alertTitle;
    
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
        // Error requires people using you app to make an action outside your app to recover
        alertTitle = @"Something went wrong";
        alertText = [FBErrorUtility userMessageForError:error];
        [self showMessage:alertText withTitle:alertTitle];
        
    } else {
        // You need to find more information to handle the error within your app
        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
            //The user refused to log in into your app, either ignore or...
            alertTitle = @"Login cancelled";
            alertText = @"You need to login to access this part of the app";
            [self showMessage:alertText withTitle:alertTitle];
            
        } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
            // We need to handle session closures that happen outside of the app
            alertTitle = @"Session Error";
            alertText = @"Your current session is no longer valid. Please log in again.";
            [self showMessage:alertText withTitle:alertTitle];
            
        } else {
            // All other errors that can happen need retries
            // Show the user a generic error message
            alertTitle = @"Something went wrong";
            alertText = @"Please retry";
            [self showMessage:alertText withTitle:alertTitle];
        }
    }
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}
@end
