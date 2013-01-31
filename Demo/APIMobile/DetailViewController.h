//
//  DetailViewController.h
//  APIMobile
//
//  Created by javen on 13-1-31.
//  Copyright (c) 2013年 yuezo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
