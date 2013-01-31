//
//  ApiFault.h
//  Gaopeng
//
//  Created by Javen Yang on 11-10-11.
//  Copyright 2011年 GP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DomainProtocol.h"

/**
 *  Api Fault class used to indicate what errors happened
 **/
@interface ApiFault : NSObject<DomainProtocol> {

@private
    NSNumber* code;
    NSString* message;
    NSString* detail;
    
}

@property(nonatomic,retain) NSNumber* code;
@property(nonatomic,retain) NSString* message;
@property(nonatomic,retain) NSString* detail;

- (void) parseDict:(NSDictionary*) dict;

- (void) parseData:(id)data;

@end
