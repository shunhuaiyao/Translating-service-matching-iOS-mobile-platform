//
//  RegisterViewController.h
//  translatorApp
//
//  Created by Yao on 2015/9/18.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *RegisterName;
@property (strong, nonatomic) IBOutlet UITextField *RegisterPhone;
@property (strong, nonatomic) IBOutlet UITextField *RegisterPassWord;
@property (strong, nonatomic) IBOutlet UITextField *RegisterPassWord2;
@property (strong, nonatomic) IBOutlet UITextField *RegisterMail;
@property (strong, nonatomic) IBOutlet UITextField *RegisterMail2;
- (IBAction)Registration:(id)sender;
@end
