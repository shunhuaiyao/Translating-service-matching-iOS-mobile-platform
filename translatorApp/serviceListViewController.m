//
//  serviceListViewController.m
//  translatorApp
//
//  Created by Yao on 2015/9/30.
//  Copyright © 2015年 Yao. All rights reserved.
//

#import "serviceListViewController.h"

@interface serviceListViewController (){
    NSMutableArray *insertRows;
    NSMutableArray *serviceList;
    NSUserDefaults *userInfo;
    
    NSString *didSelectedLang1;
    NSString *didSelectedLang2;
}

@end

@implementation serviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButton:)];
    
    self.navigationItem.title = @"語言服務列表";
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.navigationItem.backBarButtonItem.title = @"Back";

    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.tableView.editing = NO;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addButton:(UIBarButtonItem *)button{
    
    [self performSegueWithIdentifier: @"addServiceSegue" sender: self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initializeForm];
    
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
    
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Service"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"翻譯語言服務列表" sectionOptions:XLFormSectionOptionCanDelete];
    [form addFormSection:section];
    
    userInfo = [NSUserDefaults standardUserDefaults];
    serviceList = [[NSMutableArray alloc]init] ;
    serviceList = [NSMutableArray arrayWithArray:[userInfo arrayForKey:@"serviceList"]];
    
    NSLog(@"serviceList:%lu",(unsigned long)serviceList.count);
    for (int i=0; i<serviceList.count; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:[serviceList objectAtIndex:i] rowType:XLFormRowDescriptorTypeSelectorPush title:[serviceList objectAtIndex:i]];
        [section addFormRow:row];
    }

    self.form = form;
    
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"listToScheduleSegue"]){
        
        id targetViewController = segue.destinationViewController;
        if ([didSelectedLang1 isEqualToString:@"泰文"]) {
            didSelectedLang1 = [NSString stringWithFormat:@"Thai"];
        }
        else if ([didSelectedLang1 isEqualToString:@"中文"]) {
            didSelectedLang1 = [NSString stringWithFormat:@"Chinese"];
        }
        else if ([didSelectedLang1 isEqualToString:@"英文"]) {
            didSelectedLang1 = [NSString stringWithFormat:@"English"];
        }
        else if ([didSelectedLang1 isEqualToString:@"日文"]) {
            didSelectedLang1 = [NSString stringWithFormat:@"Japanese"];
        }
        else if ([didSelectedLang1 isEqualToString:@"客語"]) {
            didSelectedLang1 = [NSString stringWithFormat:@"Hakka"];
        }
        else if ([didSelectedLang1 isEqualToString:@"閩南語"]) {
            didSelectedLang1 = [NSString stringWithFormat:@"Taiwanese"];
        }
        
        if ([didSelectedLang2 isEqualToString:@"泰文"]) {
            didSelectedLang2 = [NSString stringWithFormat:@"Thai"];
        }
        else if ([didSelectedLang2 isEqualToString:@"中文"]) {
            didSelectedLang2 = [NSString stringWithFormat:@"Chinese"];
        }
        else if ([didSelectedLang2 isEqualToString:@"英文"]) {
            didSelectedLang2 = [NSString stringWithFormat:@"English"];
        }
        else if ([didSelectedLang2 isEqualToString:@"日文"]) {
            didSelectedLang2 = [NSString stringWithFormat:@"Japanese"];
        }
        else if ([didSelectedLang2 isEqualToString:@"客語"]) {
            didSelectedLang2 = [NSString stringWithFormat:@"Hakka"];
        }
        else if ([didSelectedLang2 isEqualToString:@"閩南語"]) {
            didSelectedLang2 = [NSString stringWithFormat:@"Taiwanese"];
        }
    
        
        [targetViewController setValue:didSelectedLang1 forKey:@"lang1"];
        [targetViewController setValue:didSelectedLang2 forKey:@"lang2"];
        

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    userInfo = [NSUserDefaults standardUserDefaults];
    serviceList = [[NSMutableArray alloc]init] ;
    serviceList = [NSMutableArray arrayWithArray:[userInfo arrayForKey:@"serviceList"]];
    
    NSArray * didSelectedLang = [[serviceList objectAtIndex:indexPath.row] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"⇔"]];
    didSelectedLang1 = [didSelectedLang[0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]][0];
    didSelectedLang2 = [didSelectedLang[1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]][1];
    //NSLog(@"1%@2%@",didSelectedLang1,didSelectedLang2);
    
    [self performSegueWithIdentifier: @"listToScheduleSegue" sender: self];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.tableView.editing = YES;
        [serviceList removeObjectAtIndex:indexPath.row];
        [userInfo setObject:[NSArray arrayWithArray:serviceList] forKey:@"serviceList"];
        NSLog(@"%ld",(long)indexPath.row);
        [self initializeForm];
        self.tableView.editing = NO;
//        [self.tableView deleteRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)reloadFormRow:(XLFormRowDescriptor *)formRow
{
    NSIndexPath * indexPath = [self.form indexPathOfFormRow:formRow];
    if (indexPath){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
