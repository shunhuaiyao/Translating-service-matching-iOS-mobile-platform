//
//  RatingViewController.m
//  translatorApp
//
//  Created by 歐博文 on 2015/7/20.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import "RatingViewController.h"

@interface RatingViewController(){
    NSInteger rating;
    NSUserDefaults *_userInfo;
}
@end
@implementation RatingViewController

@synthesize lang1 = _lang1;
@synthesize lang2 = _lang2;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-100,self.view.bounds.size.height/2-25, 200, 50)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.tintColor = [UIColor redColor];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:starRatingView];
    
    //NSLog(@"%@  %@",_lang1,_lang2);
    
    _userInfo = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray * historyTime = [NSMutableArray arrayWithArray:[_userInfo arrayForKey:@"historyTime"]];
    [historyTime addObject:[self getCurrentTime]];
    [_userInfo setObject:historyTime forKey:@"historyTime"];
    
    NSMutableArray * historyImage = [NSMutableArray arrayWithArray:[_userInfo arrayForKey:@"historyImage"]];
    
    if(([_lang1 isEqualToString:@"Thai"]&&[_lang2 isEqualToString:@"Chinese"])||([_lang1 isEqualToString:@"Chinese"]&&[_lang2 isEqualToString:@"Thai"])){
        [historyImage addObject:[NSString stringWithFormat:@"thai_taiwan.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"Thai"]&&[_lang2 isEqualToString:@"English"])||([_lang1 isEqualToString:@"English"]&&[_lang2 isEqualToString:@"Thai"])){
        [historyImage addObject:[NSString stringWithFormat:@"thai_english.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"Thai"]&&[_lang2 isEqualToString:@"Japanese"])||([_lang1 isEqualToString:@"Japanese"]&&[_lang2 isEqualToString:@"Thai"])){
        [historyImage addObject:[NSString stringWithFormat:@"thai_japan.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"Chinese"]&&[_lang2 isEqualToString:@"English"])||([_lang1 isEqualToString:@"English"]&&[_lang2 isEqualToString:@"Chinese"])){
        [historyImage addObject:[NSString stringWithFormat:@"taiwan_english.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"Chinese"]&&[_lang2 isEqualToString:@"Japanese"])||([_lang1 isEqualToString:@"Japanese"]&&[_lang2 isEqualToString:@"Chinese"])){
        [historyImage addObject:[NSString stringWithFormat:@"taiwan_japan.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"English"]&&[_lang2 isEqualToString:@"Japanese"])||([_lang1 isEqualToString:@"Japanese"]&&[_lang2 isEqualToString:@"English"])){
        [historyImage addObject:[NSString stringWithFormat:@"english_japan.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"Thai"]&&[_lang2 isEqualToString:@"Hakka"])||([_lang1 isEqualToString:@"Hakka"]&&[_lang2 isEqualToString:@"Thai"])){
        [historyImage addObject:[NSString stringWithFormat:@"thai_hakka.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"Thai"]&&[_lang2 isEqualToString:@"Taiwanese"])||([_lang1 isEqualToString:@"Taiwanese"]&&[_lang2 isEqualToString:@"Thai"])){
        [historyImage addObject:[NSString stringWithFormat:@"thai_taiwanese.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"English"]&&[_lang2 isEqualToString:@"Hakka"])||([_lang1 isEqualToString:@"Hakka"]&&[_lang2 isEqualToString:@"English"])){
        [historyImage addObject:[NSString stringWithFormat:@"english_hakka.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"English"]&&[_lang2 isEqualToString:@"Taiwanese"])||([_lang1 isEqualToString:@"Taiwanese"]&&[_lang2 isEqualToString:@"English"])){
        [historyImage addObject:[NSString stringWithFormat:@"english_taiwanese.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"Japanese"]&&[_lang2 isEqualToString:@"Hakka"])||([_lang1 isEqualToString:@"Hakka"]&&[_lang2 isEqualToString:@"Japanese"])){
        [historyImage addObject:[NSString stringWithFormat:@"japanese_hakka.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"Japanese"]&&[_lang2 isEqualToString:@"Taiwanese"])||([_lang1 isEqualToString:@"Taiwanese"]&&[_lang2 isEqualToString:@"Japanese"])){
        [historyImage addObject:[NSString stringWithFormat:@"japanese_taiwanese.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"Chinese"]&&[_lang2 isEqualToString:@"Hakka"])||([_lang1 isEqualToString:@"Hakka"]&&[_lang2 isEqualToString:@"Chinese"])){
        [historyImage addObject:[NSString stringWithFormat:@"chinese_hakka.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"Chinese"]&&[_lang2 isEqualToString:@"Taiwanese"])||([_lang1 isEqualToString:@"Taiwanese"]&&[_lang2 isEqualToString:@"Chinese"])){
        [historyImage addObject:[NSString stringWithFormat:@"chinese_taiwanese.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    else if (([_lang1 isEqualToString:@"Hakka"]&&[_lang2 isEqualToString:@"Taiwanese"])||([_lang1 isEqualToString:@"Taiwanese"]&&[_lang2 isEqualToString:@"Hakka"])){
        [historyImage addObject:[NSString stringWithFormat:@"hakka_taiwanese.png"]];
        [_userInfo setObject:historyImage forKey:@"historyImage"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) getCurrentTime {
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    int weekday = (int)[comps weekday];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d/YYYY";
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    NSString * day;
    
    if (weekday == 1) {
        day = @"Sunday";
    }else if (weekday == 2){
        day = @"Monday";
    }else if (weekday == 3){
        day = @"Tuesday";
    }else if (weekday == 4){
        day = @"Wednesday";
    }else if (weekday == 5){
        day = @"Thursday";
    }else if (weekday == 6){
        day = @"Friday";
    }else if (weekday == 7){
        day = @"Saturday";
    }
    NSLog(@"The Current Time is %@ weekday:%@ date:%@",[dateFormatter stringFromDate:now],day,date);
    
    return [NSString stringWithFormat:@"%@  %@",[dateFormatter stringFromDate:now],date];
    
}

- (IBAction)didChangeValue:(HCSStarRatingView *)sender {
    NSLog(@"Changed rating to %.1f", sender.value);
    rating = sender.value;
    NSLog(@"%ld",(long)rating);
}
- (IBAction)sendRating:(id)sender {
    
    NSLog(@"~~~~Rating = %ld",(long)rating);
    
    if ([[_userInfo stringForKey:@"selectedMode"] isEqualToString:@"1"]) {
        NSString *mode = [NSString stringWithFormat:@"0"];
        [_userInfo setObject:mode forKey:@"selectedMode"];
        NSLog(@"change to%@",mode);
    }
    else{
        NSString *mode = [NSString stringWithFormat:@"1"];
        [_userInfo setObject:mode forKey:@"selectedMode"];
        NSLog(@"change to%@",mode);
    }
    NSMutableArray *calledPhones = [NSMutableArray arrayWithArray:[_userInfo arrayForKey:@"calledPhones"]];
    NSInteger index = calledPhones.count-1;
    
    NSString *post = [NSString stringWithFormat:@"&lang1=%@&lang2=%@&translatorPhone=%@&rating=%@",_lang1,_lang2,[calledPhones objectAtIndex:index],[NSString stringWithFormat: @"%ld", (long)rating]];
    NSLog(@"%@ %@ %@ %@",_lang1,_lang2,[calledPhones objectAtIndex:index],[NSString stringWithFormat: @"%ld", (long)rating]);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.114.71.168/sendRating.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(conn){
        NSLog(@"Connection Successful");
    }
    else{
        NSLog(@"Connection could not be made");
    }
    
}




@end
