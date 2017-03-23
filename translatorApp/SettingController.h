//
//  SettingController.h
//  translatorApp
//
//  Created by Yao on 2015/9/17.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SettingController : UITableViewController<UITableViewDataSource,UITableViewDelegate>{
    MBProgressHUD *HUD;
    
}


@property (strong, nonatomic) IBOutlet UITableView *settingTable;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;

@property (strong, nonatomic) IBOutlet UITableViewCell *cell_1;
@property (strong, nonatomic) IBOutlet UILabel *cell_1Label;
@property (strong, nonatomic) IBOutlet UIImageView *cell_1Image;

@property (strong, nonatomic) IBOutlet UITableViewCell *cell_3;
@property (strong, nonatomic) IBOutlet UILabel *cell_3Label;
@property (strong, nonatomic) IBOutlet UIImageView *cell_3Image;


@end
