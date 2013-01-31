//
//  main.m
//  APIMobile
//
//  Created by javen on 13-1-31.
//  Copyright (c) 2013年 yuezo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "AppConfig.h"

int main(int argc, char *argv[])
{
    
    @autoreleasepool {
        //do global initialization here
        [AppConfig globalInit];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        //do global release
        [AppConfig globalRelease];
    }
}
