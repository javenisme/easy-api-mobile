//
//  HttpCmdGet.h
//  Gaopeng
//
//  Created by admin Admin on 11-10-14.
//  Copyright 2011年 GP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ApiCmd.h"

/**
 *  @author Javen Yang
 *
 *  http get command
 *
 **/
@interface HttpCmdGet : ApiCmd{
@private
    NSString* requestUri;
    
    //output
    NSString* responseFilePath;
}

@property(nonatomic, retain) NSString* requestUri;
@property(nonatomic, retain) NSString* responseFilePath;

@end
