//
//  DriverLicenseViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "DriverLicenseViewController.h"

#import "DisplayTextCell.h"
#import "AddDriverLicenseViewController.h"

@interface DriverLicenseViewController (){
    NSArray *_sections;
    NSArray *_items;
    BOOL _isEditing;
    NSMutableDictionary* result;
}

@end

@implementation DriverLicenseViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 216, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit_license:)];
    _isEditing = NO;
    
    
}
-(NSArray *)getSections{
    return @[@"基本信息"];
}
-(NSArray *)getItems{
    return @[@[ @{@"name":@"证件号码",@"key":@"number",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"姓名",@"key":@"name",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"准驾车型",@"key":@"car_type",@"mode":@"add",@"description":@"",@"vcname":@"LicenseTypeViewController"},
    @{@"name":@"初领日期",@"key":@"init_date",@"mode":@"add",@"description":@"",@"vcname":@"DatePickerViewController"}]];
}
-(NSDictionary *)getInitData{
    return @{@"number":@"370299",@"name":@"test",@"init_date":@"1999-01-01",@"car_type":@"A"};
}
-(void)saveData:(NSDictionary *)paramters{
    NSLog(@"%@",paramters);
}
-(void)edit_license:(id)sender{
    AddDriverLicenseViewController *vc = [[AddDriverLicenseViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTableView:nil];
    [super viewDidUnload];
}

-(void)initData{
    _sections=@[@"基本信息",@"计分情况",@"提醒"];
    
    _items=@[@[ @{@"name":@"证件号码",@"key":@"number",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"姓名",@"key":@"name",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"准驾车型",@"key":@"car_type",@"mode":@"add",@"description":@"",@"vcname":@"LicenseTypeViewController"},
    @{@"name":@"初领日期",@"key":@"init_date",@"mode":@"add",@"description":@"",@"vcname":@"DatePickerViewController"}],
    @[ 
    @{@"name":@"开始日期",@"key":@"start_date",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"结束日期",@"key":@"end_date",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"计分情况",@"key":@"mark",@"mode":@"",@"description":@"",@"vcname":@""}],
    @[@{@"name":@"积分到期日",@"key":@"mark_end_date",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"年审日期",@"key":@"check_date",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"换证日期",@"key":@"renew_date",@"mode":@"",@"description":@"",@"vcname":@""}]];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_items objectAtIndex:section] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sections objectAtIndex:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    DisplayTextCell *cell =nil;
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        NSArray *cells =[[NSBundle mainBundle] loadNibNamed:@"DisplayTextCell" owner:self.tableView options:nil];
        cell =[cells objectAtIndex:0];
        

    }
    
    id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *value =[result objectForKey:item[@"key"]];
    cell.keyLabel.text = item[@"name"];
    cell.valueLabel.text = value;
    return cell;
    /*
    [cell setValueByKey:item[@"key"] value:value];
    cell.displayLabel.text = item[@"name"];
    cell.valueText.delegate= self;
    if (![item[@"vcname"] isEqualToString:@""]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell start_listen];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.tag = indexPath.row;
    cell.valueText.tag = indexPath.row;
    
    [cell setEditable:_isEditing];
    */
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(void)setup{
    _helper.url =[[_helper appSetttings] url_get_driver_license];
}
-(void)processData:(id)json{
    id list = json[@"result"];
    NSLog(@"%@",list);
    /* old code
    if ([list isKindOfClass:[NSArray class]] && [list count]>0){
        result =[list objectAtIndex:0];
        
    }
     */
    result =list;
    [self.tableView reloadData];
}

@end
