//
//  SettingController.m
//  translatorApp
//
//  Created by Yao on 2015/9/17.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import "SettingController.h"
#import "translatorTabViewController.h"

@interface SettingController (){
    NSMutableData *_downloadedData;
    
    NSUserDefaults *_userInfo;
    
}

@end

@implementation SettingController
@synthesize cell_1 = _cell_1;
@synthesize cell_3 = _cell_3;
@synthesize cell_1Label = _cell_1Label;
@synthesize cell_3Label = _cell_3Label;
@synthesize cell_1Image = _cell_1Image;
@synthesize cell_3Image = _cell_3Image;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userInfo = [NSUserDefaults standardUserDefaults];
    //    [self downloadItems];
    //    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    HUD.dimBackground = YES;
    //    HUD.mode = MBProgressHUDModeIndeterminate;
    //    HUD.labelText = @"Wait";
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    translatorTabViewController *tabBarController = (translatorTabViewController *)self.tabBarController;
    [tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if([_userInfo boolForKey:@"isTranslator"]==YES){
        NSLog(@"是翻譯員~~~~1111");
        NSLog(@"%d",[_userInfo boolForKey:@"isTranslator"]);
        
    }else{
        NSLog(@"不是翻譯員~~~~2222");
        NSLog(@"%d",[_userInfo boolForKey:@"isTranslator"]);
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    if([_userInfo boolForKey:@"isTranslator"]==YES){
        [self setEnabled:NO forTableViewCell:_cell_1 cellLabel:_cell_1Label cellImage:_cell_1Image];
    }else{
        [self setEnabled:NO forTableViewCell:_cell_3 cellLabel:_cell_3Label cellImage:_cell_3Image];
    }
}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~viewDidAppear");
////    [self downloadItems];
////    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////    HUD.dimBackground = YES;
////    HUD.mode = MBProgressHUDModeIndeterminate;
////    HUD.labelText = @"Wait";
//    if([_userInfo boolForKey:@"isTranslator"]==YES){
//        [self setEnabled:NO forTableViewCell:_cell_1];
//    }else{
//        [self setEnabled:NO forTableViewCell:_cell_2];
//        [self setEnabled:NO forTableViewCell:_cell_3];
//    }
//    
//}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryDisclosureIndicator) {
        return nil;
    }
    return indexPath;
}
- (void)setEnabled:(BOOL)enabled forTableViewCell:(UITableViewCell *)tableViewCell cellLabel:(UILabel *)cellLabel cellImage:(UIImageView *)cellImage
{
    tableViewCell.accessoryType = (enabled) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    // if you dont want the blue selection on tap, comment out the following line
    tableViewCell.selectionStyle = (enabled) ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    tableViewCell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    cellLabel.textColor = [UIColor lightGrayColor];
    cellImage.alpha = 0.5f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~========================%ld",(long)indexPath.row);
}
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // rows in section 0 should not be selectable
//    //if ( indexPath.section == 0 ) return nil;
//
//    // first 3 rows in any section should not be selectable
//    if([_userInfo boolForKey:@"isTranslator"]==YES){
//        if ( indexPath.row == 0) return nil;
//    }else{
//        if ( indexPath.row == 2  || indexPath.row == 1) return nil;
//    }
//    // By default, allow row to be selected
//    return indexPath;
//}

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 // write code to dequeue or create new UITableViewCell here
 // then check if index is same as the cell that should be enabled
 
 if(index.Path.row == enabledCell)
 cell.userInteractionEnabled = NO;
 else
 cell.userInteractionEnabled = YES;
 return cell;
 }*/
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 }*/


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */
//拿來檢查帳號是否已經是翻譯員
//- (void)downloadItems
//{
//    // Download the json file
//    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://140.114.71.168/TranslatorCheck.php"];
//    
//    // Create the request
//    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
//    
//    // Create the NSURLConnection
//    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
//}
//
//#pragma mark NSURLConnectionDataProtocol Methods
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    // Initialize the data object
//    _downloadedData = [[NSMutableData alloc] init];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    // Append the newly downloaded data
//    [_downloadedData appendData:data];
//}
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    // Create an array to store the locations
//    //   NSMutableArray *_locations = [[NSMutableArray alloc] init];
//    // Parse the JSON that came in
//    NSError *error;
//    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
//    NSLog(@"~~~~%lu",(unsigned long)jsonArray.count);
//    // Loop through Json objects, create question objects and add them to our questions array
//    for (int i = 0; i < jsonArray.count; i++){
//        NSDictionary *jsonElement = jsonArray[i];
//        
//        // Create a new location object and set its props to JsonElement properties
//        NSLog(@"acount = %@ ",jsonElement[@"account"]);
//        if ([[_userInfo stringForKey:@"account"] isEqualToString:jsonElement[@"account"]]) {
//            
//            NSLog(@"跟資料庫第%d個重複了！",i);
//            [_userInfo setBool:YES forKey:@"isTranslator"];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if([_userInfo boolForKey:@"isTranslator"]==YES){
//                [self setEnabled:NO forTableViewCell:_cell_1];
//            }else{
//                [self setEnabled:NO forTableViewCell:_cell_2];
//                [self setEnabled:NO forTableViewCell:_cell_3];
//            }
//            break;
//        }else{
//            if(i == jsonArray.count -1){
//                [_userInfo setBool:NO forKey:@"isTranslator"];
//                if([_userInfo boolForKey:@"isTranslator"]==YES){
//                    [self setEnabled:NO forTableViewCell:_cell_1];
//                }else{
//                    [self setEnabled:NO forTableViewCell:_cell_2];
//                    [self setEnabled:NO forTableViewCell:_cell_3];
//                }
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            }
//        }
//    }
//}


@end
