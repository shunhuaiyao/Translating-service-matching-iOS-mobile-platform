//
//  scheduleViewController.m
//  translatorApp
//
//  Created by Yao on 2015/9/23.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import "scheduleViewController.h"
#import "addWorkViewController.h"


@interface scheduleViewController (){
    NSMutableData *_downloadedData;
    NSMutableDictionary *_data;
    CKCalendarView *calendar;
    NSString *startDateTime;
    NSString *endDateTime;
    NSUserDefaults *userInfo;
    
}

@end

@implementation scheduleViewController
@synthesize lang1 = _lang1;
@synthesize lang2 = _lang2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:NO animated:NO];
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButton:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.navigationItem.backBarButtonItem.title = @"Back";
    
    CGRect frame = CGRectMake(0,self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, 320, 330);
    calendar = [[CKCalendarView alloc] initWithFrame:frame];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    // 1. Wire up the data source and delegate.
    [calendar setDelegate:self];
    [calendar setDataSource:self];
    [[self view] addSubview:calendar];
    userInfo = [NSUserDefaults standardUserDefaults];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addButton:(UIBarButtonItem *)button{
    [self performSegueWithIdentifier: @"addWorkSegue" sender: self];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 0. Create a dictionary for the data source
    
    NSString *lang1 = _lang1;
    NSString *lang2 = _lang2;
    NSString *phone = [userInfo stringForKey:@"account"];
    
    NSString *post = [NSString stringWithFormat:@"&lang1=%@&lang2=%@&translatorPhone=%@",lang1,lang2,phone];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.114.71.168/loadWork.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (conn) {
        NSLog(@"Connection Successful");
    }
    else{
        NSLog(@"Connection could not be made");
    }
    
    
    
    NSLog(@"viewWillAppear");
}

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date{
    //NSLog(@"%@",_data);
    
    return _data[date];
}
- (void)calendarView:(CKCalendarView *)calendarView willSelectDate:(NSDate *)date{
    
    
    
    NSLog(@"willSelectDate ");
    
}
- (void)calendarView:(CKCalendarView *)calendarView didSelectDate:(NSDate *)date{
    NSLog(@"didSelectedDate");
}
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event{
    
    //NSLog(@"%@ %@\n",event.date,event.title);
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:event.date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:event.date];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    NSDate *date = [NSDate dateWithTimeInterval:gmtInterval sinceDate:event.date];
    NSArray *timeDetail = [event.title componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"➣"]];
    //NSLog(@"%@ %@ %@\n",date,timeDetail[0],timeDetail[1]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    startDateTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:date],[timeDetail[0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]][0]];
    
    endDateTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:date],[timeDetail[1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]][1]];
    NSLog(@"start:%@ end:%@",startDateTime,endDateTime);
    
    UIAlertController * alertActionSheet = [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancel = [UIAlertAction
                         actionWithTitle:@"取消"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             
                             
                         }];
    UIAlertAction* delete = [UIAlertAction
                             actionWithTitle:@"刪除時段"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                 [self deleteEvent];
//                                 [calendar setDelegate:self];
//                                 [calendar setDataSource:self];
//                                 [[self view] addSubview:calendar];
//                                 [calendar reload];
//                                 [calendar layoutSubviews];
                                 
                             }];
    UIAlertAction* edit = [UIAlertAction
                             actionWithTitle:@"編輯"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self performSegueWithIdentifier: @"editWorkSegue" sender: self];
//                                 [calendar setDelegate:self];
//                                 [calendar setDataSource:self];
//                                 [[self view] addSubview:calendar];
//                                 [calendar reload];
//                                 [calendar layoutSubviews];
                                 
                             }];
    [alertActionSheet addAction:delete];
    [alertActionSheet addAction:edit];
    [alertActionSheet addAction:cancel];
    [self presentViewController:alertActionSheet animated:YES completion:nil];
    
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    // Append the newly downloaded data
    [_downloadedData appendData:data];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError *error;
    NSMutableArray * loadWorks = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"%lu",(unsigned long)loadWorks.count);
    _data = [[NSMutableDictionary alloc] init];

    for (int i=0; i<loadWorks.count; i++) {
        NSDictionary *jsonElementforWorks = loadWorks[i];
        NSLog(@"%@ %@ %@\n",jsonElementforWorks[@"account"],jsonElementforWorks[@"starts"],jsonElementforWorks[@"ends"]);

        NSArray *startTime = [jsonElementforWorks[@"starts"] componentsSeparatedByCharactersInSet:
                          [NSCharacterSet characterSetWithCharactersInString:@" "]];
        NSArray *startDate = [startTime[0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
        
        NSDate *date = [NSDate dateWithDay:[[ NSString stringWithFormat: @"%@",startDate[2]] integerValue] month:[[ NSString stringWithFormat: @"%@",startDate[1]] integerValue] year:[[ NSString stringWithFormat: @"%@",startDate[0]] integerValue]];
        
        NSArray *startTimeDetail =[startTime[1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
        
        NSArray *endTime = [jsonElementforWorks[@"ends"] componentsSeparatedByCharactersInSet:
                              [NSCharacterSet characterSetWithCharactersInString:@" "]];
        NSArray *endTimeDetail = [endTime[1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
        
        if ([[_data allKeys] containsObject:date]) {
            NSString *title = [NSString stringWithFormat:@"%@:%@\t➣\t%@:%@",startTimeDetail[0],startTimeDetail[1],endTimeDetail[0],endTimeDetail[1]];
            NSMutableArray *worksForOneDay = _data[date];
            [worksForOneDay addObject:[CKCalendarEvent eventWithTitle:title andDate:date andInfo:nil]];
            _data[date] = worksForOneDay;
        }
        else{
            NSString *title = [NSString stringWithFormat:@"%@:%@\t➣\t%@:%@",startTimeDetail[0],startTimeDetail[1],endTimeDetail[0],endTimeDetail[1]];
            NSMutableArray *worksForOneDay = [[NSMutableArray alloc] init];
            [worksForOneDay addObject:[CKCalendarEvent eventWithTitle:title andDate:date andInfo:nil]];
            [_data setObject:worksForOneDay forKey:date];
        }
        
//        [calendar setDelegate:self];
//        [calendar setDataSource:self];
//        [[self view] addSubview:calendar];
    }
    [calendar setDelegate:self];
    [calendar setDataSource:self];
    [calendar reload];
    [calendar layoutSubviews];
    [[self view] addSubview:calendar];
}

-(void)deleteEvent{
    NSString *lang1 = _lang1;
    NSString *lang2 = _lang2;
    NSString *phone = [userInfo stringForKey:@"account"];
    NSString *post = [NSString stringWithFormat:@"&lang1=%@&lang2=%@&translatorPhone=%@&startDateTime=%@&endDateTime=%@",lang1,lang2,phone,startDateTime,endDateTime];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.114.71.168/deleteWork.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (conn) {
        NSLog(@"Connection Successful");
    }
    else{
        NSLog(@"Connection could not be made");
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"%@ %@ %@111",_lang1,_lang2,[userInfo stringForKey:@"account"]);
    
    
    if ([segue.identifier isEqualToString:@"editWorkSegue"]){
        id targetViewController = segue.destinationViewController;
        [targetViewController setValue:_lang1 forKey:@"lang1"];
        [targetViewController setValue:_lang2 forKey:@"lang2"];
        [targetViewController setValue:[userInfo stringForKey:@"account"] forKey:@"translatorPhone"];
        [targetViewController setValue:startDateTime forKey:@"startDateTime"];
        [targetViewController setValue:endDateTime forKey:@"endDateTime"];
    }
    else if ([segue.identifier isEqualToString:@"addWorkSegue"]){
        
        UINavigationController *navController = [segue destinationViewController];
        addWorkViewController * targetViewController = (addWorkViewController *)([navController viewControllers][0]);
        targetViewController.lang1 = _lang1;
        targetViewController.lang2 = _lang2;
        targetViewController.translatorPhone = [userInfo stringForKey:@"account"];

    }
}
@end
