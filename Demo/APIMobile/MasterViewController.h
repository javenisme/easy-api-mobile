//
//  MasterViewController.h
//  APIMobile
//
//  Created by javen on 13-1-31.
//  Copyright (c) 2013年 yuezo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>
#import "ApiCmdBaikeSearch.h"
#import "ApiNotify.h"
#import "ApiClient.h"

@interface MasterViewController : UITableViewController <ApiNotify>{

    ApiCmdTenHotWords * tenWordsCmd;
    ApiClient * client;
}

@property (nonatomic,retain) ApiCmdTenHotWords * tenWordsCmd;
@property (nonatomic,retain) NSMutableArray * displayHotWordsAry;

@end
