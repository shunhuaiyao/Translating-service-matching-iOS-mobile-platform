//
//  scheduleViewController.h
//  translatorApp
//
//  Created by Yao on 2015/9/23.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarKit.h"
#import "NSCalendarCategories.h"
#import "NSDate+Components.h"

@interface scheduleViewController : UIViewController<CKCalendarViewDataSource,CKCalendarViewDelegate>

@property (strong, nonatomic) NSString * lang1;
@property (strong, nonatomic) NSString * lang2;


@end
