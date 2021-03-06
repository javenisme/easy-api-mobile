//
//  UserInfo.h
//  HDBaike
//
//  Created by javen on 13-1-5.
//  Copyright (c) 2013年 yuezo. All rights reserved.
//

#import <Foundation/Foundation.h>

enum UserGender {
    undefine = 0,
    male = 1,
    female = 2,
    };

@interface UserInfo : NSObject{
    NSString * userId;
    NSString * userName;
    NSString * user_iden;
    NSNumber * user_gender;
    NSString * user_icon;
    NSString * user_pic_url;
}

@property(nonatomic,retain) NSString * user_nick;      //用户昵称”,
@property(nonatomic,retain) NSString * userId;
@property(nonatomic,retain) NSString * userName;
@property(nonatomic,retain) NSString * user_iden;
@property(nonatomic,retain) NSNumber * user_gender;  //性别:1为男,2为女,0未设置
@property(nonatomic,retain) NSString * user_icon;  //1,0,0,0 //第一位:加V 第二位:标准委员会 第三位:评审委员会 第四位:编辑委员会
@property(nonatomic,retain) NSString * user_pic_url;

- (void) parseResultData:(NSDictionary*) dictionary;

@end
