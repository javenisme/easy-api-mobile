//
//  UserInfo.m
//  HDBaike
//
//  Created by javen on 13-1-5.
//  Copyright (c) 2013年 yuezo. All rights reserved.
//

#import "UserInfo.h"
#import "common.h"

@implementation UserInfo
@synthesize userId,userName,user_gender,user_icon,user_iden,user_nick,user_pic_url;

-(id)init{
    if(self = [super init]){
        self.userId = nil;
    }
    return self;
}


- (void) parseResultData:(NSDictionary*) dictionary{
    
    if (nil == dictionary) {
        return;
    }
    
    self.user_gender = defaultNilObject([dictionary objectForKey:@"user_gender"]);
    self.user_icon = defaultNilObject([dictionary objectForKey:@"user_icon"]);
    self.user_iden = defaultNilObject([dictionary objectForKey:@"user_iden"]);
    self.user_nick = defaultNilObject([dictionary objectForKey:@"user_nick"]);
    self.user_pic_url = defaultNilObject([dictionary objectForKey:@"user_pic_url"]);
    
}

-(void)dealloc{
    [userId release];
    [userName release];
    [user_gender release];
    [user_icon release];
    [user_iden release];
    [user_nick release];
    [user_pic_url release];
    [super dealloc];
}

@end
