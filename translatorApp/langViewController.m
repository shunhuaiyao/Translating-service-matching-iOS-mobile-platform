//
//  langViewController.m
//  translatorApp
//
//  Created by Yao on 2015/5/5.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import "langViewController.h"
#import "translatorTabViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "TSMessage.h"

@interface langViewController (){
    NSMutableData *_downloadedData;
    NSMutableData *_responseData;
    NSUserDefaults *_userInfo;
   // UIBarItem * _baritem1;
   // UIBarItem * _baritem2;
    //NSMutableDictionary *codeNameDictionary;
    NSInteger
    countforcodename;
}

@end

@implementation langViewController

@synthesize currentTime = _currentTime;
@synthesize responseData = _responseData;
@synthesize jsonArrayforstatus = _jsonArrayforstatus;
@synthesize jsonArrayForTranslatorPhone = _jsonArrayForTranslatorPhone;
@synthesize translatorPhoneList = _translatorPhoneList;
@synthesize calling = _calling;
@synthesize calledPhone = _calledPhone;
@synthesize selectedMode = _selectedMode;
@synthesize modeCount = _modeCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    [self checkForNetwork];
    
    self->langCollection = [[NSArray alloc]initWithObjects:@"Thai",@"Chinese",@"English",@"Japanese",@"Hakka",@"Taiwanese", nil];
    [self.LangSelected1 selectRow:1 inComponent:0 animated:NO];
    [self.LangSelected2 selectRow:2 inComponent:0 animated:NO];
    
    // Do any additional setup after loading the view.
    
    
    translatorTabViewController *tabBarController = (translatorTabViewController *)self.tabBarController;
    NSLog(@"tab %lu",(unsigned long)[tabBarController.viewControllers indexOfObject:self]);
//    _baritem1 = [tabBarController.tabBar.items objectAtIndex:[tabBarController.viewControllers indexOfObject:self]];
//    _baritem2 = [tabBarController.tabBar.items objectAtIndex:[tabBarController.viewControllers indexOfObject:self]+1];
    
    
    _userInfo = [NSUserDefaults standardUserDefaults];
    [self getCurrentTime];
    //------------------------------11/26------------------------------------------------------------------------------------------------------------------------
    countforcodename =  [_userInfo integerForKey:@"countForNickName"];
    NSLog(@"fkfkkfkfkfkfkffkfkfkfkfkfkfk~~~~%ld",(long)countforcodename);
    
    
    //------------------------------11/26------------------------------------------------------------------------------------------------------------------------
    
    
    _selectedMode = [_userInfo stringForKey:@"selectedMode"];
    _modeCount = 0;
    
    NSLog(@"%@ %@ %d %@// langController",[_userInfo stringForKey:@"account"],[_userInfo stringForKey:@"password"],[_userInfo boolForKey:@"loginState"],_selectedMode);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self->langCollection count];
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return [self->langCollection objectAtIndex:row];
//}

- (UIView *)pickerView:(__unused UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(__unused NSInteger)component reusingView:(UIView *)view{
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 300, 30)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(140, 3, 245, 24)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        [view addSubview:label];
        
        UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 3, 24, 24)];
        flagView.contentMode = UIViewContentModeScaleAspectFit;
        flagView.tag = 2;
        [view addSubview:flagView];
    }
    NSMutableArray *showLangCollection = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i < self->langCollection.count; i++) {
        NSString *showLang = [self->langCollection objectAtIndex:i];
        if ([showLang isEqualToString:@"Chinese"]) {
            [showLangCollection addObject:[NSString stringWithFormat:@"中文"]];
        }
        else if ([showLang isEqualToString:@"English"]){
            [showLangCollection addObject:[NSString stringWithFormat:@"英文"]];
        }
        else if ([showLang isEqualToString:@"Thai"]){
            [showLangCollection addObject:[NSString stringWithFormat:@"泰文"]];
        }
        else if ([showLang isEqualToString:@"Japanese"]){
            [showLangCollection addObject:[NSString stringWithFormat:@"日文"]];
        }
        else if ([showLang isEqualToString:@"Hakka"]){
            [showLangCollection addObject:[NSString stringWithFormat:@"客語"]];
            // NSLog(@"i~~~~~~~~~等於： %ld",(long)i);
        }
        else if ([showLang isEqualToString:@"Taiwanese"]){
            [showLangCollection addObject:[NSString stringWithFormat:@"閩南語"]];
            // NSLog(@"i~~~~~~~~~等於： %ld",(long)i);
        }
        
    }
    NSString *imagePath;
    ((UILabel *)[view viewWithTag:1]).text = [showLangCollection objectAtIndex:row];
    if(![[self->langCollection objectAtIndex:row] isEqualToString:@"Hakka"]&&![[self->langCollection objectAtIndex:row] isEqualToString:@"Taiwanese"]){
        imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@", [self->langCollection objectAtIndex:row]];
    }
    else if([[self->langCollection objectAtIndex:row] isEqualToString:@"Hakka"]){
        imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@_2", [self->langCollection objectAtIndex:row]];
        
    }
    else if([[self->langCollection objectAtIndex:row] isEqualToString:@"Taiwanese"]){
        imagePath = [NSString stringWithFormat:@"CountryPicker.bundle/%@_2", [self->langCollection objectAtIndex:row]];
        
    }
    
    ((UIImageView *)[view viewWithTag:2]).image = [UIImage imageNamed:imagePath];
    
    
    return view;
    
}

-(NSString *) getCurrentTime {
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    _currentTime = [dateFormatter stringFromDate:now];
    //NSLog(@"%@",_currentTime);
    return _currentTime;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)callButton:(id)sender {
    if ([self checkForNetwork]) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.dimBackground = YES;
        HUD.mode = MBProgressHUDModeIndeterminate;
        
        HUD.labelText = @"搜尋翻譯員中...";
        _calling = 0;
        _modeCount = 0;
        //NSLog(@"calling in callButton : %d",_calling);
        
        //    self.callButtonOutlet.enabled = false;
        
        NSString * selectedPickView1 = [self->langCollection objectAtIndex:[self.LangSelected1 selectedRowInComponent:0]];
        NSString * selectedPickView2 = [self->langCollection objectAtIndex:[self.LangSelected2 selectedRowInComponent:0]];
        // NSLog(@"%@ %@",selectedPickView1,selectedPickView2);
        
  //      [_baritem1 setEnabled:FALSE];
  //      [_baritem2 setEnabled:FALSE];
        
        self.view.window.userInteractionEnabled = NO;
        
        [self translatorList:_selectedMode lang1:selectedPickView1 lang2:selectedPickView2 currentTime:[self getCurrentTime]];
    }
    
}


#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
    
    _responseData = [NSMutableData data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [_downloadedData appendData:data];
    [_responseData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create an array to store the locations
    //   NSMutableArray *_locations = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    
    //NSLog(@"～～～～～～～～～～connectionDidFinishLoading～～～～～～～～～～～～～～～");
    NSError *error;
    //NSLog(@"calling in connectionDidFinishLoading : %d",_calling);
    NSObject *resultForMutableArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingMutableContainers error:&error];
    if ([resultForMutableArray isKindOfClass:[NSMutableArray class]]) {
        _jsonArrayForTranslatorPhone = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingMutableContainers error:&error];
        
    }
    // Loop through Json objects, create question objects and add them to our questions array
    
    //NSLog(@"number of phones: %lu",(unsigned long)_jsonArrayForTranslatorPhone.count);
    // _jsonArrayForTranslatorPhone = [_jsonArrayForTranslatorPhone mutableCopy];
    
    
    
    // Create a new location object and set its props to JsonElement properties
    if (_calling == 0 && _jsonArrayForTranslatorPhone.count>0) {
        
        NSDictionary *jsonElementForTranslatorPhone = _jsonArrayForTranslatorPhone[0];
        [self callTotranslator:jsonElementForTranslatorPhone[@"account"]];
        
        
        _calledPhone = [[NSMutableArray alloc] initWithObjects:jsonElementForTranslatorPhone[@"account"], nil];
        
        NSLog(@"first called phone: %lu",(unsigned long)_calledPhone.count);
        
        NSUInteger index = 0;
        [_jsonArrayForTranslatorPhone removeObjectAtIndex:index];
    }
    else if(_calling == 0 && _jsonArrayForTranslatorPhone.count==0 && _modeCount<1){
        _modeCount++;
        NSString * selectedPickView1 = [self->langCollection objectAtIndex:[self.LangSelected1 selectedRowInComponent:0]];
        NSString * selectedPickView2 = [self->langCollection objectAtIndex:[self.LangSelected2 selectedRowInComponent:0]];
        NSString * time = [self getCurrentTime];
        [self translatorList:_selectedMode lang1:selectedPickView1 lang2:selectedPickView2 currentTime:time];
    }
    else if(_calling == 0 && _jsonArrayForTranslatorPhone.count==0 && _modeCount==1){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
   //     [_baritem1 setEnabled:TRUE];
    //    [_baritem2 setEnabled:TRUE];
        self.view.window.userInteractionEnabled = YES;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"翻譯員忙線中"
        //                                                        message:nil
        //                                                       delegate:nil
        //                                              cancelButtonTitle:@"確定"
        //                                              otherButtonTitles:nil];
        //        [alert show];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"翻譯員忙線中"
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* OKButton = [UIAlertAction
                                   actionWithTitle:@"確認"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel your yes please button action here
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        [alert addAction:OKButton];
        [self presentViewController:alert animated:YES completion:nil];
        if ([[_userInfo stringForKey:@"selectedMode"] isEqualToString:@"1"]) {
            NSString *mode = [NSString stringWithFormat:@"0"];
            [_userInfo setObject:mode forKey:@"selectedMode"];
            _selectedMode = mode;
            //NSLog(@"change to%@",_selectedMode);
        }
        else{
            NSString *mode = [NSString stringWithFormat:@"1"];
            [_userInfo setObject:mode forKey:@"selectedMode"];
            _selectedMode = mode;
            //NSLog(@"change to%@",_selectedMode);
        }
    }
    NSLog(@"8888888888888888888888888");
    
    
    NSObject *resultForDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:&error];
    if ([resultForDictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"77777777777777777777777777");
        
        _jsonArrayforstatus = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"jsonArrayforstatus: %@",_jsonArrayforstatus);
        NSLog(@"hisUuid = %@",[_jsonArrayforstatus objectForKey:@"hisUuid"]);
        
        if ([_jsonArrayforstatus objectForKey:@"hisUuid"]) {
            NSLog(@"666666666666666666");
            
            NSString *UrlforGet = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/History/Y2Y9k5I2337929036510785/%@",[_jsonArrayforstatus objectForKey:@"hisUuid"]];
            NSMutableURLRequest *requestforGET = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:UrlforGet]
                                                                         cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                     timeoutInterval:10];
            
            [requestforGET setHTTPMethod: @"GET"];
            [requestforGET addValue:@"2a4e0dd8db3807790d853dabf0f448de21cea6057b5dc48539330f934e9bddfb" forHTTPHeaderField:@"apiKey"] ;
            NSLog(@"15s pause");
            [NSThread sleepForTimeInterval:15];
            NSLog(@"finish 15s pause");
            NSURLConnection *connectionforGET = [[NSURLConnection alloc] initWithRequest:requestforGET delegate:self];
            if(connectionforGET){
                NSLog(@"connectionGet Successful");
            }
            else{
                NSLog(@"ConnectionGet could not be made");
            }
        }
        else if([_jsonArrayforstatus objectForKey:@"calleeReceive"]){
            
            if([[_jsonArrayforstatus objectForKey:@"calleeReceive"] boolValue] == 0){
                
                _calling = 0;
                
                NSLog(@"no answer phone : %lu",(unsigned long)_calledPhone.count);
                
                NSUInteger lastCalledPhoneIndex = _calledPhone.count-1;
                [_calledPhone removeObjectAtIndex:lastCalledPhoneIndex];
                if (_jsonArrayForTranslatorPhone.count==0 && _modeCount<1) {
                    _modeCount++;
                    NSString * selectedPickView1 = [self->langCollection objectAtIndex:[self.LangSelected1 selectedRowInComponent:0]];
                    NSString * selectedPickView2 = [self->langCollection objectAtIndex:[self.LangSelected2 selectedRowInComponent:0]];
                    NSString * time = [self getCurrentTime];
                    [self translatorList:_selectedMode lang1:selectedPickView1 lang2:selectedPickView2 currentTime:time];
                }
                else if(_jsonArrayForTranslatorPhone.count==0 && _modeCount==1){
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
        //            [_baritem1 setEnabled:TRUE];
        //            [_baritem2 setEnabled:TRUE];
                    self.view.window.userInteractionEnabled = YES;
                    
                    //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"翻譯員忙線中"
                    //                                                                    message:nil
                    //                                                                   delegate:nil
                    //                                                          cancelButtonTitle:@"確定"
                    //                                                          otherButtonTitles:nil];
                    //                    [alert show];
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"翻譯員忙線中"
                                                  message:nil
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* OKButton = [UIAlertAction
                                               actionWithTitle:@"確認"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   //Handel your yes please button action here
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                   
                                               }];
                    [alert addAction:OKButton];
                    [self presentViewController:alert animated:YES completion:nil];
                    if ([[_userInfo stringForKey:@"selectedMode"] isEqualToString:@"1"]) {
                        NSString *mode = [NSString stringWithFormat:@"0"];
                        [_userInfo setObject:mode forKey:@"selectedMode"];
                        _selectedMode = mode;
                        //NSLog(@"change to%@",_selectedMode);
                    }
                    else{
                        NSString *mode = [NSString stringWithFormat:@"1"];
                        [_userInfo setObject:mode forKey:@"selectedMode"];
                        _selectedMode = mode;
                        // NSLog(@"change to%@",_selectedMode);
                    }
                }
                else{
                    for (int i = 0; i < _jsonArrayForTranslatorPhone.count && _calling == 0; i++){
                        
                        NSDictionary *jsonElementForTranslatorPhone = _jsonArrayForTranslatorPhone[i];
                        NSUInteger index = i;
                        // Create a new location object and set its props to JsonElement properties
                        if (_calling == 0) {
                            
                            [_calledPhone addObject:jsonElementForTranslatorPhone[@"account"]];
                            
                            [self callTotranslator:jsonElementForTranslatorPhone[@"account"]];
                            [_jsonArrayForTranslatorPhone removeObjectAtIndex:index];
                        }
                    }
                }
            }
            else{
                NSLog(@"(unsigned long)_calledPhone.count = %lu",(unsigned long)_calledPhone.count);
                for (NSUInteger i=0; i<_calledPhone.count; i++) {
                    NSLog(@"[_calledPhone objectAtIndex:i] = %@\n",[_calledPhone objectAtIndex:i]);
                    
                    NSMutableArray *calledPhones = [NSMutableArray arrayWithArray:[_userInfo arrayForKey:@"calledPhones"]];
                    
                    //codeNameDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NickNameDic"] mutableCopy];
                    [calledPhones addObject:[_calledPhone objectAtIndex:i]];//0975378665
                    //------------------------11/26----------------------------------------------------------------------------------------------------------
                    int isnew =0; // 用來判斷這個打過的電話是不是已經之前就已經有打過了
                    NSMutableDictionary *codeNameDictionary = [[NSMutableDictionary alloc] initWithDictionary:[_userInfo objectForKey:@"NickNameDic"]];
                    NSString *temp = [_calledPhone objectAtIndex:i];
                    
                    
                    //                    NSInteger cnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"countForNickName"];
                    //                    NSLog(@"%ld",(long)cnt);
                    //                    if(cnt==nil){
                    //
                    //                    }
                    //                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:10];
                    //                    [dict setObject:[NSNumber numberWithInt:42] forKey:@"A cool number"];
                    //
                    //                    int myNumber = [[dict objectForKey:@"A cool number"] intValue];
                    if(codeNameDictionary.count==0){
                        NSLog(@"第一次！！ %@",temp);
                        [codeNameDictionary setObject:[NSString stringWithFormat:@"翻譯員1"] forKey:temp];
                        for(NSString * key in [codeNameDictionary allKeys]){
                            NSLog(@"~~~~~~~~~~~~fkfkfkfk");
                            NSString* value1 = [codeNameDictionary objectForKey:key];
                            NSLog(@"%@   %@",key,value1);
                        }
                        [_userInfo setInteger:1 forKey:@"countForNickName"];
                        
                    }
                    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~1");
                    
                    if(codeNameDictionary.count!=0){
                        for (NSString* key in [codeNameDictionary allKeys]) {
                            NSString* value = [codeNameDictionary objectForKey:key];
                            NSLog(@"----------測試代號1-------");
                            NSLog(@"key = %@",key);
                            NSLog(@"value = %@",value);
                            NSLog(@"-----------------------");
                            
                            // do stuff
                            if([[_calledPhone objectAtIndex:i] isEqualToString:key]){ //表示這個翻譯員之前已經有打過了
                                NSLog(@"這個翻譯員之前已經有打過了");
                                isnew =0;
                                break;
                            }
                            isnew =1;  //表示這個翻譯員之前沒打過
                        }
                    }
                    NSLog(@"isnew = %d",isnew);
                    if(isnew==1){//沒打過就要加新的代號
                        isnew = 0;
                        NSLog(@"要加新的代號的countForcodename = %ld",(long)countforcodename);
                        countforcodename++;//翻譯員代號的數字增加
                        [codeNameDictionary setObject:[NSString stringWithFormat:@"翻譯員%ld",(long)countforcodename] forKey:[_calledPhone objectAtIndex:i]];
                        [_userInfo setInteger:countforcodename forKey:@"countForNickName"];//增加完後的翻譯員代號數字也要存進去userdefault裡
                        //這邊是在做確認是否有沒有存進去
                        countforcodename = [_userInfo integerForKey:@"countForNickName"];
                        NSLog(@"確認countForNickName的數字=%ld~~~~",(long)countforcodename );
                        
                        //countforcodename++;
                        
                    }
                    //[codeNameDictionary setObject:[NSString stringWithFormat:@"翻譯員%d",countforcodename] forKey:@"0975378665"];
                    [_userInfo setObject:codeNameDictionary forKey:@"NickNameDic"];
                    codeNameDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NickNameDic"] mutableCopy];
                    NSLog(@"codeNameDictionary.count第二次 = %lu",codeNameDictionary.count);
                    for (NSString* key in [codeNameDictionary allKeys]) {
                        NSString* value = [codeNameDictionary objectForKey:key];
                        NSLog(@"----------測試代號2-------");
                        NSLog(@"key = %@",key);
                        NSLog(@"value = %@",value);
                        NSLog(@"-----------------------");
                        
                    }
                    countforcodename = [_userInfo integerForKey:@"countForNickName"];
                    NSLog(@"確認countForNickName的數字=%ld~~~~",(long)countforcodename );
                    
                    //----------------------------------------------------------------------------------------------------------------------------------
                    [_userInfo setObject:calledPhones forKey:@"calledPhones"];
                    calledPhones = [NSMutableArray arrayWithArray:[_userInfo arrayForKey:@"calledPhones"]];
                    NSLog(@"calledPhones.count:%lu",(unsigned long)calledPhones.count);
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            //    [_baritem1 setEnabled:TRUE];
             //   [_baritem2 setEnabled:TRUE];
                self.view.window.userInteractionEnabled = YES;
                
                if ([[_userInfo stringForKey:@"selectedMode"] isEqualToString:@"1"]) {
                    NSString *mode = [NSString stringWithFormat:@"0"];
                    [_userInfo setObject:mode forKey:@"selectedMode"];
                    _selectedMode = mode;
                    NSLog(@"change to%@",_selectedMode);
                }
                else{
                    NSString *mode = [NSString stringWithFormat:@"1"];
                    [_userInfo setObject:mode forKey:@"selectedMode"];
                    _selectedMode = mode;
                    NSLog(@"change to%@",_selectedMode);
                }
                [self performSegueWithIdentifier: @"langSegue" sender: self];
            }
        }
    }
    
    
}
-(void)translatorList:(NSString *)mode lang1:(NSString *)lang1 lang2:(NSString *)lang2 currentTime:(NSString *)time{
    
    NSString *post = [NSString stringWithFormat:@"&lang1=%@&lang2=%@&currentTime=%@&selectedMode=%@",lang1,lang2,time,mode];
    NSLog(@"%@ %@ %@",lang1,lang2,time);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.114.71.168/translatorPhone.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    if(conn){
        NSLog(@"Connection Successful");
        if ([[_userInfo stringForKey:@"selectedMode"] isEqualToString:@"1"]) {
            NSString *mode = [NSString stringWithFormat:@"0"];
            [_userInfo setObject:mode forKey:@"selectedMode"];
            _selectedMode = mode;
            NSLog(@"change to%@",_selectedMode);
        }
        else{
            NSString *mode = [NSString stringWithFormat:@"1"];
            [_userInfo setObject:mode forKey:@"selectedMode"];
            _selectedMode = mode;
            NSLog(@"change to%@",_selectedMode);
        }
    }
    else{
        NSLog(@"Connection could not be made");
    }
}
-(void)callTotranslator:(NSString *)translatorPhone{
    NSString *jsonPostBody = [NSString stringWithFormat:@"{\"caller\":\"%@\",\"callee\":\"%@\"}",[translatorPhone stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[_userInfo stringForKey:@"account"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *postData = [jsonPostBody dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSLog(@"Json: %@",jsonPostBody);
    NSURL *url = [NSURL URLWithString: @"https://ts.kits.tw/projectLYS/v0/Call/test01/generalCallRequest"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:180.0];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*pass the api key*/
    [request addValue:@"2a4e0dd8db3807790d853dabf0f448de21cea6057b5dc48539330f934e9bddfb" forHTTPHeaderField:@"apiKey"] ;
    
    NSURLConnection *connectionCall = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"post to call api");
    if(connectionCall){
        NSLog(@"connectionCall Successful");
    }
    else
    {
        NSLog(@"connectionCall could not be made");
    }
    // add calling to 1
    _calling = 1;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"langSegue"]) {
        
        id targetViewController = segue.destinationViewController;
        [targetViewController setValue:[self->langCollection objectAtIndex:[self.LangSelected1 selectedRowInComponent:0]] forKey:@"lang1"];
        [targetViewController setValue:[self->langCollection objectAtIndex:[self.LangSelected2 selectedRowInComponent:0]] forKey:@"lang2"];
        
    }
}

- (BOOL)checkForNetwork
{
    // check if we've got network connectivity
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    
    switch (myStatus) {
        case NotReachable:
            NSLog(@"There's no internet connection at all. Display error message now.");
            [TSMessage showNotificationWithTitle:@"無法連線上網!"
                                        subtitle:@"請確認已連上網路"
                                            type:TSMessageNotificationTypeError];
            return NO;
            
            break;
            
        case ReachableViaWWAN:
            NSLog(@"We have a 3G connection");
            return YES;
            break;
            
        case ReachableViaWiFi:
            NSLog(@"We have WiFi.");
            return YES;
            break;
            
        default:
            break;
    }
}
@end
