//
//  ApiCmd.h
//  Gaopeng
//
//  Created by Javen Yang on 11-10-11.
//  Copyright 2011年 GP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"

#import "ApiNotify.h"

/**
 * @author Javen Yang
 *
 * This is the base class for all Api Command,
 * You should inherit from this class to create a new command
 *
 */
@interface ApiCmd : NSObject<ApiNotify>{

@private
    
    BOOL isFromCache;
    
    id<ApiNotify> apiClient; 
    id<ApiNotify> delegate; 

    NSDictionary* dict;
    
    NSArray* errorArray;
    NSArray* warnArray;
    
    id userData;
    id resultData;
    
    NSString * uuid;
    
}

@property(nonatomic, assign) BOOL isFromCache;

@property(nonatomic,retain) id<ApiNotify> apiClient; 
@property(nonatomic,retain) id<ApiNotify> delegate; 

@property(nonatomic,retain) NSDictionary* dict;

@property(nonatomic,retain) NSArray* errorArray;
@property(nonatomic,retain) NSArray* warnArray;

@property(nonatomic,retain) id userData;
@property(nonatomic,retain) id resultData;

@property (nonatomic,retain) NSString * uuid;

- (BOOL) hasError;
- (BOOL) hasWarn;

/**
 *  for synchrous call
 */
- (void) parseHttpDataAll:(NSData*) data;

/**
 *  parse api error
 **/
- (void) parseApiError:(NSDictionary*) dictionary;

/**
 * parse result data, decendent should override this method
 **/
- (void) parseResultData:(NSDictionary*) dictionary;

/**
 * get all parameters list
 *
 * decendent should override this method
 *
 **/
- (NSMutableDictionary*) getParamDict;

/**
 *  define the cache key for command
 *  we would generate cache key from parameters, if this does not meet your requirement, 
 *  you can override this method to define your own key
 **/
- (NSString*) getCacheKey;

/**
 *  cache file path
 ***/
- (NSString*) getCacheFilePath;

@end
