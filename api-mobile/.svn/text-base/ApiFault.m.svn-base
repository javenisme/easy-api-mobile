//
//  ApiFault.m
//  Gaopeng
//
//  Created by Javen Yang on 11-10-11.
//  Copyright 2011年 GP. All rights reserved.
//

#import "ApiFault.h"

static NSString* keyCode = @"error";
static NSString* keyMessage = @"msg";
static NSString* keyInfo = @"info";

@implementation ApiFault

@synthesize code,message,detail;


- (void) dealloc {
    [code release];
	[message release];
	[detail release];
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

- (void) parseDict:(NSDictionary*) dict {
    
    self.code = [dict objectForKey:keyCode];
    self.message = [dict objectForKey:keyMessage];
    self.detail = [dict objectForKey:keyInfo];  
}

- (void) parseData:(id)data {
    [self parseDict:data];
}

@end
