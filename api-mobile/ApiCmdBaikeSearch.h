//
//  ApiCmdBaikeSearch.h
//  HDBaike
//
//  Created by javen on 13-1-9.
//  Copyright (c) 2013年 yuezo. All rights reserved.
//

#import "ApiCmd.h"

// 热词
@interface HotWords : NSObject{
    NSString * keyword;
    NSNumber * trend;
}

@property(nonatomic,retain)NSString * keyword;
@property(nonatomic,retain)NSNumber * trend;

@end

// 十大热词api接口
@interface ApiCmdTenHotWords : ApiCmd{
    NSArray * tenHotWordsDay;
    NSArray * tenHotWordsWeekly;
    NSArray * tenHotWordsMonth;
}
@property (nonatomic,retain)NSArray * tenHotWordsDay;
@property (nonatomic,retain)NSArray * tenHotWrodsWeekly;
@property (nonatomic,retain)NSArray * tenHotWordsMonth;

+(NSString *)getSuffixUrl;

@end

@interface ApiCmdBaikeSearch : ApiCmd{
    NSString * searchKeyWord;
    NSString * type;
    
    NSMutableArray * searchResultsArray;
}
@property (nonatomic,retain)NSString * searchKeyWord;
@property (nonatomic,retain)NSString * type;
@property (nonatomic,retain)NSMutableArray * searchResultsArray;

+(NSString *)getSuffixUrl;

@end


// 判断词条是否存在，吱声数量api接口

@interface ApiCmdBaikeCheckDoc : ApiCmd{

    // 入参
    NSString * docTitle;
    
    NSString * message;
    NSString * state;
    
    NSNumber * docCommentsNumber;
    NSString * docID;
}


@property (nonatomic,retain)NSString * docTitle;
@property (nonatomic,retain)NSString * message;
@property (nonatomic,retain)NSString * state;
@property (nonatomic,retain)NSNumber * docCommentsNumber;
@property (nonatomic,retain)NSString *docID;

+(NSString *)getSuffixUrl;

@end
