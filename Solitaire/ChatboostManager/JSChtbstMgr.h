//
//  JSChtbstMgr.h
//  MessageWiper
//
//  Created by ZhangBuSe on 6/19/13.
//
//

#import <Foundation/Foundation.h>
#import "Chartboost.h"

#define CHARTBOOST_APPID @"53274e0c9ddc35588c36251e"
#define CHARTBOOST_APPSIGN @"dd1e6286835c2115a367120043f0ae4f8e58d9f7"

@interface JSChtbstMgr : NSObject
+(void)Show;
+(void)Show:(NSString*)param;
+(void)ShowMoreApps;
+(void)ReleaseChartboost;
@end
