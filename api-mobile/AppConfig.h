//
//  AppConfig.h
//  yikuair
//
//  Created by Javen Yang on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "ApiClient.h"

/**
 * @author Javen Yang
 *  
 * define the enviroment,
 */

@interface AppConfig : NSObject
{

}


/**
 * do global initialization , including allocating global variables
 */
+ (void) globalInit;

/**
 *  release global resources that allocaed by globalInit
 *
 */
+ (void) globalRelease;

/***
 *  @author Javen Yang
 *
 *  check whether there is a cookie, so we know whether user has login 
 ****/
+ (BOOL) hasLogin;

/***
 *  @author Javen Yang
 *
 *  logout user
 ****/
+ (void) logout;

+ (ApiClient*) getApiClient;

+ (void)updateUserInfo:(UserInfo *)_userInfo;

+(UserInfo *)getUserInfo;

+(NSNumber *)getUserId;

+(void)updateDevToken:(NSData *)deviceToken;

+(NSData *)getDevToken;

+ (BOOL) isDev;
+ (BOOL) isQA;
+ (BOOL) isLive;

@end
