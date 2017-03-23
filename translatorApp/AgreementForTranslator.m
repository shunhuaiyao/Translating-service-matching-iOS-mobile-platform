//
//  AgreementForTranslator.m
//  translatorApp
//
//  Created by 歐博文 on 2015/10/6.
//  Copyright © 2015年 Yao. All rights reserved.
//

#import "AgreementForTranslator.h"

@interface AgreementForTranslator (){
    NSMutableData *_downloadedData;
    NSUserDefaults *_userInfo;
    NSString *CorrectPhoneNumber;
    
}

@end
@implementation AgreementForTranslator
@synthesize AgreementLabel = _AgreementLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    _userInfo = [NSUserDefaults standardUserDefaults];

    NSLog(@"%@ %@ // Agreement",[_userInfo stringForKey:@"account"],[_userInfo stringForKey:@"password"]);
    if([_userInfo boolForKey:@"isTranslator"]==YES){
        NSLog(@"是翻譯員");
        NSLog(@"%d",[_userInfo boolForKey:@"isTranslator"]);
        
    }else{
        NSLog(@"不是翻譯員");
        NSLog(@"%d",[_userInfo boolForKey:@"isTranslator"]);
    }
    UIScrollView *scrollView= [UIScrollView new];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];
    
    UILabel *scrollViewLabel = [[UILabel alloc] init];
    scrollViewLabel.numberOfLines = 0;
    scrollViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:scrollViewLabel];
    
    scrollViewLabel.text = @"翻譯員權益須知：\n1. 貴我雙方同意且接受條款：\n當您使用本翻譯員服務時（以下簡稱「本服務」），即表示您已全部閱讀且暸解並同意接受本約定書之所有內容，方得使用或繼續使用本服務。\n\n2. 翻譯員註冊必須注意事項：\n依本服務註冊表之提示請您提供本人正確以及最新最完整的資料。本服務將維持並更新您個人資料，確保您的個人資料為正確，最新及完整狀態。\n\n3.翻譯員如有下列情形發生時，本服務得保留終止您的翻譯員資格：\n您同意且絕不為任何非法目的或以任何非法的方式使用本服務，並承諾遵守消費者保護法、公平交易法或其他中華民國境內及境外（含其他國家）法律規定及一切使用網際網路之國際慣例。您若是中華民國以外之使用者，並同意遵守所屬國家或地域之法令。您同意並保證不得利用本服務從事侵害他人權益或違法之行為。您同意並保證不得利用本服務從事侵害他人權益或違法之行為，如：\n\nA.透過本服務公布或傳送任何誹謗、侮辱、具威脅性、攻擊性、不雅、猥褻、不實、違反公共秩序或善良風俗或其他不法之文字、圖片或任何形式的檔案於本服務。\n\nB.侵害他人名譽、隱私權、營業秘密、商標權、著作權、專利權、其他智慧財產權及其他權利。\n\nC.違反依法律或契約所應負之保密義務。\n\nD.冒用他人名義或冒用他人個人資料使用本服務。\n\nE.透過本服務傳輸或散佈電腦病毒。\n\nF.從事不法交易行為或張貼虛假不實、引人犯罪之訊息。\n\nG.販賣槍枝、毒品、禁藥、盜版軟體或其他違禁物。\n\n\nH.提供賭博資訊或以任何方式引誘他人參與賭博。\n\nI.其他本服務有正當理由認為不適當之行為。\n\n5. 系統維護及中斷聲明：\n本服務有時可能會出現中斷或故障等現象，或許將造成您使用上的不便、資料喪失、錯誤、遭人篡改或其它損失等情形。會員於使用本服務時宜自行採取防護措施。會員應瞭解並同意，本服務可能因天災等不可抗力因素，或協力廠商、相關電信服務業者、系統軟硬體之故障、失靈或人為操作疏失，造成系統中斷、故障、延遲、或傳輸錯誤時，導致會員使用上之不便，會員同意上述聲明不得要求任何形式之補償或賠償。";
    
    
    /*** Auto Layout ***/
    
    NSDictionary *views = NSDictionaryOfVariableBindings(scrollView, scrollViewLabel);
    
    NSArray *scrollViewLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollViewLabel(scrollView)]" options:0 metrics:nil views:views];
    [scrollView addConstraints:scrollViewLabelConstraints];
    
    scrollViewLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollViewLabel]|" options:0 metrics:nil views:views];
    [scrollView addConstraints:scrollViewLabelConstraints];
    
    NSArray *scrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[scrollView]-|" options:0 metrics:nil views:views];
    [self.view addConstraints:scrollViewConstraints];
    
    scrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(100)-[scrollView(500)]-|" options:0 metrics:nil views:views];
    [self.view addConstraints:scrollViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Accept:(id)sender {
    [_userInfo setBool:YES forKey:@"isTranslator"];
    [self PostToPhp:[_userInfo stringForKey:@"account"] :[_userInfo stringForKey:@"password"]];
}

-(void)PostToPhp:(NSString *)Phone :(NSString*)PassWord{
    CorrectPhoneNumber =  [Phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSLog(@"Phone為:%@ PassWord為%@",CorrectPhoneNumber,PassWord);
    NSString *post = [NSString stringWithFormat:@"&PhoneNumber=%@&PassWord=%@",CorrectPhoneNumber,PassWord];
    NSLog(@"POST 的帳號密碼為 : %@",post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.114.71.168/RegistrationForTranslator.php"]]];
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








/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
