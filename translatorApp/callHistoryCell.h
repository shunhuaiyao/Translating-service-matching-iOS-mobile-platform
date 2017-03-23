//
//  callHistoryCell.h
//  translatorApp
//
//  Created by Yao on 2015/6/3.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface callHistoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *translatorName;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *translatorImage;

@end
