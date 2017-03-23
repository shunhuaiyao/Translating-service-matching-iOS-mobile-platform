//
//  addWorkViewController.m
//  translatorApp
//
//  Created by Yao on 2015/9/26.
//  Copyright © 2015年 Yao. All rights reserved.
//

#import "addWorkViewController.h"


@interface addWorkViewController (){
    BOOL doneButton;
    NSString *CorrectPhoneNumber;
}

@end

@implementation addWorkViewController
@synthesize lang1 = _lang1;
@synthesize lang2 = _lang2;
@synthesize translatorPhone = _translatorPhone;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"addWork:%@ %@ %@",_lang1,_lang2,_translatorPhone);
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(addWorkButton:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSLog(@"add: %@ %@ %@",_lang1,_lang2,_translatorPhone);
}
-(void)cancelButton:(UIBarButtonItem *)button{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)addWorkButton:(UIBarButtonItem *)button{
    
    
//    NSString *lang1 = @"Chinese";
//    NSString *lang2 = @"Thai";
//    NSString *phone = @"0987697829";
    
    //    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    //    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:[[self getRowValue] objectForKey:@"starts"]];
    //    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:[[self getRowValue] objectForKey:@"starts"]];
    //    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    //
    //    NSDate *startDate = [NSDate dateWithTimeInterval:gmtInterval sinceDate:[[self getRowValue] objectForKey:@"starts"]];
    //    NSDate *endDate = [NSDate dateWithTimeInterval:gmtInterval sinceDate:[[self getRowValue] objectForKey:@"ends"]];
    
    //    NSLog(@"start:%@ end:%@",[[self getRowValue] objectForKey:@"starts"],[[self getRowValue] objectForKey:@"ends"]);
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *starts = [dateFormatter stringFromDate:[[self getRowValue] objectForKey:@"starts"]];
    NSString *ends = [dateFormatter stringFromDate:[[self getRowValue] objectForKey:@"ends"]];
    
    //-------------------------------------------------------1/22改
    CorrectPhoneNumber =  [_translatorPhone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSLog(@"Phone為:%@ ",CorrectPhoneNumber);

    
    
    
    NSString *post = [NSString stringWithFormat:@"&lang1=%@&lang2=%@&translatorPhone=%@&starts=%@&ends=%@",_lang1,_lang2,CorrectPhoneNumber,starts, ends];
    NSLog(@"%@ %@ %@ %@ %@",_lang1,_lang2,CorrectPhoneNumber,starts,ends);
    //----------------------------------------------------------------
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.114.71.168/addWork.php"]]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"增加服務時段"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"allDay" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"整日"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"allDayDate" rowType:XLFormRowDescriptorTypeDateInline title:@"日期"];
    row.value = [NSDate new];
    [row.cellConfigAtConfigure setObject:row.value forKey:@"minimumDate"];
    row.hidden = @YES;
    row.disabled = @YES;
    [section addFormRow:row];
    
    // DateTime
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"starts" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"開始"];
    row.value = [NSDate new];
    [row.cellConfigAtConfigure setObject:row.value forKey:@"minimumDate"];
    [section addFormRow:row];
    
    // DateTime
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ends" rowType:XLFormRowDescriptorTypeTimeInline title:@"結束"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60];
    [section addFormRow:row];
    
    self.form = form;
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    // super implementation must be called
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    
    if([formRow.tag isEqualToString:@"starts"]){
        //        NSLog(@"%@ %@ %@",formRow.value,[[self getRowValue] objectForKey:@"ends"],[NSDate dateWithTimeInterval:60*60 sinceDate:formRow.value]);
        
        
        [self.form formRowWithTag:@"ends"].value = [NSDate dateWithTimeInterval:60*60 sinceDate:formRow.value];
        [[self.form formRowWithTag:@"ends"].cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
        [[self.form formRowWithTag:@"ends"].cellConfig setObject:[UIColor grayColor] forKey:@"detailTextLabel.textColor"];
        [formRow.cellConfig setObject:self.view.tintColor forKey:@"detailTextLabel.textColor"];
        [self reloadFormRow:[self.form formRowWithTag:@"ends"]];
        
    }
    else if ([formRow.tag isEqualToString:@"ends"]){
        
        if ([formRow.value compare:[self.form formRowWithTag:@"starts"].value] == NSOrderedAscending || [formRow.value compare:[self.form formRowWithTag:@"starts"].value] == NSOrderedSame) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [formRow.cellConfig setObject:[UIColor redColor] forKey:@"textLabel.textColor"];
            [formRow.cellConfig setObject:[UIColor redColor] forKey:@"detailTextLabel.textColor"];
            
        }
        else{
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [formRow.cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
            [formRow.cellConfig setObject:self.view.tintColor forKey:@"detailTextLabel.textColor"];
        }
    }
    else if ([formRow.tag isEqualToString:@"allDay"]){
        
        
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        formatter.dateFormat = @"EEE M d,YYYY";
        //
        //        NSString *date = [formatter stringFromDate:[self.form formRowWithTag:@"starts"].value];
        NSString *toggleSwitch = [NSString stringWithFormat:@"%@",formRow.value];
        
        
        
        if([toggleSwitch isEqualToString:@"1"]){
            
            [self.form formRowWithTag:@"allDayDate"].disabled = @NO;
            [self.form formRowWithTag:@"allDayDate"].hidden = @NO;
            [self.form formRowWithTag:@"starts"].disabled = @YES;
            [self.form formRowWithTag:@"ends"].disabled = @YES;
            
            [[self.form formRowWithTag:@"starts"].cellConfig setObject:[UIColor lightGrayColor] forKey:@"textLabel.textColor"];
            [[self.form formRowWithTag:@"starts"].cellConfig setObject:[UIColor lightGrayColor] forKey:@"detailTextLabel.textColor"];
            [[self.form formRowWithTag:@"ends"].cellConfig setObject:[UIColor lightGrayColor] forKey:@"textLabel.textColor"];
            [[self.form formRowWithTag:@"ends"].cellConfig setObject:[UIColor lightGrayColor] forKey:@"detailTextLabel.textColor"];
            
            [self reloadFormRow:[self.form formRowWithTag:@"allDayDate"]];
            [self reloadFormRow:[self.form formRowWithTag:@"starts"]];
            [self reloadFormRow:[self.form formRowWithTag:@"ends"]];
            
            doneButton = self.navigationItem.rightBarButtonItem.enabled;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            
        }
        else{
            [self.form formRowWithTag:@"allDayDate"].disabled = @YES;
            [self.form formRowWithTag:@"allDayDate"].hidden = @YES;
            [self.form formRowWithTag:@"starts"].disabled = @NO;
            [self.form formRowWithTag:@"ends"].disabled = @NO;
            
            [[self.form formRowWithTag:@"starts"].cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
            [[self.form formRowWithTag:@"starts"].cellConfig setObject:[UIColor grayColor] forKey:@"detailTextLabel.textColor"];
            
            if ([[self.form formRowWithTag:@"ends"].value compare:[self.form formRowWithTag:@"starts"].value] == NSOrderedAscending || [[self.form formRowWithTag:@"ends"].value compare:[self.form formRowWithTag:@"starts"].value] == NSOrderedSame){
                [[self.form formRowWithTag:@"ends"].cellConfig setObject:[UIColor redColor] forKey:@"textLabel.textColor"];
            }
            else{
                [[self.form formRowWithTag:@"ends"].cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
            }
            
            [[self.form formRowWithTag:@"ends"].cellConfig setObject:[UIColor grayColor] forKey:@"detailTextLabel.textColor"];
            
            [self reloadFormRow:[self.form formRowWithTag:@"allDayDate"]];
            [self reloadFormRow:[self.form formRowWithTag:@"starts"]];
            [self reloadFormRow:[self.form formRowWithTag:@"ends"]];
            
            self.navigationItem.rightBarButtonItem.enabled = doneButton;
        }
    }
    else if ([formRow.tag isEqualToString:@"allDayDate"]){
        
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
