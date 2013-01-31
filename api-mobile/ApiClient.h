//
//  ApiClient.h
//  Gaopeng
//
//  Created by Javen Yang on 11-10-11.
//  Copyright 2011年 GP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ApiNotify.h"
#import "ApiCmd.h"
#import "HttpCmdGet.h"

/**
 *  @author Javen Yang
 *
 *  This is the ApiClient , You should keep this Object 
 *  as a singleton , reuse it , and use it one at a time
 *
 *  This class is NOT-Thread safe
 */
@interface ApiClient : NSObject<ApiNotify>{

@private
    NSString* cookie;
}


//share instance method
+(ApiClient *)sharedInstance;

@property(nonatomic,retain) NSString* cookie;


/**
 *  execute ApiCmd asynchrouse
 **/
- (void) executeApiCmdAsync:(ApiCmd*) cmd;

/**
 *  execute ApiCmd sync
 **/
- (NSError*) executeApiCmd:(ApiCmd*) cmd;


/**
 *  execute HttpCmd asynchrouse
 **/
- (void) executeHttpCmdGetAsync:(HttpCmdGet*) cmd;

/**
 *  execute HttpCmd sync
 **/
- (NSError*) executeHttpCmdGet:(HttpCmdGet*) cmd;


@end
