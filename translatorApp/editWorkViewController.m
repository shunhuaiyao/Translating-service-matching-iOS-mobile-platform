//
//  editWorkViewController.m
//  translatorApp
//
//  Created by Yao on 2015/11/3.
//  Copyright © 2015年 Yao. All rights reserved.
//

#import "editWorkViewController.h"

@interface editWorkViewController (){
    BOOL doneButton;
}

@end

@implementation editWorkViewController

@synthesize lang1 = _lang1;
@synthesize lang2 = _lang2;
@synthesize translatorPhone = _translatorPhone;
@synthesize startDateTime = _startDateTime;
@synthesize endDateTime = _endDateTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem * editButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(editWorkButton:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [self.form formRowWithTag:@"starts"].value = [dateFormatter dateFromString:_startDateTime];
    [[self.form formRowWithTag:@"starts"].cellConfig setObject:[UIColor grayColor] forKey:@"detailTextLabel.textColor"];
    [[self.form formRowWithTag:@"starts"].cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
    [self.form formRowWithTag:@"ends"].value = [dateFormatter dateFromString:_endDateTime];
    [[self.form formRowWithTag:@"ends"].cellConfig setObject:[UIColor grayColor] forKey:@"detailTextLabel.textColor"];
    [[self.form formRowWithTag:@"ends"].cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
    [self reloadFormRow:[self.form formRowWithTag:@"starts"]];
    [self reloadFormRow:[self.form formRowWithTag:@"ends"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)editWorkButton:(UIBarButtonItem *)button{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *starts = [dateFormatter stringFromDate:[[self getRowValue] objectForKey:@"starts"]];
    NSString *ends = [dateFormatter stringFromDate:[[self getRowValue] objectForKey:@"ends"]];
    
    NSString *post = [NSString stringWithFormat:@"&lang1=%@&lang2=%@&translatorPhone=%@&starts=%@&ends=%@&oldStarts=%@&oldEnds=%@",_lang1,_lang2,_translatorPhone,starts,ends,_startDateTime,_endDateTime];
    NSLog(@"%@ %@ %@ %@ %@ %@ %@",_lang1,_lang2,_translatorPhone,starts,ends,_startDateTime,_endDateTime);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.114.71.168/editWork.php"]]];
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

    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSLog(@"%@ %@ %@ %@ %@",_lang1,_lang2,_translatorPhone,_startDateTime,_endDateTime);
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"編輯服務時段"];
    
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
    [section addFormRow:row];
    
    // DateTime
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ends" rowType:XLFormRowDescriptorTypeTimeInline title:@"結束"];
    [section addFormRow:row];
    
    self.form = form;
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    // super implementation must be called
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if([formRow.tag isEqualToString:@"starts"]){
        //        NSLog(@"%@ %@ %@",formRow.value,[[self getRowValue] objectForKey:@"ends"],[NSDate dateWithTimeInterval:60*60 sinceDate:formRow.value]);
        [self.form formRowWithTag:@"ends"].value = [NSDate dateWithTimeInterval:60*60 sinceDate:formRow.value];
        [[self.form formRowWithTag:@"ends"].cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
        [[self.form formRowWithTag:@"ends"].cellConfig setObject:[UIColor grayColor] forKey:@"detailTextLabel.textColor"];
        [formRow.cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
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
