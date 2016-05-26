//
//  JSONManager.m
//  WrightHub
//
//  Created by ZhiXing Li on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONManager.h"

@implementation JSONManager
@synthesize delegate;

-(id)initWithAsyncOption:(BOOL)isAsync
{
    if (self = [super init])
    {
        m_postReq = [[NSMutableArray alloc] init];
        m_isAsync = isAsync;
    }
    return self;
}

-(void)dealloc
{
    for (int i = 0; i < m_postReq.count; i++)
        [[m_postReq objectAtIndex:i] release];
    [m_postReq removeAllObjects];
    [m_postReq release];
    [super dealloc];
}

-(ASIHTTPRequest*)JSONRequest:(NSString*)strUrl params:(NSDictionary*)requestData requestMethod:(enum RequestMethod)method
{
    switch (method) {
        case POST:
        {
            NSURL* url = [NSURL URLWithString:strUrl];
            ASIFormDataRequest* postReq = [ASIFormDataRequest requestWithURL:url];
            if (requestData)
            {
                for(NSString* key in [requestData allKeys])
                {
                    [postReq setPostValue:[requestData valueForKey:key] forKey:key];
                }
            }
            if (m_isAsync)
            {
                [postReq setDelegate:self];
                [postReq setDidFailSelector:@selector(requestFailed:)];
                [postReq setDidFinishSelector:@selector(requestFinished:)];
                [postReq startAsynchronous];
            }
            else {
                [postReq startSynchronous];
                NSError* err = [postReq error];
                if (!err)
                {
                    return (ASIHTTPRequest*)postReq;
                }
            }
            break;
        } 
        case GET:
        {
            BOOL hasParam = false;
            NSMutableString* getUrl = [NSMutableString stringWithString:strUrl];
            if (requestData)
            {
                [getUrl appendString:@"?"];
                for(NSString* key in [requestData allKeys])
                {
                    hasParam = true;
                    [getUrl appendFormat:@"%@=%@&", key, [requestData valueForKey:key]];
                }
            }
            if (hasParam)
            {
                NSRange r;
                r.location = 0;
                r.length = [getUrl length] - 1;
                [getUrl substringWithRange:r];
            }
            
            NSURL* url = [NSURL URLWithString:getUrl];
            ASIHTTPRequest* getReq = [ASIHTTPRequest requestWithURL:url];
            
            if (m_isAsync)
            {
                [getReq setDelegate:self];
                [getReq setDidFailSelector:@selector(requestFailed:)];
                [getReq setDidFinishSelector:@selector(requestFinished:)];
                [getReq startAsynchronous];
            }
            else {
                [getReq startSynchronous];
                NSError* err = [getReq error];
                if (!err)
                {
                    return (ASIHTTPRequest*)getReq;
                }
            }
            break;
        }
        default:
            break;
    }
    return nil;
}

-(NSError*)UploadFile:(NSString*)url FilePath:(NSString*)filePath FileName:(NSString*)fileName
{
    ASIFormDataRequest *postReq = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [postReq setTimeOutSeconds:600];
    [postReq setPostValue:[NSString stringWithFormat:@"%@.png", fileName] forKey:@"filename"];
    [postReq setFile:filePath forKey:@"upload"];
    
    if (m_isAsync)
    {
        [postReq setDelegate:self];
        [postReq setDidFailSelector:@selector(requestFailed:)];
        [postReq setDidFinishSelector:@selector(requestFinished:)];
        [postReq startAsynchronous];
        return nil;
    }
    else
    {
        [postReq startSynchronous];
        return [postReq error];
    }
}

-(NSError*)DownloadFile:(NSString*)url SavePath:(NSString*)path
{
    ASIHTTPRequest *postReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [postReq setTimeOutSeconds:600];
    [postReq setDownloadDestinationPath:path];
    
    [m_postReq addObject:[postReq retain]];
    if (m_isAsync)
    {
        [postReq setDelegate:self];
        [postReq setDidFailSelector:@selector(requestFailed:)];
        [postReq setDidFinishSelector:@selector(requestFinished:)];
        [postReq startAsynchronous];
        return nil;
    }
    else
    {
        [postReq startSynchronous];
        return [postReq error];
    }
}

-(void)DownloadFileByProgress:(NSString*)url FileName:(NSString*)fileName
{
    ASIHTTPRequest *postReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [postReq setDownloadProgressDelegate:self];
    
    [postReq setTimeOutSeconds:600];
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
	NSString *savePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    [postReq setDownloadDestinationPath:savePath];
    
    [postReq setDelegate:self];
    [postReq setDidFailSelector:@selector(requestFailed:)];
    [postReq setDidFinishSelector:@selector(requestFinished:)];
    
    [m_postReq addObject:[postReq retain]];
    
    [postReq startAsynchronous];
}

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    
}


- (void)requestFinished:(ASIHTTPRequest *)request 
{
    if (delegate != nil)
    {
        [delegate JSONRequestFinished:request];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (delegate != nil)
        [delegate JSONRequestFailed:request];
}

-(void)RequestCancel
{
    for (int i = 0; i < m_postReq.count; i++)
    {
        ASIHTTPRequest* req = (ASIHTTPRequest*)[m_postReq objectAtIndex:i];
        [req clearDelegatesAndCancel];
        [req release];
    }
    [m_postReq removeAllObjects];
}

+(NSString*)GetSavePath:(NSString*)dirName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString* path = [basePath stringByAppendingPathComponent:dirName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:path])
    {
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
	}
    return path;
}

+(NSString*)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString*)string autorelease];
}
@end
