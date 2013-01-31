//
//  ApiConfig.m
//  yikuair
//
//  Created by Javen Yang on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ApiConfig.h"

struct EnvConfig{
char apiRequestUrl[128];
char apiStaticUrlPrefix[128];
char apiAppId[64];
char apiSignParamKey[128];

//// these fields are for alipay
//char alipayPartner[128];
//char alipaySeller[128];
//char alipayNotifyUrl[1024];
//char alipayAppScheme[16];
//char alipayPrivateKey[1024];
//char alipayPublicKey[1024];

};

// enviroments
static enum Environment apiEnv = APIDEV;

static struct EnvConfig envConfigArray[APIEND] = {
    //API Dev
    {
        .apiRequestUrl = "http://api.hudong.com/",
        .apiStaticUrlPrefix =  "http://www.baike.com/api",
        .apiAppId = "97b291a1eae2f6020708c169512f9478",
    },
    //API QA 
    {
        .apiRequestUrl = "http://www.baike.com/api", 
        .apiStaticUrlPrefix = "http://www.baike.com/api",
        .apiAppId = "3619919282", 
    },
    //API Live
    {
        .apiRequestUrl = "http://www.baike.com/api", 
        .apiStaticUrlPrefix = "http://www.baike.com/api",
        .apiAppId = "97b291a1eae2f6020708c169512f9478", 
    }
};

static const struct EnvConfig* getEnvConfig() {
    
    return &envConfigArray[apiEnv];
}

static const char* getApiRequestUrl() {
    return getEnvConfig()->apiRequestUrl;
}

static const char* getApiStaticUrlPrefix() {
    return getEnvConfig()->apiStaticUrlPrefix;
}

static const char* getApiAppId() {
    return getEnvConfig()->apiAppId;
}

static const char* getApiSignParamKey() {
    return getEnvConfig()->apiSignParamKey;
}

static BOOL apiMessageDebug = YES;

@implementation ApiConfig

/**
 * get environment setting
 */
+ (enum Environment) getEnv{
    return apiEnv;
}

/**
 * set environment 
 */
+ (void) setEnv:(enum Environment) env{
    apiEnv = env;
}

+ (NSString*) getApiRequestUrl{
    return [NSString stringWithUTF8String:getApiRequestUrl()];
}

+ (NSString*) getApiStaticUrlPrefix{
    return [NSString stringWithUTF8String:getApiStaticUrlPrefix()];
}

+ (NSString*) getApiAppId{
    return [NSString stringWithUTF8String:getApiAppId()];
}

+ (NSString*) getApiSignParamKey{
    return [NSString stringWithUTF8String:getApiSignParamKey()];
}

+ (BOOL) getApiMessageDebug{
    return apiMessageDebug;
}

+ (void) setApiMessageDebug:(BOOL) isDebug{
    apiMessageDebug = isDebug;
}

@end
