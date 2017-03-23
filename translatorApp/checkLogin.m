//
//  checkLogin.m
//  translatorApp
//
//  Created by Yao on 2015/8/3.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import "checkLogin.h"

@interface checkLogin ()

@end

@implementation checkLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];

    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    BOOL login = [userInfo boolForKey:@"loginState"];
    if (login) {
        [NSThread sleepForTimeInterval:2.0f];
        [self performSegueWithIdentifier: @"hasLoginbefore" sender: self];
    }
    else{
        [NSThread sleepForTimeInterval:2.0f];
        [self performSegueWithIdentifier: @"hasNotLoginbefore" sender: self];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
