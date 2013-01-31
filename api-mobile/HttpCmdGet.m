//
//  HttpCmdGet.m
//  Gaopeng
//
//  Created by admin Admin on 11-10-14.
//  Copyright 2011年 GP. All rights reserved.
//

#import "HttpCmdGet.h"

#import "common.h"

@implementation HttpCmdGet

@synthesize requestUri, responseFilePath;

- (id)init
{
    self = [super init];
    if (self) {
        self.requestUri = @"";
    }
    
    return self;
}

- (void) dealloc {
    
    [requestUri release];
    [responseFilePath release];
    
	[super dealloc];
}

/**
 *   ASIHttp callback success
 **/
- (void)requestFinished:(ASIHTTPRequest *)request
{      
    // call delegate
    [self.delegate apiNotifyResult:self error:nil];
}

/**
 *  ASIHttp callback fail
 **/
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    if (nil != error && [[NSFileManager defaultManager] fileExistsAtPath:[self getCacheFilePath]]) {
        self.isFromCache = YES;
    }
    
    // call delegate
    [self.delegate apiNotifyResult:self error:error];
}


// you should never call this method
- (NSMutableDictionary*) getParamDict {
    return nil;
}

- (NSString*) getCacheFilePath {
    return getTmpDownloadFilePath(self.requestUri);
}

@end
