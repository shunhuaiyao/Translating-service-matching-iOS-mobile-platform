//
//  RegisterViewController.m
//  translatorApp
//
//  Created by Yao on 2015/9/18.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import "RegisterViewController.h"
#import "translatorTabViewController.h"
#import "NBPhoneNumberUtil.h"
#import "NBPhoneNumber.h"

#define kOFFSET_FOR_KEYBOARD 80.0
@interface RegisterViewController (){
    NSMutableData *_downloadedData;
    int isrepeat;
    int registerisdone;
    NSLocale *countryLocale ;
    NSString *countryCode;
    NSString *country ;
    NSString *CorrectPhoneNumber;

}@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isrepeat = 0;
    registerisdone = 0;
    // Do any additional setup after loading the view.
    translatorTabViewController *tabBarController = (translatorTabViewController *)self.tabBarController;
    [tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:NO animated:NO];
    self.navigationItem.backBarButtonItem.title = @"Setting";
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    
    
    tapGr.cancelsTouchesInView = NO;
    
    
    [self.view addGestureRecognizer:tapGr];
    countryLocale = [NSLocale currentLocale];
    countryCode = [countryLocale objectForKey:NSLocaleCountryCode];
    country = [countryLocale displayNameForKey:NSLocaleCountryCode value:countryCode];

    
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    
    
    [self.RegisterName resignFirstResponder];
    [self.RegisterPassWord resignFirstResponder];
    [self.RegisterPassWord2 resignFirstResponder];
    [self.RegisterMail resignFirstResponder];
    [self.RegisterMail2 resignFirstResponder];
    [self.RegisterPhone resignFirstResponder];
    
    
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


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        translatorTabViewController *tabBarController = (translatorTabViewController *)self.tabBarController;
        [tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationItem setHidesBackButton:NO animated:YES];
        NSLog(@"back");
        
    }
    [super viewWillDisappear:animated];
}



- (IBAction)Registration:(id)sender {
    NSLog(@"--------正在填東西--------");
    if (self.RegisterName.text.length == 0 || self.RegisterPhone.text.length == 0 || self.RegisterPassWord.text.length == 0 || self.RegisterPassWord2.text.length == 0 || self.RegisterMail.text.length == 0 || self.RegisterMail2.text.length == 0)
    {
        NSLog(@"有少填東西");
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"錯誤"
                                      message:@"請輸入完整資料"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* OKButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel your yes please button action here
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        [alert addAction:OKButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        NSLog(@"有東西");
        if (self.RegisterPassWord.text.length>=6 && self.RegisterPassWord.text.length>=6 && self.RegisterPhone.text.length==10){
            //密碼長度超過6 手機長度等於10
            if ([self.RegisterPassWord2.text isEqualToString:self.RegisterPassWord.text] ) {//密碼正確
                NSLog(@"密碼正確");
                if ([self.RegisterMail2.text isEqualToString:self.RegisterMail.text]) {//密碼正確且信箱正確----->要檢查是否帳號重複
                    NSLog(@"信箱正確");
                    
                    [self downloadItems];
                    NSLog(@"=======%d",isrepeat);
                    
                }
                else{                                                                   //密碼正確但信箱錯誤
                    NSLog(@"信箱錯誤");
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"信箱錯誤" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"錯誤"
                                                  message:@"信箱錯誤"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* OKButton = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   //Handel your yes please button action here
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                   
                                               }];
                    [alert addAction:OKButton];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }else{                                                                          //密碼錯誤
                NSLog(@"密碼錯誤");
                if ([self.RegisterMail2.text isEqualToString:self.RegisterMail.text] ) {
                    NSLog(@"信箱正確");
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"密碼錯誤" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"錯誤"
                                                  message:@"密碼錯誤"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* OKButton = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   //Handel your yes please button action here
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                   
                                               }];
                    [alert addAction:OKButton];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }else{                                                                      //密碼錯誤且信箱錯誤
                    NSLog(@"密碼信箱錯誤");
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"密碼以及信箱錯誤" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"錯誤"
                                                  message:@"密碼以及信箱錯誤"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* OKButton = [UIAlertAction
                                               actionWithTitle:@"OK"
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
        }else if(self.RegisterPassWord.text.length<6 && self.RegisterPassWord.text.length<6 && self.RegisterPhone.text.length==10){
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"密碼至少要6碼" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"錯誤"
                                          message:@"密碼至少為6碼"
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* OKButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           //Handel your yes please button action here
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
            [alert addAction:OKButton];
            [self presentViewController:alert animated:YES completion:nil];

            
        }else if(self.RegisterPassWord.text.length>=6 && self.RegisterPassWord.text.length>=6 && self.RegisterPhone.text.length!=10){
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"請填入完整手機號碼" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"錯誤"
                                          message:@"請填入完整手機號碼"
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* OKButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           //Handel your yes please button action here
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
            [alert addAction:OKButton];
            [self presentViewController:alert animated:YES completion:nil];

            
        }else if(self.RegisterPassWord.text.length<6 && self.RegisterPassWord.text.length<6 && self.RegisterPhone.text.length!=10) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"請填入完整手機號碼以及密碼" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"錯誤"
                                          message:@"請填入完整手機號碼以及密碼"
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* OKButton = [UIAlertAction
                                       actionWithTitle:@"OK"
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
-(void)PostToPhp:(NSString *)Phone :(NSString*)PassWord :(NSString*)Name :(NSString*)Email{
    NSLog(@"Phone為:\%@ PassWord為%@",Phone,PassWord);
    NSString *post = [NSString stringWithFormat:@"&PhoneNumber=\%@&PassWord=%@&Name=%@&Email=%@",Phone,PassWord,Name,Email];
    NSLog(@"POST 的帳號密碼為 : %@",post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.114.71.168/Registration.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(conn){
        NSLog(@"Connection Successful~~~~~");
    }
    else{
        NSLog(@"Connection could not be made~~~~~");
    }
    
}

- (IBAction)CheckForRepeatAccount:(id)sender {
    if (self.RegisterPhone.text.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤"
//                                                        message:@"請填入完整手機號碼"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"錯誤"
                                      message:@"請填入完整手機號碼"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* OKButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel your yes please button action here
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        [alert addAction:OKButton];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self downloadItems];
    }
    
}

//拿來檢查帳號是否重複
- (void)downloadItems
{
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://140.114.71.168/RegisterCheck.php"];
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [_downloadedData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create an array to store the locations
    //   NSMutableArray *_locations = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    /*這邊要做的就是把電話號碼加上國碼，變成CorrectPhoneNumber，完成過後就post到php來做註冊的動作*/
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:self.RegisterPhone.text
                                 defaultRegion:countryCode error:&anError];
    NSString *tempCorrectPhoneNumber;
    if (anError == nil) {
        // E164          : +436766077303
        tempCorrectPhoneNumber = [phoneUtil format:myNumber numberFormat:NBEPhoneNumberFormatE164 error:&anError];
        CorrectPhoneNumber = [tempCorrectPhoneNumber
                                         stringByReplacingOccurrencesOfString:@"+" withString:@""];
        NSLog(@"要檢查的的電話帳號為%@", CorrectPhoneNumber);
        
    } else {
        NSLog(@"Error : %@", [anError localizedDescription]);
    }
    
    for (int i = 0; i < jsonArray.count; i++){
        
        NSDictionary *jsonElement = jsonArray[i];
        
        // Create a new location object and set its props to JsonElement properties
        NSLog(@"acount = %@ ",jsonElement[@"account"]);
        if ([tempCorrectPhoneNumber isEqualToString:jsonElement[@"account"]]) {
            
            NSLog(@"跟資料庫第%d個重複了！",i);
            isrepeat = 1;
            break;
        }else{
            isrepeat = 0;
        }
    }
    if(registerisdone==0){
        if(isrepeat==1){
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"帳號重複"
//                                                        message:@"已有他人使用此帳號"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"確定"
//                                              otherButtonTitles:nil];
//            [ alert show];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"帳號重複"
                                          message:@"帳號已被使用過"
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* OKButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           //Handel your yes please button action here
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
            [alert addAction:OKButton];
            [self presentViewController:alert animated:YES completion:nil];
        
        }
        else if(isrepeat==0){
            registerisdone =1;
            NSString *alertMessage = [NSString stringWithFormat:@"+%@",CorrectPhoneNumber];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Your Account is"
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* OKButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           //Handel your yes please button action here
                                           [self performSegueWithIdentifier: @"doneRegistration" sender: self];
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
            [alert addAction:OKButton];
            [self presentViewController:alert animated:YES completion:nil];
            [self PostToPhp:CorrectPhoneNumber :self.RegisterPassWord.text :self.RegisterName.text :self.RegisterMail.text];
            
        }
    }

    NSLog(@"isrepeat = %d",isrepeat);
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self animateTextField: textField up: YES];
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self animateTextField: textField up: NO];
//}
//
//- (void) animateTextField: (UITextField*) textField up: (BOOL) up
//{
//    const int movementDistance = 150; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    
//    int movement = (up ? -movementDistance : movementDistance);
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
