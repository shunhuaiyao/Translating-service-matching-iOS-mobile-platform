//
//  addServiceViewController.m
//  translatorApp
//
//  Created by Yao on 2015/9/27.
//  Copyright © 2015年 Yao. All rights reserved.
//

#import "addServiceViewController.h"

@interface addServiceViewController (){
    NSMutableArray *serviceList;
    NSUserDefaults *userInfo;
    XLFormRowDescriptor * rowForLang1;
    XLFormRowDescriptor * rowForLang2;
    NSString *CorrectPhoneNumber;
}

@end

@implementation addServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.title = @"增加語言服務";

    UIBarButtonItem * addServiceButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(addServiceButton:)];
    //barButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered
//      target:self action:@selector(editMode:)];
    self.navigationItem.rightBarButtonItem = addServiceButton;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    userInfo = [NSUserDefaults standardUserDefaults];
    serviceList = [[NSMutableArray alloc]init] ;
    serviceList = [NSMutableArray arrayWithArray:[userInfo arrayForKey:@"serviceList"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelButton:(UIBarButtonItem *)button{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)addServiceButton:(UIBarButtonItem *)button{
    NSString *service = [NSString stringWithFormat:@"%@\t⇔\t%@",[[self getRowValue] objectForKey:@"lang1"],[[self getRowValue] objectForKey:@"lang2"]];
    [serviceList addObject:service];
    [userInfo setObject:[NSArray arrayWithArray:serviceList] forKey:@"serviceList"];
    //---------------------------------------------------1/22改

    CorrectPhoneNumber =  [[userInfo stringForKey:@"account"] stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSLog(@"Phone為:%@ ",CorrectPhoneNumber);
    
    NSString *post = [NSString stringWithFormat:@"&lang1=%@&lang2=%@&translatorPhone=%@",[self transferToEnglish:[[self getRowValue] objectForKey:@"lang1"]],[self transferToEnglish:[[self getRowValue] objectForKey:@"lang2"]],CorrectPhoneNumber];
    //----------------------------------------------------------------
    NSLog(@"%@ %@ %@",[self transferToEnglish:[[self getRowValue] objectForKey:@"lang1"]],[self transferToEnglish:[[self getRowValue] objectForKey:@"lang2"]],CorrectPhoneNumber);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.114.71.168/addService.php"]]];
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
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}

-(void)initializeForm{
    
    
    NSArray * langCollection = @[@"中文",@"客家語",@"閩南語", @"英文", @"日文", @"泰文"];
    
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"New Service"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"請選擇兩種語言"];
    [form addFormSection:section];
    rowForLang1 = [XLFormRowDescriptor formRowDescriptorWithTag:@"lang1" rowType:XLFormRowDescriptorTypeSelectorPickerViewInline title:@"語言1"];
    rowForLang1.selectorOptions = langCollection;
    rowForLang1.value = [langCollection objectAtIndex:0];
    [section addFormRow:rowForLang1];
    
    rowForLang2 = [XLFormRowDescriptor formRowDescriptorWithTag:@"lang2" rowType:XLFormRowDescriptorTypeSelectorPickerViewInline title:@"語言2"];
    rowForLang2.selectorOptions = langCollection;
    rowForLang2.value = [langCollection objectAtIndex:3];
    [section addFormRow:rowForLang2];
    
    self.form = form;
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    
    if([formRow.tag isEqualToString:@"lang1"]){
        
        if (formRow.value == [self.form formRowWithTag:@"lang2"].value) {
            
            [[self.form formRowWithTag:@"lang1"].cellConfig setObject:[UIColor redColor] forKey:@"textLabel.textColor"];
            [[self.form formRowWithTag:@"lang1"].cellConfig setObject:[UIColor redColor] forKey:@"detailTextLabel.textColor"];
            
            [[self.form formRowWithTag:@"lang2"].cellConfig setObject:[UIColor redColor] forKey:@"textLabel.textColor"];
            [[self.form formRowWithTag:@"lang2"].cellConfig setObject:[UIColor grayColor] forKey:@"detailTextLabel.textColor"];
            [self reloadFormRow:[self.form formRowWithTag:@"lang2"]];
            
            self.navigationItem.rightBarButtonItem.enabled = NO;

        }
        else{
            [[self.form formRowWithTag:@"lang1"].cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
            [[self.form formRowWithTag:@"lang1"].cellConfig setObject:self.view.tintColor forKey:@"detailTextLabel.textColor"];
            
            [[self.form formRowWithTag:@"lang2"].cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
            [[self.form formRowWithTag:@"lang2"].cellConfig setObject:[UIColor grayColor] forKey:@"detailTextLabel.textColor"];
            [self reloadFormRow:[self.form formRowWithTag:@"lang2"]];
            
            self.navigationItem.rightBarButtonItem.enabled = YES;

        }
        
    }
    else if ([formRow.tag isEqualToString:@"lang2"]){
        
        if (formRow.value == [self.form formRowWithTag:@"lang1"].value) {
            
            [[self.form formRowWithTag:@"lang2"].cellConfig setObject:[UIColor redColor] forKey:@"textLabel.textColor"];
            [[self.form formRowWithTag:@"lang2"].cellConfig setObject:[UIColor redColor] forKey:@"detailTextLabel.textColor"];
            
            [[self.form formRowWithTag:@"lang1"].cellConfig setObject:[UIColor redColor] forKey:@"textLabel.textColor"];
            [[self.form formRowWithTag:@"lang1"].cellConfig setObject:[UIColor grayColor] forKey:@"detailTextLabel.textColor"];
            [self reloadFormRow:[self.form formRowWithTag:@"lang1"]];
            
            self.navigationItem.rightBarButtonItem.enabled = NO;

            
        }
        else{
            [[self.form formRowWithTag:@"lang2"].cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
            [[self.form formRowWithTag:@"lang2"].cellConfig setObject:self.view.tintColor forKey:@"detailTextLabel.textColor"];
            
            [[self.form formRowWithTag:@"lang1"].cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
            [[self.form formRowWithTag:@"lang1"].cellConfig setObject:[UIColor grayColor] forKey:@"detailTextLabel.textColor"];
            [self reloadFormRow:[self.form formRowWithTag:@"lang1"]];
            
            self.navigationItem.rightBarButtonItem.enabled = YES;

        }
    }
    
}

-(void)reloadFormRow:(XLFormRowDescriptor *)formRow
{
    NSIndexPath * indexPath = [self.form indexPathOfFormRow:formRow];
    if (indexPath){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(NSMutableDictionary *)getRowValue{
    
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    for (XLFormSectionDescriptor * section in self.form.formSections) {
        if (!section.isMultivaluedSection){
            for (XLFormRowDescriptor * row in section.formRows) {
                if (row.tag && ![row.tag isEqualToString:@""]){
                    [result setObject:(row.value ?: [NSNull null]) forKey:row.tag];
                }
            }
        }
        else{
            NSMutableArray * multiValuedValuesArray = [NSMutableArray new];
            for (XLFormRowDescriptor * row in section.formRows) {
                if (row.value){
                    [multiValuedValuesArray addObject:row.value];
                }
            }
            [result setObject:multiValuedValuesArray forKey:section.multivaluedTag];
        }
    }
    return result;
}

-(NSString *)transferToEnglish:(NSString *)lang{
    
    NSString * ans;
    
    if ([lang isEqualToString:@"中文"]) {
        ans = @"Chinese";
    }
    else if([lang isEqualToString:@"客家語"]){
        ans = @"Hakka";
    }
    else if([lang isEqualToString:@"閩南語"]){
        ans = @"Taiwanese";
    }
    else if([lang isEqualToString:@"英文"]){
        ans = @"English";
    }
    else if([lang isEqualToString:@"日文"]){
        ans = @"Japanese";
    }
    else if([lang isEqualToString:@"泰文"]){
        ans = @"Thai";
    }
    
    return ans;
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
