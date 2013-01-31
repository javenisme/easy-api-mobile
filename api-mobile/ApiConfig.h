//
//  ApiConfig.h
//  yikuair
//
//  Created by Javen Yang on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @author Javen Yang
 *  
 * define the enviroment,
 */
enum Environment {APIDEV = 0, APIQA , APILIVE , APIEND};

@interface ApiConfig : NSObject
/**
 * get environment setting
 */
+ (enum Environment) getEnv;

/**
 * set environment 
 */
+ (void) setEnv:(enum Environment) env;

/**
 *  get api request url
 */
+ (NSString*) getApiRequestUrl;

+ (NSString*) getApiStaticUrlPrefix;

+ (NSString*) getApiAppId;

+ (NSString*) getApiSignParamKey;

/**
 * whether do api message debug
 */
+ (BOOL) getApiMessageDebug;

+ (void) setApiMessageDebug:(BOOL) isDebug;

@end
