//
//  JSONManager.h
//  WrightHub
//
//  Created by ZhiXing Li on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONManagerDelegate.h"

enum RequestMethod
{
    GET, PUT, POST, DELETE
};

@interface JSONManager : NSObject<ASIHTTPRequestDelegate, ASIProgressDelegate>
{
    id<JSONManagerDelegate> delegate;
    NSMutableArray* m_postReq;
@public
    BOOL            m_isAsync;
}

@property (nonatomic, retain) id   delegate;
-(id)initWithAsyncOption:(BOOL)isAsync;
-(ASIHTTPRequest*)JSONRequest:(NSString*)strUrl params:(NSDictionary*)requestData requestMethod:(enum RequestMethod)method;
-(NSError*)UploadFile:(NSString*)url FilePath:(NSString*)filePath FileName:(NSString*)fileName;
-(NSError*)DownloadFile:(NSString*)url SavePath:(NSString*)path;
-(void)RequestCancel;
+(NSString*)GetSavePath:(NSString*)dirName;
+(NSString*)GetUUID;
@end
