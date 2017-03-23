//
//  ViewController.m
//  translatorApp
//
//  Created by Yao on 2015/4/16.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import "ViewController.h"


@interface ViewController (){
    NSMutableData *_downloadedData;
    int checkfortranslator;
    
}

@end

@implementation ViewController
@synthesize userAccount = _userAccount;
@synthesize userPassword = _userPassword;
//@synthesize instance = _instance;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    checkfortranslator = 0;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    
    
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    self.userPassword.secureTextEntry = YES;
    
    
}

- (IBAction)signUp:(id)sender {
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://140.114.71.168:8080/cloud/member.html"]];
    //    NSLog(@"測試超連結");
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    
    
    [self.userAccount resignFirstResponder];
    [self.userPassword resignFirstResponder];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initView{
    //1
    //2
    self.userAccount.delegate = self;
    self.userPassword.delegate = self;
    //3
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



- (void)downloadItems
{
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://140.114.71.168/translatorLogin.php"];
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}
- (void)checkForTranslator
{
    checkfortranslator = 1;
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://140.114.71.168/TranslatorCheck.php"];
    
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
    NSLog(@"checkfortranslator = %d",checkfortranslator);
    // Create an array to store the locations
    //   NSMutableArray *_locations = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    // Loop through Json objects, create question objects and add them to our questions array
    if(checkfortranslator!=1){
        for (int i = 0; i < jsonArray.count; i++){
            
            NSDictionary *jsonElement = jsonArray[i];
            NSLog(@"account:%@ password: %@",jsonElement[@"account"],jsonElement[@"pwd"]);

            // Create a new location object and set its props to JsonElement properties
            
            if ([self.userAccount.text isEqualToString:jsonElement[@"account"]] && [self.userPassword.text isEqualToString:jsonElement[@"pwd"]  ]) {
                NSLog(@"%d",i);
                self->loginState = YES;
                [self saveNSUserDefaults];
                //            [self readNSUserDefaults];
                break;
            }
            // Add this question to the locations array
            
        }
        if (!self->loginState) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登入錯誤"
                                                            message:@"帳號或密碼有誤"
                                                           delegate:nil
                                                  cancelButtonTitle:@"確定"
                                                  otherButtonTitles:nil];
            [alert show];
            self.view.window.userInteractionEnabled = YES;
            
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.view.window.userInteractionEnabled = YES;
            
            [self performSegueWithIdentifier: @"loginSegue" sender: self];
            //        NSLog(@"%d %@ %@",instance.loginState,instance.userAccount,instance.userPassword);
        }
    }else if(checkfortranslator==1){
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSError *error;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
        // Loop through Json objects, create question objects and add them to our questions array
        for (int i = 0; i < jsonArray.count; i++){
            NSDictionary *jsonElement = jsonArray[i];
            
            // Create a new location object and set its props to JsonElement properties
            NSLog(@"acount = %@ ",jsonElement[@"account"]);
            if ([self.userAccount.text isEqualToString:jsonElement[@"account"]]) {
                [userInfo setBool:YES forKey:@"isTranslator"];
                break;
            }else{
                if(i == jsonArray.count -1){
                    [userInfo setBool:NO forKey:@"isTranslator"];
                }
            }
        }
        checkfortranslator = 0;
    }
    
    // Ready to notify delegate that data is ready and pass back items
    //    if (self.delegate)
    //    {
    //        [self.delegate itemsDownloaded:_locations];
    //    }
}

-(void)saveNSUserDefaults{
    
    NSString * selectedMode = [NSString stringWithFormat:@"1"];
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setObject:self.userAccount.text forKey:@"account"];
    [userInfo setObject:self.userPassword.text forKey:@"password"];
    [userInfo setObject:selectedMode forKey:@"selectedMode"];
    [userInfo setBool:YES forKey:@"loginState"];
    
    [userInfo synchronize];
}

-(void)readNSUserDefaults{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString * account = [userInfo stringForKey:@"account"];
    NSString * password = [userInfo stringForKey:@"password"];
    BOOL login = [userInfo boolForKey:@"loginState"];
    NSLog(@"%@ %@ %d //loginView",account,password,login);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        //     NSLog(@"4");
        //        ViewController * globalUser = [ViewController sharedInstance];
        //        instance = [[User alloc]initWithAccount:self.userAccount.text userPassword:self.userPassword.text loginState:true];
        //        id targetViewController = segue.destinationViewController;
        //        [targetViewController setValue:instance forKey:@"instance"];
    }
    
}


- (IBAction)userLogin:(id)sender {
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.dimBackground = YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    HUD.labelText = @"登入中..";
    if(self.userAccount.text.length==0||self.userPassword.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登入錯誤"
                                                        message:@"帳號或密碼有誤"
                                                       delegate:nil
                                              cancelButtonTitle:@"確定"
                                              otherButtonTitles:nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    else{
        //self.view.window.userInteractionEnabled = NO;
        
        [self checkForTranslator];
        [self downloadItems];
    }
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 200; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


@end
