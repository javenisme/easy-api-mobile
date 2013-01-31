//
//  ApiClient.m
//  Gaopeng
//
//  Created by Javen Yang on 11-10-11.
//  Copyright 2011年 GP. All rights reserved.
//

#import "ASIFormDataRequest.h"

#import "ApiCmdBaikeSearch.h"

#import "ApiConfig.h"
#import "ApiLogger.h"
#import "ApiClient.h"
#import "common.h"

// const static key
static NSString* keyCookie = @"cookie";
//static NSString* keyAppId = @"appId";
static NSString* keySign = @"sign";

//static NSString* keyFormat = @"format";
//static NSString* valueFormat = @"json";

//static NSString* keyPhoneType = @"phoneType";
//static NSString* valuePhoneType = @"iPhone";

@implementation ApiClient
static ApiClient * instance = nil;
// define getter/setter methods
@synthesize cookie;


/**
 *  release all resources
 *
 */
- (void) dealloc {
	[cookie release];
	
	[super dealloc];
}

/**
 *  do init work
 */
- (id)init
{
    self = [super init];
    if (self) {
        // set an empty cookie, so we would not met any null pointer
        cookie = @""; 
    }
    
    return self;
}

+(ApiClient *)sharedInstance{
    if (!instance)
	{
		instance = [[ApiClient alloc] init];
	}
	return instance;
}

- (void) apiNotifyResult:(id) apiCmd  error:(NSError*) error {
    // update cookie here
    ApiCmd* cmd = (ApiCmd*)apiCmd;
    
    NSString* newCookie = [NSString string];
    if ([cmd.dict isKindOfClass:[NSDictionary class]]) {
        newCookie = [cmd.dict objectForKey:keyCookie];
    }

    if (nil != newCookie) {
        self.cookie = newCookie;
    }
}

/**
 *  do signature of all parametrs
 */
- (NSString*) signParam:(NSMutableDictionary*) dict{
    
    // add all keys into array
    NSMutableArray* paramArray = [[[NSMutableArray alloc] initWithCapacity:[dict count]] autorelease];
    
    NSEnumerator *enumerator = [dict keyEnumerator];
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
    
    // append the values to form the pre-encryption string
    NSMutableString* mutableString = [[[NSMutableString alloc] initWithCapacity:128] autorelease];
    for (NSInteger index = 0; index < [paramArray count]; index++) {
        id tmpId = [dict objectForKey:[paramArray objectAtIndex:index]];
        
        NSString* strValue =  @"";
        
        if ([tmpId isKindOfClass:[NSString class]]) {
            strValue = tmpId;
        }else if([tmpId isKindOfClass:[NSNumber class]]){
            strValue = [tmpId stringValue];
        }else{
            // do nothing
            apiLogError(@"Error Value of [%@], can only accept NSString or NSNumber",[paramArray objectAtIndex:index]);
        }
        
        [mutableString appendString:strValue];
    }
    
    // append the apiSignParamKey
    [mutableString appendString:[ApiConfig getApiSignParamKey]];
    
    // do MD5 encryption
    return md5(mutableString);
}

- (ASIFormDataRequest*) prepareExecuteApiCmd:(id) cmd{
    
    // set apiClient of cmd
//    cmd.apiClient = self;
    
    // prepare post data
    NSMutableDictionary* postDict = [cmd getParamDict];
    
    // add appId & cookie & phoneType
//    [postDict setValue:[ApiConfig getApiAppId] forKey:@"token"];
    
//    [postDict setValue:self.cookie forKey:keyCookie];
//    [postDict setValue:valueFormat forKey:keyFormat];
//    [postDict setValue:valuePhoneType forKey:keyPhoneType];
    
    // caculate signature of parameters
//    NSString* paramSign = [self signParam:postDict];
//    [postDict setValue:paramSign forKey:keySign];
    
    // add all parameters to post data
    
    // get suxffix url string 
    NSString * _suffixUrlString = [NSString string];
    if ([cmd isKindOfClass:[ApiCmdTenHotWords  class]]) {
        _suffixUrlString = [ApiCmdTenHotWords getSuffixUrl];
    }
    
    // prepare http request
    NSURL *url = nil;
    if ([cmd isKindOfClass:[ApiCmdBaikeSearch class]]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.hudong.com/%@",_suffixUrlString]];
    }else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[ApiConfig getApiRequestUrl],_suffixUrlString]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    if ([ApiConfig getApiMessageDebug]) {
        apiLogInfo(@"ApiRequestURL : [%@]", url);
        apiLogInfo(@"Request Param Count : [%d]", [postDict count]);
    }
    
    NSEnumerator *enumerator = [postDict keyEnumerator];
    id key;
    
    while ((key = [enumerator nextObject])) {
        
        id value = [postDict objectForKey:key];
        
        // set post data
        if ([value isKindOfClass:[NSString class]]) {
            [request setPostValue:value forKey:(NSString*)key];
        }else if ([value isKindOfClass:[NSData class]]){
            [request addData:value forKey:key];
        }
        
        
        // for debugging purpose
        if ([ApiConfig getApiMessageDebug]) {
            apiLogInfo(@"Post Param : Key [%@] Value [%@]", (NSString*)key, value);
        }
    }
    
    // save all result to a file
    if (!isEmpty([cmd getCacheFilePath])) {
        [request setDownloadDestinationPath:[cmd getCacheFilePath]];
        apiLogDebug(@"save api result to cache file [%@]",[cmd getCacheFilePath]);
    }
    
    return request;
}

- (void) executeApiCmdAsync:(id) cmd{
    [cmd  retain];
    ASIFormDataRequest* request = [self prepareExecuteApiCmd:cmd];
    
    apiLogDebug(@"request url %@",request.url);
    
    [request setDelegate:cmd];
    [request startAsynchronous];
}


- (NSError*) executeApiCmd:(ApiCmd*) cmd{
    
    ASIFormDataRequest* request = [self prepareExecuteApiCmd:cmd];
//    [request setDelegate:cmd];
    [request startSynchronous];
    
//    NSData * responseData2 = [request responseData];
//    NSLog(@"responseData 2 %@",[responseData2 description]);
    
    NSError *error = [request error];
    
    NSData *responseData = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[cmd getCacheFilePath]]) {
        
        apiLogDebug(@"network error, read from cache file [%@]",[cmd getCacheFilePath]);
        
        responseData = [NSData dataWithContentsOfFile:[cmd getCacheFilePath]];
        if (responseData == nil) {
            return nil;
        }
        [cmd parseHttpDataAll:responseData];
        // ApiClient needs to update cookie 
        [self apiNotifyResult:cmd error:error];
    }

    if (nil != error && nil != responseData) {
        cmd.isFromCache = YES;
    }
            
    return error;
}


- (ASIHTTPRequest*) prepareExecuteHttpCmdGet:(HttpCmdGet*) cmd {
    
    // prepare http request
    NSURL *url = [NSURL URLWithString:prepareStaticHttpPath(cmd.requestUri)];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    // save to file directly
    [request setDownloadDestinationPath:[cmd getCacheFilePath]]; 
    [request setPersistentConnectionTimeoutSeconds:60];
    
    cmd.responseFilePath = [cmd getCacheFilePath];
    
    if ([ApiConfig getApiMessageDebug]) {
        apiLogError(@"Request File : [%@]", prepareStaticHttpPath(cmd.requestUri));
        apiLogDebug(@"DowladFilePath : [%@]", cmd.responseFilePath);
    }
    
    return request;
}

/**
 *  execute HttpCmd asynchrouse
 **/
- (void) executeHttpCmdGetAsync:(HttpCmdGet*) cmd {
    ASIHTTPRequest* request = [self prepareExecuteHttpCmdGet:cmd];
    [request setDelegate:cmd];
    [request startAsynchronous];
}

/**
 *  execute HttpCmd sync
 **/
- (NSError*) executeHttpCmdGet:(HttpCmdGet*) cmd {
    
    ASIHTTPRequest* request = [self prepareExecuteHttpCmdGet:cmd];
    [request startSynchronous];
    
    NSError* error = [request error];
    
    if (nil != error && [[NSFileManager defaultManager] fileExistsAtPath:[cmd getCacheFilePath]]) {
        cmd.isFromCache = YES;
    }
    
    return error;
}


@end
