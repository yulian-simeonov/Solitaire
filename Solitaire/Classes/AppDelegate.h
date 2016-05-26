//
//  AppDelegate.h
//  Solitaire
//
//  Created by richboy on 2/23/14.
//  Copyright Appdeen 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "cocos2d.h"
#import "JSWebManager.h"
#import "JSFBManager.h"
#import "DBManager.h"
#import "OALSimpleAudio.h"
#import "JSStoreManager.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "JSTwitterManager.h"
#import <MessageUI/MessageUI.h>

@class MenuScreen;

@interface AppDelegate : CCAppDelegate<JSFBManagerDelegate, GADBannerViewDelegate, UIActionSheetDelegate, JSStoreManagerDelegate, MFMailComposeViewControllerDelegate>
{
    JSFBManager* m_fbMgr;
    JSTwitterManager* m_twMgr;
    JSWebManager* m_webMgr;
    DBManager*      m_dbMgr;
    GADBannerView *bannerView_;
@public
    NSArray*    m_friends;
}
-(void)ShowActionsheet;
-(void)UpdateStates;
-(void)PlayEffect:(NSString*)sound;
-(void)HandleError:(NSError*)error;
-(void)SetBannerViewBottomPosition;
-(void)SetBannerViewTopPosition;
-(void)ShowAd;
-(void)AddQAView:(MenuScreen*)mnuScreen;
@end

