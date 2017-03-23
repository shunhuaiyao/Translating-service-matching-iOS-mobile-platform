//
//  historyViewController.m
//  translatorApp
//
//  Created by Yao on 2015/5/5.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import "historyViewController.h"
#import "translatorTabViewController.h"
#import "callHistoryCell.h"
#import "TSMessage.h"


@interface historyViewController (){
    NSString *PhoneNumber;
    NSString *lang1;
    NSString *lang2;
    NSUserDefaults *_userInfo;
   // UIBarItem * _baritem1;
  //  UIBarItem * _baritem2;
    NSUInteger translatorCount;
    int ischecking ;
    int isFree ;
    
}

@end

@implementation historyViewController
@synthesize currentTime= _currentTime;

@synthesize calledPhones = _calledPhones;
@synthesize historyTime = _historyTime;
@synthesize historyImage = _historyImage;
@synthesize responseData = _responseData;
@synthesize jsonArrayforstatus = _jsonArrayforstatus;
@synthesize reverseCountryArray = _reverseCountryArray;
@synthesize reverseTimeArray = _reverseTimeArray;
@synthesize reversePhoneNumberArray = _reversePhoneNumberArray;
@synthesize historyList = _historyList;

- (void)viewDidLoad {
    [super viewDidLoad];
    ischecking = 0;
    
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    translatorTabViewController *tabBar = (translatorTabViewController *)self.tabBarController;
    
    NSLog(@"tab %lu",(unsigned long)[tabBar.viewControllers indexOfObject:self]);
    _userInfo = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@ %@ %d // historyController",[_userInfo stringForKey:@"account"],[_userInfo stringForKey:@"password"],[_userInfo boolForKey:@"loginState"]);
    
    _calledPhones = [NSMutableArray arrayWithArray:[_userInfo arrayForKey:@"calledPhones"]];   //裡面存已打過的翻譯員電話
    _historyTime = [NSMutableArray arrayWithArray:[_userInfo arrayForKey:@"historyTime"]];
    _historyImage = [NSMutableArray arrayWithArray:[_userInfo arrayForKey:@"historyImage"]];
    
    _historyList = [[NSMutableArray alloc]init];// //裡面存已打過的翻譯員代號
    
    /**
     新的algo 開始
     **/
    //    translatorCount =1;
    //    if (_calledPhones.count!=0) {
    //        NSString *temp1 = [NSString stringWithFormat:@"翻譯員 %lu",(unsigned long)translatorCount];
    //        [_historyList addObject:temp1];
    //
    //    }
    //------------------------------------------------------11/21新加 超過20組要刪掉
    NSLog(@"_calledPhones現在裡面有%lu個",_calledPhones.count);
    if(_calledPhones.count>20){
        unsigned long remove_count = _calledPhones.count - 20;
        NSLog(@"%lu",remove_count);
        for (int i = 0; i<remove_count; i++) {
            [_calledPhones removeObjectAtIndex:i];
            [_userInfo setObject:_calledPhones forKey:@"calledPhones"];
            
            [_historyImage removeObjectAtIndex:i];
            [_userInfo setObject:_historyImage forKey:@"historyImage"];
            
            
            [_historyTime removeObjectAtIndex:i];
            [_userInfo setObject:_historyTime forKey:@"historyTime"];
            
        }
        NSLog(@"刪完後_calledPhones現在裡面有%lu個",_calledPhones.count);
        
    }
    
    //------------------------------------------------------11/21新加 超過20組要刪掉
    //--------------------------------------------11/27新加------------------最新的顯示翻譯員代號的algo
    //  NSMutableArray *test = [[NSMutableArray alloc]init];
    
    //int countforcodename = [_userInfo integerForKey:@"countForNickName"];  //去userdefault拿現在翻譯員代號到幾號
    // NSMutableArray *_calledPhones1 = [NSMutableArray arrayWithArray:[_userInfo arrayForKey:@"calledPhones"]];   //裡面存已打過的翻譯員電話
    
    NSMutableDictionary *codeNameDictionary = [[NSMutableDictionary alloc] initWithDictionary:[_userInfo objectForKey:@"NickNameDic"]];
    // NSMutableDictionary *codeNameDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NickNameDic"] mutableCopy]; // 將要用來比對翻譯員代號的dictionary拿出來
    
    NSLog(@"codeNameDictionary.count in 通話紀錄 = %lu",codeNameDictionary.count);
    //         for (NSString* key in [codeNameDictionary allKeys]) {
    //             NSString* value = [codeNameDictionary objectForKey:key];
    //
    //             NSLog(@"----------測試代號in通話紀錄-------");
    //             NSLog(@"key = %@",key);
    //             NSLog(@"value = %@",value);
    //             NSLog(@"-----------------------");
    //
    //             for(int i = 0; i < _calledPhones1.count ; i++){ //將calledPhones與dictionary裡面的代號比對
    //                NSLog(@"[_calledPhones1 objectAtIndex:%d] = %@",i,[_calledPhones1 objectAtIndex:i]);
    //
    //                if([ [_calledPhones1 objectAtIndex:i] isEqualToString: key ]){ //若是相等的話就要再創一個專門用來顯示在通話紀錄上的array：翻譯員1 翻譯員2之類的
    //                    [test addObject:value];
    //                    break;
    //                }
    //                else{
    //                    NSLog(@"不一樣的key = %@ ",key);
    //                }
    //             }
    //        }
    
    for(int i = 0; i < _calledPhones.count ; i++){ //將calledPhones與dictionary裡面的代號比對
        NSLog(@"[_calledPhones objectAtIndex:%d] = %@",i,[_calledPhones objectAtIndex:i]);
        for (NSString* key in [codeNameDictionary allKeys]) {
            NSString* value = [codeNameDictionary objectForKey:key];
            
            NSLog(@"----------測試代號in通話紀錄-------");
            NSLog(@"key = %@",key);
            NSLog(@"value = %@",value);
            NSLog(@"-----------------------");
            if([ [_calledPhones objectAtIndex:i] isEqualToString: key ]){ //若是相等的話就要再創一個專門用來顯示在通話紀錄上的array：翻譯員1 翻譯員2之類的
                [_historyList addObject:value];
                break;
            }
            else{
                NSLog(@"不一樣的key = %@ ",key);
            }
        }
    }
    NSLog(@"_historyList.count = %lu",_historyList.count);
    for(int i =0 ; i<_historyList.count;i++){
        NSLog(@"_historyList[%d] = %@",i,[_historyList objectAtIndex:i]);
    }
    
    
    
    // ---------------------------------------------------------------------------------------------
    //    for (NSUInteger i = 1; i < _calledPhones.count; i++) {
    //        for (NSUInteger j =0; j < i ; j++) {
    //            if([_historyList objectAtIndex:j]==nil){
    //                NSLog(@" historyList 沒東西");
    //            }
    //            else if([_historyList objectAtIndex:j]!=nil){
    //
    //                if([[_calledPhones objectAtIndex:i]isEqualToString:[_calledPhones objectAtIndex:j]]){
    //                    [_historyList addObject:[_historyList objectAtIndex:j]];
    //                    break;
    //                }
    //                else if ([[_calledPhones objectAtIndex:i]isEqualToString:[_calledPhones objectAtIndex:j]]==false && j!=i-1){
    //
    //                    continue;
    //                }
    //                else if ([[_calledPhones objectAtIndex:i]isEqualToString:[_calledPhones objectAtIndex:j]]==false && j==i-1){
    //
    //                    translatorCount  = (translatorCount + 1);
    //                    [_historyList addObject:[NSString stringWithFormat:@"翻譯員 %lu",(unsigned long)translatorCount]];
    //                    break;
    //                }
    //
    //            }
    //        }
    //    }
    _reversePhoneNumberArray = [NSMutableArray arrayWithArray:[[_historyList reverseObjectEnumerator] allObjects]];
    _reverseCountryArray = [NSMutableArray arrayWithArray:[[_historyImage reverseObjectEnumerator] allObjects] ];
    _reverseTimeArray = [NSMutableArray arrayWithArray:[[_historyTime reverseObjectEnumerator] allObjects]];
    
   // _baritem1 = [tabBar.tabBar.items objectAtIndex:[tabBar.viewControllers indexOfObject:self]];
  //  _baritem2 = [tabBar.tabBar.items objectAtIndex:[tabBar.viewControllers indexOfObject:self]-1];
    
    [self.historyTable setEditing:NO animated:YES];
    [self.historyTable registerNib:[UINib nibWithNibName:@"callHistoryCell" bundle:nil] forCellReuseIdentifier:@"historyCell"];
    //    NSLog(@"%lu",(unsigned long)_historyImage.count);
    //    for(int i = 0 ; i < _historyImage.count; i++){
    //        NSLog(@"[%d] = %@",i,[_historyImage objectAtIndex:i]);
    //    }
    //    NSLog(@"===============================");
    //    NSLog(@"%lu",(unsigned long)_reverseCountryArray.count);
    //
    //    for(int i = 0 ; i < _reverseCountryArray.count; i++){
    //        NSLog(@"[%d] = %@",i,[_reverseCountryArray objectAtIndex:i]);
    //    }
    //
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


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"~~~~~~~~~~~還沒刪除~~~~~~~~~~~~~~~~~~~~");
    //    NSLog(@"%lu",(unsigned long)_historyImage.count);
    //    for(int i = 0 ; i < _historyImage.count; i++){
    //        NSLog(@"[%d] = %@",i,[_historyImage objectAtIndex:i]);
    //    }
    //    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    //    NSLog(@"%lu",(unsigned long)_reverseCountryArray.count);
    
    //    for(int i = 0 ; i < _reverseCountryArray.count; i++){
    //        NSLog(@"[%d] = %@",i,[_reverseCountryArray objectAtIndex:i]);
    //    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_calledPhones removeObjectAtIndex:_reversePhoneNumberArray.count - indexPath.row-1];
        [_userInfo setObject:_calledPhones forKey:@"calledPhones"];
        
        [_historyList removeObjectAtIndex:_reversePhoneNumberArray.count - indexPath.row-1];
        
        [_historyTime removeObjectAtIndex:_reversePhoneNumberArray.count - indexPath.row-1];
        [_userInfo setObject:_historyTime forKey:@"historyTime"];
        
        [_historyImage removeObjectAtIndex:_reversePhoneNumberArray.count - indexPath.row-1];
        [_userInfo setObject:_historyImage forKey:@"historyImage"];
        [_reversePhoneNumberArray removeObjectAtIndex:indexPath.row];
        [_reverseCountryArray removeObjectAtIndex:indexPath.row];
        [_reverseTimeArray removeObjectAtIndex:indexPath.row];
        //        NSLog(@"----------刪除後---------------------");
        //        NSLog(@"%lu",(unsigned long)_historyImage.count);
        //        for(int i = 0 ; i < _historyImage.count; i++){
        //            NSLog(@"[%d] = %@",i,[_historyImage objectAtIndex:i]);
        //        }
        //        NSLog(@"-------------------------------");
        //        NSLog(@"%lu",(unsigned long)_reverseCountryArray.count);
        //
        //        for(int i = 0 ; i < _reverseCountryArray.count; i++){
        //            NSLog(@"[%d] = %@",i,[_reverseCountryArray objectAtIndex:i]);
        //        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_historyList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"historyCell";
    
    callHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[callHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    if (_historyList.count!=0) {
        cell.translatorName.text = [_reversePhoneNumberArray objectAtIndex:(indexPath.row)];
        cell.translatorImage.image = [UIImage imageNamed:[_reverseCountryArray objectAtIndex:(indexPath.row)]];
        cell.time.text = [_reverseTimeArray objectAtIndex:(indexPath.row)];
        
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self checkForNetwork]) {
        
        NSUInteger phoneNumberIndex =(unsigned long)(_reversePhoneNumberArray.count - indexPath.row-1);
        PhoneNumber =[_calledPhones objectAtIndex:phoneNumberIndex];
        NSLog(@"_historyImage.count - indexPath.row-1 = %lu ",_historyImage.count - indexPath.row-1);
        
        if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"thai_taiwan.png"]) {
            lang1 = [NSString stringWithFormat:@"Thai"];
            lang2 = [NSString stringWithFormat:@"Chinese"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"thai_english.png"]){
            lang1 = [NSString stringWithFormat:@"Thai"];
            lang2 = [NSString stringWithFormat:@"English"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"thai_japan.png"]){
            lang1 = [NSString stringWithFormat:@"Thai"];
            lang2 = [NSString stringWithFormat:@"Japanese"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"taiwan_english.png"]){
            lang1 = [NSString stringWithFormat:@"English"];
            lang2 = [NSString stringWithFormat:@"Chinese"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"taiwan_japan.png"]){
            lang1 = [NSString stringWithFormat:@"Japanese"];
            lang2 = [NSString stringWithFormat:@"Chinese"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"english_japan.png"]){
            lang1 = [NSString stringWithFormat:@"English"];
            lang2 = [NSString stringWithFormat:@"Japanese"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"taiwanese_hakka.png"]){
            lang1 = [NSString stringWithFormat:@"Taiwanese"];
            lang2 = [NSString stringWithFormat:@"Hakka"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"thai_hakka.png"]){
            lang1 = [NSString stringWithFormat:@"Thai"];
            lang2 = [NSString stringWithFormat:@"Hakka"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"thai_taiwanese.png"]){
            lang1 = [NSString stringWithFormat:@"Thai"];
            lang2 = [NSString stringWithFormat:@"Taiwanese"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"english_hakka.png"]){
            lang1 = [NSString stringWithFormat:@"English"];
            lang2 = [NSString stringWithFormat:@"Hakka"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"english_taiwanese.png"]){
            lang1 = [NSString stringWithFormat:@"English"];
            lang2 = [NSString stringWithFormat:@"Taiwanese"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"japanese_hakka.png"]){
            lang1 = [NSString stringWithFormat:@"Japanese"];
            lang2 = [NSString stringWithFormat:@"Hakka"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"japanese_taiwanese.png"]){
            lang1 = [NSString stringWithFormat:@"Japanese"];
            lang2 = [NSString stringWithFormat:@"Taiwanese"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"chinese_hakka.png"]){
            lang1 = [NSString stringWithFormat:@"Chinese"];
            lang2 = [NSString stringWithFormat:@"Hakka"];
        }
        else if ([[_historyImage objectAtIndex:_historyImage.count - indexPath.row-1] isEqualToString:@"chinese_taiwanese.png"]){
            lang1 = [NSString stringWithFormat:@"Chinese"];
            lang2 = [NSString stringWithFormat:@"Taiwanese"];
        }
        
        [self getCurrentTime];
        
        
        
        
        NSLog(@"現在時間: %@  lang1 = %@  lang2 = %@ phone number = %@",_currentTime,lang1,lang2,PhoneNumber);
        ischecking =1;
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"是否要撥打給此翻譯員？"
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* OKButton = [UIAlertAction
                                   actionWithTitle:@"是"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel your yes please button action here
                                       HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                       HUD.dimBackground = YES;
                                       HUD.mode = MBProgressHUDModeIndeterminate;
                                       //HUD.labelText = @"搜尋中...";
                                       
                                       //                                       [_baritem1 setEnabled:FALSE];
                                       //                                       [_baritem2 setEnabled:FALSE];
                                       self.view.window.userInteractionEnabled = NO;
                                       [self CheckisFree:lang1 lang2:lang2 currentTime:_currentTime];
                                       //[self callTotranslator:PhoneNumber];
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"否"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        
        [alert addAction:noButton];
        [alert addAction:OKButton];
        [self presentViewController:alert animated:YES completion:nil];
        // [self callTotranslator:[_calledPhones objectAtIndex:indexPath.row]];
    }
    
}
//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"Phone Number in alertView = %@",PhoneNumber);
//    switch (buttonIndex) {
//        case 0:
//            break;
//        case 1:
//            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            HUD.dimBackground = YES;
//            HUD.mode = MBProgressHUDModeIndeterminate;
//            HUD.labelText = @"Calling";
//
//            [_baritem1 setEnabled:FALSE];
//            [_baritem2 setEnabled:FALSE];
//            self.view.window.userInteractionEnabled = NO;
//
//            [self callTotranslator:PhoneNumber];
//
//            NSLog(@"++++++++++++按下鍵後+++++++++++++++++++");
//            NSLog(@"%lu",(unsigned long)_historyImage.count);
//            for(int i = 0 ; i < _historyImage.count; i++){
//                NSLog(@"[%d] = %@",i,[_historyImage objectAtIndex:i]);
//            }
//            NSLog(@"+++++++++++++++++++++++++++++++");
//            NSLog(@"%lu",(unsigned long)_reverseCountryArray.count);
//
//            for(int i = 0 ; i < _reverseCountryArray.count; i++){
//                NSLog(@"[%d] = %@",i,[_reverseCountryArray objectAtIndex:i]);
//            }
//
//            break;
//        default:
//            break;
//
//    }
//
//}

-(void)callTotranslator:(NSString *)translatorPhone{
    NSString *jsonPostBody = [NSString stringWithFormat:@"{\"caller\":\"%@\",\"callee\":\"%@\"}",[translatorPhone stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[_userInfo stringForKey:@"account"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *postData = [jsonPostBody dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSURL *url = [NSURL URLWithString: @"https://ts.kits.tw/projectLYS/v0/Call/test01/generalCallRequest"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:180.0];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*pass the api key*/
    [request addValue:@"2a4e0dd8db3807790d853dabf0f448de21cea6057b5dc48539330f934e9bddfb" forHTTPHeaderField:@"apiKey"] ;
    
    NSURLConnection *connectionCall = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(connectionCall){
        NSLog(@"connectionCall Successful");
    }
    else
    {
        NSLog(@"connectionCall could not be made");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
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
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"ischecking in connection!! = %d",ischecking);
    NSError *error;
    NSDictionary *resultForDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:&error];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:&error];
    if (ischecking==0) {
        
        
        if ([resultForDictionary isKindOfClass:[NSDictionary class]]) {
            
            _jsonArrayforstatus = resultForDictionary;
            
            // NSLog(@"jsonArrayforstatus: %@",_jsonArrayforstatus);
            //NSLog(@"hisUuid = %@",[_jsonArrayforstatus objectForKey:@"hisUuid"]);
            
            if ([_jsonArrayforstatus objectForKey:@"hisUuid"]) {
                NSString *UrlforGet = [NSString stringWithFormat:@"https://ts.kits.tw/projectLYS/v0/History/Y2Y9k5I2337929036510785/%@",[_jsonArrayforstatus objectForKey:@"hisUuid"]];
                NSMutableURLRequest *requestforGET = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:UrlforGet]
                                                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                         timeoutInterval:10];
                
                [requestforGET setHTTPMethod: @"GET"];
                [requestforGET addValue:@"2a4e0dd8db3807790d853dabf0f448de21cea6057b5dc48539330f934e9bddfb" forHTTPHeaderField:@"apiKey"] ;
                // NSLog(@"35s pause");
                [NSThread sleepForTimeInterval:15];
                //NSLog(@"finish 35s pause");
                NSURLConnection *connectionforGET = [[NSURLConnection alloc] initWithRequest:requestforGET delegate:self];
                if(connectionforGET){
                    NSLog(@"connectionGet Successful");
                }
                else{
                    NSLog(@"ConnectionGet could not be made");
                }
            }
            else if([_jsonArrayforstatus objectForKey:@"calleeReceive"]){
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
              //  [_baritem1 setEnabled:TRUE];
              //  [_baritem2 setEnabled:TRUE];
                self.view.window.userInteractionEnabled = YES;
                
                if([[_jsonArrayforstatus objectForKey:@"calleeReceive"] boolValue] == 1){
                    
                    
                    [_calledPhones addObject:PhoneNumber];
                    //NSLog(@"count:%lu",(unsigned long)_calledPhones.count);
                    [_userInfo setObject:_calledPhones forKey:@"calledPhones"];
                    _calledPhones = [NSMutableArray arrayWithArray:[_userInfo arrayForKey:@"calledPhones"]];
                    //NSLog(@"calledPhones.count:%lu",(unsigned long)_calledPhones.count);
                    
                    
                    [self performSegueWithIdentifier: @"hisSegue" sender: self];
                }
                else{
                    
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
                    
                    
                }
            }
        }
    }
    else if (ischecking==1){
        ischecking=0;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *test = @"0975378665";
        NSLog(@"~~~~%lu",(unsigned long)jsonArray.count);
        if(jsonArray.count==0){
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"非此翻譯員服務時段"
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
            self.view.window.userInteractionEnabled = YES;
            
        }
        for (int i = 0; i < jsonArray.count; i++){
            NSDictionary *jsonElement = jsonArray[i];
            
            // Create a new location object and set its props to JsonElement properties
            NSLog(@"acount = %@ ",jsonElement[@"account"]);
            if ([PhoneNumber isEqualToString:jsonElement[@"account"]]) {
                
                HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                HUD.dimBackground = YES;
                HUD.mode = MBProgressHUDModeIndeterminate;
                HUD.labelText = @"通話中...";
                
            //    [_baritem1 setEnabled:FALSE];
            //    [_baritem2 setEnabled:FALSE];
                self.view.window.userInteractionEnabled = NO;
                //[self CheckisFree:lang1 lang2:lang2 currentTime:_currentTime];
                [self callTotranslator:PhoneNumber];
                
                NSLog(@"跟資料庫第%d個重複了！",i);
                break;
            }else if(i == jsonArray.count-1){
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"目前非此翻譯員服務時段"
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
                self.view.window.userInteractionEnabled = YES;
                
                
            }
        }
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
            [TSMessage showNotificationWithTitle:@"No Connection!"
                                        subtitle:@"Make sure to connect to the Internet"
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
-(NSString *) getCurrentTime {
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    _currentTime = [dateFormatter stringFromDate:now];
    NSLog(@"%@",_currentTime);
    return _currentTime;
}
-(void)CheckisFree:(NSString *)lang1 lang2:(NSString *)lang2 currentTime:(NSString *)time{
    
    NSString *post = [NSString stringWithFormat:@"&lang1=%@&lang2=%@&currentTime=%@",lang1,lang2,time];
    //NSLog(@"測試看看呦～%@ %@ %@",lang1,lang2,time);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.114.71.168/CheckisFree.php"]]];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"hisSegue"]) {
        
        id targetViewController = segue.destinationViewController;
        [targetViewController setValue:lang1 forKey:@"lang1"];
        [targetViewController setValue:lang2 forKey:@"lang2"];
        
    }
}

@end
