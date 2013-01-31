//
//  AppConfig.m
//  yikuair
//
//  Created by Javen Yang on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppConfig.h"
#import "ApiConfig.h"
#import "ApiClient.h"
#import "Common.h"
#import "Common.h"
#import "Userinfo.h"
#import "ApiLogger.h"
#import "CheckNetwork.h"

static ApiClient* apiClient =  nil;
UserInfo * userInfo = nil;
NSData * devToken = nil;

@implementation AppConfig

-(void)dealloc{
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (void) globalInit{
    // configure api-mobile module
    // we configure it to be Debug mode for development
    // but we need to change to Prod mode when do deploy
    
    [ApiConfig setEnv:APIDEV];
//    [ApiConfig setEnv:APIQA];
//    [ApiConfig setEnv:APILIVE];
    [ApiConfig setApiMessageDebug:YES];
//    [ApiConfig setApiMessageDebug:NO];
    
    if (nil == apiClient) {
        apiClient = [[ApiClient alloc] init];
        userInfo = [[UserInfo alloc] init];
        devToken = [NSData data];
    }
}

+ (void) globalRelease {
    [apiClient release];
    [userInfo release];
}

+ (BOOL) hasLogin {
    BOOL isConnected = [CheckNetwork isExistenceNetwork];
    if (userInfo.userName && userInfo.userId && isConnected) {
        return YES;
    }else
        return NO;
//        return (!isNull(apiClient.cookie) && [apiClient.cookie length] >0);
}

/***
 *  @author Javen Yang
 *
 *  logout user
 ****/
+ (void) logout{
    apiClient = nil;
    userInfo = nil;
}

#pragma mark - global resource method
/**
 *  return the global ApiClient Object
 **/
+ (ApiClient*) getApiClient {
    return apiClient;
}

+ (void)updateUserInfo:(UserInfo *)_userInfo{
//    [userInfo release];

    userInfo = _userInfo;
    [userInfo retain];
}

+(UserInfo *)getUserInfo{
    return userInfo;
}

//+(BabyInfo *)getBabyInfo{
//    return babyInfo;
//}

+(NSNumber *)getUserId{
    return userInfo.userId;
}

#pragma mark - device token method
/**
 *  return the global devtoken Object
 **/
+(void)updateDevToken:(NSData *)deviceToken{
    devToken = deviceToken;
    [devToken retain];
}

+(NSData *)getDevToken{
    return devToken;
}

#pragma mark - evrionment check method

+ (BOOL) isDev {
    return APIDEV == [ApiConfig getEnv];
}

+ (BOOL) isQA {
    return APIQA == [ApiConfig getEnv];
}

+ (BOOL) isLive {
    return APILIVE == [ApiConfig getEnv];
}

@end
