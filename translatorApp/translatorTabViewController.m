//
//  translatorTabViewController.m
//  translatorApp
//
//  Created by Yao on 2015/5/6.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import "translatorTabViewController.h"
#import "SettingController.h"

@interface translatorTabViewController ()

@end

@implementation translatorTabViewController
//@synthesize instance = _instance;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];

    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@ %@ %d  // tabController",[userInfo stringForKey:@"account"],[userInfo stringForKey:@"password"],[userInfo boolForKey:@"loginState"]);
    /**
     這裏是NavigationBar右邊會多出一個Home圖示的按鈕，按了便可以連結到雲端真人翻譯的網站
     **/
//    UIImage* image3 = [UIImage imageNamed:@"house.png"];
//    CGRect frameimg = CGRectMake(20,10, 30,30);
//    
//    UIButton *homeButton = [[UIButton alloc] initWithFrame:frameimg];
//    [homeButton setBackgroundImage:image3 forState:UIControlStateNormal];
//    [homeButton addTarget:self action:@selector(HyperLink_btn:)
//         forControlEvents:UIControlEventTouchUpInside];
//    [homeButton setShowsTouchWhenHighlighted:YES];
//    
//    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:homeButton];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        SettingController *tabBarController = (SettingController *)self.tabBarController;
        [tabBarController.navigationController setNavigationBarHidden:NO animated:NO];

        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.navigationItem setHidesBackButton:YES animated:NO];
    }
    else{
        SettingController *tabBarController = (SettingController *)self.tabBarController;
        [tabBarController.navigationController setNavigationBarHidden:NO animated:NO];

        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationItem setHidesBackButton:YES animated:NO];
    }
    
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
