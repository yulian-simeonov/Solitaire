//
//  JSChtbstMgr.m
//  MessageWiper
//
//  Created by ZhangBuSe on 6/19/13.
//
//

#import "JSChtbstMgr.h"

@implementation JSChtbstMgr

static JSChtbstMgr* delegate;
+(void)Show
{
    Chartboost *cb = [Chartboost sharedChartboost];
    if (!delegate)
        delegate = [[JSChtbstMgr alloc] init];
    
    cb.delegate = (id)delegate;
    if (cb.appId == nil)
    {
        cb.appId = CHARTBOOST_APPID;
        cb.appSignature = CHARTBOOST_APPSIGN;
        
        // Begin a user session
        [cb startSession];
    }
    // Show an interstitial
    [cb showInterstitial];
}

+(void)Show:(NSString*)param
{
    Chartboost *cb = [Chartboost sharedChartboost];
    JSChtbstMgr* delegate = [[JSChtbstMgr alloc] init];
    if (!delegate)
        delegate = [[JSChtbstMgr alloc] init];
    cb.delegate = (id)delegate;
    if (cb.appId == nil)
    {
        cb.appId = CHARTBOOST_APPID;
        cb.appSignature = CHARTBOOST_APPSIGN;
        
        // Begin a user session
        [cb startSession];
    }
    // Show an interstitial
    [cb showInterstitial:param];
}

+(void)ShowMoreApps
{
    Chartboost *cb = [Chartboost sharedChartboost];
    JSChtbstMgr* delegate = [[JSChtbstMgr alloc] init];
    if (!delegate)
        delegate = [[JSChtbstMgr alloc] init];
    cb.delegate = (id)delegate;
    if (cb.appId == nil)
    {
        cb.appId = CHARTBOOST_APPID;
        cb.appSignature = CHARTBOOST_APPSIGN;
        
        // Begin a user session
        [cb startSession];
    }
    // Show an interstitial
    [cb showMoreApps];
}

+(void)ReleaseChartboost
{
    if (delegate)
        [delegate release];
}
// Same as above, but only called when dismissed for a close
- (void)didCloseInterstitial:(NSString *)location
{

}

// Same as above, but only called when dismissed for a click
- (void)didClickInterstitial:(NSString *)location
{

}

// Called when the More Apps page has been received and cached
- (void)didCacheMoreApps
{

}

// Same as above, but only called when dismissed for a close
- (void)didCloseMoreApps
{
    
}

// Same as above, but only called when dismissed for a click
- (void)didClickMoreApps
{

}


- (void)didCacheInterstitial:(NSString *)location {
    NSLog(@"interstitial cached at ocation %@", location);
}

- (BOOL)shouldDisplayInterstitial:(NSString *)location {
    NSLog(@"about to display interstitial at location %@", location);
    return YES;
}

- (void)didFailToLoadInterstitial:(NSString *)location {
    NSLog(@"failure to load interstitial at location %@", location);
//    
//        [NSTimer scheduledTimerWithTimeInterval:1.0
//                                         target:self
//                                       selector:@selector(showCBAd)
//                                       userInfo:nil
//                                        repeats:NO];
    
}

- (void)didFailToLoadMoreApps {
    NSLog(@"failure to load more apps");
}

- (void)didDismissInterstitial:(NSString *)location {
    NSLog(@"dismissed interstitial at location %@", location);
    [[Chartboost sharedChartboost] cacheInterstitial:location];
    
    if([location isEqual: @"gameOver"]){
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(showCBAd)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void)didDismissMoreApps {
    NSLog(@"dismissed more apps page, re-caching now");
    [[Chartboost sharedChartboost] cacheMoreApps];
}

- (void)showCBAd{
    [[Chartboost sharedChartboost] showInterstitial];
}
@end
