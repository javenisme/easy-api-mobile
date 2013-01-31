//
//  MasterViewController.m
//  APIMobile
//
//  Created by javen on 13-1-31.
//  Copyright (c) 2013年 yuezo.com. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "ApiClient.h"
#import "ApiCmdBaikeSearch.h"
#import "ApiLogger.h"

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController
@synthesize tenWordsCmd;
@synthesize displayHotWordsAry;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)dealloc
{
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
    [self apicmdMethod];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
//    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - api-cmd method

- (void)apicmdMethod{
    client = [ApiClient sharedInstance];
    tenWordsCmd = [[ApiCmdTenHotWords alloc] init];
    tenWordsCmd.delegate = self;
    [tenWordsCmd retain];
    [client executeApiCmdAsync:tenWordsCmd];
}

- (void) apiNotifyResult:(id) apiCmd  error:(NSError*) error{
    self.tenWordsCmd = (ApiCmdTenHotWords *)apiCmd;
    
    for (int index = 0; index < 10 ; index ++) {
        HotWords *wd = [tenWordsCmd.tenHotWordsDay objectAtIndex:index];
        apiLogDebug(@"wd %@ ---- trend %@",wd.keyword,wd.trend);
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table View

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}


@end
