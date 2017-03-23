//
//  editWorkViewController.h
//  translatorApp
//
//  Created by Yao on 2015/11/3.
//  Copyright © 2015年 Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLForm.h"
#import "XLFormViewController.h"

@interface editWorkViewController : XLFormViewController

@property (strong, nonatomic) NSString * lang1;
@property (strong, nonatomic) NSString * lang2;
@property (strong, nonatomic) NSString * translatorPhone;
@property (strong, nonatomic) NSString * startDateTime;
@property (strong, nonatomic) NSString * endDateTime;

@end
