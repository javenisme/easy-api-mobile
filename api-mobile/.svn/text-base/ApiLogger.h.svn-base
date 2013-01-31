//
//  ApiLogger.h
//  Gaopeng
//
//  Created by Javen Yang on 11-10-10.
//  Copyright 2011年 GP. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ApiLogLevel{
    ApiLogNone = 0,
    ApiLogError,
    ApiLogWarn,
    ApiLogInfo,
    ApiLogDebug,
};


/**
 * get / set the log level
 **/
extern enum ApiLogLevel apiGetLogLevel();
extern void apiSetLogLevel(enum ApiLogLevel level);

/**
 *  log message
 **/
extern void apiLogError(NSString *format,...);
extern void apiLogWarn(NSString *format,...);
extern void apiLogInfo(NSString *format,...);
extern void apiLogDebug(NSString *format,...);
