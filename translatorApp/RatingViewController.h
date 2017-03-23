//
//  RatingViewController.h
//  translatorApp
//
//  Created by 歐博文 on 2015/7/20.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HCSStarRatingView.h"
@interface RatingViewController : UIViewController
- (IBAction)sendRating:(id)sender;

@property (strong, nonatomic) NSString * lang1;

@property (strong, nonatomic) NSString * lang2;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UIButton *ratingButtonOutlet;

@end
