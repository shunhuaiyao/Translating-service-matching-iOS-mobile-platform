//
//  historyViewController.h
//  translatorApp
//
//  Created by Yao on 2015/5/5.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "callHistoryCell.h"
#import "MBProgressHUD.h"
#import "Reachability.h"


@interface historyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) NSString * currentTime;

@property (strong, nonatomic) IBOutlet UITableView *historyTable;

@property (strong, nonatomic) NSMutableArray *calledPhones;

@property (strong, nonatomic) NSMutableArray *historyTime;

@property (strong, nonatomic) NSMutableArray *historyImage;

@property (strong, nonatomic) NSMutableData *responseData;

@property (strong, nonatomic)NSDictionary *jsonArrayforstatus;

@property (strong, nonatomic) NSMutableArray *historyList;

@property (strong ,nonatomic)NSMutableArray *reversePhoneNumberArray;

@property (strong ,nonatomic)NSMutableArray *reverseCountryArray;

@property (strong ,nonatomic)NSMutableArray *reverseTimeArray;

@end
