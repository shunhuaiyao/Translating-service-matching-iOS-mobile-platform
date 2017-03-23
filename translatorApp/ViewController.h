//
//  ViewController.h
//  translatorApp
//
//  Created by Yao on 2015/4/16.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ViewController : UIViewController<UITextFieldDelegate>{
    BOOL loginState;
    //    User * instance;
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UIImageView *translatorLogingImage;

@property (strong, nonatomic) IBOutlet UITextField *userAccount;

@property (strong, nonatomic) IBOutlet UITextField *userPassword;

//@property (strong, nonatomic) User * instance;

//+(ViewController *)sharedInstance;

- (void)downloadItems;

- (IBAction)userLogin:(id)sender;


@end

