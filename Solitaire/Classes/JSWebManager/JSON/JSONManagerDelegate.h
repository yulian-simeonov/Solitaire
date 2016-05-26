//
//  JSONManagerDelegate.h
//  WebTest
//
//  Created by ZhiXing Li on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ASIHTTPRequest.h"
@protocol JSONManagerDelegate <NSObject>

@optional
-(void)JSONRequestFinished:(ASIHTTPRequest*)request;
-(void)JSONRequestFailed:(ASIHTTPRequest*)request;
@end
