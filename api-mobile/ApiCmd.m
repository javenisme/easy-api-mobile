//
//  ApiCmd.m
//  Gaopeng
//
//  Created by Javen Yang on 11-10-11.
//  Copyright 2011年 GP. All rights reserved.
//

#import "JSON.h"

#import "common.h"
#import "ApiConfig.h"
#import "ApiLogger.h"
#import "ApiFault.h"

#import "ApiCmd.h"


@implementation ApiCmd

@synthesize isFromCache, apiClient, delegate;
@synthesize dict;
@synthesize userData, resultData, errorArray, warnArray;
@synthesize uuid;

- (void) dealloc {
	[apiClient release];
    [delegate release];
	[userData release];
    [resultData release];
    [dict release];
    [errorArray release];
	
	[super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.apiClient = nil;
        self.delegate = nil;
        self.userData = nil;
        self.dict = nil;
        self.errorArray = nil;
        self.isFromCache = NO;
        self.uuid = [UIDevice currentDevice].uniqueIdentifier;
    }
    
    return self;
}

- (BOOL) hasError {
    if (nil == errorArray) {
        return NO;
    }
    
    return [errorArray count] > 0;
}

- (BOOL) hasWarn {
    if (nil == warnArray) {
        return NO;
    }
    
    return [warnArray count] > 0;
}

- (void) parseJson:(NSData*) data{
    
    if (nil == data) {
        return;
    }
    
    self.dict = nil;
    
    NSString* jsonString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    if (nil == jsonString) {
        apiLogError(@"can not parse NSData to string");
        return;
    }
    
    if ([ApiConfig getApiMessageDebug]) {
        apiLogInfo(@"****Return Json String:\n%@", jsonString);
    }
    
    // parse hudong json data
    NSPredicate * p = [NSPredicate predicateWithFormat:@"SELF like[c] %@",@"json(*)"];
    BOOL jsonBoo = [p evaluateWithObject:jsonString];
    if (jsonBoo) {
        // hudong json format
        NSRange range;
        range.location = 5;
        range.length = jsonString.length - 6;
        NSString * string = [jsonString substringWithRange:range];
        jsonString = string;
    }
    
    NSDictionary* tmpDict = [jsonString JSONValue];
    if (nil == tmpDict) {
        apiLogError(@"can not parse json string to NSDictionary");
    }
    
    // set the dict value
    self.dict = tmpDict;
}

- (void) parseApiError:(NSDictionary*) dictionary {
 
    apiLogDebug(@"dictionary %@",dictionary);
//        {"err_code":10006,"err_msg":"userid FIELD REQUIRED"}
    
    // reset the old state
    self.errorArray = nil;
    
    NSString * errorCode = nil;
    
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        errorCode = defaultNilObject([dictionary objectForKey:@"error_code"]);
    }else {
        errorCode = nil;
        return ;
    }

    if (nil == errorCode) {
        // no error
        return;
    }
    
    NSMutableArray* apiFaultArray = [[[NSMutableArray alloc] init] autorelease];
    self.errorArray =  apiFaultArray;

    ApiFault* fault = [[[ApiFault alloc] init] autorelease];
    [fault parseDict:dictionary];
    [apiFaultArray addObject:fault];
    
    
    // reset the old state
    self.warnArray = nil;
    
    NSArray* warnNode = defaultNilObject([dictionary objectForKey:@"warn"]);
    
    if (nil == warnNode) {
        // no error
        return;
    }
    
    apiFaultArray = [[[NSMutableArray alloc] initWithCapacity:[warnNode count]] autorelease];
    self.warnArray =  apiFaultArray;
    
    for(NSUInteger index = 0; index < [warnNode count]; index++){
        NSDictionary* faultNode = [warnNode objectAtIndex:index];
        ApiFault* fault = [[[ApiFault alloc] init] autorelease];
        [fault parseDict:faultNode];
        [apiFaultArray addObject:fault];
    }    
}

- (void) parseResultData:(NSDictionary*) dictionary{
    // we do nothing here
    // you should override this method in decendent classes
    
    self.resultData = nil;
}

- (void) parseHttpDataAll:(NSData*) data{
    
    // parse json data
    [self parseJson:data];
    
    if (nil == self.dict) {
        return;
    }
    
    // parse api error
    [self parseApiError:self.dict];
    
    if (![self hasError]) {
        // parse into object data
        [self parseResultData:self.dict];
    }else{
        apiLogDebug(@"Api response has error, do not parse result data");
    }
}

/**
 *   ASIHttp callback success
 **/
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSData * responseD = [request responseData];
    apiLogDebug(@"request response string -------- %@",[request responseString]);
//                [responseD description]);
    
    // Use when fetching binary data
    NSData *responseData = [NSData dataWithContentsOfFile:[self getCacheFilePath]];
    
    [self parseHttpDataAll:responseData];
    
    if (nil != apiClient) {
        // call apiClient first
        [apiClient apiNotifyResult:self error:nil];
    }
    
    if (nil != delegate) {
        // call delegate
        [delegate apiNotifyResult:self error:nil];
    }else{
        [self apiNotifyResult:self error:nil];
    }
    
}

/**
 *  ASIHttp callback fail
 **/
- (void)requestFailed:(ASIHTTPRequest *)request
{
    apiLogInfo(@"request failed %@",[request responseString]);
    
    NSError *error = [request error];
    NSData * responseData;
    
    if ([request responseString].length) {
        responseData = [request responseData];
    }else 
        responseData = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getCacheFilePath]]) {
        
        apiLogDebug(@"network error, read from cache file [%@]",[self getCacheFilePath]);
        
        responseData = [NSData dataWithContentsOfFile:[self getCacheFilePath]];        
        [self parseHttpDataAll:responseData];
    }
    
    if (nil != responseData) {
        self.isFromCache = YES;
    }
    
    if (nil != delegate) {
        // call delegate
        [delegate apiNotifyResult:self error:error];
    }else{
        [self apiNotifyResult:self error:error];
    }
}

/**
 *  Implement ApiNotify Protocol
 **/
- (void) apiNotifyResult:(id) apiCmd  error:(NSError*) error {
    apiLogWarn(@"apiNotifyResult called, you should override this method to have your own implementation");
}

- (NSMutableDictionary*) getParamDict{
    return [NSMutableDictionary dictionaryWithCapacity:1];
}

- (NSString*) getCacheKey {
    
    NSMutableString* cacheKey = [[[NSMutableString alloc] initWithCapacity:30] autorelease];
    
    // generate cache key from parameters
    NSDictionary* paramDict = [self getParamDict];
    
    // add all keys into array
    NSMutableArray* paramArray = [[[NSMutableArray alloc] initWithCapacity:[paramDict count]] autorelease];
    
    NSEnumerator *enumerator = [paramDict keyEnumerator];
    NSString* key;
    
    while ((key = [enumerator nextObject])) {
        [paramArray addObject:key];
    }
    
    // sort the param array
    [paramArray sortUsingComparator:^(id obj1, id obj2){
        NSString* str1 = obj1;
        NSString* str2 = obj2;
        return [str1 compare:str2];
    }];

    for (NSInteger index = 0; index < [paramArray count]; index++) {
        NSString* key = [paramArray objectAtIndex:index];
        id tmpId = [paramDict objectForKey:key];
        
        NSString* strValue =  @"";
        
        if ([tmpId isKindOfClass:[NSString class]]) {
            strValue = tmpId;
        }else if([tmpId isKindOfClass:[NSNumber class]]){
            strValue = [tmpId stringValue];
        }else{
            strValue =  @"";
        }
        
        [cacheKey appendFormat:@"_%@_%@_", key, strValue];
    }
    
    
    if (isEmpty(cacheKey)) {
        return nil;
    }
    
    return cacheKey;
}

- (NSString*) getCacheFilePath {
    
    if (isEmpty([self getCacheKey])) {
        return nil;
    }
    
    return getCacheFilePath([self getCacheKey]);
}

@end
