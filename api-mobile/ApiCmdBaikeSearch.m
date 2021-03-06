//
//  ApiCmdBaikeSearch.m
//  HDBaike
//
//  Created by javen on 13-1-9.
//  Copyright (c) 2013年 yuezo. All rights reserved.
//

#import "ApiCmdBaikeSearch.h"
#import "common.h"


@implementation HotWords
@synthesize keyword,trend;

-(id)init{
    if (self = [super init]) {
        self.keyword = nil;
    }
    return self;
}

-(void)parseResultData:(NSDictionary *)dictionary{
    if (dictionary == nil) {
        return;
    }
    
    self.keyword = defaultNilObject([dictionary objectForKey:@"keyword"]);
    self.trend = defaultNilObject([dictionary objectForKey:@"trend"]);
    
}

-(void)dealloc{
    [super dealloc];
}
@end


@implementation ApiCmdTenHotWords
@synthesize tenHotWordsDay,tenHotWordsMonth,tenHotWrodsWeekly;

-(id)init{
    if (self = [super init]) {
        self.tenHotWordsDay = [[NSArray alloc] init];
        self.tenHotWordsMonth = [[NSArray alloc] init];
        self.tenHotWrodsWeekly = [[NSArray alloc] init];
    }
    return self;
}


+(NSString *)getSuffixUrl{
    return @"hotword.do";
}

- (NSMutableDictionary*) getParamDict{
    NSMutableDictionary* paramDict = [[[NSMutableDictionary alloc] init] autorelease];
    [paramDict setObject:@"search" forKey:@"type"];
    return paramDict;
}

-(void)parseResultData:(NSDictionary *)dictionary{
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary  class]]) {
        return;
    }
    
    // daywords parse
    NSMutableArray * dayWordsAry = [NSMutableArray array];
    
    NSDictionary * valueDict = defaultNilObject([dictionary objectForKey:@"value"]);
    NSArray * daysAry = defaultNilObject([valueDict objectForKey:@"day"]);
    
    for (int i = 0; i < 10; i++) {
        NSDictionary * kWordDict = [daysAry objectAtIndex:i];
        HotWords * hotWord = [[HotWords alloc] init];
        [hotWord parseResultData:kWordDict];
        [dayWordsAry addObject:hotWord];
        [hotWord release];
    }
    
    self.tenHotWordsDay = dayWordsAry;
    
    // weekwords parse
    NSMutableArray * weeklyWordsAry = [NSMutableArray array];
    NSArray * weekAry = defaultNilObject([valueDict objectForKey:@"week"]);
    
    for (int i = 0; i < 10; i++) {
        NSDictionary * weekWordDict = [weekAry objectAtIndex:i];
        HotWords * hotWord = [[HotWords alloc] init];
        [hotWord parseResultData:weekWordDict];
        [weeklyWordsAry addObject:hotWord];
    }
    
    self.tenHotWrodsWeekly = weeklyWordsAry;
    
    // month words parse
    NSMutableArray * monthWordsAry = [NSMutableArray array];
    NSArray * dayAry = defaultNilObject([valueDict objectForKey:@"month"]);
    
    for (int i = 0; i < 10; i++) {
        NSDictionary * weekWordDict = [dayAry objectAtIndex:i];
        HotWords * hotWord = [[HotWords alloc] init];
        [hotWord parseResultData:weekWordDict];
        [monthWordsAry addObject:hotWord];
        [hotWord release];
    }
    
    self.tenHotWordsMonth = monthWordsAry;
}

-(void)dealloc{
    [tenHotWordsDay release];
    [tenHotWordsMonth release];
    [tenHotWordsWeekly release];
    [super dealloc];
}

@end

// api cmd baike keywords search api
@implementation ApiCmdBaikeSearch
@synthesize searchKeyWord,type,searchResultsArray;


-(id)init{
    if (self = [super init]) {
        self.searchKeyWord = nil;
    }
    return self;
}

+(NSString *)getSuffixUrl{
    return @"SearchSuggest.do";
}

- (NSMutableDictionary*) getParamDict{
    NSMutableDictionary* paramDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [paramDict setObject:@"search" forKey:@"type"];
    [paramDict setObject:searchKeyWord forKey:@"q"];
    [paramDict setObject:@"json" forKey:@"callback"];
    [paramDict setObject:@"10" forKey:@"limit"];
    return paramDict;
}

-(void)parseResultData:(NSDictionary *)dictionary{
    
    if (dictionary == nil) {
        return ;
    }
    
    NSMutableArray  * resultArray = [NSMutableArray array];
    NSArray * array = [NSArray array];
   
    if ([dictionary isKindOfClass:[NSArray class]]) {
        array = (NSArray *)dictionary;
    }
    
    for ( int index = 0; index < [array count]; index ++) {
        NSDictionary * dict = [array objectAtIndex:index];
        [resultArray addObject:[dict objectForKey:@"doc"]];
    }
    
    // json([{doc:"cannotfindmatchword"}])  搜索找不到结果
    self.searchResultsArray = resultArray;


}

-(void)dealloc{
    [searchResultsArray release];
    [searchKeyWord release];
    [type release];
    [super dealloc];
}

@end


@implementation ApiCmdBaikeCheckDoc
@synthesize docTitle,message,state,docCommentsNumber,docID;

-(id)init{
    self = [super init];
    if (self) {
        self.docTitle = nil;
    }
    return self;
}

+(NSString *)getSuffixUrl{
    return @"checkExistDoc.do";
}

-(NSMutableDictionary *)getParamDict{
    NSMutableDictionary* paramDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [paramDict setObject:self.docTitle forKey:@"doc_title"];
    
    return paramDict;
}

- (void) parseResultData:(NSDictionary*) dictionary{
    if (dictionary == nil) {
        return;
    }
    
    self.message = defaultNilObject([dictionary objectForKey:@"msg"]);
    self.state = defaultNilObject([dictionary objectForKey:@"status"]);
    
    NSDictionary * resultDict = defaultNilObject([dictionary objectForKey:@"value"]);
    
    self.docCommentsNumber = defaultNilObject([resultDict objectForKey:@"doc_comment_count"]);
    NSNumber * number = defaultNilObject([resultDict objectForKey:@"doc_id"]);
    self.docID = [NSString stringWithFormat:@"%@",number];
    
}


-(void)dealloc{
    [docTitle release];
    [super dealloc];
}
@end
