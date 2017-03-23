//
//  langViewController.h
//  translatorApp
//
//  Created by Yao on 2015/5/5.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "translatorTabViewController.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
@interface langViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSArray * langCollection;
    MBProgressHUD *HUD;

}
@property (strong, nonatomic) IBOutlet UIPickerView *LangSelected1;

@property (strong, nonatomic) IBOutlet UIPickerView *LangSelected2;

@property (strong, nonatomic) IBOutlet UIButton *callButtonOutlet;

@property (strong, nonatomic) NSString * currentTime;

@property (strong, nonatomic) NSMutableData *responseData;

@property (strong, nonatomic)NSDictionary *jsonArrayforstatus;

@property (strong, nonatomic)NSMutableArray *jsonArrayForTranslatorPhone;

@property (strong, nonatomic)NSDictionary *translatorPhoneList;

@property (strong, nonatomic)NSMutableArray *calledPhone;

@property int  calling,modeCount;

@property (strong, nonatomic)NSString * selectedMode;


- (IBAction)callButton:(id)sender;

- (void)callTotranslator:(NSString *) translatorPhone;

//@property (strong, nonatomic) User * instance;

@end
